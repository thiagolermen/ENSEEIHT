
(* The type of tokens. *)

type token = 
  | UL_SEMICOLON
  | UL_RBRACE
  | UL_NAME of (string)
  | UL_LBRACE
  | UL_INT of (int)
  | UL_IDENT of (string)
  | UL_FIN
  | UL_EQUAL

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val record: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
