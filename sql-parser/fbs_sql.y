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
            fprintf(ctxp->log, "trans statement\n");
        }
    |   statement_list[stl] statement[stm] ';' {
            fprintf(ctxp->log, "trans statement_list sub_list\n");
            fprintf(ctxp->log, "trans statement\n");
        }
    ;

statement:
        select_stmt[sls] {
            fprintf(ctxp->log, "trans select_stmt\n");
        }
    ;

select_stmt:
        SELECT selection[sel] from_clause[fcl] where_clause[wcl] {
            fprintf(ctxp->log, "trans selection sel\n");
            fprintf(ctxp->log, "trans from_clause fcl\n");
            fprintf(ctxp->log, "trans where_clause wcl\n");
            fprintf(ctxp->log, "handle SELECT\n");
        }
    ;

selection:
        scalar_exp_list[sel] {
            fprintf(ctxp->log, "trans scalar_exp_list\n");
        }
    |   '*' {
            fprintf(ctxp->log, "trans *\n");
        }
    ;

scalar_exp_list:
        scalar_exp {
            fprintf(ctxp->log, "trans scalar_exp\n");
        }
    |   scalar_exp_list[sel] ',' scalar_exp[sep] {
            fprintf(ctxp->log, "trans scalar_exp_list sub_list\n");
            fprintf(ctxp->log, "trans scalar_exp\n");
        }
    ;

from_clause:
        FROM table_ref_list[trl] {
            fprintf(ctxp->log, "trans table_ref_list\n");
            fprintf(ctxp->log, "handle FROM\n");
        }
    ;

where_clause:
        /* empty */ {
            FBS_USE(ctxp);
        }
    |   WHERE search_condition[scd] {
            fprintf(ctxp->log, "trans search_condition\n");
        }
    ;

table_ref_list:
        table_ref[trf] {
            fprintf(ctxp->log, "trans table_ref\n");
        }
    |   table_ref_list[trl] ',' table_ref[trf] {
            fprintf(ctxp->log, "trans table_ref_list\n");
            fprintf(ctxp->log, "trans table_ref\n");
        }
    ;

table_ref:
        name_ref[nrf] {
            fprintf(ctxp->log, "trans name_ref\n");
        }
    ;

search_condition:
        search_condition[sdl] OR search_condition[sdr]  {
            fprintf(ctxp->log, "trans search_condition sdl\n");
            fprintf(ctxp->log, "trans search_condition sdr\n");
            fprintf(ctxp->log, "handle OR\n");
        }
    |   search_condition[sdl] AND search_condition[sdr] {
            fprintf(ctxp->log, "trans search_condition sdl\n");
            fprintf(ctxp->log, "trans search_condition sdr\n");
            fprintf(ctxp->log, "handle AND\n");
        }
    |   '(' search_condition[sdt] ')' {
            fprintf(ctxp->log, "trans search_condition sdt\n");
            fprintf(ctxp->log, "handle QUOTE\n");
        }
    |   predicate[pdt] {
            fprintf(ctxp->log, "trans predicate\n");
        }
    ;

predicate:
        comparison_predicate[cpd] {
            fprintf(ctxp->log, "trans comparison_predicate\n");
        }
    |   like_predicate[lpd] {
            fprintf(ctxp->log, "trans like_predicate\n");
        }
    ;

comparison_predicate:
        scalar_exp[sel] COMPARISON[cmp] scalar_exp[ser] {
            fprintf(ctxp->log, "trans scalar sep\n");
            fprintf(ctxp->log, "trans scalar ser\n");
            fprintf(ctxp->log, "handle COMPARISON[%d]\n", $[cmp]);
        }
    ;

like_predicate:
        scalar_exp[sep] NOT LIKE like_literal[lkl] {
            fprintf(ctxp->log, "trans scalar sep\n");
            fprintf(ctxp->log, "trans scalar lkl\n");
            fprintf(ctxp->log, "handle NOT LIKE\n");
        }
    |   scalar_exp[sep] LIKE like_literal[lkl] {
            fprintf(ctxp->log, "trans scalar sep\n");
            fprintf(ctxp->log, "trans scalar lkl\n");
            fprintf(ctxp->log, "handle LIKE\n");
        }
    ;

scalar_exp:
        scalar_exp[sel] '+' scalar_exp[ser] {
            fprintf(ctxp->log, "trans scalar sel\n");
            fprintf(ctxp->log, "trans scalar ser\n");
            fprintf(ctxp->log, "handle +\n");
        }
    |   scalar_exp[sel] '-' scalar_exp[ser] {
            fprintf(ctxp->log, "trans scalar sel\n");
            fprintf(ctxp->log, "trans scalar ser\n");
            fprintf(ctxp->log, "handle -\n");
        }
    |   scalar_exp[sel] '*' scalar_exp[ser] {
            fprintf(ctxp->log, "trans scalar sel\n");
            fprintf(ctxp->log, "trans scalar ser\n");
            fprintf(ctxp->log, "handle *\n");
        }
    |   scalar_exp[sel] '/' scalar_exp[ser] {
            fprintf(ctxp->log, "trans scalar sel\n");
            fprintf(ctxp->log, "trans scalar ser\n");
            fprintf(ctxp->log, "handle /\n");
        }
    |   '+' scalar_exp[sep] %prec UMINUS {
            fprintf(ctxp->log, "handle + UMINUS\n");
        }
    |   '-' scalar_exp[sep] %prec UMINUS {
            fprintf(ctxp->log, "handle - UMINUS\n");
        }
    |   '(' scalar_exp[sep] ')' {
            fprintf(ctxp->log, "trans scalar_exp quote\n");
        }
    |   scalar_unit[sun] {
            fprintf(ctxp->log, "trans scalar_exp unit\n");
        }
    ;

scalar_unit:
        INTNUM[val] {
            fprintf(ctxp->log, "reg %d\n", $[val]);
        }
    |   name_ref[nrf] {
            fprintf(ctxp->log, "trans name_ref\n");
        }
    ;

name_ref:
        STRING[str] {
            fprintf(ctxp->log, "reg_str %s\n", ctxp->lex_text);
        }
    |   name_ref[nrf] '.' STRING {
            fprintf(ctxp->log, "reg_str %s\n", ctxp->lex_text);
        }
    ;

like_literal:
        STRING[str] {
            fprintf(ctxp->log, "reg_str %s\n", ctxp->lex_text);
        }
    |   INTNUM[val] {
            fprintf(ctxp->log, "reg %d\n", $[val]);
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
