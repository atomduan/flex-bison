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
    double  floatval;
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
%destructor { printf("destructor floatval, do nothing.\n"); } <floatval>
%destructor { printf("destructor tokenum, do nothing.\n"); } <tokenum>
%destructor { printf("destructor symid, do nothing.\n"); } <symid>
%destructor { printf("Discarding tagless symbol.\n"); } <>
%destructor { free($$); } <*>


/* --------------------------------------------------------------------- */
/* Grammar Rules Section */
%%
accept:
        sql[sql] {
            FBS_USE(@$); FBS_USE(ctxp);
            $$ = on_accept(ctxp,$[sql]);
        }
    ;

sql:   
        /* empty */ {
            $$ = on_sql_empty(ctxp);
        }
    |   statement_list[stl] {
            $$ = on_sql_sl(ctxp, $[stl]);
        }
    ;

statement_list:
        statement[stm] ';' {
            $$ = on_statement_list_s(ctxp, $[stm]);
        }
    |   statement_list[stl] statement[stm] ';' {
            $$ = on_statement_list_ss(ctxp, $[stl], $[stm]);
        }
    ;

statement:
        select_stmt[sls] {
            $$ = on_statement_ss(ctxp, $[sls]);
        }
    ;

select_stmt:
        SELECT selection[sel] from_clause[fcl] where_clause[wcl] {
            $$ = on_select_stmt_ssfw(ctxp, $[sel], $[fcl], $[wcl]);
        }
    ;

selection:
        scalar_exp_list[sel] {
            $$ = on_selection_sel(ctxp, $[sel]);
        }
    |   '*' {
            $$ = on_selection_all(ctxp);
        }
    ;

scalar_exp_list:
        scalar_exp {
            $$ = on_scalar_exp_list_s(ctxp);
        }
    |   scalar_exp_list[sel] ',' scalar_exp[sep] {
            $$ = on_scalar_exp_list_ss(ctxp,$[sel], $[sep]);
        }
    ;

from_clause:
        FROM table_ref_list[trl] {
            $$ = on_from_clause_ft(ctxp, $[trl]);
        }
    ;

where_clause:
        /* empty */ {
            $$ = on_where_clause_empty(ctxp);
        }
    |   WHERE search_condition[scd] {
            $$ = on_where_clause_ws(ctxp, $[scd]);
        }
    ;

table_ref_list:
        table_ref[trf] {
            $$ = on_table_ref_list_t(ctxp, $[trf]);
        }
    |   table_ref_list[trl] ',' table_ref[trf] {
            $$ = on_table_ref_list_tt(ctxp, $[trl], $[trf]);
        }
    ;

table_ref:
        name_ref[nrf] {
            $$ = on_table_ref_n(ctxp, $[nrf]);
        }
    ;

search_condition:
        search_condition[sdl] OR search_condition[sdr]  {
            $$ = on_search_condition_sos(ctxp, $[sdl], $[sdr]);
        }
    |   search_condition[sdl] AND search_condition[sdr] {
            $$ = on_search_condition_sas(ctxp, $[sdl], $[sdr]);
        }
    |   '(' search_condition[sdt] ')' {
            $$ = on_search_condition_s(ctxp, $[sdt]);
        }
    |   predicate[pdt] {
            $$ = on_search_condition_p(ctxp, $[pdt]);
        }
    ;

predicate:
        comparison_predicate[cpd] {
            $$ = on_predicate_c(ctxp, $[cpd]);
        }
    |   like_predicate[lpd] {
            $$ = on_predicate_l(ctxp, $[lpd]);
        }
    ;

comparison_predicate:
        scalar_exp[sel] COMPARISON scalar_exp[ser] {
            $$ = on_comparison_predicate_scs(ctxp, $[sel], $[ser]);
        }
    ;

like_predicate:
        scalar_exp[sep] NOT LIKE like_literal[lkl] {
            $$ = on_like_predicate_snll(ctxp, $[sep], $[lkl]);
        }
    |   scalar_exp[sep] LIKE like_literal[lkl] {
            $$ = on_like_predicate_sll(ctxp, $[sep], $[lkl]);
        }
    ;

scalar_exp:
        scalar_exp[sel] '+' scalar_exp[ser] {
            $$ = on_scalar_exp_sps(ctxp, $[sel], $[ser]);
        }
    |   scalar_exp[sel] '-' scalar_exp[ser] {
            $$ = on_scalar_exp_sss(ctxp, $[sel], $[ser]);
        }
    |   scalar_exp[sel] '*' scalar_exp[ser] {
            $$ = on_scalar_exp_sms(ctxp, $[sel], $[ser]);
        }
    |   scalar_exp[sel] '/' scalar_exp[ser] {
            $$ = on_scalar_exp_sds(ctxp, $[sel], $[ser]);
        }
    |   '+' scalar_exp[sep] %prec UMINUS {
            $$ = on_scalar_exp_aspu(ctxp, $[sep]);
        }
    |   '-' scalar_exp[sep] %prec UMINUS {
            $$ = on_scalar_exp_sspu(ctxp, $[sep]);
        }
    |   '(' scalar_exp[sep] ')' {
            $$ = on_scalar_exp_se(ctxp, $[sep]);
        }
    |   scalar_unit[sun] {
            $$ = on_scalar_exp_su(ctxp, $[sun]);
        }
    ;

scalar_unit:
        INTNUM[val] {
            $$ = on_scalar_unit_i(ctxp, $[val]);
        }
    |   name_ref[nrf] {
            $$ = on_scalar_unit_n(ctxp, $[nrf]);
        }
    ;

name_ref:
        STRING {
            $$ = on_name_ref_s(ctxp);
        }
    |   name_ref[nrf] '.' STRING {
            $$ = on_name_ref_ns(ctxp, $[nrf]);
        }
    ;

like_literal:
        STRING {
            $$ = on_like_literal_s(ctxp);
        }
    |   INTNUM[val] {
            $$ = on_like_literal_i(ctxp, $[val]);
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
