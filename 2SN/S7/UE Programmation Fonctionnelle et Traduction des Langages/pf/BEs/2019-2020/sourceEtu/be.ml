let decompose_chaine_ s =
  let rec decompose i accu =
    if i < 0 then accu
    else decompose (i-1) (s.[i]::accu)
  in decompose (String.length s - 1) []

let%test _ = decompose_chaine_ "" = []
let%test _ = decompose_chaine_ "a" = ['a']
let%test _ = decompose_chaine_ "aa" = ['a';'a']
let%test _ = decompose_chaine_ "ab" = ['a';'b']
let%test _ = decompose_chaine_ "abcdef" = ['a'; 'b'; 'c'; 'd'; 'e'; 'f']

let rec recompose_chaine_ lc =
  List.fold_right (fun t q -> String.make 1 t ^ q) lc ""

let%test _ = recompose_chaine_ [] = ""
let%test _ = recompose_chaine_ ['a'] = "a"
let%test _ = recompose_chaine_ ['a';'a'] = "aa"
let%test _ = recompose_chaine_ ['a';'b'] = "ab"
let%test _ = recompose_chaine_ ['a'; 'b'; 'c'; 'd'; 'e'; 'f'] = "abcdef"

let decompose_int_ i =
  List.map int_of_string (List.map (String.make 1)  (decompose_chaine_ (string_of_int i)))

let%test _ = decompose_int_ 258 = [2;5;8]
let%test _ = decompose_int_ 25 = [2;5]
let%test _ = decompose_int_ 2 = [2]

let recompose_int_ li =
  int_of_string (List.fold_right (^) (List.map string_of_int li) "" )

let%test _ = recompose_int_ [2;5;8] = 258
let%test _ = recompose_int_ [2;5] = 25
let%test _ = recompose_int_ [2] = 2
let%test _ = recompose_int_ [121;23;3] = 121233

(*  Exercice 1 **)

let p0 = [2.5]
let p1 = [2.;3.]
let p2 = [2.;5.5;-2.]
let p3 = [4.5;6.;-3.5;-8.]


(* 
  evalue: evaluates a polynom given a value of x
  Signature: float -> float list -> float
  Result: the value of the polynom with coeficients defined in lc given the value x
*)

let evalue x lc = 
  match (List.fold_left (fun (acc, p) e -> (acc+.((x ** p)*.e), p+.1.)) (0., 0.) lc) with
    | (r, _) -> r

let%test _ = evalue 1. p0 = 2.5
let%test _ = evalue 2. p0 = 5.
let%test _ = evalue 1. p1 = 5.
let%test _ = evalue 2. p1 = 8.
let%test _ = evalue 1. p2 = 5.5
let%test _ = evalue 2. p2 = 5.
let%test _ = evalue 3. p2 = 0.5
let%test _ = evalue 1. p3 = -1.
let%test _ = evalue 2. p3 = -61.5

(* retract : float list -> float list
Prend un poulynome et supprime les coéfficients nuls inutiles (ceux de la fin de la liste)
poly : un polynome codé avec une float list
Retour : équivalent à poly sans zéro superflu
*)

let rec retract lc = 
  match lc with
    | [] -> []
    | [e] -> if e != 0. then [e] else []
    | t::q -> if ((List.fold_left (+.) 0. q) = 0.)
                then (retract [t]) else (retract [t])@(retract q)

let%test _ = retract p0 = p0
let%test _ = retract p1 = p1
let%test _ = retract p2 = p2
let%test _ = retract p3 = p3
let%test _ = retract [2.;0.;0.;0.;0.;0.] = [2.]
let%test _ = retract [2.;0.;0.;0.;0.;2.] = [2.;0.;0.;0.;0.;2.]
let%test _ = retract [2.;0.;0.;0.;0.;2.;0.;0.] = [2.;0.;0.;0.;0.;2.]
let%test _ = retract [2.;0.;0.;0.;0.;2.;0.] = [2.;0.;0.;0.;0.;2.]
let%test _ = retract [2.;3.;0.;0.;0.;0.] = [2.;3.]
let%test _ = retract [2.;5.;-2.;0.;0.;0.] = [2.;5.;-2.]
let%test _ = retract [4.;6.;-3.;-8.;0.;0.] = [4.;6.;-3.;-8.]


(* scal_mult : float -> float liste -> float list
Fonction qui multiplie un polynome par un scalaire
Parametre x : un réel
Paramètre poly : un polynome codé avec une float list
Résultat : x * poly, un polynome
*)

let scal_mult c lc = List.map (fun l -> l *. c) lc

let%test _ = scal_mult 0. p0 = []
let%test _ = scal_mult 0. p1 = []
let%test _ = scal_mult 0. p2 = []
let%test _ = scal_mult 0. p3 = []
let%test _ = scal_mult 1. p0 = p0
let%test _ = scal_mult 1. p1 = p1
let%test _ = scal_mult 1. p2 = p2
let%test _ = scal_mult 1. p3 = p3
let%test _ = scal_mult 2. p0 = [5.]
let%test _ = scal_mult 2. p1 = [4.;6.]
let%test _ = scal_mult 2. p2 = [4.;11.;-4.]
let%test _ = scal_mult 2. p3 = [9.;12.;-7.;-16.]

(* plus : float list -> float list -> float list
Fonction qui fait la somme de deux polynomes
Paramètre poly1, poly2 : deux polynomes codés avec une float list
Resultat : un polynome, somme de poly1 et poly2
*)

let rec plus p1 p2 = 
  match p1,p2 with
    | [], [] -> p1
    | [], p -> p
    | p, [] -> p
    | t1::q1, t2::q2 -> (t1 +. t2)::(plus q1 q2)

let%test _ = plus p0 p0 = [5.]
let%test _ = plus p0 p1 = [4.5;3.]
let%test _ = plus p0 p2 = [4.5;5.5;-2.]
let%test _ = plus p0 p3 = [7.;6.;-3.5;-8.]
let%test _ = plus p1 p0 = plus p0 p1
let%test _ = plus p1 p1 = [4.;6.]
let%test _ = plus p1 p2 = [4.;8.5;-2.]
let%test _ = plus p1 p3 = [6.5;9.;-3.5;-8.]
let%test _ = plus p2 p0 = plus p0 p2
let%test _ = plus p2 p1 = plus p1 p2
let%test _ = plus p2 p2 = [4.;11.;-4.]
let%test _ = plus p2 p3 = [6.5;11.5;-5.5;-8.]
let%test _ = plus p3 p0 = plus p0 p3
let%test _ = plus p3 p1 = plus p1 p3
let%test _ = plus p3 p2 = plus p2 p3
let%test _ = plus p3 p3 = [9.;12.;-7.;-16.]
let%test _ = plus p3 [-4.5;-6.;3.5;8.] = []
let%test _ = plus p3 [-4.5;-6.;3.5] = [0.;0.;0.;-8.]
let%test _ = plus p3 [0.;-6.;3.5;8.] = [4.5]
let%test _ = plus p3 [0.;0.;3.5;8.] = [4.5;6.]
let%test _ = plus p3 [0.;0.;0.;8.] = [4.5;6.;-3.5]


(* Exercice 2 *)

open Util

(* Arbre d'encodage : arbre ternaire *)
type arbre_encodage = Vide | Lettre of char | Noeud of arbre_encodage * arbre_encodage * arbre_encodage

(* Arbre d'encodage complexe du sujet 
Permet de coder les mots sur {'a','b','c','d','e','f'} 
en codant le 'a' par 3, le 'b' par 12, le 'c' par 212, le 'd' par 22, le 'e' par 11 et le 'f' par 213
*)
let arbre_sujet =
  Noeud (
          Noeud (Lettre 'e',Lettre 'b',Vide) ,
          Noeud (
                Noeud (Vide, Lettre 'c', Lettre 'f'),
                Lettre 'd',
                Vide),
          Lettre 'a'
        )

(* Arbre d'encodage simple du sujet
Permet de coder les mots sur {'a','b','c'} 
en codant le 'a' par 1, le 'b' par 2 et le 'c' par 3*)
let arbre_simple =
  Noeud (Lettre 'a', Lettre 'b', Lettre 'c')


(* Exception levée quand le code ne peut pas être décodé avec l'arbre d'encodage *)
exception CodeNonValide

(* decoder : int -> arbre_encodage -> string
Décode un entier en utilisant l'abre d'encodage
Paramètre code : l'entier à décoder
Paramètre arbre : l'arbre d'encodage
Retour : la chaîne de caractère correspondant à l'entier
Erreur si le code ne peut pas être décodé avec l'arbre d'encodage
*)
let rec decoder code arbre = 
  let rec aux c ar =
    match c with
      | [] -> ""
      | t::q -> 
        match ar with
          | Vide -> raise CodeNonValide
          | Lettre a -> (Char.escaped a) ^ (decoder (recompose_int q) arbre) 
          | Noeud (g,m,d) -> 
            if t = 1
              then (aux q g) 
            else if t = 2
              then (aux q m)
            else (aux q d)
  in aux (decompose_int code) arbre

let%test _ = decoder 123212 arbre_simple = "abcbab"
let%test _ = decoder 123212 arbre_sujet = "bac"
let%test _ = decoder 123 arbre_simple = "abc"
let%test _ = decoder 123 arbre_sujet = "ba"
let%test _ = decoder 321321 arbre_simple = "cbacba"
let%test _ = try let _ = decoder 321321 arbre_sujet in false with CodeNonValide -> true
let%test _ = try let _ = decoder 457 arbre_simple in false with CodeNonValide -> true

(* arbre_to_liste : arbre_encodage -> (char*int) list
  Converti un arbre d'encodage en une liste associative (caractère, code)
  Paramètre a : l'abre à convertir
  Retour la liste  associative (caractère, code)
*)
let arbre_to_liste arbre = 
  let rec aux ar acc =
    match ar with
      | Vide -> []
      | Lettre a -> [(a, (recompose_int acc))]
      | Noeud (g,m,d) -> (aux g (acc@[1]))@(aux m (acc@[2]))@(aux d (acc@[3]))
  in aux arbre []


let liste_arbre_simple = arbre_to_liste arbre_simple
let%test _ = List.length liste_arbre_simple =3
let%test _ = List.mem ('a',1) liste_arbre_simple
let%test _ = List.mem ('b',2) liste_arbre_simple
let%test _ = List.mem ('c',3) liste_arbre_simple

let liste_arbre_sujet = arbre_to_liste arbre_sujet
let%test _ = List.length liste_arbre_sujet =6
let%test _ = List.mem ('a',3) liste_arbre_sujet
let%test _ = List.mem ('b',12) liste_arbre_sujet
let%test _ = List.mem ('c',212) liste_arbre_sujet
let%test _ = List.mem ('d',22) liste_arbre_sujet
let%test _ = List.mem ('e',11) liste_arbre_sujet
let%test _ = List.mem ('f',213) liste_arbre_sujet

(* Exception levée quand le mot ne peut pas être encodé avec l'arbre d'encodage *)
exception MotNonValide


(* encoder : string -> arbre_encodage -> int
Encode un mot à l'aide d'un arbre d'encodage
Paramètre mot : le mot à encoder
Paramètre arbre : l'arbre d'encodage
Retour : le code associé au mot
Erreur si le mot ne peut pas être encodé avec l'arbre d'encodage
*)

let encoder_char mot arbre =
  let rec aux c a_liste = 
    match c with
      | [] -> []
      | t::q -> 
        try (List.assoc t a_liste)::(aux q a_liste) with Not_found -> raise MotNonValide
  in aux (decompose_chaine_ mot) (arbre_to_liste arbre)

let encoder mot arbre = (recompose_int_ (encoder_char mot arbre))

let%test _ = encoder "abcbab" arbre_simple = 123212
let%test _ = encoder "bac" arbre_sujet = 123212
let%test _ = encoder "abc" arbre_simple = 123
let%test _ = encoder "ba" arbre_sujet = 123
let%test _ = encoder "cbacba" arbre_simple = 321321
let%test _ = try let _ = encoder "dab" arbre_simple in false with MotNonValide -> true 
let%test _ = try let _ = encoder "zut" arbre_simple in false with MotNonValide -> true 


(* fold :  COMPLETER
Itérateur fold pour les arbres d'encodage
*)
let fold  = fun _ -> assert false

(* arbre_encodage : arbre_encodage -> int
Fonction qui calcule le nombre de lettres présentent dans un arbre d'encodage
Paramètre : l'arbre d'encodage
Retour : le nombre de lettre
*)

let nbLettres  = fun _ -> assert false

let%test _ = nbLettres arbre_simple = 3
let%test _ = nbLettres arbre_sujet = 6


(* lettres :  arbre_encodage -> char list
Fonction qui renvoie la liste des lettres présentent dans un arbre d'encodage
Paramètre : l'arbre d'encodage
Retour : la liste de lettre
*)
let lettres  = fun _ -> []

let lettres_arbre_simple = lettres arbre_simple
let%test _ = List.length lettres_arbre_simple = 3
let%test _ = List.mem 'a' lettres_arbre_simple
let%test _ = List.mem 'b' lettres_arbre_simple
let%test _ = List.mem 'c' lettres_arbre_simple

let lettres_arbre_sujet = lettres arbre_sujet
let%test _ = List.length lettres_arbre_sujet = 6
let%test _ = List.mem 'a' lettres_arbre_sujet
let%test _ = List.mem 'b' lettres_arbre_sujet
let%test _ = List.mem 'c' lettres_arbre_sujet
let%test _ = List.mem 'd' lettres_arbre_sujet
let%test _ = List.mem 'e' lettres_arbre_sujet
let%test _ = List.mem 'f' lettres_arbre_sujet


(* arbre_to_liste_2 : arbre_encodage -> (char*int) list
  Converti un arbre d'encodage en une liste associative (caractère, code)
  Paramètre a : l'abre à convertir
  Retour la liste  associative (caractère, code)
*)
let arbre_to_liste_2 = fun _ -> []


let liste_arbre_simple_2 = arbre_to_liste_2 arbre_simple
let%test _ = List.length liste_arbre_simple_2 =3
let%test _ = List.mem ('a',1) liste_arbre_simple_2
let%test _ = List.mem ('b',2) liste_arbre_simple_2
let%test _ = List.mem ('c',3) liste_arbre_simple_2

let liste_arbre_sujet_2 = arbre_to_liste_2 arbre_sujet
let%test _ = List.length liste_arbre_sujet_2 =6
let%test _ = List.mem ('a',3) liste_arbre_sujet_2
let%test _ = List.mem ('b',12) liste_arbre_sujet_2
let%test _ = List.mem ('c',212) liste_arbre_sujet_2
let%test _ = List.mem ('d',22) liste_arbre_sujet_2
let%test _ = List.mem ('e',11) liste_arbre_sujet_2
let%test _ = List.mem ('f',213) liste_arbre_sujet_2