/* Location tracking calculator. */

%{
  #include <ctype.h>
  #include <stdio.h>
  #include <math.h>

  int yylex (void);
  void yyerror (char const *);
%}

/* Bison declarations. */
%define api.value.type {int}
%token NUM

%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'

%% /* The grammar follows */
input:
  %empty
| input line
;

line:
  '\n'
| exp '\n' { printf ("%d\n", $1); }
;

exp:
  NUM
| exp '+' exp { $$ = $1 + $3; }
| exp '-' exp { $$ = $1 - $3; }
| exp '*' exp { $$ = $1 * $3; }
| exp '/' exp
  {
    if ($3)
      $$ = $1 / $3;
    else
      {
        $$ = 1;
        fprintf (stderr, "%d.%d-%d.%d: division by zero ",
                 @3.first_line, @3.first_column,
                 @3.last_line, @3.last_column);
      }
  }
| '-' exp %prec NEG { $$ = -$2; }
| exp '^' exp       { $$ = pow ($1, $3); }
| '(' exp ')'       { $$ = $2; }
%%

/* yyerror.c */
/* Called by yyparse on error. */
void
yyerror (char const *s)
{
  fprintf(stderr, "%s\n", s);
}

int
yylex (void)
{
  int c;

  /* Skip white space. */
  while ((c = getchar ()) == ' ' || c == '\t')
    ++yylloc.last_column;

  /* Step */
  yylloc.first_line = yylloc.last_line;
  yylloc.first_column = yylloc.last_column;

  /* Process numbers */
  if (isdigit(c))
  {
    yylval = c - '0';
    ++yylloc.last_column;
    while (isdigit (c = getchar ()))
    {
      ++yylloc.last_column;
      yylval = yylval * 10 + c - '0';
    }
    ungetc (c, stdin);
    return NUM;
  }

  /* Return end-of-input */
  if (c == EOF)
    return YYEOF;

  /* Return a single char, and update location */
  if (c == '\n')
  {
    ++yylloc.last_line;
    yylloc.last_column = 0;
  }
  else
    ++yylloc.last_column;
  return c;
}

int
main (void)
{
  yylloc.first_line = yylloc.last_line = 1;
  yylloc.first_column = yylloc.last_column = 0;
  return yyparse ();
}
