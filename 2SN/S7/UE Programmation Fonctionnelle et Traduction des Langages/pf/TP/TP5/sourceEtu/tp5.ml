(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

(* EXERCICE 1 *)
(* Module réalisant la conversion des expressions en chaine de caracteres *)
module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "(" ^ e1 ^ "+" ^ e2 ^ ")"
  let mult e1 e2 = "(" ^ e1 ^ "*" ^ e2 ^ ")"
end

(* Module d'évaluation des exemples *)
module EvalPrintExemples =  ExemplesSimples (PrintSimple)

let%test _ = (EvalPrintExemples.exemple1 = "(1+(2*3))")
let%test _ = (EvalPrintExemples.exemple2 = "((5+2)*(2*3))")

(* EXERCICE 2 *)
(* Module permet de compter les opérations d’une expression *)
module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 0
  let plus e1 e2 = e1 + e2 + 1
  let mult e1 e2 = e1 + e2 + 1
end

(* Module d'évaluation des exemples *)
module EvalCompteExemples =  ExemplesSimples (CompteSimple)

let%test _ = (EvalCompteExemples.exemple1 = 2)
let%test _ = (EvalCompteExemples.exemple2 = 3)

(* EXERCICE 3 *)
(* Module abstrayant les expressions *)
(* Module *)
module type ExprVar =
sig 
  type t
  val def : (string * t) -> t -> t
  val var : string -> t
end

module type Expr =
sig 
  include ExprSimple
  include (ExprVar with type t := t)
end

(* EXERCICE 4 *)
(* Module réalisant la conversion des expressions en chaine de caracteres *)
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let var v = v
  let def (v, e1) e2 = "let "^v^" = "^e1^" in "^e2
end

module Print : Expr with type t = string =
struct
  include PrintSimple
  include (PrintVar : ExprVar with type t := t)
end 

(* Définition des expressions *)
module ExemplesVar (E:Expr) =
struct
  (* “let x = 1+2 in x*3” *)
  let exemple1  = E.(def ("x", (plus (const 1) (const 2))) (mult (var "x") (const 3) ))
  let exemple2 = E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalVarExamples =  ExemplesVar (Print)
let%test _ = (EvalVarExamples.exemple1 = "let x = (1+2) in (x*3)")
let%test _ = (EvalVarExamples.exemple2 = "((5+2)*(2*3))")




