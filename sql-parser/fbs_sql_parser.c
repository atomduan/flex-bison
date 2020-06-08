#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>


int main(int argc,char **argv)
{
    /* Enable parse traces on option -x.  */
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i],"-x") == 0)
            yydebug = 1;
    }
    return reentrant_yyparse();
}
