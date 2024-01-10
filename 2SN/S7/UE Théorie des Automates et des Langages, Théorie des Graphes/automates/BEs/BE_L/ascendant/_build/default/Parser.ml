
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | UL_PT
    | UL_PAROUV
    | UL_PARFER
    | UL_IDENT of (
# 16 "Parser.mly"
       (string)
# 18 "Parser.ml"
  )
    | UL_FIN
    | UL_ENTIER of (
# 17 "Parser.mly"
       (int)
# 24 "Parser.ml"
  )
  
end

include MenhirBasics

# 1 "Parser.mly"
  

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)


# 39 "Parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_scheme) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: scheme. *)

  | MenhirState01 : (('s, _menhir_box_scheme) _menhir_cell1_UL_PAROUV, _menhir_box_scheme) _menhir_state
    (** State 01.
        Stack shape : UL_PAROUV.
        Start symbol: scheme. *)

  | MenhirState09 : ((('s, _menhir_box_scheme) _menhir_cell1_UL_PAROUV, _menhir_box_scheme) _menhir_cell1_expression, _menhir_box_scheme) _menhir_state
    (** State 09.
        Stack shape : UL_PAROUV expression.
        Start symbol: scheme. *)

  | MenhirState10 : (((('s, _menhir_box_scheme) _menhir_cell1_UL_PAROUV, _menhir_box_scheme) _menhir_cell1_expression, _menhir_box_scheme) _menhir_cell1_UL_PT, _menhir_box_scheme) _menhir_state
    (** State 10.
        Stack shape : UL_PAROUV expression UL_PT.
        Start symbol: scheme. *)

  | MenhirState13 : ((('s, _menhir_box_scheme) _menhir_cell1_expression, _menhir_box_scheme) _menhir_cell1_expression, _menhir_box_scheme) _menhir_state
    (** State 13.
        Stack shape : expression expression.
        Start symbol: scheme. *)


and ('s, 'r) _menhir_cell1_expression = 
  | MenhirCell1_expression of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_UL_PAROUV = 
  | MenhirCell1_UL_PAROUV of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_UL_PT = 
  | MenhirCell1_UL_PT of 's * ('s, 'r) _menhir_state

and _menhir_box_scheme = 
  | MenhirBox_scheme of (unit) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 33 "Parser.mly"
                               ( (print_endline "expression : sous_expression_1") )
# 85 "Parser.ml"
     : (unit))

let _menhir_action_02 =
  fun () ->
    (
# 34 "Parser.mly"
                               ( (print_endline "expression : UL_IDENT ") )
# 93 "Parser.ml"
     : (unit))

let _menhir_action_03 =
  fun () ->
    (
# 35 "Parser.mly"
                               ( (print_endline "expression : UL_ENTIER ") )
# 101 "Parser.ml"
     : (unit))

let _menhir_action_04 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 109 "Parser.ml"
     : (unit list))

let _menhir_action_05 =
  fun x xs ->
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 117 "Parser.ml"
     : (unit list))

let _menhir_action_06 =
  fun () ->
    (
# 31 "Parser.mly"
                           ( (print_endline "scheme : expression UL_FIN ") )
# 125 "Parser.ml"
     : (unit))

let _menhir_action_07 =
  fun () ->
    (
# 37 "Parser.mly"
                                                          ( (print_endline "sous_expression_1 : UL_PAROUV sous_expression_2 UL_PARFER") )
# 133 "Parser.ml"
     : (unit))

let _menhir_action_08 =
  fun () ->
    (
# 39 "Parser.mly"
                                       ( (print_endline "sous_expression_2 : sous_expression_3") )
# 141 "Parser.ml"
     : (unit))

let _menhir_action_09 =
  fun () ->
    (
# 40 "Parser.mly"
                                                ( (print_endline "sous_expression_2 : expression*") )
# 149 "Parser.ml"
     : (unit))

let _menhir_action_10 =
  fun () ->
    (
# 42 "Parser.mly"
                                                 ( (print_endline "sous_expression_3 : expression UL_PT expression") )
# 157 "Parser.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | UL_ENTIER _ ->
        "UL_ENTIER"
    | UL_FIN ->
        "UL_FIN"
    | UL_IDENT _ ->
        "UL_IDENT"
    | UL_PARFER ->
        "UL_PARFER"
    | UL_PAROUV ->
        "UL_PAROUV"
    | UL_PT ->
        "UL_PT"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_run_15 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_scheme =
    fun _menhir_stack _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_FIN ->
          let _v = _menhir_action_06 () in
          MenhirBox_scheme _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_scheme) _menhir_state -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_PAROUV (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_PAROUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState01
      | UL_IDENT _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_02 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | UL_ENTIER _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_03 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | UL_PARFER ->
          let _ = _menhir_action_04 () in
          _menhir_run_08_spec_01 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_09 : type  ttv_stack. ((ttv_stack, _menhir_box_scheme) _menhir_cell1_UL_PAROUV as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_scheme) _menhir_state -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expression (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_PT ->
          let _menhir_stack = MenhirCell1_UL_PT (_menhir_stack, MenhirState09) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_PAROUV ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState10
          | UL_IDENT _ ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _ = _menhir_action_02 () in
              _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
          | UL_ENTIER _ ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _ = _menhir_action_03 () in
              _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
          | _ ->
              _eRR ())
      | UL_PAROUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState09
      | UL_IDENT _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_02 () in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState09 _tok
      | UL_ENTIER _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_03 () in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState09 _tok
      | UL_PARFER ->
          let _v = _menhir_action_04 () in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_11 : type  ttv_stack. (((ttv_stack, _menhir_box_scheme) _menhir_cell1_UL_PAROUV, _menhir_box_scheme) _menhir_cell1_expression, _menhir_box_scheme) _menhir_cell1_UL_PT -> _ -> _ -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_UL_PT (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expression (_menhir_stack, _, _) = _menhir_stack in
      let _ = _menhir_action_10 () in
      let _ = _menhir_action_08 () in
      _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
  
  and _menhir_run_05 : type  ttv_stack. (ttv_stack, _menhir_box_scheme) _menhir_cell1_UL_PAROUV -> _ -> _ -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_PARFER ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_UL_PAROUV (_menhir_stack, _menhir_s) = _menhir_stack in
          let _ = _menhir_action_07 () in
          let _v = _menhir_action_01 () in
          _menhir_goto_expression _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_expression : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_scheme) _menhir_state -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_15 _menhir_stack _tok
      | MenhirState13 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState09 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState01 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_13 : type  ttv_stack. ((ttv_stack, _menhir_box_scheme) _menhir_cell1_expression as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_scheme) _menhir_state -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expression (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_PAROUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | UL_IDENT _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_02 () in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState13 _tok
      | UL_ENTIER _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_03 () in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState13 _tok
      | UL_PARFER ->
          let _v = _menhir_action_04 () in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_12 : type  ttv_stack. (ttv_stack, _menhir_box_scheme) _menhir_cell1_expression -> _ -> _ -> _ -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expression (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_05 x xs in
      _menhir_goto_list_expression_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_list_expression_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_scheme) _menhir_state -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState13 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState09 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState01 ->
          _menhir_run_08_spec_01 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_08_spec_01 : type  ttv_stack. (ttv_stack, _menhir_box_scheme) _menhir_cell1_UL_PAROUV -> _ -> _ -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let _ = _menhir_action_09 () in
      _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
  
  let rec _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_scheme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_PAROUV ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | UL_IDENT _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _ = _menhir_action_02 () in
          _menhir_run_15 _menhir_stack _tok
      | UL_ENTIER _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _ = _menhir_action_03 () in
          _menhir_run_15 _menhir_stack _tok
      | _ ->
          _eRR ()
  
end

let scheme =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_scheme v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 43 "Parser.mly"
  

# 357 "Parser.ml"
