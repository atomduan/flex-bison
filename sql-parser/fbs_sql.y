/* --------------------------------------------------------------------- */
%code top {
#include <fbs_sql_context.h>

#define YYDEBUG 1
}/*code top end*/

%code requires {
#define YYLTYPE YYLTYPE
typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
    char *filename;
} YYLTYPE;
union YYSTYPE {
    int     intval;
    int     tokenum;
    int     symid;
};
}/*code requires end*/

%code {
int yylex(YYSTYPE * yylval_param, YYLTYPE * yylloc_param, fbs_ctx *ctxp);
int _yylex(YYSTYPE * yylval_param, YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner);
void yyerror(YYLTYPE *yylsp, fbs_ctx *ctxp, char const *msg);
}/*code end*/


/* --------------------------------------------------------------------- */
/* Declarations Section */
%defines "fbs_yy_gen.h"
%define api.value.type {union YYSTYPE}
/*pure option not compatitable with %glr-parser */
%define api.pure full

/*to integerat with flex reentran mod*/
%lex-param      {fbs_ctx *ctxp}
%parse-param    {fbs_ctx *ctxp}

%token <symid>      STRING
%token <intval>     INTNUM

/* operators */
%left OR
%left AND
%left NOT
%left <tokenum> COMPARISON /* = <> < > <= >= */
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

/* literal keyword tokens */
%token SELECT
%token FROM
%token WHERE
%token LIKE

%nterm  <symid>     accept
%nterm  <symid>     sql  
%nterm  <symid>     statement_list
%nterm  <symid>     statement
%nterm  <symid>     select_stmt
%nterm  <symid>     selection
%nterm  <symid>     scalar_exp_list
%nterm  <symid>     from_clause
%nterm  <symid>     where_clause
%nterm  <symid>     table_ref_list
%nterm  <symid>     table_ref
%nterm  <symid>     search_condition
%nterm  <symid>     predicate
%nterm  <symid>     comparison_predicate
%nterm  <symid>     like_predicate
%nterm  <symid>     scalar_exp
%nterm  <symid>     scalar_unit
%nterm  <symid>     name_ref
%nterm  <symid>     like_literal

%destructor { printf("destructor intval, do nothing.\n"); } <intval>
%destructor { printf("destructor tokenum, do nothing.\n"); } <tokenum>
%destructor { printf("destructor symid, do nothing.\n"); } <symid>
%destructor { printf("Discarding tagless symbol.\n"); } <>
%destructor { free($$); } <*>


/* --------------------------------------------------------------------- */
/* Grammar Rules Section */
%%
accept:
        sql[sql] {
            FBS_USE(@$);
            FBS_USE(ctxp);
        }
    ;

sql:   
        /* empty */ {
            FBS_USE(ctxp);
        }
    |   statement_list[stl] {
            FBS_USE(ctxp);
        }
    ;

statement_list:
        statement[stm] ';' {
            FBS_USE(ctxp);
        }
    |   statement_list[stl] statement[stm] ';' {
            FBS_USE(ctxp);
        }
    ;

statement:
        select_stmt[sls] {
            FBS_USE(ctxp);
        }
    ;

select_stmt:
        SELECT selection[sel] from_clause[fcl] where_clause[wcl] {
            FBS_USE(ctxp);
        }
    ;

selection:
        scalar_exp_list[sel] {
            FBS_USE(ctxp);
        }
    |   '*' {
            FBS_USE(ctxp);
        }
    ;

scalar_exp_list:
        scalar_exp {
            FBS_USE(ctxp);
        }
    |   scalar_exp_list[sel] ',' scalar_exp[sep] {
            FBS_USE(ctxp);
        }
    ;

from_clause:
        FROM table_ref_list[trl] {
            FBS_USE(ctxp);
        }
    ;

where_clause:
        /* empty */ {
            FBS_USE(ctxp);
        }
    |   WHERE search_condition[scd] {
            FBS_USE(ctxp);
        }
    ;

table_ref_list:
        table_ref[trf] {
            FBS_USE(ctxp);
        }
    |   table_ref_list[trl] ',' table_ref[trf] {
            FBS_USE(ctxp);
        }
    ;

table_ref:
        name_ref[nrf] {
            FBS_USE(ctxp);
        }
    ;

search_condition:
        search_condition[sdl] OR search_condition[sdr]  {
            FBS_USE(ctxp);
        }
    |   search_condition[sdl] AND search_condition[sdr] {
            FBS_USE(ctxp);
        }
    |   '(' search_condition[sdt] ')' {
            FBS_USE(ctxp);
        }
    |   predicate[pdt] {
            FBS_USE(ctxp);
        }
    ;

predicate:
        comparison_predicate[cpd] {
            FBS_USE(ctxp);
        }
    |   like_predicate[lpd] {
            FBS_USE(ctxp);
        }
    ;

comparison_predicate:
        scalar_exp[sel] COMPARISON scalar_exp[ser] {
            FBS_USE(ctxp);
        }
    ;

like_predicate:
        scalar_exp[sep] NOT LIKE like_literal[lkl] {
            FBS_USE(ctxp);
        }
    |   scalar_exp[sep] LIKE like_literal[lkl] {
            FBS_USE(ctxp);
        }
    ;

scalar_exp:
        scalar_exp[sel] '+' scalar_exp[ser] {
            FBS_USE(ctxp);
        }
    |   scalar_exp[sel] '-' scalar_exp[ser] {
            FBS_USE(ctxp);
        }
    |   scalar_exp[sel] '*' scalar_exp[ser] {
            FBS_USE(ctxp);
        }
    |   scalar_exp[sel] '/' scalar_exp[ser] {
            FBS_USE(ctxp);
        }
    |   '+' scalar_exp[sep] %prec UMINUS {
            FBS_USE(ctxp);
        }
    |   '-' scalar_exp[sep] %prec UMINUS {
            FBS_USE(ctxp);
        }
    |   '(' scalar_exp[sep] ')' {
            FBS_USE(ctxp);
        }
    |   scalar_unit[sun] {
            FBS_USE(ctxp);
        }
    ;

scalar_unit:
        INTNUM[val] {
            FBS_USE(ctxp);
        }
    |   name_ref[nrf] {
            FBS_USE(ctxp);
        }
    ;

name_ref:
        STRING {
            FBS_USE(ctxp);
        }
    |   name_ref[nrf] '.' STRING {
            FBS_USE(ctxp);
        }
    ;

like_literal:
        STRING {
            FBS_USE(ctxp);
        }
    |   INTNUM[val] {
            FBS_USE(ctxp);
        }
    ;
%%


/* --------------------------------------------------------------------- */
/* Epilogue Begin */
void yyerror(YYLTYPE *yylsp, fbs_ctx *ctxp, char const *msg)
{
    FBS_USE(yylsp);
    FBS_USE(ctxp);
    fprintf(stderr,"%s\n",msg);
}

int yylex(YYSTYPE * yylval_param, YYLTYPE * yylloc_param, fbs_ctx *ctxp)
{
    yyscan_t yyscanner = ctxp->yyscanner;
    return _yylex(yylval_param,yylloc_param,ctxp,yyscanner);
}
