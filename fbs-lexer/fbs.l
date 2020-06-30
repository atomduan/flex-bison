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
NEW_LINE                \n
OTHER                   .

STR_FLAG                \"
STR_CTNT                [^\"]

COMMENT_BLOCK_BEGIN_FLAG      (\/\*)
COMMENT_BLOCK_END_FLAG        (\*\/)
COMMENT_BLOCK_CTNT            (.|\n)

COMMENT_LINE_FLAG       (\/\/|#)
COMMENT_LINE_CTNT       .


%x STRING_VAR
%x COMMENT_BLOCK_SECTOR
%x COMMENT_LINE_SECTOR

%%
{COMMENT_LINE_FLAG} {
    ctxp->lex_text_ptr = ctxp->lex_text;
    fprintf(ctxp->log, "\033[01;90m%s\033[00m", yytext);
    BEGIN(COMMENT_LINE_SECTOR);
}
<COMMENT_LINE_SECTOR>{NEW_LINE} {
    BEGIN(INITIAL);
    *ctxp->lex_text_ptr = '\0';
    fprintf(ctxp->log, "\033[01;90m%s\033[00m\n", ctxp->lex_text);
}
<COMMENT_LINE_SECTOR>{COMMENT_LINE_CTNT} {
    *ctxp->lex_text_ptr++ = yytext[0];
}

{COMMENT_BLOCK_BEGIN_FLAG} {
    ctxp->lex_text_ptr = ctxp->lex_text;
    BEGIN(COMMENT_BLOCK_SECTOR);
}
<COMMENT_BLOCK_SECTOR>{COMMENT_BLOCK_END_FLAG} {
    BEGIN(INITIAL);
    *ctxp->lex_text_ptr = '\0';
    fprintf(ctxp->log, "\033[01;90m/*\033[00m");
    fprintf(ctxp->log, "\033[01;90m%s\033[00m", ctxp->lex_text);
    fprintf(ctxp->log, "\033[01;90m*/\033[00m");
}
<COMMENT_BLOCK_SECTOR>{COMMENT_BLOCK_CTNT} {
    *ctxp->lex_text_ptr++ = yytext[0];
}

{SPACE} {
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

{STR_FLAG} {
    /**
     * reset lex_text tmp pointer
     */
    ctxp->lex_text_ptr = ctxp->lex_text;
    BEGIN(STRING_VAR);
}
<STRING_VAR>{STR_FLAG} {
    BEGIN(INITIAL);
    *ctxp->lex_text_ptr = '\0';
    fprintf(ctxp->log, "\033[01;60m'%s'\033[00m", ctxp->lex_text);
}
<STRING_VAR>{STR_CTNT} {
    *ctxp->lex_text_ptr++ = yytext[0];
}

"FROM" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"LIKE" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"SELECT" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"WHERE" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"OR" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"AND" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

"NOT" {   
    fprintf(ctxp->log, "\033[01;32m%s\033[00m", yytext);
}

{INTNUM} {   
    fprintf(ctxp->log, "%s", yytext);
}

{STRING} {   
    fprintf(ctxp->log, "%s", yytext);
}

{CMP} {   
    fprintf(ctxp->log, "%s", yytext);
}

{NEW_LINE} {
    fprintf(ctxp->log, "%s", yytext);
}

{OTHER} {   
    fprintf(ctxp->log, "%s", yytext);
}

<<EOF>> {
    fprintf(ctxp->log, "\n");
    return EOF;
}
%%
