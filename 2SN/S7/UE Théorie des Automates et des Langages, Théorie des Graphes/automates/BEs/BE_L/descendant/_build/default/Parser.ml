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


(* parseS : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseS stream =
  (print_string "S -> ");
  (match (peekAtFirstToken stream) with
    (* regle #1 *)
    | UL_PAROUV -> (print_endline "(X)");
    (inject stream >>=
    accept UL_PAROUV >>=
    parseX >>=
    accept UL_PARFER)
    (* regle #2 *)
    | UL_IDENT _ -> (print_endline "Ident");
    (inject stream >>=
    acceptIdent)
    (* regle #3 *)
    | UL_ENTIER _ -> (print_endline "entier");
    (inject stream >>=
    acceptEntier)
    | _ -> Failure)

and parseX stream =
(print_string "X -> ");
(match (peekAtFirstToken stream) with
  (* regle #4 *)
  |  UL_PARFER -> (print_endline "");
  (inject stream)
  (* regle #5 *)
  | (UL_PAROUV | UL_IDENT _ | UL_ENTIER _ ) -> (print_endline "S Y");
  (inject stream >>=
  parseS >>=
  parseY)
  | _ -> Failure)

and parseY stream =
  (print_string "Y -> ");
  (match (peekAtFirstToken stream) with
    (* regle #6 *)
    |  UL_PT -> (print_endline ". S");
    (inject stream >>=
    accept UL_PT >>=
    parseS)
    (* regle #7 *)
    | (UL_PAROUV | UL_IDENT _ | UL_ENTIER _ ) -> (print_endline "L");
    (inject stream >>=
    parseL)
    | _ -> Failure)

and parseL stream =
  (print_string "L -> ");
  (match (peekAtFirstToken stream) with
    (* regle #8 *)
    | (UL_PAROUV | UL_IDENT _ | UL_ENTIER _ ) -> (print_endline "S L");
    (inject stream >>=
    parseS >>=
    parseL)
    (* regle #9 *)
    |  UL_PARFER -> (print_endline "");
    (inject stream)    
    | _ -> Failure)
;;
