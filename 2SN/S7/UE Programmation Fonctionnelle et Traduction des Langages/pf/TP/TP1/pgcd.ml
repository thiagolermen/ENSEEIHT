(*  Exercice à rendre **)
(* pgcd: int -> int -> int *)
(*
Preconditions: a + b > 0 -> a and b can't be zero at the same time because the PGCD is not defined

When the recursive input a b are equal, returns a. It always reaches the 
base case because it keeps substracting the smallest number from the highest,
reaching either the smallest number or 1, which is the last case scenario for the program to stop.contents

Yes. We can use the inner scope of the function pgcd (using the local definition of an auxiliary function)
to initialie another function that can check if the values are positive or negative instead of applying 
the function abs to all values in the function pgcd. The defined function use the local definition to treat
the case when a or b are negative basically calculating the absolute value of them (definition of pgcd)
*)

let rec pgcd a b =
  let aux a b =
    if a = 0 then b
    else if b = 0 || a = b then a
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
