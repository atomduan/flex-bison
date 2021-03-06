/* Prologue Section */
%code top {
#include <fbs_parser.h>
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
    double  DNUM;    
    symrec *FUNC_PTR;
};
}/*code requires end*/
%code {
int yylex(fbs_ctx *ctxp);
void yyerror(fbs_ctx *ctxp, char const *msg);
}/*code end*/


/* Declarations Section */
%defines "fbs_yy_gen.h"
%define api.value.type {union YYSTYPE}
%lex-param      {fbs_ctx *ctxp}
%parse-param    {fbs_ctx *ctxp}

%token  <DNUM>        NUM
%token  <FUNC_PTR>    VAR FNCT
%nterm  <DNUM>        exp

%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'
%expect 5

%destructor { printf("DNUM dsctructor, do nothing\n"); } <DNUM>
%destructor { printf("FUNC_PTR dsctructor\n"); free($$); } <FUNC_PTR>
%destructor { free($$); } <*>
%destructor { printf("Discarding tagless symbol.\n"); } <>

%printer { /*do nothing*/ } <*>
%printer { /*do nothing*/ } <>
%printer { printf("FUNC_PTR, name:%s\n", $$->name); } <FUNC_PTR>

%glr-parser


/* Grammar Rules Section */ 
%%
input:
    %empty                          /*If you don’t specify an action for a rule, Bison supplies a default: $$ = $1.*/
|   input line
;

line:
    '\n'
|   exp '\n'                        {   printf("%.10g\n", $1);  }
|   error '\n'                      {   yyerrok;    }
;

exp:
    NUM                             {   $$ = $1;    }
|   VAR[var]                        { 
                                        if ($[var]->has_init == 1) {
                                            $$ = $[var]->value.var; 
                                        } else {
                                            printf("use uninit VAR name %s\n", $[var]->name);
                                            yyerror(ctxp,"use uninit VAR error\n");
                                        }
                                    }
|   VAR[var] '=' exp                { 
                                        $$ = $3; 
                                        $[var]->value.var = $3;
                                        $[var]->has_init = 1;
                                    }
|   FNCT[func] '(' exp ')'          {   $$ = (*($[func]->value.fnctptr))($3);   }
|   exp[left] '+' exp[right]        {   $$ = $[left] + $[right];    }
|   exp[left] '-' exp[right]        {   $$ = $[left] - $[right];    }
|   exp[left] '*' exp[right]        {   $$ = $[left] * $[right];    }
|   exp[left] '/' exp[right]        { 
                                        if ($[right] != 0) {
                                            $$ = $[left] / $[right];
                                        } else {
                                            $$ = 1;
                                            fprintf(stderr,"(%d,%d)-(%d,%d): division bu zero\n",
                                                    @[right].first_line,@[right].first_column,
                                                    @[right].last_line,@[right].last_column);
                                            yyerror(ctxp,"zero error\n");
                                        }
                                    }
|   '-' exp %prec NEG               {   $$ = -$2;   }
|   exp[base] '^' exp[factor]       {   $$ =  pow($[base],$[factor]);   }
|   '(' exp ')'                     {   $$ =  $2;   }
;
%%

/* Epilogue Section */
void yyerror(fbs_ctx *ctxp, char const *msg)
{
    FBS_USE(ctxp);
    fprintf(stderr,"%s\n",msg);
}
