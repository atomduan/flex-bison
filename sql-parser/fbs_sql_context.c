#include <fbs_sql_context.h>
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

void * fbs_alloc(size_t size)
{
    void * ptr = NULL;
    ptr = malloc(size);
    memset(ptr, 0, size);
    return ptr;
}

void fbs_free(void *ptr)
{
    if (ptr != NULL) free(ptr);
}

fbs_ctx * fbs_ctx_init()
{
    yyscan_t yyscanner;
    yylex_init(&yyscanner);
    fbs_ctx *ctxp = fbs_alloc(sizeof(fbs_ctx));
    ctxp->yyscanner = yyscanner;
    //log setting
    ctxp->log = stdout;
    ctxp->log_err = stderr;
    //lex str buff
    ctxp->lex_text = fbs_alloc(FBS_MAX_STR_CONST);
    ctxp->lex_text_ptr = ctxp->lex_text;
    //init symbol table
    int tsz = sizeof(fbs_symbol*)*FBS_SYMBOL_TABLE_SIZE;
    ctxp->symbol_table = fbs_alloc(tsz);
    ctxp->symbol_curr_id = 0;
    return ctxp;    
}

int fbs_ctx_desctroy(fbs_ctx *ctxp)
{
    if (ctxp != NULL) {
        yyscan_t yyscanner = ctxp->yyscanner;
        if (yyscanner != NULL) {
            yylex_destroy(yyscanner);
        }
        fbs_free(ctxp);
    }
    return 0;
}

fbs_symbol * fbs_symbol_create(fbs_ctx *ctxp, int type)
{
    fbs_symbol * p = fbs_alloc(sizeof(fbs_symbol));
    p->type = type;
    p->child = fbs_alloc(sizeof(int)*FBS_SYMBOL_CHILD_SIZE);
    p->child_ptr = p->child;
    p->ctxp = ctxp;
    return p; 
}

int fbs_symbol_register(fbs_ctx *ctxp, fbs_symbol *symbol)
{
    int curr_id = ctxp->symbol_curr_id;
    ctxp->symbol_table[curr_id] = symbol;
    ctxp->symbol_curr_id++;
    return ctxp->symbol_curr_id;
}

void fbs_symbol_add_child(fbs_symbol *symbol, int child_symbol_id)
{
   *symbol->child_ptr++ = child_symbol_id; 
}

char * fbs_str_dup(char * src)
{
    char * res = fbs_alloc(strlen(src)+1);
    memcpy(res, src, strlen(src));
    return res;
}

void fbs_lex_log(fbs_ctx *ctxp, char *tkn, char *yt)
{
    //fprintf(ctxp->log, "lex>> hit pattern:[%s] --> token:[%s]\n", tkn, yt);
}
