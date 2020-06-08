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
%token INTNUM

/* operators */
%left OR
%left AND
%left NOT
%left <subtok> COMPARISON /* = <> < > <= >= */
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

/* literal keyword tokens */
%token FROM 
%token LIKE
%token SELECT
%token WHERE 

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
        /* empty */
    |   SELECT selection table_exp
    ;

/* --------- LV1 --------- */
selection:
        scalar_exp_commalist
    |   '*'
    ;

table_exp:
        from_clause
        opt_where_clause
    ;

/* --------- LV2 --------- */
scalar_exp_commalist:
        scalar_exp
    |   scalar_exp_commalist ',' scalar_exp
    ;

from_clause:
        FROM table_ref_commalist
    ;

opt_where_clause:
        /* empty */
    |   where_clause
    ;

/* --------- LV3 --------- */
table_ref_commalist:
        table 
    |   table_ref_commalist ',' table 
    ;

where_clause:
        WHERE search_condition
    ;

/* --------- LV4 --------- */
search_condition:
    |   search_condition OR search_condition
    |   search_condition AND search_condition
    |   '(' search_condition ')'
    |   predicate
    ;

/* --------- LV5 --------- */
predicate:
        comparison_predicate
    |   like_predicate
    ;

comparison_predicate:
        scalar_exp COMPARISON scalar_exp
    ;

like_predicate:
        scalar_exp NOT LIKE literal
    |   scalar_exp LIKE literal
    ;

/* --------- LV6 --------- */
scalar_exp:
        scalar_exp '+' scalar_exp
    |   scalar_exp '-' scalar_exp
    |   scalar_exp '*' scalar_exp
    |   scalar_exp '/' scalar_exp
    |   '+' scalar_exp %prec UMINUS
    |   '-' scalar_exp %prec UMINUS
    |   literal 
    |   column_ref
    |   '(' scalar_exp ')'
    ;

/* --------- LV7 --------- */
table:
        NAME
    |   NAME '.' NAME
    ;

column_ref:
        NAME
    |   NAME '.' NAME   /* needs semantics */
    |   NAME '.' NAME '.' NAME
    ;

literal:
        STRING
    |   INTNUM
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
