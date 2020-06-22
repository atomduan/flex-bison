#include <fbs_context.h>
#include <fbs_lex.yy.h>

#define YYEOF           0

extern int ctx_yylex(fbs_ctx *ctxp, yyscan_t yyscanner);

int main(int argc,char **argv)
{
    fbs_ctx *ctxp = fbs_ctx_init();
    yyscan_t yyscanner = ctxp->yyscanner;
    FILE *log= ctxp->log;
    int yychar = 0;
fbs_read_next:
    fprintf(log, "fbs_lexer>> parse next token:\n\n");
    yychar = ctx_yylex(ctxp, yyscanner);
    if (yychar <= YYEOF) {
        fprintf(log, "fbs_lexer>> Now at end of input.\n");
        goto fbs_lex_fin;
    }
    fprintf(log, "fbs_lexer>> yylex token return. value is : %d\n", yychar);
    goto fbs_read_next;
fbs_lex_fin:
    fbs_ctx_desctroy(ctxp);
    return 0;
}
