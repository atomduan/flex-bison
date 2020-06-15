%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno
%option bison-bridge bison-locations
%option reentrant
%option case-insensitive 

%option outfile="fbs_sql_lex.yy.c"
%option header-file="fbs_sql_lex.yy.h"

%{
#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1
#define YY_DECL int _yylex (YYSTYPE * yylval_param,YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner)
extern YY_DECL;
#endif
%}


CMP                     (=|<>|<|>|<=|>=)
STRING                  [a-zA-Z0-9_-]+
INTNUM                  [0-9]+
SPACE                   [[:space:]]+
OTHER                   .|\n

%%
"FROM"                  {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[FROM] --> token:[%s]\n", yytext);
                            return FROM;
                        }

"LIKE"                  {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[LIKE] --> token:[%s]\n", yytext); 
                            return LIKE;
                        }

"SELECT"                {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[SELECT] --> token:[%s]\n", yytext); 
                            return SELECT;
                        }

"WHERE"                 {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[WHERE] --> token:[%s]\n", yytext); 
                            return WHERE;
                        }

"OR"                    {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[OR] --> token:[%s]\n", yytext); 
                            return OR;
                        }

"AND"                   {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[AND] --> token:[%s]\n", yytext); 
                            return AND;
                        }

"NOT"                   {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[NOT] --> token:[%s]\n", yytext); 
                            return NOT;
                        }

{STRING}                {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[STRING] --> token:[%s]\n", yytext); 
                            return STRING;
                        }

{INTNUM}                {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[INTNUM] --> token:[%s]\n", yytext); 
                            return INTNUM;
                        }

{CMP}                   {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[{CMP}] --> token:[%s]\n", yytext); 
                            yylval_param->subtok = (int)*yytext;
                            return COMPARISON;
                        }

{SPACE}                 /* SKIP, No action needed */

{OTHER}                 {   
                            fprintf(ctxp->logger, "lex>> hit pattern:[{OTHER}] --> token:[%s]\n", yytext); 
                            return (int)*yytext;
                        }
%%
