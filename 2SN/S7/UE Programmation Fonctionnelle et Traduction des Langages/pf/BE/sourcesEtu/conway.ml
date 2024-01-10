(* Exercice 1*)

(* max : int list -> int  *)
(* Paramètre : liste dont on cherche le maximum *)
(* Précondition : la liste n'est pas vide *)
(* Résultat :  l'élément le plus grand de la liste *)
let max list = 
  match list with
      | [] -> failwith "ERROR! Liste vide"
      | t::q -> 
        let rec aux l acc =
          match l with 
            | [] -> acc
            | t::q -> if t > acc then aux q t else aux q acc
        in aux q t 

let%test _ = max [ 1 ] = 1
let%test _ = max [ 1; 2 ] = 2
let%test _ = max [ 2; 1 ] = 2
let%test _ = max [ 1; 2; 3; 4; 3; 2; 1 ] = 4

(* max_max : int list list -> int  *)
(* Paramètre : la liste de listes dont on cherche le maximum *)
(* Précondition : il y a au moins un élement dans une des listes *)
(* Résultat :  l'élément le plus grand de la liste *)
let max_max list = max (List.map max list)

let%test _ = max_max [ [ 1 ] ] = 1
let%test _ = max_max [ [ 1 ]; [ 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 2 ]; [ 1; 1; 2; 1; 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 1 ] ] = 2
let%test _ = max_max [ [ 1; 1; 2; 1 ]; [ 1; 2; 2 ] ] = 2

let%test _ =
  max_max [ [ 1; 1; 1 ]; [ 2; 1; 2 ]; [ 3; 2; 1; 4; 2 ]; [ 1; 3; 2 ] ] = 4

(* Exercice 2*)

(* suivant : int list -> int list *)
(* Calcule le terme suivant dans une suite de Conway *)
(* Paramètre : le terme dont on cherche le suivant *)
(* Précondition : paramètre différent de la liste vide *)
(* Retour : le terme suivant *)

let suivant list = 
  match list with
    | [] -> failwith "ERROR!"
    | t::q ->  
      let rec aux l n n_times =
        match l with
          | [] -> [n_times]@[n]
          | t::q -> if n = t then (aux q n (n_times+1)) else [n_times]@[n]@(aux q t 1)
      in aux q t 1

let%test _ = suivant [ 1 ] = [ 1; 1 ]
let%test _ = suivant [ 2 ] = [ 1; 2 ]
let%test _ = suivant [ 3 ] = [ 1; 3 ]
let%test _ = suivant [ 1; 1 ] = [ 2; 1 ]
let%test _ = suivant [ 1; 2 ] = [ 1; 1; 1; 2 ]
let%test _ = suivant [ 1; 1; 1; 1; 3; 3; 4 ] = [ 4; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 1; 1; 3; 3; 4 ] = [ 3; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 3; 3; 4 ] = [ 1; 1; 2; 3; 1; 4 ]
let%test _ = suivant [3;3] = [2;3]

(* suite : int -> int list -> int list list *)
(* Calcule la suite de Conway *)
(* Paramètre taille : le nombre de termes de la suite que l'on veut calculer *)
(* Paramètre depart : le terme de départ de la suite de Conway *)
(* Résultat : la suite de Conway *)
let suite taille list = 
    let rec aux p l acc =
      if p = taille 
        then acc 
      else 
        match l with
          | [] -> acc@[suivant l]
          | _ -> acc@(aux (p+1) (suivant l) [suivant l])
      in aux 1 list [list]


let%test _ = suite 1 [ 1 ] = [ [ 1 ] ]
let%test _ = suite 2 [ 1 ] = [ [ 1 ]; [ 1; 1 ] ]
let%test _ = suite 3 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ] ]
let%test _ = suite 4 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1 ] ]

(* The sum can never reach a number > 3 when the first number is one because the maximum repetition of the numbers in the sequence is 3*)
let%test _ = suite 6 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1]]
let%test _ = suite 8 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1]]
let%test _ = suite 10 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1];[3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1];[1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1]]
let%test _ = suite 12 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1];[3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1];[1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1];[1; 1; 1; 3; 1; 2; 2; 1; 1; 3; 3; 1; 1; 2; 1; 3; 2; 1; 1; 3; 2; 1; 2; 2; 2; 1];[3; 1; 1; 3; 1; 1; 2; 2; 2; 1; 2; 3; 2; 1; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1; 1; 3;1; 2; 1; 1; 3; 2; 1; 1]]


(* Tests de la conjecture *)
(* "Aucun terme de la suite, démarant à 1, ne comporte un chiffre supérieur à 3" *)
let%test _ = suite 6 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1]]
let%test _ = suite 8 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1]]
let%test _ = suite 10 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1];[3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1];[1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1]]
let%test _ = suite 12 [ 1 ] = [[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];[1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1];[3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1];[1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1];[1; 1; 1; 3; 1; 2; 2; 1; 1; 3; 3; 1; 1; 2; 1; 3; 2; 1; 1; 3; 2; 1; 2; 2; 2; 1];[3; 1; 1; 3; 1; 1; 2; 2; 2; 1; 2; 3; 2; 1; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1; 1; 3;1; 2; 1; 1; 3; 2; 1; 1]]


(* Remarque :*)
(* 
  The sum can never reach a number > 3 when the first 
  number is one because the maximum repetition of the numbers in the sequence is 3.
  For example, as we know the sequence is the number of times that the same number appears in sequence,
  followed by the same strategy until the rest of the numbers. In the case of 1 as the first elemente,
  the repetition of the number can never reach a sum > 3 because the last numbers will always be
  the repetition maximum 3 times.
*)


