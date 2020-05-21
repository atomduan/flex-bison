#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>

int
main(int argc,char **argv)
{
    int i;
    /* Enable parse traces on option -x.  */
    for (i = 1; i < argc; ++i)
        if (strcmp(argv[i],"-x") == 0)
            yydebug = 1;
    return do_yyparse();
}

/*reentrant invoke, for every scanner is thread safe*/
int do_yyparse()
{
    fbs_ctx fbsctx = fbs_ctx_init();
    yyparse(fbsctx);
    fbs_ctx_desctroy(fbsctx);
    return 0;
}

fbs_ctx fbs_ctx_init()
{
    yyscan_t yyscanner;
    yylex_init(&yyscanner);
    fbs_ctx fbsctx = malloc(sizeof(fbs_ctx_t));
    fbsctx->yyscanner = yyscanner;
    return fbsctx;    
}

int fbs_ctx_desctroy(fbs_ctx fbsctx)
{
    if (fbsctx != NULL) {
        yyscan_t yyscanner = fbsctx->yyscanner;
        if (yyscanner != NULL) {
            yylex_destroy(yyscanner);
        }
        free(fbsctx);
    }
    return 0;
}

