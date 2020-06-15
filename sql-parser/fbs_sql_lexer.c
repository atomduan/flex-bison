#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>

#define YYEOF           0

int _yylex(YYSTYPE * yylval_param, YYLTYPE * yylloc_param, fbs_ctx *ctxp, yyscan_t yyscanner);

int main(int argc,char **argv)
{
    fbs_ctx *ctxp = fbs_ctx_init();
    yyscan_t yyscanner = ctxp->yyscanner;
    FILE *log= ctxp->log;
    YYSTYPE yylval;
    YYLTYPE yylloc;
    int yychar = 0;
fbs_read_next:
    fprintf(log, "fbs_sql_lexer>>  ---------   parse next token  ---------  \n");
    yychar = _yylex(&yylval,&yylloc,ctxp,yyscanner);
    if (yychar <= YYEOF) {
        fprintf(log, "fbs_sql_lexer>> Now at end of input.\n");
        goto fbs_lex_fin;
    }
    fprintf(log, "fbs_sql_lexer>> yychar is numeric value is : %d\n\n", yychar);
    goto fbs_read_next;
fbs_lex_fin:
    fbs_ctx_desctroy(ctxp);
    return 0;
}
