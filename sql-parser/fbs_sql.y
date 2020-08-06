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
%token AS 

%nterm  <symid>     sql
%nterm  <symid>     statement_list
%nterm  <symid>     statement
%nterm  <symid>     select_stmt
%nterm  <symid>     selection
%nterm  <symid>     from_clause
%nterm  <symid>     where_clause
%nterm  <symid>     table_ref_list
%nterm  <symid>     table_ref
%nterm  <symid>     search_condition
%nterm  <symid>     predicate
%nterm  <symid>     comparison_predicate
%nterm  <symid>     like_predicate
%nterm  <symid>     scalar_exp_list
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
sql:
        /* empty */ {
            FBS_USE(@$);
            FBS_USE(ctxp);
        }
    |   statement_list[stl] {
            /* nothing to do */
            fprintf(ctxp->log, "trans statement_list\n");
        }
    ;

statement_list:
        statement[stm] ';' {
            fprintf(ctxp->log, "trans statement SINGLE\n");
        }
    |   statement_list[stl] statement[stm] ';' {
            fprintf(ctxp->log, "trans statement RIGHT SINGLE\n");
        }
    ;

statement:
        select_stmt[sls] {
        }
    ;

select_stmt:
        SELECT selection[sel] from_clause[fcl] where_clause[wcl] {
        }
    ;

selection:
        scalar_exp_list[sel] {
        }
    |   '*' {
        }
    ;

scalar_exp_list:
        scalar_exp {
        }
    |   scalar_exp_list[sel] ',' scalar_exp[sep] {
        }
    ;

from_clause:
        FROM table_ref_list[trl] {
        }
    ;

where_clause:
        /* empty */ {
            FBS_USE(ctxp);
        }
    |   WHERE search_condition[scd] {
        }
    ;

table_ref_list:
        table_ref[trf] {
        }
    |   table_ref_list[trl] ',' table_ref[trf] {
        }
    ;

table_ref:
        name_ref[nrf] {
        }
    ;

search_condition:
        search_condition[sdl] OR search_condition[sdr]  {
        }
    |   search_condition[sdl] AND search_condition[sdr] {
        }
    |   '(' search_condition[sdt] ')' {
        }
    |   predicate[pdt] {
        }
    ;

predicate:
        comparison_predicate[cpd] {
        }
    |   like_predicate[lpd] {
        }
    ;

comparison_predicate:
        scalar_exp[sel] COMPARISON[cmp] scalar_exp[ser] {
        }
    ;

like_predicate:
        scalar_exp[sep] NOT LIKE like_literal[lkl] {
        }
    |   scalar_exp[sep] LIKE like_literal[lkl] {
        }
    ;

scalar_exp:
        scalar_exp[sel] '+' scalar_exp[ser] {
        }
    |   scalar_exp[sel] '-' scalar_exp[ser] {
        }
    |   scalar_exp[sel] '*' scalar_exp[ser] {
        }
    |   scalar_exp[sel] '/' scalar_exp[ser] {
        }
    |   '+' scalar_exp[sep] %prec UMINUS {
        }
    |   '-' scalar_exp[sep] %prec UMINUS {
        }
    |   '(' scalar_exp[sep] ')' {
        }
    |   scalar_unit[sun] {
        }
    ;

scalar_unit:
        INTNUM[val] {
        }
    |   name_ref[nrf] {
        }
    ;

name_ref:
        STRING[str] {
        }
    |   name_ref[nrf] '.' STRING {
        }
    ;

like_literal:
        STRING[str] {
        }
    |   INTNUM[val] {
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
