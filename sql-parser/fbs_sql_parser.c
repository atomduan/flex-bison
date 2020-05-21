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
    /*reentrant invoke, for every scanner is thread safe*/
    yyscan_t scanner;
    yylex_init(&scanner);
    yyparse(scanner);
    yylex_destroy(scanner);
}
