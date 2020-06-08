#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>

/*reentrant invoke, for every scanner is thread safe*/
int reentrant_yyparse()
{
    fbs_ctx *ctxp = fbs_ctx_init();
    yyparse(ctxp);
    fbs_ctx_desctroy(ctxp);
    return 0;
}

fbs_ctx * fbs_ctx_init()
{
    yyscan_t yyscanner;
    yylex_init(&yyscanner);
    fbs_ctx *ctxp = malloc(sizeof(fbs_ctx));
    ctxp->yyscanner = yyscanner;
    return ctxp;    
}

int fbs_ctx_desctroy(fbs_ctx *ctxp)
{
    if (ctxp != NULL) {
        yyscan_t yyscanner = ctxp->yyscanner;
        if (yyscanner != NULL) {
            yylex_destroy(yyscanner);
        }
        free(ctxp);
    }
    return 0;
}
