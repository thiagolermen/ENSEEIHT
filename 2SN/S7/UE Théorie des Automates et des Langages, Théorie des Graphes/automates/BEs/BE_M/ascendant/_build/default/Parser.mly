%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token  UL_LBRACE
%token  UL_RBRACE
%token  UL_EQUAL
%token  UL_SEMICOLON

/* Defini le type des donnees associees a l'unite lexicale */

%token  <string> UL_IDENT
%token  <int> UL_INT   
%token  <string> UL_NAME   

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> record

/* Le non terminal document est l'axiome */
%start record

%% /* Regles de productions */

record : valeur UL_FIN { (print_endline "record : valeur UL_FIN") }

valeur : UL_IDENT { (print_endline "valeur : UL_IDENT") }
        | UL_INT   { (print_endline "valeur : UL_INT") }
        | UL_LBRACE blocLbrace UL_RBRACE { (print_endline "valeur : UL_LBRACE blocLbrace UL_RBRACE") }

blocLbrace : blockName blockSemi { (print_endline "blocLbrace : blockName blockSemi") }

blockSemi :  {(print_endline "blockSemi : ")}
            |UL_SEMICOLON blocLbrace { (print_endline "blockSemi : |UL_SEMICOLON blocLbrace") }

blockName : UL_NAME UL_EQUAL valeur { (print_endline "blocName : UL_NAME UL_EQUAL valeur") }
%%
