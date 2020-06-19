#ifndef FBS_SQL_CONTEXT
#define FBS_SQL_CONTEXT

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

#define FBS_MAX_STR_CONST       4096
#define FBS_SYMBOL_TABLE_SIZE   4096
#define FBS_SYMBOL_CHILD_SIZE   10

#define FBS_SYMBOL_INT      1
#define FBS_SYMBOL_STR      2
#define FBS_SYMBOL_NONTERM  3

typedef struct fbs_symbol_s fbs_symbol; 
typedef struct fbs_ctx_s fbs_ctx; 

struct fbs_ctx_s {
    yyscan_t        yyscanner;
    /* user defined start below... */
    FILE *          log;
    FILE *          log_err;
    char *          lex_text;
    char *          lex_text_ptr;
    fbs_symbol **   symbol_table;
    int             symbol_curr_id;
}; 
struct fbs_symbol_s {
    int         type; 
    int *       children; 
    int         val;
    fbs_ctx *   ctxp;
};

int reentrant_yyparse();
fbs_ctx * fbs_ctx_init();
int fbs_ctx_desctroy(fbs_ctx *ctxp);

/* lex utils */
#define FBS_LEX_NUL         0
#define FBS_LEX_EQ          1
#define FBS_LEX_GT          2
#define FBS_LEX_LT          3
#define FBS_LEX_NEQ         4
#define FBS_LEX_EGT         5
#define FBS_LEX_ELT         6
int fbs_lex_get_cmp_tokenum(const char *fbs_text);

void * fbs_alloc(size_t size);
void fbs_free(void *ptr);

fbs_symbol * fbs_create_symbol(fbs_ctx *ctxp, int type, int val);
int fbs_regist_symbol(fbs_ctx *ctxp, fbs_symbol *symbol);

#include <fbs_sql_parser.h>
#endif/*FBS_SQL_CONTEXT*/
