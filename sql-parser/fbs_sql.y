/* --------------------------------------------------------------------- */
%code top {
#include <fbs_sql_parser.h>

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
    char   *strval;
    int     subtok;
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

%token NAME
%token STRING
%token INTNUM APPROXNUM

/* operators */
%left OR
%left AND
%left NOT
%left <subtok> COMPARISON /* = <> < > <= >= */
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

/* literal keyword tokens */
%token ALL AMMSC ANY BETWEEN BY
%token DISTINCT 
%token ESCAPE EXISTS FROM 
%token GROUP HAVING IN INDICATOR INTO
%token IS LIKE NULLX 
%token SELECT
%token SOME 
%token USER WHERE 

%destructor { printf("destructor intval, do nothing.\n"); } <intval>
%destructor { printf("destructor floatval, do nothing.\n"); } <floatval>
%destructor { printf("destructor subtok, do nothing.\n"); } <subtok>
%destructor { printf("Discarding tagless symbol.\n"); } <>
%destructor { free($$); } <*>

/* --------------------------------------------------------------------- */
/* Grammar Rules Section */ 
%%
/* --------- LV0 --------- */
sql_list:
                                    /*useless, without this stmt yyerror with gen error with pure api */
        /* empty */                 {   FBS_USE(@$); FBS_USE(ctxp);     }
    |   sql ';'                     {   ;                               } 
    |   sql_list sql ';'
    ;

sql:    manipulative_statement
    ;

manipulative_statement:
        /* empty */
    |   select_statement
    ;

select_statement:
        SELECT opt_all_distinct selection INTO target_commalist table_exp
    |   SELECT opt_all_distinct selection table_exp
    ;

/* --------- LV1 --------- */
opt_all_distinct:
        /* empty */
    |   ALL
    |   DISTINCT
    ;

selection:
        scalar_exp_commalist
    |   '*'
    ;

target_commalist:
        target
    |   target_commalist ',' target
    ;

table_exp:
        from_clause
        opt_where_clause
        opt_group_by_clause
        opt_having_clause
    ;

/* --------- LV2 --------- */
scalar_exp_commalist:
        scalar_exp
    |   scalar_exp_commalist ',' scalar_exp
    ;

target:
        parameter_ref
    ;

from_clause:
        FROM table_ref_commalist
    ;

opt_where_clause:
        /* empty */
    |   where_clause
    ;

opt_group_by_clause:
        /* empty */
    |   GROUP BY column_ref_commalist
    ;

opt_having_clause:
        /* empty */
    |   HAVING search_condition
    ;

/* --------- LV3 --------- */
scalar_exp:
        scalar_exp '+' scalar_exp
    |   scalar_exp '-' scalar_exp
    |   scalar_exp '*' scalar_exp
    |   scalar_exp '/' scalar_exp
    |   '+' scalar_exp %prec UMINUS
    |   '-' scalar_exp %prec UMINUS
    |   atom
    |   column_ref
    |   function_ref
    |   '(' scalar_exp ')'
    ;

parameter_ref:
        parameter
    |   parameter parameter
    |   parameter INDICATOR parameter
    ;

table_ref_commalist:
        table_ref
    |   table_ref_commalist ',' table_ref
    ;

where_clause:
        WHERE search_condition
    ;

column_ref_commalist:
        column_ref
    |   column_ref_commalist ',' column_ref
    ;

search_condition:
    |   search_condition OR search_condition
    |   search_condition AND search_condition
    |   NOT search_condition
    |   '(' search_condition ')'
    |   predicate
    ;

/* --------- LV4 --------- */
atom:
        parameter_ref
    |   literal
    |   USER
    ;

function_ref:
        AMMSC '(' '*' ')'
    |   AMMSC '(' DISTINCT column_ref ')'
    |   AMMSC '(' ALL scalar_exp ')'
    |   AMMSC '(' scalar_exp ')'
    ;

parameter:
        ':' NAME
    ;

table_ref:
        table 
    |   table range_variable
    ;

predicate:
        comparison_predicate
    |   between_predicate
    |   like_predicate
    |   test_for_null
    |   in_predicate
    |   all_or_any_predicate
    |   existence_test
    ;

/* --------- LV5 --------- */
literal:
        STRING
    |   INTNUM
    |   APPROXNUM
    ;

table:
        NAME
    |   NAME '.' NAME
    ;

range_variable: NAME
    ;

comparison_predicate:
        scalar_exp COMPARISON scalar_exp
    |   scalar_exp COMPARISON subquery
    ;

between_predicate:
        scalar_exp NOT BETWEEN scalar_exp AND scalar_exp
    |   scalar_exp BETWEEN scalar_exp AND scalar_exp
    ;

like_predicate:
        scalar_exp NOT LIKE atom opt_escape
    |   scalar_exp LIKE atom opt_escape
    ;

test_for_null:
        column_ref IS NOT NULLX
    |   column_ref IS NULLX
    ;

in_predicate:
        scalar_exp NOT IN '(' subquery ')'
    |   scalar_exp IN '(' subquery ')'
    |   scalar_exp NOT IN '(' atom_commalist ')'
    |   scalar_exp IN '(' atom_commalist ')'
    ;

all_or_any_predicate:
        scalar_exp COMPARISON any_all_some subquery
    ;

existence_test:
        EXISTS subquery
    ;

/* --------- LV6 --------- */
subquery:
        '(' SELECT opt_all_distinct selection table_exp ')'
    ;

opt_escape:
        /* empty */
    |   ESCAPE atom
    ;

column_ref:
        NAME
    |   NAME '.' NAME   /* needs semantics */
    |   NAME '.' NAME '.' NAME
    ;

atom_commalist:
        atom
    |   atom_commalist ',' atom
    ;

any_all_some:
        ANY
    |   ALL
    |   SOME
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
