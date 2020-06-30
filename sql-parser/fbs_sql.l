%option warn nodefault debug verbose
%option nounput noinput noyywrap
%option yylineno
%option bison-bridge bison-locations
%option reentrant
%option case-insensitive 

%option outfile="fbs_sql_lex.yy.c"
%option header-file="fbs_sql_lex.yy.h"

%{
#include <fbs_sql_context.h>
#include <fbs_yy_gen.h>
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1
#define YY_DECL int _yylex (YYSTYPE * yylval_param,YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner)
extern YY_DECL;
#endif
%}

CMP             (=|<>|<|>|<=|>=)
INTNUM          [0-9]+
STRING          [a-zA-Z0-9_-]+
SPACE           [ \t]+
NEW_LINE        \n
OTHER           .
STR_FLAG        \"
STR_CTNT        [^\"]

COMMENT_BLOCK_BEGIN_FLAG      (\/\*)
COMMENT_BLOCK_END_FLAG        (\*\/)
COMMENT_BLOCK_CTNT            (.|\n)

COMMENT_LINE_FLAG       (\/\/|#)
COMMENT_LINE_CTNT       .

%x STRING_SC
%x COMMENT_BLOCK_SC
%x COMMENT_LINE_SC

%%
{COMMENT_BLOCK_BEGIN_FLAG} {
    BEGIN(COMMENT_BLOCK_SC);
}
<COMMENT_BLOCK_SC>{COMMENT_BLOCK_END_FLAG} {
    BEGIN(INITIAL);
}
<COMMENT_BLOCK_SC>{COMMENT_BLOCK_CTNT} {
    /* skip all comment block */
}

{COMMENT_LINE_FLAG} {
    BEGIN(COMMENT_LINE_SC);
}
<COMMENT_LINE_SC>{NEW_LINE} {
    BEGIN(INITIAL);
}
<COMMENT_LINE_SC>{OTHER} {
    /* skip all comment line */
}

{SPACE}|{NEW_LINE} {
    /* skip white space */
}

{STR_FLAG} {
    fbs_lex_log(ctxp, "{STR_FLAG}", yytext);
    ctxp->lex_text_ptr = ctxp->lex_text;
    BEGIN(STRING_SC);
}
<STRING_SC>{STR_CTNT} {
    fbs_lex_log(ctxp, "{STRING_SC}_{STR_CTNT}", yytext);
    *ctxp->lex_text_ptr++ = yytext[0];
}
<STRING_SC>{STR_FLAG} {
    fbs_lex_log(ctxp, "{STRING_SC}_{STR_FLAG}", yytext);
    BEGIN(INITIAL);
    *ctxp->lex_text_ptr = '\0';
    fbs_lex_log(ctxp, "{STRING_SC}_RES", yytext);
    return STRING;
}

"FROM" {   
    fbs_lex_log(ctxp, "FROM", yytext);
    return FROM;
}

"LIKE" {   
    fbs_lex_log(ctxp, "LIKE", yytext);
    return LIKE;
}

"SELECT" {   
    fbs_lex_log(ctxp, "SELECT", yytext);
    return SELECT;
}

"WHERE" {   
    fbs_lex_log(ctxp, "WHERE", yytext);
    return WHERE;
}

"OR" {   
    fbs_lex_log(ctxp, "OR", yytext);
    return OR;
}

"AND" {   
    fbs_lex_log(ctxp, "AND", yytext);
    return AND;
}

"NOT" {   
    fbs_lex_log(ctxp, "NOT", yytext);
    return NOT;
}

{INTNUM} {   
    fbs_lex_log(ctxp, "{INTNUM}", yytext);
    yylval_param->intval = atoi(yytext);
    return INTNUM;
}

{STRING} {   
    fbs_lex_log(ctxp, "{STRING}", yytext);
    memset(ctxp->lex_text, 0, FBS_MAX_STR_CONST);
    memcpy(ctxp->lex_text, yytext, strlen(yytext));
    return STRING;
}

{CMP} {   
    fbs_lex_log(ctxp, "{CMP}", yytext);
    if (0 == strcmp("=", yytext)) {
        yylval_param->tokenum = FBS_LEX_EQ;
    }
    if (0 == strcmp(">", yytext)) {
        yylval_param->tokenum = FBS_LEX_GT;
    }
    if (0 == strcmp("<", yytext)) {
        yylval_param->tokenum = FBS_LEX_LT;
    }
    if (0 == strcmp("<>", yytext)) {
        yylval_param->tokenum = FBS_LEX_NEQ;
    }
    if (0 == strcmp("<=", yytext)) {
        yylval_param->tokenum = FBS_LEX_ELT;
    }
    if (0 == strcmp(">=", yytext)) {
        yylval_param->tokenum = FBS_LEX_EGT;
    }
    return COMPARISON;
}

{OTHER} {   
    fbs_lex_log(ctxp, "{OTHER}", yytext);
    return (int)*yytext;
}
%%
