(*Interface that corresponds to an writing rule*)
module type Regle =
sig
  (*Type of the rule's identificator - we have a number that corresponds to each rule *)
  type tid = int
  (*Type of the terms in a given rule*)
  type td
  (*Given a char chain, returns the id of the rule that the chain belongs to
     Signature: tid
     Result: the type of the rule's identificator*)
  val id : tid
  
  (*Apply the rule on a chain of characters
     Signature: td -> td list
     Result: A list of charachters with the BOA rule applied*)
  val appliquer : td -> td list
end

module Regle1 : Regle with type td = char list = 
struct
  type tid = int
  type td = char list
  let id = 1
  let appliquer l = [l@['A']]

  let%test _ = appliquer ['B', 'O'] =  [['B', 'O', 'A']]
end

module Regle2 : Regle with type td = char list = 
struct
  type tid = int
  type td = char list
  let id = 2
  let appliquer l = [l@(List.tl l)]

  let%test _ = appliquer ['B', 'O', 'A'] =  [['B', 'O', 'A', 'O', 'A']]
end

module Regle3 : Regle with type td = char list = 
struct
  type tid = int
  type td = char list
  let id = 3
  let rec appliquer l = 
    match l with
      | t1::t2::t3::q -> 
        if ((t1 == 'O') && (t2 == 'O') && (t3 == 'O') || ((t1 == 'A') && (t2 == 'O') && (t3 == 'A'))) then 
        (['A':: q]) @ (List.map (fun l -> t1 :: l) (appliquer (t2 :: t3 :: q))) 
        else
          (List.map (fun l -> t1 :: l) (appliquer (t2 :: t3 :: q)))
      | _ -> []

    let%test _ = appliquer ['B', 'O', 'O', 'O', 'O'] =  [['B', 'O', 'A'], [['B', 'A', 'O']]]    
end

module Regle4 : Regle with type td = char list = 
struct
  type tid = int
  type td = char list
  let id = 4
  let rec appliquer l = 
    match l with
      | t1::t2::q -> 
        if ((t1 == 'A') && (t2 == 'A')) then 
        [q]
      else 
        (List.map (fun l -> t1 :: l) (appliquer (t2 :: q)))
      | _ -> []

    let%test _ = appliquer ['B', 'O', 'O', 'O', 'O'] =  [['B', 'O', 'A'], [['B', 'A', 'O']]]    
end


module type ArbreReecriture =
sig

  (*Type of the rule's identificator *)
  type tid = int

  (*Type of the terms*)
  type td

  (*Type of n-ary trees with terms in the nodes and the indentificators of rules on the branches*)
  type arbre_reecriture = Noeud of td * ((tid * arbre_reecriture) list)

  (*Create a node in the tree
     Signature: td -> (tid * arbre_reecriture) list -> arbre_reecriture
     Returns: a tree with the new node created*)
  val creer_noeud : td -> (tid * arbre_reecriture) list -> arbre_reecriture

  (* Returns the root of a given tree
     Signature: arbre_reecriture -> td
     Returns: the root of a given tree*)
  val racine : arbre_reecriture -> td

  (* Returns the children of a given tree
     Signature: arbre_reecriture -> (tid * arbre_reecriture) list
     Returns: the chldren of a given tree*)
  val fils : arbre_reecriture -> (tid * arbre_reecriture) list

  (* Check if a given node belongs to the tree
     Signature: td -> arbre_reecriture -> bool
     Returns: a boolean that means if a given node belongs to the tree*)
  val appartient : td -> arbre_reecriture -> bool
end

module ArbreReecritureBOA : ArbreReecriture with type td = char list = 
struct
  type tid = int
  type td = char list
  type arbre_reecriture = Noeud of td * ((tid * arbre_reecriture) list)

  let creer_noeud racine fils =  Noeud (racine, fils)

  let racine (Noeud (racine, fils)) = racine
  
  let fils (Noeud (racine, fils)) = fils

  let appartient c (Noeud (racine, fils)) = 
    if c = racine 
      then true 
  else
    let rec aux c fils = 
      match fils with
        | [] -> false
        | (id, (Noeud (r, f)))::q -> if c = r then true else aux c q || aux c f
    in aux c fils

  let example1 = Noeud (['B';'O';'O'], [(1, Noeud (['B';'O';'O';'A'], 
                                          [(2, Noeud (['B';'O';'O';'A';'O';'O';'A'], []))])); 
                                        (2, Noeud (['B';'O';'O';'O';'O'],
                                            [(1, Noeud (['B';'O';'O';'O';'O';'A'], [])); 
                                              (2, Noeud (['B';'O';'O';'O';'O';'O';'O';'O';'O'], []));
                                              (3, Noeud (['B';'A';'O'], []));
                                              (3, Noeud (['B';'O';'A'], []))
                                            ]
                                          )
                                        )
                                      ]
                                    )
  
  let%test _ = appartient ['B';'O';'O';'A'] exemple1 = true
  let%test _ = appartient ['B';'O';'O';'O';'O'] exemple1 = true
  let%test _ = appartient ['B';'O';'A'] exemple1 = true
  let%test _ = fils exemple1 = [(1, Noeud (['B';'O';'O';'A'], 
                                [(2, Noeud (['B';'O';'O';'A';'O';'O';'A'], []))])); 
                              (2, Noeud (['B';'O';'O';'O';'O'],
                                  [(1, Noeud (['B';'O';'O';'O';'O';'A'], [])); 
                                    (2, Noeud (['B';'O';'O';'O';'O';'O';'O';'O';'O'], []));
                                    (3, Noeud (['B';'A';'O'], []));
                                    (3, Noeud (['B';'O';'A'], []))
                                  ]
                                )
                              )
                              ]
  let%test _ = racine exemple1 = ['B';'O';'O']

  
  let example2 = Noeud(['B';'O';'O'], [(1, Noeud(['B';'O';'O';'A'], [(1, Noeud(['B'], [])); (2, Noeud(['O'], []))])); (2, Noeud(['B';'O';'O';'O';'O'], []))])
  
  let%test _ = appartient ['O'] exemple2 = true
  let%test _ = appartient ['O'] exemple2 = true 
  let%test _ = appartient ['B'] exemple2 = true 
  let%test _ = appartient ['B';'O';'O'] exemple2 = true 
  let%test _ = appartient ['B';'O';'O';'A'] exemple2 = true 
  let%test _ = appartient ['B';'O';'O';'O';'O'] exemple1 = true
  let%test _ = fils exemple2 = [(1, Noeud(['B';'O';'O';'A'], [(1, Noeud(['B'], [])); (2, Noeud(['O'], []))])); (2, Noeud(['B';'O';'O';'O';'O'], []))]
  let%test _ = racine exemple2 = ['B';'O';'O']
end



