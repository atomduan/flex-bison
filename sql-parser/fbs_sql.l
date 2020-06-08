%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno
%option bison-bridge bison-locations
%option reentrant

%option outfile="fbs_sql_lex.yy.c"
%option header-file="fbs_sql_lex.yy.h"

%{
#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
/* TODO:FLEX hecked! fbs_sql_lex.yy.h dup here!! need fix */
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1
extern int _yylex (YYSTYPE * yylval_param,YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner);
#define YY_DECL int _yylex (YYSTYPE * yylval_param,YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner)
#endif
%}


ANY_OTHER           .|\n
CMP_PT              (=|<>|<|>|<=|>=)

%%
"NAME"                  {   return NAME;            }
"STRING"                {   return STRING;          }
"INTNUM"                {   return INTNUM;          }
"FROM"                  {   return FROM;            }
"LIKE"                  {   return LIKE;            }
"SELECT"                {   return SELECT;          }
"WHERE"                 {   return WHERE;           }
"OR"                    {   return OR;              }
"AND"                   {   return AND;             }
"NOT"                   {   return NOT;             }

{CMP_PT}                {   yylval_param->subtok = (int)*yytext;
                            return COMPARISON;      }

{ANY_OTHER}             {   return (int)*yytext;    }
%%
