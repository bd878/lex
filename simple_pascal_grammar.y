%token TYPE DOTDOT ID

%left '+' '-'
%left '*' '/'

%glr-parser
%expect-rr 1

%%
type_decl: TYPE ID '=' type ';' ;

type:
  '(' id_list ')'
| expr DOTDOT expr
;

id_list:
  ID
| id_list ',' ID
;

expr:
  '(' expr ')'
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr '/' expr
| ID
;
