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
INTNUM                  [0-9]+
STRING                  [a-zA-Z0-9_-]+
SPACE                   [[:space:]]+
OTHER                   .|\n
STR_FLAG                \"
STR_CTNT                [^\"]

%x STRING_VAR

%%
{SPACE}                 /* SKIP, No action needed */

{STR_FLAG}              {
                            fprintf(ctxp->log, "lex>> hit pattern:[{STR_FLAG} START] --> token:[%s]\n", yytext);
                            ctxp->lex_text_ptr = ctxp->lex_text;
                            BEGIN(STRING_VAR);
                        }

<STRING_VAR>{STR_CTNT}  {
                            fprintf(ctxp->log, "lex>> hit pattern:[<STRING_VAR>{CTNT}] --> token:[%s]\n", yytext);
                            *ctxp->lex_text_ptr++ = yytext[0];
                        }

<STRING_VAR>{STR_FLAG}  {
                            fprintf(ctxp->log, "lex>> hit pattern:[<STRING_VAR>{STR_FLAG} END] --> token:[%s]\n", yytext);
                            BEGIN(INITIAL);
                            *ctxp->lex_text_ptr = '\0';
                            fprintf(ctxp->log, "lex>> hit pattern:[<STRING_VAR>] RES --> token:[%s]\n", ctxp->lex_text);
                            return STRING;
                        }

"FROM"                  {   
                            fprintf(ctxp->log, "lex>> hit pattern:[FROM] --> token:[%s]\n", yytext);
                            return FROM;
                        }

"LIKE"                  {   
                            fprintf(ctxp->log, "lex>> hit pattern:[LIKE] --> token:[%s]\n", yytext); 
                            return LIKE;
                        }

"SELECT"                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[SELECT] --> token:[%s]\n", yytext); 
                            return SELECT;
                        }

"WHERE"                 {   
                            fprintf(ctxp->log, "lex>> hit pattern:[WHERE] --> token:[%s]\n", yytext); 
                            return WHERE;
                        }

"OR"                    {   
                            fprintf(ctxp->log, "lex>> hit pattern:[OR] --> token:[%s]\n", yytext); 
                            return OR;
                        }

"AND"                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[AND] --> token:[%s]\n", yytext); 
                            return AND;
                        }

"NOT"                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[NOT] --> token:[%s]\n", yytext); 
                            return NOT;
                        }

{INTNUM}                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[INTNUM] --> token:[%s]\n", yytext); 
                            return INTNUM;
                        }

{STRING}                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[STRING] --> token:[%s]\n", yytext); 
                            memset(ctxp->lex_text, 0, FBS_MAX_STR_CONST);
                            memcpy(ctxp->lex_text, yytext, strlen(yytext));
                            return STRING;
                        }

{CMP}                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[{CMP}] --> token:[%s]\n", yytext); 
                            yylval_param->subtok = (int)*yytext;
                            return COMPARISON;
                        }

{OTHER}                 {   
                            fprintf(ctxp->log, "lex>> hit pattern:[{OTHER}] --> token:[%s]\n", yytext); 
                            return (int)*yytext;
                        }
%%
