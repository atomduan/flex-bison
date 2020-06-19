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

int fbs_lex_get_cmp_tokenum(const char *fbs_text)
{
    if (0 == strcmp("=", fbs_text)) {
        return FBS_LEX_EQ;
    }
    if (0 == strcmp(">", fbs_text)) {
        return FBS_LEX_GT;
    }
    if (0 == strcmp("<", fbs_text)) {
        return FBS_LEX_LT;
    }
    if (0 == strcmp("<>", fbs_text)) {
        return FBS_LEX_NEQ;
    }
    if (0 == strcmp("<=", fbs_text)) {
        return FBS_LEX_ELT;
    }
    if (0 == strcmp(">=", fbs_text)) {
        return FBS_LEX_EGT;
    }
    return FBS_LEX_NUL;
}

fbs_symbol * fbs_create_symbol(fbs_ctx *ctxp, int type, int val) {
    fbs_symbol * p = fbs_alloc(sizeof(fbs_symbol));
    p->type = type;
    p->val = val;
    p->children = fbs_alloc(sizeof(int)*FBS_SYMBOL_CHILD_SIZE);
    p->ctxp = ctxp;
    return p; 
}

int fbs_regist_symbol(fbs_ctx *ctxp, fbs_symbol *symbol) {
    int curr_id = ctxp->symbol_curr_id;
    *ctxp->symbol_table[curr_id] = *symbol;
    ctxp->symbol_curr_id++;
    return ctxp->symbol_curr_id;
}
