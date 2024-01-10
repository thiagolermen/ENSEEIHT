open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptEntier : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un entier *)
(* et avance dans l'analyse si c'est le cas *)
let acceptEntier stream =
  match (peekAtFirstToken stream) with
    | (UL_ENTIER entier) -> (print_endline (("accept : ") ^ (string_of_int entier)));(Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un ident *)
(* et avance dans l'analyse si c'est le cas *)
let acceptIdent stream =
  match (peekAtFirstToken stream) with
    | (UL_IDENT ident) -> (print_endline (("accept : ") ^ ident));(Success (advanceInStream stream))
    | _ -> Failure
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseT : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseT stream =
  (print_string "T -> ");
  (match (peekAtFirstToken stream) with
    (* regle #1 *)
    | UL_CROOUV -> (print_endline "[L SL]");
    (inject stream >>=
    accept UL_CROOUV >>=
    parseL >>=
    parseSL >>=
    accept UL_CROFER)
    | _ -> Failure)

(* parseL : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseL stream =
  (print_string "L -> ");
  (match (peekAtFirstToken stream) with
    | (UL_CROOUV | UL_IDENT _ | UL_ENTIER _ ) -> (print_endline "V SV");
      (inject stream >>=
      parseV >>=
      parseSV)
    | _ -> Failure)

(* parseSL : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSL stream =
  (print_string "SL -> ");
  (match (peekAtFirstToken stream) with
    (* regle #2 *)
    | UL_CROFER -> (print_endline "");
    (inject stream)
    (* regle #3 *)
    | UL_PTVIRG -> (print_endline ";L SL");
    (inject stream >>=
    accept UL_PTVIRG >>=
    parseL >>=
    parseSL)
    | _ -> Failure)

(* parseV : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseV stream =
  (print_string "V -> ");
  (match (peekAtFirstToken stream) with
  | UL_CROOUV -> (print_endline "T");
  (inject stream >>=
  parseT)
  | UL_IDENT _ -> (print_endline "Ident");
  (inject stream >>=
  acceptIdent)
  | UL_ENTIER _ -> (print_endline "Entier");
  (inject stream >>=
  acceptEntier)
  | _ -> Failure)


(* parseSV : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSV stream =
  (print_string "SV -> ");
  (match (peekAtFirstToken stream) with
  |  UL_VIRG -> (print_endline ", V SV");
  (inject stream >>=
  accept UL_VIRG >>=
  parseV >>=
  parseSV)
  | (UL_PTVIRG | UL_CROFER) -> (print_endline "");
  (inject stream)
  | _ -> Failure)











;;
