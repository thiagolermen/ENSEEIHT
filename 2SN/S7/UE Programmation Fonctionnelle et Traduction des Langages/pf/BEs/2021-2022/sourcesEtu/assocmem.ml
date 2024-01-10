open Util
open Mem


(* get_assoc: function that given a key e in a list l, returns its value
and if the key does't exist, returns 0 by default
Signature: 'a -> ('a * 'b) list -> 'b -> 'b
Returns: the value of a given key or def if the key doesn't exist
 *)
let rec get_assoc e l def = 
    match l with
        | [] -> def
        | (tk, tv)::q -> if e = tk then tv else get_assoc e q def


let%test _ = get_assoc 1 [(1, 'J');(2, 'F');(3, 'M')] _0 = 'J'
let%test _ = get_assoc 5 [(1, 'J');(2, 'F');(3, 'M')] _0 = _0

(* set_assoc : given a key e, replace the value v of e in a list l to x, or adds a tuple (e, x)
if the key e doesn't exist
Signature: 'a -> ('a * 'b) list -> 'b -> ('a * 'b) list
Returns: 
 *)
let rec set_assoc e l x = 
    match l with
        | [] -> [(e, x)]
        | (tk, tv)::q -> if e = tk then (tk, x)::q else [(tk, tv)]@(set_assoc e q x)

(* Tests unitaires : TODO *)
let%test _ = set_assoc 2 [(1, 'J');(2, 'F');(3, 'M')] 'A' = [(1, 'J');(2, 'A');(3, 'M')]
let%test _ = set_assoc 3 [(1, 'J');(2, 'F');(3, 'M')] 'B' = [(1, 'J');(2, 'F');(3, 'B')]
let%test _ = set_assoc 5 [(1, 'J');(2, 'F');(3, 'M')] 'B' = [(1, 'J');(2, 'F');(3, 'M');(5, 'B')]

module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = (int * char) list

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (bs, m) = (2*bs)*(List.length m)

    (* Nombre de cases utilisées *)
    let busyness (bs, m) = List.fold_left (fun acc (_, v) -> if v == _0 then acc else acc + 1) 0 m

    (* Construire une mémoire vide *)
    let clear bs = (bs, List.init (pow2 bs) (fun x -> (x, _0)))

    (* Lire une valeur *)
    let rec read (bs, m) addr = get_assoc addr m _0

    (* Écrire une valeur *)
    let rec write (bs, m) addr x = (bs, set_assoc addr m x)
end
