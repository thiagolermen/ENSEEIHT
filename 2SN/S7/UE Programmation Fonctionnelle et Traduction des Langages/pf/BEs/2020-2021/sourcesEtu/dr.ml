(*  Module qui permet la décomposition et la recomposition de données **)
(*  Passage du type t1 vers une liste d'éléments de type t2 (décompose) **)
(*  et inversement (recopose).**)
module type DecomposeRecompose =
sig
  (*  Type de la donnée **)
  type mot
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole

  (* 
    fonction de recomposition pour les chaînes de caractères
    signature : recompose_chaine : char list -> string = <fun>
    paramètre(s) : une liste de caractères                              
    résultat     : la chaîne des caractères composant la liste paramètre
  *)
  val decompose : mot -> symbole list

  (* 
    fonction de décomposition pour les chaînes de caractères
    signature : decompose_chaine : string -> char list = <fun>
    paramètre(s) : une chaîne de caractères                                 
    résultat     : la liste des caractères composant la chaîne paramètre
  *)
  val recompose : symbole list -> mot
end

module DRString : DecomposeRecompose with type mot = string and type symbole = char =
struct

  type mot = string
  type symbole = char

  let decompose s =                                                  
    let rec aux i accu = 
      if i < 0 
        then accu 
      else 
        aux (i-1) (s.[i]::accu)
    in aux (String.length s - 1) [] 

  let rec recompose sl =
    match sl with
      | [] -> ""
      | t::q -> (Char.escaped t) ^ (recompose q)

  let%test _ = decompose "" = []
  let%test _ = decompose "a" = ['a']
  let%test _ = decompose "aa" = ['a';'a']
  let%test _ = decompose "abc" = ['a';'b';'c']
  let%test _ = decompose "abcdef" = ['a'; 'b'; 'c'; 'd'; 'e'; 'f']

  let%test _ = recompose [] = ""
  let%test _ = recompose ['a'] = "a"
  let%test _ = recompose ['a';'a'] = "aa"
  let%test _ = recompose ['a';'b';'c'] = "abc"
  let%test _ = recompose ['a'; 'b'; 'c'; 'd'; 'e'; 'f'] = "abcdef"

end

module DRNat : DecomposeRecompose with type mot = int and type symbole = int =
struct

  type mot = int
  type symbole = int

  let decompose n = 
    if n = 0 
      then [0] 
    else 
      let rec aux n =
        match n with
          | 0 -> []
          | _ -> (aux (n / 10))@[(n mod 10)]
      in aux n
  let recompose sl = 
    let rec aux l num =
      match l with 
        | [] -> num
        | (t::q) -> aux q ((num * 10 ) + t)
  in aux sl 0

  let%test _ = decompose 0 = [0]
  let%test _ = decompose 1 = [1]
  let%test _ = decompose 12 = [1;2]
  let%test _ = decompose 123= [1;2;3]
  let%test _ = decompose 12345 = [1;2;3;4;5]

  let%test _ = recompose [0] = 0
  let%test _ = recompose [1] = 1
  let%test _ = recompose [1;2] = 12
  let%test _ = recompose [1;2;3] = 123
  let%test _ = recompose [1;2;3;4;5] = 12345

end