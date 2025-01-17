(* Analyseur sémantique *)

open Ast

(* ========================================================*)
(* Définition du type des erreurs *)
type errorType =
  | UnknownIdentError of string
  | TypeMismatchError
  | RuntimeError
  | UndefinedExpressionError


(* ========================================================*)
(* Définition du type des valeurs renvoyées par l'interprète *)
type valueType =
  | FrozenValue of ast * environment
  | FixPoint of ast * environment
  | IntegerValue of int
  | BooleanValue of bool
  | ErrorValue of errorType
and environment = (string * valueType) list


(* ========================================================*)
(* string_of_names : string list -> string *)
(* Convertit une liste de chaînes de caractères en une seule chaîne de caractères *)
let string_of_names names =
  String.concat " " names

(* string_of_env : environment -> string *)
(* Convertit un environnement en une chaîne de caractères en vue de son affichage *)
let rec string_of_env env =
  "{"
  ^ List.fold_left (fun s (key, value) ->
      s ^ (if s = "" then "" else " ; ") ^ key ^ "," ^ string_of_value value)
    "" env
  ^ "}"

(* string_of_value : valueType -> string *)
(* Convertit une valueType en une chaîne de caractères en vue de son affichage *)
and string_of_value value =
  match value with
  | FixPoint(expr, env) -> "fix(" ^ string_of_ast expr ^ string_of_env env ^ ")"
  | FrozenValue(expr, env) -> string_of_ast expr ^ string_of_env env
  | IntegerValue value -> string_of_int value
  | BooleanValue value -> string_of_bool value
  | ErrorValue error -> string_of_error error

(* string_of_error : errorType -> string *)
(* Convertit une erreur en une chaîne de caractères en vue de son affichage *)
and string_of_error error =
  match error with
  | UnknownIdentError name -> "Unknown ident: " ^ name
  | RuntimeError -> "Runtime error"
  | TypeMismatchError -> "Type mismatch"
  | UndefinedExpressionError -> "Undefined expression error"


(* ========================================================*)
type 'a searchResult = 
  | NotFound 
  | Found of 'a


(* lookfor : string -> environment -> valueType searchResult *)
(* Cherche un identifiant dans un environnement et renvoie la valeur associée le cas échéant *)
let rec lookfor name env =
  match env with
  | [] -> NotFound
  | (key, value) :: others ->
    if key = name then Found value else lookfor name others


(* ========================================================*)
(* value_of_expr : ast -> environment -> valueType *)
(* Fonction d'évaluation des expressions *)
let rec value_of_expr expr env =
  match expr with
  | FunctionNode _ -> ruleFunction expr env
  | CallNode (fexpr, pexpr) -> ruleCallByValue env fexpr pexpr
  (*| CallNode (fexpr, pexpr) -> ruleCallByName env fexpr pexpr *)
  | IfthenelseNode (cond, bthen, belse) -> ruleIf env cond bthen belse
  | LetNode (ident, bvalue, bin) -> ruleLet env ident bvalue bin
  | LetrecNode (ident, bvalue, bin) -> ruleLetrec env ident bvalue bin
  | AccessNode name -> ruleName env name
  | IntegerNode value -> ruleInteger value
  | TrueNode -> ruleTrue
  | FalseNode -> ruleFalse
  | BinaryNode (op, left, right) -> ruleBinary env op left right
  | UnaryNode (op, expr) -> ruleUnary env op expr

(* ========================================================*)
(* ruleName : environment -> string -> valueType *)
(* Fonction d'évaluation d'un identificateur *)
and ruleName env name =
  match lookfor name env with
  | NotFound -> ErrorValue (UnknownIdentError name)
  | Found value -> 
      match value with
        | (FixPoint (expr, envdef)) -> FrozenValue (expr,(name, FixPoint(expr,envdef))::envdef)
        | _ -> value

(* ========================================================*)
(* ruleLet : environment -> string -> ast- > ast -> valueType *)
(* Fonction d'évaluation d'un let *)
(* "let ident = bvalue in bin" *)
and ruleLet env ident bvalue bin =
  let v1 = value_of_expr bvalue env in
  match v1 with
    | ErrorValue _ as result -> result
    | _ -> value_of_expr bin ((ident,v1)::env)

(* ========================================================*)
(* ruleBinary : environment -> binary -> ast- > ast -> valueType *)
(* Fonction d'évaluation d'un opérateur binaire *)
and ruleBinary env op left right =
  let leftvalue = value_of_expr left env in
  match leftvalue with
   | ErrorValue _ as result -> result
   | _ ->
     let rightvalue = value_of_expr right env in
     (match rightvalue with
      | ErrorValue _ as result -> result
      | _ ->
        (match leftvalue, rightvalue with
         | IntegerValue leftvalue, IntegerValue rightvalue ->
           (match op with
            | Equal -> BooleanValue (leftvalue = rightvalue)
            | Different -> BooleanValue (leftvalue <> rightvalue)
            | Lesser -> BooleanValue (leftvalue < rightvalue)
            | LesserEqual -> BooleanValue (leftvalue <= rightvalue)
            | Greater -> BooleanValue (leftvalue > rightvalue)
            | GreaterEqual -> BooleanValue (leftvalue >= rightvalue)
            | Add -> IntegerValue (leftvalue + rightvalue)
            | Substract -> IntegerValue (leftvalue - rightvalue)
            | Multiply -> IntegerValue (leftvalue * rightvalue)
            | Divide ->
              if rightvalue = 0 then
                 ErrorValue RuntimeError
               else
                 IntegerValue (leftvalue / rightvalue)
            | _ -> ErrorValue TypeMismatchError)
         | BooleanValue leftvalue, BooleanValue rightvalue ->
           (match op with
            | Or -> BooleanValue (leftvalue || rightvalue)
            | And -> BooleanValue (leftvalue && rightvalue)
            | _ -> ErrorValue TypeMismatchError)
         | _ -> ErrorValue TypeMismatchError))

(* ========================================================*)
(* ruleUnary : environment -> unary -> ast- > valueType *)
(* Fonction d'évaluation d'un opérateur unaire *)
and ruleUnary env op exp =
  let value = value_of_expr exp env in
  match value with
  | ErrorValue _ as result -> result
  | IntegerValue value ->
    (match op with
     | Negate -> IntegerValue (- value))
  | _ -> ErrorValue TypeMismatchError

(* ========================================================*)
(* ruleIf : environment -> ast -> ast -> ast- > valueType *)
(* Fonction d'évaluation d'une conditionnelle *)
(* "if cond then bthen else belse" *)
and ruleIf env cond bthen belse =
    let val_cond = value_of_expr cond env in
    match val_cond with
      | ErrorValue _ as result -> result
      | BooleanValue true -> let v1 = value_of_expr bthen env in 
        match v1 with
        | ErrorValue _ as result -> result
        | _ -> v1
      | BooleanValue false -> let v2 = value_of_expr belse env in 
        match v2 with
        | ErrorValue _ as result -> result
        | _ -> v2
      | _ -> ErrorValue TypeMismatchError

(* ========================================================*)
(* ruleFunction : ast -> environment -> valueType *)
(* Fonction d'évaluation d'une définition de fonction *)
and ruleFunction expr env =
  FrozenValue (expr, env)

(* Appel par nom *)
(* ========================================================*)
(* ruleCallByName : environment -> ast -> ast -> valueType *)
(* Fonction d'évaluation d'un appel de fonction avec passage de paramètre par nom *)
and ruleCallByName env fexpr pexpr =
 let fval = value_of_expr fexpr env in
  match fval with
  | FrozenValue(fexpr2,envdef) -> 
    match fexpr2 with
    | FunctionNode(ident,e3) ->
      let froz = FrozenValue(pexpr,env) in value_of_expr e3 ((ident,froz)::envdef)
    | _ -> ErrorValue TypeMismatchError
  | _ -> ErrorValue TypeMismatchError

(* ========================================================*)
(* ruleCallByValue : environment -> ast -> ast -> valueType *)
(* Fonction d'évaluation d'un appel de fonction avec passage de paramètre par valeur *)
and ruleCallByValue env fexpr pexpr =
  let v2 = value_of_expr pexpr env in
  match v2 with
    | ErrorValue _ as result -> result
    | _ -> let froz = value_of_expr fexpr env in
      match froz with
      | FrozenValue(FunctionNode(x,e3),envdef) -> value_of_expr e3 ((x,v2)::envdef)
      | _ -> ErrorValue TypeMismatchError

(* ========================================================*)
(* ruleLetrec : environment -> string -> ast- > ast -> valueType *)
(* Fonction d'évaluation d'un let rec*)
(* "letrec ident = bvalue in bin" *)
and ruleLetrec env ident bvalue bin =
  let fix = FixPoint(bvalue,env) in value_of_expr bin ((ident,fix)::env)

(* ========================================================*)
(* ruleTrue : valueType *)
(* Fonction d'évaluation de true *)
and ruleTrue = BooleanValue true

(* ========================================================*)
(* ruleFalse : valueType *)
(* Fonction d'évaluation de false *)
and ruleFalse = BooleanValue false

(* ========================================================*)
  (* ruleInteger : int -> valueType *)
  (* Fonction d'évaluation d'un entier *)
and ruleInteger value = IntegerValue value