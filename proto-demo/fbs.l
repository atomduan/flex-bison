%option nounput noinput noyywrap
%option warn nodefault
%option yylineno
%option outfile="fbs_lex.yy.c"

%{
#include <fbs_parser.h>
#include <fbs_yy_gen.h>
#define YY_DECL int yylex (fbs_ctx *ctxp)
%}

FUNC_NAME       (atan|cos|exp|ln|sin|sqrt)
VAR_NAME	    ([[:alpha:]_][[:alnum:]_-]*)
ANY_OTHER       .|\n

%%
[ \t]           {   ;/* ignore all whitespace*/    }
[0-9]+\.[0-9]+ 	{   yylval.DNUM = atof(yytext); return NUM; }
[0-9]+		    {   yylval.DNUM = atof(yytext); return NUM; }
{FUNC_NAME}     {
                    symrec *s = getsym(yytext,ctxp);
                    yylval.FUNC_PTR = s;
                    return s->type;
                }
"+"             {   return (int)*yytext;    }
"-"             {   return (int)*yytext;    }
"*"             {   return (int)*yytext;    }
"/"             {   return (int)*yytext;    }
"("             {   return (int)*yytext;    }
")"             {   return (int)*yytext;    }
"="             {   return (int)*yytext;    }
"^"             {   return (int)*yytext;    }
{VAR_NAME}      {   
                    symrec *s = putsym(yytext,VAR,ctxp);
                    return s->type;
                }
{ANY_OTHER}     {   return (int)*yytext;    }
%%
