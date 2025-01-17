(* Module de la passe de placement mémoire *)
(* doit être conforme à l'interface Passe *)

open Tds
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

let getTailleList liste = List.fold_right (fun r e -> getTaille r + e) liste 0

(* analyse_placement_expression : AstType.expression -> AstPlacement.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie le bon placement mémoire et tranforme l'expression
en une expression de type AstPlacement.expression *)
(* Erreur si mauvais placement mémoire *)
let analyse_placement_expression e = e

(* analyse_placement_instruction : AstType.instruction * int * string -> AstPlacement.instruction*int *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre depl : Déplacement *)
(* Paramètre reg : Registre *)
(* Vérifie le bon placement mémoire  et transforme l'instruction
en une instruction de type AstPlacement.instruction *)
(* Erreur si mauvais placement mémoire *)
let rec analyse_placement_instruction (i, depl, reg) =
  match i with
  | AstType.Declaration (info_ast, e) -> 
    begin
      match info_ast_to_info info_ast with
      | InfoVar (_, t, _, _) ->
        begin
          let _ = modifier_adresse_variable depl reg info_ast in
          (AstPlacement.Declaration (info_ast, e), getTaille t)
        end
      | _ -> failwith "Erreur interne."
    end
    | AstType.Affectation (info_ast, e) ->
      begin
        (AstPlacement.Affectation(info_ast, e), 0)
      end
    | AstType.AffichageInt e ->
        (AstPlacement.AffichageInt e, 0)
    | AstType.AffichageRat e ->
      (AstPlacement.AffichageRat e, 0)
    | AstType.AffichageBool e ->
      (AstPlacement.AffichageBool e, 0)
    | AstType.Conditionnelle (e, b1, b2) ->
      begin
        let nb1 = analyse_placement_bloc b1 depl reg in
        let nb2 = analyse_placement_bloc b2 depl reg in
        (AstPlacement.Conditionnelle(e, nb1, nb2), 0)
      end
    | AstType.TantQue (e, b) ->
      begin
        let nb = analyse_placement_bloc b depl reg in
        (AstPlacement.TantQue (e, nb), 0)
      end
    | AstType.Retour (e, info_ast) ->
      begin
        match info_ast_to_info info_ast with
        | InfoFun (_, t, lp) ->
          (AstPlacement.Retour (e, getTaille t, getTailleList lp), 0)
        | _ -> failwith "Erreur interne."
      end
    | AstType.Empty -> (AstPlacement.Empty, 0)


(* analyse_placement_bloc : AstType.bloc*Int*String -> AstPlacementBloc*Int *)
(* Vérifie le bon placement mémoire et tranforme le bloc en un bloc de type AstPlacement.bloc *)
(* Erreur si mauvais placement mémoire *)
and analyse_placement_bloc li depl reg =
      match li with
      | [] -> ([], 0)
      | i::iq -> 
        let (ni, taille) = analyse_placement_instruction (i, depl, reg) in 
        let (nli, tli) = analyse_placement_bloc iq (depl + taille) reg in
        (ni::nli , taille + tli)

(* analyse_placement_parametres : AstType.parametres -> AstPlacement.parametres *)
(* Paramètre lpia : liste des infos_ast sur les paramètres *)
(* Modifie l'information d'adressage associées aux paramètres et renvoie la taille totale des paramètres *)
let rec analyse_placement_parametres lpia = 
  match lpia with
  | [] -> 0
  | tia::qia -> 
    begin
      match info_ast_to_info tia with
      | InfoVar(_,t,_,_) -> 
        begin
          let tailleq = analyse_placement_parametres qia in
          let taillet = getTaille t in 
          let _ = modifier_adresse_variable (-tailleq-taillet) "LB" tia in 
          taillet + tailleq
         end
      | _ -> failwith "Erreur interne."
     end

(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction*)
(* Paramètre : la fonction à analyser *)
(* Vérifie le bon placement mémoire et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvais placement mémoire *)
let analyse_placement_fonction fonction =
  match fonction with
  | AstType.Fonction (info_ast, linfo_ast, li) ->
    begin 
      let nlp = analyse_placement_parametres linfo_ast in
      let nli = analyse_placement_bloc li 3 "LB" in
      AstPlacement.Fonction(info_ast, linfo_ast, nli)
    end

(* analyser : AstType.programme -> AstPlacement.Programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie le bon placement mémoire et tranforme le programme
en un programme de type AstPlacement.programme *)
(* Erreur si mauvais placement mémoire *)
let analyser (AstType.Programme (fonctions,prog)) =
  let nlf = List.map analyse_placement_fonction fonctions in 
  let nli = analyse_placement_bloc prog 0 "SB" in
  AstPlacement.Programme (nlf, nli)