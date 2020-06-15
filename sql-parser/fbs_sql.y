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

sql:    
        /* empty */                                             {   FBS_USE(@$); FBS_USE(ctxp);                     }
    |   sql_list 
    ;

sql_list:
        statement ';'
    |   sql_list statement ';'
    ;

statement:
        select_statement
    ;

select_statement:
        SELECT selection from_clause where_clause
    ;

selection:
        scalar_exp_commalist
    |   '*'
    ;

scalar_exp_commalist:
        scalar_exp
    |   scalar_exp_commalist ',' scalar_exp
    ;

from_clause:
        FROM table_ref_commalist
    ;

where_clause:
        /* empty */
    |   WHERE search_condition
    ;

table_ref_commalist:
        table_ref 
    |   table_ref_commalist ',' table_ref 
    ;

table_ref:
        name_ref 
    ;

search_condition:
        search_condition OR search_condition
    |   search_condition AND search_condition
    |   '(' search_condition ')'
    |   predicate
    ;

predicate:
        comparison_predicate
    |   like_predicate
    ;

comparison_predicate:
        scalar_exp COMPARISON scalar_exp
    ;

like_predicate:
        scalar_exp NOT LIKE like_literal
    |   scalar_exp LIKE like_literal
    ;

scalar_exp:
        scalar_exp '+' scalar_exp
    |   scalar_exp '-' scalar_exp
    |   scalar_exp '*' scalar_exp
    |   scalar_exp '/' scalar_exp
    |   '+' scalar_exp %prec UMINUS /*TODO what the hell of this, prec*/
    |   '-' scalar_exp %prec UMINUS
    |   '(' scalar_exp ')'
    |   scalar_unit 
    ;

scalar_unit:
        INTNUM
    |   name_ref 
    ;

name_ref:
        STRING
    |   name_ref '.' STRING       /*TODO what the relation between shift reduce and stack ops*/
    ;

like_literal:
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
