#include <fbs_parser.h>
#include <fbs_yy_gen.h>

static const init_fnct arith_fncts[] =
{
    { "atan", atan },
    { "cos",  cos  },
    { "exp",  exp  },
    { "ln",   log  },
    { "sin",  sin  },
    { "sqrt", sqrt },
    { 0, 0 },
};

symrec * putsym(const char *sym_name, int sym_type, fbs_ctx *ctxp)
{
    symrec *ptr = (symrec*) malloc(sizeof(symrec));
    ptr->name = (char*)malloc(strlen(sym_name)+1);
    strcpy (ptr->name,sym_name);
    ptr->type = sym_type;
    ptr->value.var = 0; /* Set value to 0 even if fctn.  */
    ptr->has_init = 0;
    ptr->next = ctxp->sym_table;
    ctxp->sym_table = ptr;
    return ptr;
}

symrec * getsym(const char *sym_name, fbs_ctx *ctxp)
{
    symrec *ptr = NULL;
    for (ptr=ctxp->sym_table; ptr!=NULL; ptr=ptr->next) {
        if (strcmp(ptr->name,sym_name) == 0) {
            return ptr;
        }
    }
    return 0;
}

fbs_ctx * fbs_ctx_init()
{
    fbs_ctx *ctxp = malloc(sizeof(fbs_ctx));
    memset(ctxp,0,sizeof(fbs_ctx));
    for (int i=0; arith_fncts[i].fname != 0; i++) {
        symrec *ptr = putsym(arith_fncts[i].fname,FNCT,ctxp);
        ptr->value.fnctptr = arith_fncts[i].fnct;
    }
    return ctxp;    
}

int fbs_ctx_desctroy(fbs_ctx *ctxp)
{
    if (ctxp != NULL) {
        free(ctxp);
    }
    return 0;
}

int main(int argc,char **argv)
{
    int i;
    /* Enable parse traces on option -x.  */
    for (i = 1; i < argc; ++i)
        if (strcmp(argv[i],"-x") == 0)
            yydebug = 1;
    fbs_ctx *ctxp = fbs_ctx_init();
    yyparse(ctxp);
    fbs_ctx_desctroy(ctxp);
}
