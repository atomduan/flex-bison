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
SPACE                   [ \t]+
STR_FLAG                \"
STR_CTNT                [^\"]
NEW_LINE                \n
OTHER                   .

%x STRING_VAR

%%
{SPACE}                 {
                            /** 
                             * no return means ignore, 
                             * and will read next token
                             * without return to yylex
                             * and yytext tmp will be discarded
                             * NEW_LINE \n should be preserved
                             * [ \t]+ should be trimed
                             */
                            fprintf(ctxp->log, " ");
                        }
{STR_FLAG}              {
                            /**
                             * reset lex_text tmp pointer
                             */
                            ctxp->lex_text_ptr = ctxp->lex_text;
                            BEGIN(STRING_VAR);
                        }
<STRING_VAR>{STR_CTNT}  {
                            *ctxp->lex_text_ptr++ = yytext[0];
                        }
<STRING_VAR>{STR_FLAG}  {
                            BEGIN(INITIAL);
                            *ctxp->lex_text_ptr = '\0';
                            fprintf(ctxp->log, "\033[01;60m'%s'\033[00m", ctxp->lex_text);
                        }
"FROM"                  {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"LIKE"                  {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"SELECT"                {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"WHERE"                 {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"OR"                    {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"AND"                   {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
"NOT"                   {   
                            fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
                        }
{INTNUM}                {   
                            fprintf(ctxp->log, "%s", yytext);
                        }
{STRING}                {   
                            fprintf(ctxp->log, "%s", yytext);
                        }
{CMP}                   {   
                            fprintf(ctxp->log, "%s", yytext);
                        }
{NEW_LINE}              {
                            fprintf(ctxp->log, "%s", yytext);
                        }
{OTHER}                 {   
                            fprintf(ctxp->log, "%s", yytext);
                        }
<<EOF>>                 {
                            fprintf(ctxp->log, "\n");
                            return EOF;
                        }
%%
