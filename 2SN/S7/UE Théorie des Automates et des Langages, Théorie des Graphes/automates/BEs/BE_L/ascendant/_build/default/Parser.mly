%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PAROUV UL_PARFER
%token UL_PT

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT
%token <int> UL_ENTIER

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> scheme

/* Le non terminal document est l'axiome */
%start scheme

%% /* Regles de productions */

scheme : expression UL_FIN { (print_endline "scheme : expression UL_FIN ") }

expression : sous_expression_1 { (print_endline "expression : sous_expression_1") }
           | UL_IDENT          { (print_endline "expression : UL_IDENT ") }
           | UL_ENTIER         { (print_endline "expression : UL_ENTIER ") }

sous_expression_1 : UL_PAROUV sous_expression_2 UL_PARFER { (print_endline "sous_expression_1 : UL_PAROUV sous_expression_2 UL_PARFER") }

sous_expression_2 : sous_expression_3  { (print_endline "sous_expression_2 : sous_expression_3") }
                  | expression*                 { (print_endline "sous_expression_2 : expression*") }

sous_expression_3 : expression UL_PT expression  { (print_endline "sous_expression_3 : expression UL_PT expression") }
%%
