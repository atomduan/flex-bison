#ifndef FBS_SQL_PARSER
#define FBS_SQL_PARSER

#define _FILE_OFFSET_BITS  64

#include <unistd.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <pwd.h>
#include <grp.h>
#include <dirent.h>
#include <glob.h>
#include <fcntl.h>

#include <time.h>
#include <limits.h>
#include <stdbool.h>

/* use of dirname */
#include <libgen.h>
#include <dlfcn.h>

extern char **environ;
#define FBS_USE(VALUE)

/* TODO:FLEX hecked! fbs_sql_lex.yy.h dup here!! need fix */
#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

typedef struct fbs_ctx_s fbs_ctx; 
struct fbs_ctx_s {
    yyscan_t yyscanner;
}; 

int reentrant_yyparse();
fbs_ctx * fbs_ctx_init();
int fbs_ctx_desctroy(fbs_ctx *ctxp);
#endif/*FBS_SQL_PARSER*/
