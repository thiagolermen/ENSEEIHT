(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Type
open Exceptions
open Ast
open AstType

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

(* analyse_type_affectable : AstSyntax.affectable -> AstType.affectable *)
(* Paramètre a: l'affectable à analyser *)
(* Vérifie la bonne utilisation du type et tranforme l'affectable
en un affectable de type AstType.affectable et renvoie aussi le type de l'affectable *)
(* Erreur si problème de typage *)
let rec analyse_type_affectable info_ast = 
  match info_ast_to_info info_ast with  
    | InfoFun (_, t, _) -> (Ident(info_ast), t)
    | InfoVar (_, t, _, _) -> (Ident(info_ast), t)
    | InfoConst (_, _) -> (Ident(info_ast), Int)

(* analyse_type_expression : AstTds.expression -> AstType.expression * typ *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation du type et tranforme l'expression
en une expression de type AstType.expression , renvoie aussi le type de l'expression *)
(* Erreur si problème de typage *)
let rec analyse_type_expression e = 
  match e with
    | AstTds.AppelFonction (info_ast, el) ->
      begin
        match info_ast_to_info info_ast with
          | InfoFun (_, t, tp) ->
            let l = List.map analyse_type_expression el in
            let le, lt =  (List.split l) in
            if (est_compatible_list lt tp) then 
              (AstType.AppelFonction (info_ast, le), t)
            else
              raise (TypesParametresInattendus (lt, tp))
          | _ -> failwith "Erreur interne"
      end
    | AstTds.Ident info_ast -> 
      begin
        match info_ast_to_info info_ast with
          | InfoVar (_, t, _, _) -> (AstType.Ident info_ast, t)
          | InfoConst _ -> (AstType.Ident info_ast, Int)
          | _ -> failwith "Erreur interne"
      end
    | AstTds.Booleen (i) -> (Booleen (i), Bool)
    | AstTds.Entier (i) -> (Entier (i), Int)
    | AstTds.Unaire (op, e) ->
      begin
        let (ne, t) = analyse_type_expression e in
        match (op, t) with
        | (AstSyntax.Numerateur, Type.Rat) -> (AstType.Unaire(AstType.Numerateur, ne), Type.Int)
        | (AstSyntax.Denominateur, Type.Rat) -> (AstType.Unaire(AstType.Denominateur, ne), Type.Int)
        | _ -> raise (TypeInattendu(t, Type.Rat))
      end
    | AstTds.Binaire (op, e1, e2) ->
      begin
        let (ne1, t1) = analyse_type_expression  e1 in
        let (ne2, t2) = analyse_type_expression  e2 in
        match (op, t1, t2) with
        | (AstSyntax.Plus, Type.Int, Type.Int ) -> AstType.Binaire(AstType.PlusInt, ne1, ne2), Type.Int
        | (AstSyntax.Plus, Type.Rat, Type.Rat ) -> AstType.Binaire(AstType.PlusRat, ne1, ne2), Type.Rat
        | (AstSyntax.Mult, Type.Int, Type.Int ) -> AstType.Binaire(AstType.MultInt, ne1, ne2), Type.Int
        | (AstSyntax.Mult, Type.Rat, Type.Rat ) -> AstType.Binaire(AstType.MultRat, ne1, ne2), Type.Rat
        | (AstSyntax.Equ, Type.Int, Type.Int ) -> AstType.Binaire(AstType.EquInt, ne1, ne2), Type.Bool
        | (AstSyntax.Equ, Type.Bool, Type.Bool ) -> AstType.Binaire(AstType.EquBool, ne1, ne2), Type.Bool
        | (AstSyntax.Inf, Type.Int, Type.Int ) -> AstType.Binaire(AstType.Inf, ne1, ne2), Type.Bool
        | (AstSyntax.Fraction, Type.Int, Type.Int ) -> AstType.Binaire(AstType.Fraction, ne1, ne2), Type.Rat
        | _ -> raise (TypeBinaireInattendu (op, t1, t2))
      end


(* analyse_type_instruction : AstTds.instruction ->  -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation du type et tranforme l'instruction
en un instruction de type AstType.instruction et renvoie aussi le type de l'instruction *)
(* Erreur si problème de typage *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration (t, info_ast, e) -> 
    begin
      let (ne, texp) = analyse_type_expression e in 
        if est_compatible t texp then
          let _ = modifier_type_variable t info_ast in
          AstType.Declaration (info_ast, ne)
        else 
          raise (TypeInattendu (texp, t))
    end
  | AstTds.Affectation (info_ast, e) ->
    begin
      let (na, ta) = analyse_type_affectable info_ast in 
      let (ne, te) = analyse_type_expression e in
      if est_compatible ta te then
        AstType.Affectation (info_ast, ne)
      else 
        raise (TypeInattendu (te, ta))
    end
  | AstTds.Affichage (e) -> 
    let (ne, texp) = analyse_type_expression e in 
    begin
      match texp with 
      | Int -> (AffichageInt ne)
      | Rat -> (AffichageRat ne)
      | Bool -> (AffichageBool ne)
      | _ -> failwith "Erreur interne" 
    end
  | AstTds.Conditionnelle (e, b1, b2) ->
    let (ne, texp) = analyse_type_expression e in 
    if est_compatible Bool texp then
      let nbthen = analyse_type_bloc b1 in
      let nbelse = analyse_type_bloc b2 in
      (AstType.Conditionnelle(ne, nbthen, nbelse))
    else 
      raise (TypeInattendu (texp, Bool))
  | AstTds.TantQue (e, b) ->
    let (ne, texp) = analyse_type_expression e in 
    if est_compatible texp Bool then
      AstType.TantQue (ne, analyse_type_bloc b)
    else
       raise (TypeInattendu (texp, Bool))
  | AstTds.Retour (e, info_ast) ->
    begin
      let (ne, te) = analyse_type_expression e in
      match info_ast_to_info info_ast with
        | InfoFun(_, t, _) -> 
          if est_compatible te t then
            (AstType.Retour(ne, info_ast))
          else
            raise (TypeInattendu (te, t))
        | _ -> failwith("Erreur interne.")
    end
  | Empty -> (AstType.Empty)


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Analyse chaque instruction de la liste li *)
and analyse_type_bloc li = List.map analyse_type_instruction li

(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Appel analyse type des paramètres, des instructions, modifie le type de la fonction
 et tranforme la fonction en une fonction de type AstType.fonction *)
(* Erreur si problèmes de typage  *)
let analyse_type_fonction fonction =
  match fonction with
  | AstTds.Fonction(t,info_ast,lp,li) ->
    List.iter (fun (pt, pi) -> modifier_type_variable pt pi) lp;
    let (paramTypeList, paramInfoList) = List.split lp in
    modifier_type_fonction t paramTypeList info_ast;
    let nb = analyse_type_bloc li in
    AstType.Fonction(info_ast, paramInfoList, nb)

(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstTds.Programme (fonctions,prog)) =
  let nf = List.map analyse_type_fonction fonctions in
  let nb = analyse_type_bloc prog in
  AstType.Programme (nf,nb)
