%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno

%option outfile="fbs_sql_lex.yy.c"

%{
#include <fbs_sql_parser.h>
%}

ANY_OTHER       .|\n

%%
{ANY_OTHER}     {   return (int)*yytext;    }
%%
