
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | UL_VIRG
    | UL_PTVIRG
    | UL_IDENT of (
# 16 "Parser.mly"
       (string)
# 17 "Parser.ml"
  )
    | UL_FIN
    | UL_ENTIER of (
# 17 "Parser.mly"
       (int)
# 23 "Parser.ml"
  )
    | UL_CROOUV
    | UL_CROFER
  
end

include MenhirBasics

# 1 "Parser.mly"
  

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)


# 40 "Parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_array) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: array. *)

  | MenhirState01 : (('s, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_state
    (** State 01.
        Stack shape : UL_CROOUV.
        Start symbol: array. *)

  | MenhirState04 : (('s, _menhir_box_array) _menhir_cell1_sous_expression_2, _menhir_box_array) _menhir_state
    (** State 04.
        Stack shape : sous_expression_2.
        Start symbol: array. *)

  | MenhirState06 : ((('s, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_cell1_list_sous_expression_2_, _menhir_box_array) _menhir_state
    (** State 06.
        Stack shape : UL_CROOUV list(sous_expression_2).
        Start symbol: array. *)

  | MenhirState09 : (((('s, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_cell1_list_sous_expression_2_, _menhir_box_array) _menhir_cell1_sous_expression_1, _menhir_box_array) _menhir_state
    (** State 09.
        Stack shape : UL_CROOUV list(sous_expression_2) sous_expression_1.
        Start symbol: array. *)


and ('s, 'r) _menhir_cell1_list_sous_expression_2_ = 
  | MenhirCell1_list_sous_expression_2_ of 's * ('s, 'r) _menhir_state * (unit list)

and ('s, 'r) _menhir_cell1_sous_expression_1 = 
  | MenhirCell1_sous_expression_1 of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_sous_expression_2 = 
  | MenhirCell1_sous_expression_2 of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_UL_CROOUV = 
  | MenhirCell1_UL_CROOUV of 's * ('s, 'r) _menhir_state

and _menhir_box_array = 
  | MenhirBox_array of (unit) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 32 "Parser.mly"
                          ( (print_endline "array : expression UL_FIN ") )
# 89 "Parser.ml"
     : (unit))

let _menhir_action_02 =
  fun () ->
    (
# 34 "Parser.mly"
                                                                                        ( (print_endline "expression : UL_CROOUV sous_expression* sous_expression_1  UL_CROFER") )
# 97 "Parser.ml"
     : (unit))

let _menhir_action_03 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 105 "Parser.ml"
     : (unit list))

let _menhir_action_04 =
  fun x xs ->
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 113 "Parser.ml"
     : (unit list))

let _menhir_action_05 =
  fun () ->
    (
# 39 "Parser.mly"
                               ( (print_endline "sous_expression_1 : expression") )
# 121 "Parser.ml"
     : (unit))

let _menhir_action_06 =
  fun () ->
    (
# 40 "Parser.mly"
                           ( (print_endline "sous_expression_1 : UL_IDENT") )
# 129 "Parser.ml"
     : (unit))

let _menhir_action_07 =
  fun () ->
    (
# 41 "Parser.mly"
                            ( (print_endline "sous_expression_1 : UL_ENTIER") )
# 137 "Parser.ml"
     : (unit))

let _menhir_action_08 =
  fun () ->
    (
# 43 "Parser.mly"
                             ( (print_endline "sous_expression_2 : UL_VIRG") )
# 145 "Parser.ml"
     : (unit))

let _menhir_action_09 =
  fun () ->
    (
# 44 "Parser.mly"
                            ( (print_endline "sous_expression_2 : UL_PTVIRG") )
# 153 "Parser.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | UL_CROFER ->
        "UL_CROFER"
    | UL_CROOUV ->
        "UL_CROOUV"
    | UL_ENTIER _ ->
        "UL_ENTIER"
    | UL_FIN ->
        "UL_FIN"
    | UL_IDENT _ ->
        "UL_IDENT"
    | UL_PTVIRG ->
        "UL_PTVIRG"
    | UL_VIRG ->
        "UL_VIRG"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_run_13 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_array =
    fun _menhir_stack _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_FIN ->
          let _v = _menhir_action_01 () in
          MenhirBox_array _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_array) _menhir_state -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_CROOUV (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_VIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_08 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | UL_PTVIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_09 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | UL_CROOUV | UL_ENTIER _ | UL_IDENT _ ->
          let _v = _menhir_action_03 () in
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_array) _menhir_state -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_sous_expression_2 (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_VIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_08 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState04 _tok
      | UL_PTVIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_09 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState04 _tok
      | UL_CROFER | UL_CROOUV | UL_ENTIER _ | UL_IDENT _ ->
          let _v = _menhir_action_03 () in
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_05 : type  ttv_stack. (ttv_stack, _menhir_box_array) _menhir_cell1_sous_expression_2 -> _ -> _ -> _ -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_sous_expression_2 (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_04 x xs in
      _menhir_goto_list_sous_expression_2_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_list_sous_expression_2_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_array) _menhir_state -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState09 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState01 ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState04 ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_10 : type  ttv_stack. (((ttv_stack, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_cell1_list_sous_expression_2_, _menhir_box_array) _menhir_cell1_sous_expression_1 -> _ -> _ -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_CROFER ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_sous_expression_1 (_menhir_stack, _, _) = _menhir_stack in
          let MenhirCell1_list_sous_expression_2_ (_menhir_stack, _, _) = _menhir_stack in
          let MenhirCell1_UL_CROOUV (_menhir_stack, _menhir_s) = _menhir_stack in
          let _ = _menhir_action_02 () in
          _menhir_goto_expression _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_expression : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_array) _menhir_state -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_13 _menhir_stack _tok
      | MenhirState06 ->
          _menhir_run_12_spec_06 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_12_spec_06 : type  ttv_stack. ((ttv_stack, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_cell1_list_sous_expression_2_ -> _ -> _ -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let _v = _menhir_action_05 () in
      _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
  
  and _menhir_run_09 : type  ttv_stack. (((ttv_stack, _menhir_box_array) _menhir_cell1_UL_CROOUV, _menhir_box_array) _menhir_cell1_list_sous_expression_2_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_array) _menhir_state -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_sous_expression_1 (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_VIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_08 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState09 _tok
      | UL_PTVIRG ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_09 () in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState09 _tok
      | UL_CROFER ->
          let _ = _menhir_action_03 () in
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_06 : type  ttv_stack. ((ttv_stack, _menhir_box_array) _menhir_cell1_UL_CROOUV as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_array) _menhir_state -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_list_sous_expression_2_ (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_IDENT _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_06 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | UL_ENTIER _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_07 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | UL_CROOUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
      | _ ->
          _eRR ()
  
  let rec _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_array =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_CROOUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | _ ->
          _eRR ()
  
end

let array =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_array v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 47 "Parser.mly"
  

# 331 "Parser.ml"
