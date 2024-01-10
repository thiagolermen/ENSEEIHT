(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp

  (* 
  eval : exp -> int
  Evaluates the result of an expression given an expression
  Params:
    - e: exp, expression that we need to evaluate
  Returns: 
    - v: int the value of the given expression
   *)
  val eval : exp -> int
end

(* Exercice 4 *)

module ExpAvecArbreBinaire : Expression =
struct
  (* Type pour représenter les expressions binaires *)
  type op = Moins | Plus | Mult | Div
  type exp = Binaire of exp * op * exp | Entier of int

  (* eval *)
  let rec eval arbre = 
    match arbre with
      | Entier a -> a
      | Binaire (eg, op, ed) -> 
        match op with
          | Moins -> (eval eg) - (eval ed)
          | Plus -> (eval eg) + (eval ed)
          | Mult -> (eval eg) * (eval ed)
          | Div -> (eval eg) / (eval ed)
          | _ -> failwith "ERROR! Operation not defined!"

  let arbre_sujet = Binaire (Binaire (Entier 3, Plus, Entier 4), Moins, Entier 12)
  let arbre1 = Binaire (Binaire (Entier 5, Mult, Entier 5), Moins, Entier 5)
  let arbre2 = Binaire (Binaire (Entier 4, Mult, Entier 4), Div, Entier 2)

  let%test _ = eval arbre_sujet = -5
  let%test _ = eval arbre1 = 20
  let%test _ = eval arbre2 = 8

end

(* Exercice 5 *)
module ExpAvecArbreNaire : Expression =
struct

  (* Linéarisation des opérateurs binaire associatif gauche et droit *)
  type op = Moins | Plus | Mult | Div
  type exp = Naire of op * exp list | Valeur of int

  
  (* bienformee : exp -> bool *)
  (* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
  (* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
  (* et que les opérateurs de division et soustraction ont exactement deux opérandes.*)
  (* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)
  let rec bienformee arbre = 
    match arbre with
      | Valeur _ -> true
      | Naire (op, fils) -> 
        match op with
          | Moins -> 
            if List.length fils = 2 
              then not (List.mem false (List.map bienformee fils)) 
            else false
          | Plus -> 
            if List.length fils >= 2 
              then not (List.mem false (List.map bienformee fils)) 
            else false
          | Mult ->
            if List.length fils >= 2 
              then not (List.mem false (List.map bienformee fils)) 
            else false
          | Div -> 
            if List.length fils = 2 
              then not (List.mem false (List.map bienformee fils)) 
            else false
          | _ -> failwith "ERROR! Operation not defined!" 

  let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
  let en2 = Naire (Moins, [ en1; Valeur 5 ])
  let en3 = Naire (Mult, [ en1; en2; en1 ])
  let en4 = Naire (Div, [ en3; Valeur 2 ])
  let en1err = Naire (Plus, [ Valeur 3 ])
  let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
  let en3err = Naire (Mult, [ en1 ])
  let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

  let%test _ = bienformee en1
  let%test _ = bienformee en2
  let%test _ = bienformee en3
  let%test _ = bienformee en4
  let%test _ = not (bienformee en1err)
  let%test _ = not (bienformee en2err)
  let%test _ = not (bienformee en3err)
  let%test _ = not (bienformee en4err)

  (* eval : exp-> int *)
  (* Calcule la valeur d'une expression n-aire *)
  (* Paramètre : l'expression dont on veut calculer la valeur *)
  (* Précondition : l'expression est bien formée *)
  (* Résultat : la valeur de l'expression *)
  let rec eval_bienformee arbre = 
    if bienformee arbre 
      then 
        match arbre with
          | Valeur a -> a
          | Naire (op, fils) -> 
            match op with
              | Moins -> 
                (match fils with
                  | [t1;t2] -> (eval_bienformee t1) - (eval_bienformee t2)
                  | _ -> failwith "ERROR! Expression malformee")
              | Plus -> List.fold_right (+) (List.map eval_bienformee fils) 0
              | Mult -> List.fold_right ( * ) (List.map eval_bienformee fils) 1
              | Div -> 
                (match fils with
                | [t1;t2] -> (eval_bienformee t1) / (eval_bienformee t2)
                | _ -> failwith "ERROR! Expression malformee")
              | _ -> failwith "ERROR! Operation not defined!"
    else failwith "ERROR! Expretion malformee"

  let%test _ = eval_bienformee en1 = 19
  let%test _ = eval_bienformee en2 = 14
  let%test _ = eval_bienformee en3 = 5054
  let%test _ = eval_bienformee en4 = 2527

  (* Définition de l'exception Malformee *)
  exception Malformee

  (* eval : exp-> int *)
  (* Calcule la valeur d'une expression n-aire *)
  (* Paramètre : l'expression dont on veut calculer la valeur *)
  (* Résultat : la valeur de l'expression *)
  (* Exception  Malformee si le paramètre est mal formé *)
  let eval arbre = if bienformee arbre then eval_bienformee arbre else raise Malformee

  let%test _ = eval en1 = 19
  let%test _ = eval en2 = 14
  let%test _ = eval en3 = 5054
  let%test _ = eval en4 = 2527

  let%test _ =
    try
      let _ = eval en1err in
      false
    with Malformee -> true

  let%test _ =
    try
      let _ = eval en2err in
      false
    with Malformee -> true

  let%test _ =
    try
      let _ = eval en3err in
      false
    with Malformee -> true

  let%test _ =
    try
      let _ = eval en4err in
      false
    with Malformee -> true

end