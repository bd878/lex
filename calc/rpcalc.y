/* Infix notation calculator */

%{
  #include <stdio.h>
  #include <math.h>
  int yylex (void);
  void yyerror (char const *);
%}

/* Bison declarations. */
%define api.value.type {double}
%token NUM
%left '-' '+'
%left '*' '/'
%precedence NEG    /* negation--unary minus */
%right '^'         /* exponentiation */

%% /* The grammar follows. */
input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'    { printf ("%.10g\n", $1); }
;

exp:
  NUM
| exp '+' exp           { $$ = $1 + $3;      }
| exp '-' exp           { $$ = $1 - $3;      }
| exp '*' exp           { $$ = $1 * $3;      }
| exp '/' exp           { $$ = $1 / $3;      }
| '-' exp %prec NEG     { $$ = -$2;          } /* Unary minus    */
| exp '^' exp           { $$ = pow ($1, $3); } /* Exponentiation */
| '(' exp ')'           { $$ = $3;           }
;
%%

/* analyzer.c */
/* The lexical analyzer returns a double floating point
 * number on the stack and the token NUM, or the numeric code
 * of the character read if not a number. It skips all blanks
 * and tabs, and returns 0 for ent-of-unput */

#include <ctype.h>
#include <stdlib.h>

int
yylex (void)
{
  int c = getchar ();
  /* Skip white space. */
  while (c == ' ' || c == '\t')
    c = getchar ();
  /* Process numbers. */
  if (c == '.' || isdigit (c))
  {
    ungetc (c, stdin);
    if (scanf ("%lf", &yylval) != 1)
      abort ();
    return NUM;
  }
  /* Return end-of-input */
  else if (c == EOF)
    return YYEOF;
  /* Return a single char */
  else
    return c;
}

/* yyerror.c */
/* Called by yyparse on error. */
void
yyerror (char const *s)
{
  fprintf(stderr, "%s\n", s);
}

/* main.c */
int
main (void)
{
  return yyparse ();
}
