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
    int intval;
    double floatval;
    char *strval;
    int subtok;
};
/* TODO:FLEX hecked! fbs_sql_lex.yy.h dup here!! need fix */
#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif
}/*code requires end*/

%code {
int yylex(YYSTYPE * yylval_param,YYLTYPE * yylloc_param ,yyscan_t yyscanner);
void yyerror(YYLTYPE *yylsp, char const *msg, yyscan_t yyscanner);
}/*code end*/


/* --------------------------------------------------------------------- */
/* Declarations Section */
%defines "fbs_yy_gen.h"
%define api.value.type {union YYSTYPE}
%define api.pure full 

/*to integerat with flex reentran mod*/
%lex-param      {yyscan_t yyscanner}
%parse-param    {yyscan_t yyscanner}

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
%token DELETE DISTINCT 
%token ESCAPE EXISTS FROM 
%token GROUP HAVING IN INDICATOR INSERT INTO
%token IS LIKE NULLX 
%token SELECT SET
%token SOME 
%token UPDATE USER VALUES WHERE 

%destructor { printf("destructor intval, do nothing.\n"); } <intval>
%destructor { printf("destructor floatval, do nothing.\n"); } <floatval>
%destructor { printf("destructor subtok, do nothing.\n"); } <subtok>
%destructor { printf("Discarding tagless symbol.\n"); } <>
%destructor { free($$); } <*>

/* --------------------------------------------------------------------- */
/* Grammar Rules Section */ 
%%
sql_list:
    |   sql ';'                     {  
                                        /*useless, without this stmt yyerror with gen error with pure api */
                                        fprintf(stdout,"debug :%d,%d\n",@1.last_line,@1.last_column);    
                                    }
    |   sql_list sql ';'
    ;

sql:    manipulative_statement
    ;

manipulative_statement:
        /* empty */
    |   delete_statement_searched
    |   insert_statement
    |   select_statement
    |   update_statement_searched
    ;

delete_statement_searched:
        DELETE FROM table opt_where_clause
    ;

insert_statement:
        INSERT INTO table opt_column_commalist values_or_query_spec
    ;

select_statement:
        SELECT opt_all_distinct selection INTO target_commalist table_exp
    |   SELECT opt_all_distinct selection table_exp
    ;

update_statement_searched:
        UPDATE table SET assignment_commalist opt_where_clause
    ;

table:
        NAME
    |   NAME '.' NAME
    ;

opt_where_clause:
        /* empty */
    |   where_clause
    ;

opt_column_commalist:
        /* empty */
    |   '(' column_commalist ')'
    ;

values_or_query_spec:
        VALUES '(' insert_atom_commalist ')'
    |   query_spec
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

assignment_commalist:
    |   assignment
    |   assignment_commalist ',' assignment
    ;

where_clause:
        WHERE search_condition
    ;

column_commalist:
        column
    |   column_commalist ',' column
    ;

insert_atom_commalist:
        insert_atom
    |   insert_atom_commalist ',' insert_atom
    ;

query_spec:
        SELECT opt_all_distinct selection table_exp
    ;

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

opt_group_by_clause:
        /* empty */
    |   GROUP BY column_ref_commalist
    ;

opt_having_clause:
        /* empty */
    |   HAVING search_condition
    ;

assignment:
        column '=' scalar_exp
    |   column '=' NULLX
    ;

column:     NAME
    ;

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

search_condition:
    |   search_condition OR search_condition
    |   search_condition AND search_condition
    |   NOT search_condition
    |   '(' search_condition ')'
    |   predicate
    ;

insert_atom:
        atom
    |   NULLX
    ;

opt_all_distinct:
        /* empty */
    |   ALL
    |   DISTINCT
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

column_ref_commalist:
        column_ref
    |   column_ref_commalist ',' column_ref
    ;

atom:
        parameter_ref
    |   literal
    |   USER
    ;

column_ref:
        NAME
    |   NAME '.' NAME   /* needs semantics */
    |   NAME '.' NAME '.' NAME
    ;

function_ref:
        AMMSC '(' '*' ')'
    |   AMMSC '(' DISTINCT column_ref ')'
    |   AMMSC '(' ALL scalar_exp ')'
    |   AMMSC '(' scalar_exp ')'
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

parameter:
        ':' NAME
    ;

table_ref:
        table 
    |   table range_variable
    ;

literal:
        STRING
    |   INTNUM
    |   APPROXNUM
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

range_variable: NAME
    ;

subquery:
        '(' SELECT opt_all_distinct selection table_exp ')'
    ;

opt_escape:
        /* empty */
    |   ESCAPE atom
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
void yyerror(YYLTYPE *yylsp, char const *msg, yyscan_t yyscanner)
{
    FBS_USE(yylsp); 
    FBS_USE(yyscanner); 
    fprintf(stderr,"%s\n",msg);
}
