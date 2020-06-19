#include <fbs_sql_context.h>
#include <fbs_yy_gen.h>
#include <fbs_sql_lex.yy.h>


int on_accept(fbs_ctx *ctxp, int sql)
{
    return 0;
}

int on_sql_empty(fbs_ctx *ctxp)
{
    return 0;
}

int on_sql_sl(fbs_ctx *ctxp, int stl)
{
    return 0;
}

int on_statement_list_s(fbs_ctx *ctxp, int stm)
{
    return 0;
}

int on_statement_list_ss(fbs_ctx *ctxp, int stl, int stm)
{
    return 0;
}

int on_statement_ss(fbs_ctx *ctxp, int sls)
{
    return 0;
}

int on_select_stmt_ssfw(fbs_ctx *ctxp, int sel, int fcl, int wcl)
{
    return 0;
}

int on_selection_sel(fbs_ctx *ctxp, int sel)
{
    return 0;
}

int on_selection_all(fbs_ctx *ctxp)
{
    return 0;
}

int on_scalar_exp_list_s(fbs_ctx *ctxp)
{
    return 0;
}

int on_scalar_exp_list_ss(fbs_ctx *ctxp, int sel, int sep)
{
    return 0;
}

int on_from_clause_ft(fbs_ctx *ctxp, int trl)
{
    return 0;
}

int on_where_clause_empty(fbs_ctx *ctxp)
{
    return 0;
}

int on_where_clause_ws(fbs_ctx *ctxp, int scd)
{
    return 0;
}

int on_table_ref_list_t(fbs_ctx *ctxp, int trf)
{
    return 0;
}

int on_table_ref_list_tt(fbs_ctx *ctxp, int trl, int trf)
{
    return 0;
}

int on_table_ref_n(fbs_ctx *ctxp, int nrf)
{
    return 0;
}

int on_search_condition_sos(fbs_ctx *ctxp, int sdl, int sdr)
{
    return 0;
}

int on_search_condition_sas(fbs_ctx *ctxp, int sdl, int sdr)
{
    return 0;
}

int on_search_condition_s(fbs_ctx *ctxp, int sdt)
{
    return 0;
}

int on_search_condition_p(fbs_ctx *ctxp, int pdt)
{
    return 0;
}

int on_predicate_c(fbs_ctx *ctxp, int cpd)
{
    return 0;
}

int on_predicate_l(fbs_ctx *ctxp, int lpd)
{
    return 0;
}

int on_comparison_predicate_scs(fbs_ctx *ctxp, int sel, int ser)
{
    return 0;
}

int on_like_predicate_snll(fbs_ctx *ctxp, int sep, int lkl)
{
    return 0;
}

int on_like_predicate_sll(fbs_ctx *ctxp, int sep, int lkl)
{
    return 0;
}

int on_scalar_exp_sps(fbs_ctx *ctxp, int sel, int ser)
{
    return 0;
}

int on_scalar_exp_sss(fbs_ctx *ctxp, int sel, int ser)
{
    return 0;
}

int on_scalar_exp_sms(fbs_ctx *ctxp, int sel, int ser)
{
    return 0;
}

int on_scalar_exp_sds(fbs_ctx *ctxp, int sel, int ser)
{
    return 0;
}

int on_scalar_exp_aspu(fbs_ctx *ctxp, int sep)
{
    return 0;
}

int on_scalar_exp_sspu(fbs_ctx *ctxp, int sep)
{
    return 0;
}

int on_scalar_exp_se(fbs_ctx *ctxp, int sep)
{
    return 0;
}

int on_scalar_exp_su(fbs_ctx *ctxp, int sun)
{
    return 0;
}

int on_scalar_unit_i(fbs_ctx *ctxp, int val)
{
    fprintf(ctxp->log, "bison>> on_scalar_unit_i is :%d\n", val);
    fbs_symbol *vp = fbs_symbol_create(ctxp, FBS_SYMBOL_INT);
    vp->val = val;
    int vid = fbs_symbol_register(ctxp, vp);

    fbs_symbol *np = fbs_symbol_create(ctxp, FBS_SYMBOL_NONTERM); 
    fbs_symbol_add_child(np, vid);
    return fbs_symbol_register(ctxp, np); 
}

int on_scalar_unit_n(fbs_ctx *ctxp, int nrf)
{
    return 0;
}

int on_name_ref_s(fbs_ctx *ctxp)
{
    char * ss = ctxp->lex_text;
    fprintf(ctxp->log, "bison>> on_name_ref_s :%s\n", ss);
    fbs_symbol *sp = fbs_symbol_create(ctxp, FBS_SYMBOL_STR);
    sp->yield = fbs_str_dup(ss);
    int sid = fbs_symbol_register(ctxp, sp);

    fbs_symbol *np = fbs_symbol_create(ctxp, FBS_SYMBOL_NONTERM); 
    fbs_symbol_add_child(np, sid);
    return fbs_symbol_register(ctxp, np);
}

int on_name_ref_ns(fbs_ctx *ctxp, int nrf)
{
    char * ss = ctxp->lex_text;
    fprintf(ctxp->log, "bison>> on_name_ref_ns :%s\n", ss);
    fbs_symbol *sp = fbs_symbol_create(ctxp, FBS_SYMBOL_STR);
    sp->yield = fbs_str_dup(ss);
    int sid = fbs_symbol_register(ctxp, sp);

    fbs_symbol *np = fbs_symbol_create(ctxp, FBS_SYMBOL_NONTERM); 
    fbs_symbol_add_child(np, nrf);
    fbs_symbol_add_child(np, sid);
    return fbs_symbol_register(ctxp, np);
}

int on_like_literal_s(fbs_ctx *ctxp)
{
    char * ss = ctxp->lex_text;
    fprintf(ctxp->log, "bison>> on_like_literal_s is :%s\n", ss);
    fbs_symbol *sp = fbs_symbol_create(ctxp, FBS_SYMBOL_STR);
    sp->yield = fbs_str_dup(ss);
    int sid = fbs_symbol_register(ctxp, sp);

    fbs_symbol *np = fbs_symbol_create(ctxp, FBS_SYMBOL_NONTERM); 
    fbs_symbol_add_child(np, sid);
    return fbs_symbol_register(ctxp, np);
}

int on_like_literal_i(fbs_ctx *ctxp, int val)
{
    fprintf(ctxp->log, "bison>> on_like_literal_i is :%d\n", val);
    fbs_symbol *vp = fbs_symbol_create(ctxp, FBS_SYMBOL_INT);
    vp->val = val;
    int vid = fbs_symbol_register(ctxp, vp);

    fbs_symbol *np = fbs_symbol_create(ctxp, FBS_SYMBOL_NONTERM); 
    fbs_symbol_add_child(np, vid);
    return fbs_symbol_register(ctxp, np); 
}
