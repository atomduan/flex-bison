%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno
%option reentrant
%option case-insensitive 

%option outfile="fbs_lex.yy.c"
%option header-file="fbs_lex.yy.h"

%{
#include <fbs_context.h>
#define YY_DECL int ctx_yylex (fbs_ctx *ctxp, yyscan_t yyscanner)
%}

CMP                     (=|<>|<|>|<=|>=)
INTNUM                  [0-9]+
STRING                  [a-zA-Z0-9_-]+
SPACE                   [[:space:]]+
OTHER                   .|\n
STR_FLAG                \"
STR_CTNT                [^\"]

%x STRING_VAR

%%
{SPACE}                 /* SKIP, No action needed */
%%
