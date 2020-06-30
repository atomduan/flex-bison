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
SPACE           [[:space:]]+
OTHER           .|\n
STR_FLAG        \"
STR_CTNT        [^\"]

%x STRING_VAR

%%
{SPACE}     /* SKIP, No action needed */

{STR_FLAG} {
    lex_log(ctxp, "{STR_FLAG}", yytext);
    ctxp->lex_text_ptr = ctxp->lex_text;
    BEGIN(STRING_VAR);
}
<STRING_VAR>{STR_CTNT} {
    lex_log(ctxp, "{STRING_VAR}_{STR_CTNT}", yytext);
    *ctxp->lex_text_ptr++ = yytext[0];
}
<STRING_VAR>{STR_FLAG} {
    lex_log(ctxp, "{STRING_VAR}_{STR_FLAG}", yytext);
    BEGIN(INITIAL);
    *ctxp->lex_text_ptr = '\0';
    lex_log(ctxp, "{STRING_VAR}_RES", yytext);
    return STRING;
}

"FROM" {   
    lex_log(ctxp, "FROM", yytext);
    return FROM;
}

"LIKE" {   
    lex_log(ctxp, "LIKE", yytext);
    return LIKE;
}

"SELECT" {   
    lex_log(ctxp, "SELECT", yytext);
    return SELECT;
}

"WHERE" {   
    lex_log(ctxp, "WHERE", yytext);
    return WHERE;
}

"OR" {   
    lex_log(ctxp, "OR", yytext);
    return OR;
}

"AND" {   
    lex_log(ctxp, "AND", yytext);
    return AND;
}

"NOT" {   
    lex_log(ctxp, "NOT", yytext);
    return NOT;
}

{INTNUM} {   
    lex_log(ctxp, "{INTNUM}", yytext);
    yylval_param->intval = atoi(yytext);
    return INTNUM;
}

{STRING} {   
    lex_log(ctxp, "{STRING}", yytext);
    memset(ctxp->lex_text, 0, FBS_MAX_STR_CONST);
    memcpy(ctxp->lex_text, yytext, strlen(yytext));
    return STRING;
}

{CMP} {   
    lex_log(ctxp, "{CMP}", yytext);
    yylval_param->tokenum = fbs_lex_get_cmp_tokenum(yytext);
    return COMPARISON;
}

{OTHER} {   
    lex_log(ctxp, "{OTHER}", yytext);
    return (int)*yytext;
}
%%
