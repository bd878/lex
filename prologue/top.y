/* we qualify %code directive with top
 * to overwrite YYLTYPE bison definition */
%{
%}

%code top {
  #define _GNU_SOURCE
  #include <stdio.h>

  /* WARNING: This code really belongs
   * in a '%code requires'; see below */

  #include "ptypes.h"
  #define YYLTYPE YYLTYPE
  typedef struct YYLTYPE
  {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
    char *filename;
  } YYLTYPE;
}

%union {
  long n;
  tree t; /* tree is defined in ptypes.h */
}

%code {
  static void print_token (yytoken_kind_t token, YYSTYPE val);
  static void trace_token (yytoken_kind_t token, YYLTYPE loc);
}
