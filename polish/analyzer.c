/* The lexical analyzer returns a double floating point
 * number on the stack and the token NUM, or the numeric code
 * of the character read if not a number. It skips all blanks
 * and tabs, and returns 0 for ent-of-unput */

#include <stdio.h>
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
