#ifndef FBS_CAL_PARSER

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

#define FBS_USE(VALUE) /*empty*/

/* Function type.  */
typedef double (*func_t)(double);

/* Data type for links in the chain of symbols.  */
typedef struct symrec_s symrec;
struct symrec_s {
    char *name;  /* name of symbol */
    int type;    /* type of symbol: either VAR or FNCT */
    int has_init;
    union {
        double var;      /* value of a VAR */
        func_t fnctptr;  /* value of a FNCT */
    } value;
    symrec *next;  /* link field */
};

typedef struct init_fnct_s init_fnct;
struct init_fnct_s {
    char const *fname;
    double (*fnct) (double);
};

/* CONTEXT DEFINE */
typedef struct fbs_ctx_s fbs_ctx; 
struct fbs_ctx_s {
    symrec *sym_table;
}; 
fbs_ctx * fbs_ctx_init();
int fbs_ctx_desctroy(fbs_ctx *ctxp);

symrec * putsym(const char *sym_name, int sym_type, fbs_ctx *ctxp);
symrec * getsym(const char *sym_name, fbs_ctx *ctxp);
#endif/*FBS_CAL_PARSER*/
