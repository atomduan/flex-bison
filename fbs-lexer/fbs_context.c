#include <fbs_context.h>
#include <fbs_lex.yy.h>

/*reentrant invoke, for every scanner is thread safe*/
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

char * fbs_str_dup(char * src)
{
    char * res = fbs_alloc(strlen(src)+1);
    memcpy(res, src, strlen(src));
    return res;
}
