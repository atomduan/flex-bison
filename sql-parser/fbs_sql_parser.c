#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>

static int do_yyparse();

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

static int do_yyparse()
{
    /*reentrant invoke, for every scanner is thread safe*/
    fbs_ctx fbsctx = malloc(sizeof(fbs_ctx_t));
    yyscan_t scanner;
    yylex_init(&scanner);
    fbs_ctx_init(fbsctx,scanner);

    ///invoke parse
    yyparse(fbsctx);
    yylex_destroy(scanner);
    free(fbsctx);
    return 0;
}


int fbs_ctx_init(fbs_ctx fbsctx, yyscan_t scanner)
{
    fbsctx->yyscanner = scanner;
    return 0;    
}
