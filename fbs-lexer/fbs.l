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
                        }

"FROM"                  {   
                            fprintf(ctxp->log, "lex>> hit pattern:[FROM] --> token:[%s]\n", yytext);
                        }
"LIKE"                  {   
                            fprintf(ctxp->log, "lex>> hit pattern:[LIKE] --> token:[%s]\n", yytext); 
                        }
"SELECT"                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[SELECT] --> token:[%s]\n", yytext); 
                        }
"WHERE"                 {   
                            fprintf(ctxp->log, "lex>> hit pattern:[WHERE] --> token:[%s]\n", yytext); 
                        }
"OR"                    {   
                            fprintf(ctxp->log, "lex>> hit pattern:[OR] --> token:[%s]\n", yytext); 
                        }
"AND"                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[AND] --> token:[%s]\n", yytext); 
                        }
"NOT"                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[NOT] --> token:[%s]\n", yytext); 
                        }
{INTNUM}                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[INTNUM] --> token:[%s]\n", yytext); 
                        }
{STRING}                {   
                            fprintf(ctxp->log, "lex>> hit pattern:[STRING] --> token:[%s]\n", yytext); 
                            memset(ctxp->lex_text, 0, FBS_MAX_STR_CONST);
                            memcpy(ctxp->lex_text, yytext, strlen(yytext));
                        }
{CMP}                   {   
                            fprintf(ctxp->log, "lex>> hit pattern:[{CMP}] --> token:[%s]\n", yytext); 
                            return fbs_lex_get_cmp_tokenum(yytext);
                        }
{OTHER}                 {   
                            fprintf(ctxp->log, "lex>> hit pattern:[{OTHER}] --> token:[%s]\n", yytext); 
                            return (int)*yytext;
                        }
%%
