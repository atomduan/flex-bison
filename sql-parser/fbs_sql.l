%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno
%option bison-bridge bison-locations
%option reentrant

/*Comment Me...*/
%option outfile="fbs_sql_lex.yy.c"
%option header-file="fbs_sql_lex.yy.h"

%{
#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
%}

ANY_OTHER           .|\n
CMP_PT              (=|<>|<|>|<=|>=)

%%
"NAME"                  {   return NAME;            }
"STRING"                {   return STRING;          }
"INTNUM"                {   return INTNUM;          }
"APPROXNUM"             {   return APPROXNUM;       }
"ALL"                   {   return ALL;             }
"AMMSC"                 {   return AMMSC;           }
"ANY"                   {   return ANY;             }
"BETWEEN"               {   return BETWEEN;         }
"BY"                    {   return BY;              }
"DISTINCT"              {   return DISTINCT;        }
"ESCAPE"                {   return ESCAPE;          }
"EXISTS"                {   return EXISTS;          }
"FROM"                  {   return FROM;            }
"GROUP"                 {   return GROUP;           }
"HAVING"                {   return HAVING;          }
"IN"                    {   return IN;              }
"INDICATOR"             {   return INDICATOR;       }
"INTO"                  {   return INTO;            }
"IS"                    {   return IS;              }
"LIKE"                  {   return LIKE;            }
"NULLX"                 {   return NULLX;           }
"SELECT"                {   return SELECT;          }
"SOME"                  {   return SOME;            }
"USER"                  {   return USER;            }
"WHERE"                 {   return WHERE;           }
"OR"                    {   return OR;              }
"AND"                   {   return AND;             }
"NOT"                   {   return NOT;             }

{CMP_PT}                {   yylval_param->subtok = (int)*yytext;
                            return COMPARISON;      }

{ANY_OTHER}             {   return (int)*yytext;    }
%%
