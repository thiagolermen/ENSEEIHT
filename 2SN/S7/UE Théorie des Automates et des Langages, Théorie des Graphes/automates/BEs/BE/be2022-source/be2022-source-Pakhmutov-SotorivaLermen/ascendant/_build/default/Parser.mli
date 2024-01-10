
(* The type of tokens. *)

type token = 
  | UL_VIRG
  | UL_PTVIRG
  | UL_IDENT of (string)
  | UL_FIN
  | UL_ENTIER of (int)
  | UL_CROOUV
  | UL_CROFER

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val array: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
