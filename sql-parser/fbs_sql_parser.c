#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>

int
main(int argc,char **argv)
{
    int i;
    /* Enable parse traces on option -x.  */
    for (i = 1; i < argc; ++i)
        if (strcmp(argv[i],"-x") == 0)
            yydebug = 1;
    return yyparse();
}
