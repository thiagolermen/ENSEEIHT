(* open Graphics *)
(* open Affichage *)

(* Exercice 2 *)
(*  
   coeff_directeur : float*float -> float*float -> float
   calcule le coefficient directeur de la droite représentée par deux points
   Parametre (x1, y1) : float*float, le premier point
   Parametre (x2, y2) : float*float, le second point
   Resultat : float, le coefficient directeur de la droite passant par
   (x1, y1) et (x2, y2)
*)

let coeff_directeur (x1,y1) (x2,y2) = (y2 -. y1) /. (x2 -. x1)

let%test _ = coeff_directeur (0., 0.) (1., 2.) = 2.
let%test _ = coeff_directeur (1., 2.) (0., 0.) = 2.
let%test _ = coeff_directeur (0., 0.) (2., 1.) = 0.5
let%test _ = coeff_directeur (0., 0.) (-2., 1.) = -0.5
let%test _ = coeff_directeur (1., 2.) (2., 1.) = -1.


(* Exercice 3 *)
(* Les contrats et tests des fonctions ne sont pas demandés *)
(* f1 : int * int -> bool *)
let double_greater_equal (a, b) = 
   if 2*a >= b
      then true
   else
      false

(* f2 : int -> bool *)
let is_even a = 
   if a mod 2 = 0
      then true
   else
      false

(* f3 : 'a -> `a *)
let identity a = a

(* f4 : `a * `a -> bool *)
let is_first_greater tuple = fst(tuple) > snd(tuple)

(* f5 : `a*`b -> `a*)
let return_first tuple = fst(tuple)


(* Exercice 4 *)
(* ieme : ('a * 'a * 'a) -> 'a type *)
(* renvoie le ième élément d'un triplet *)
(* t : le triplet *)
(* i : l'indice de l'élèment dans le triplet *)
(* renvoie le ième élément t *)
(* précondition : 1 =< i =< 3 *)

let ieme t i = 
   if i = 1 then let (a, _, _) = t in a
   else if i = 2 then let (_, b, _) = t in b
   else let (_, _, c) = t in c

let%test _ = ieme (5,60,7) 1 = 5
let%test _ = ieme (5,60,17) 2 = 60
let%test _ = ieme (5,60,17) 3 = 17
let%test _ = ieme ('r','e','l') 1 = 'r'
let%test _ = ieme ('r','e','l') 2 = 'e'

(* Exercice 5 *)
(* PGCD -> pgcd.ml *)
(*pgcd: int -> int -> int*)
(*
Preconditions: 
   when the recursive input a b are equal, returns a. It always reaches the 
   base case because it keeps substracting the smallest number from the highest,
   reaching either the smallest number or 1, which is the last case scenario for the program to stop.contents

Yes. We can use the inner scope of the function pgcd to initialie another function that can check if the values
   are positive or negative instead of applying the function abs to all values in the function pgcd
*)

(* let rec pgcd a b =
   if abs a = abs b then abs a
   else if abs a > abs b then (pgcd (abs a - abs b)  (abs b))
   else (pgcd (abs a) (abs b - abs a)) *)

   let rec pgcd a b =
      let aux a b =
        if a = 0 then b
        else if b = 0 then a
        else if a = b then a
        else if a > b then (pgcd (a - b) b)
        else (pgcd a (b - a))
      in aux (abs a) (abs b)
    
    let%test _ = pgcd 5 5 = 5
    let%test _ = pgcd 36 48 = 12
    let%test _ = pgcd 48 36 = 12
    let%test _ = pgcd 100 50 = 50
    let%test _ = pgcd 7 2 = 1
    let%test _ = pgcd (-10) (-10) = 10
    let%test _ = pgcd (-10) (5) = 5
    let%test _ = pgcd (5) (-10) = 5
    let%test _ = pgcd 0 1 = 1
    let%test _ = pgcd 20 0 = 20
    let%test _ = pgcd 1532 1237 = 1
    let%test _ = pgcd 15320 6050 = 10


(* Exercice 6 *)
(*  padovan : int -> int
Fonction qui calcule la nième valeur de la suite de Padovan : u(n+3) = u(n+1) + u(n); u(2)=1, u(1)=u(0)=0 
Paramètre n : un entier représentant la nième valeur à calculer
Précondition : n >=0
Résultat : un entier la nième valeur de la suite de Padovan 
*)

let rec padovan n = 
   match n with
      | 0 -> 0
      | 1 -> 0
      | 2 -> 1
      | _ -> (padovan (n - 2)) + (padovan (n - 3))


let%test _ = padovan 0 = 0
let%test _ = padovan 1 = 0 
let%test _ = padovan 2 = 1
let%test _ = padovan 3 = 0
let%test _ = padovan 4 = 1
let%test _ = padovan 5 = 1
let%test _ = padovan 6 = 1
let%test _ = padovan 7 = 2
let%test _ = padovan 8 = 2
let%test _ = padovan 9 = 3
let%test _ = padovan 10 = 4

let padovan2 n = 
   let rec pad_term p pad_p =
      if n >= n then pad_p
      else pad_term (p+2) ((p+3) + pad_p)
   in pad_term 0 0

(* Exercice 7 *)
(* estPremier : int -> bool
fonction qui indique si un nombre est premier
Paramètre n : un entier naturel dont on doit dire s'il est premier ou pas
Précondition : n >= 0
Résultat : l'information de si n est premier ou pas
*)

let rec estPremier n i =
   if (n <= 2 || n mod i = 0) then
      false
   else if (i * i > n) then
      true
   else
      estPremier n (i + 1)

let i = 2
let%test _ = estPremier 2 i
let%test _ = estPremier 3 i
let%test _ = not (estPremier 4 i)
let%test _ = estPremier 5
let%test _ = not (estPremier 6 i)
let%test _ = estPremier 7 i
let%test _ = not (estPremier 8 i)
let%test _ = not (estPremier 9 i)
let%test _ = not (estPremier 10 i)
let%test _ = not (estPremier 0 i)
let%test _ = not (estPremier 1 i)

(*****************************)
(****** Bonus "ludique" ******)
(*****************************)


(*  Création de l'écran d'affichage *)
(* let _ = open_graph " 800x600" *)

(* Exercice 8 *)
(*  
   dragon : (int*int) -> (int*int) -> int -> unit
   Dessine la courbe du dragon à partir de deux points et d'une précision.
   Parametre (xa,ya) : (int*int), coordonnées de la première extrémité du dragon
   Paramètre (xb,yb) : (int*int), coordonnées de la seconde extrémité du dragon
   Paramètre n : nombre d'itération (plus n est grand, plus la courbe aura de détails)
   Resultat : unit, affichage de la courbe du dragon sur l'écran
   Précondition : n positif ou nul
*)

let dragon (xa,ya) (xb,yb) n = failwith "TO DO"

(* let%test_unit _ = dragon (200,350) (600,350) 20; *)

(*  Fermeture de l'écran d'affichage *)
(* close_graph() *)
*)