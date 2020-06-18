#ifndef FBS_SQL_PARSER
#define FBS_SQL_PARSER

int on_accept(fbs_ctx *ctxp, int sql);
int on_sql_empty(fbs_ctx *ctxp);
int on_sql_sl(fbs_ctx *ctxp, int stl);
int on_statement_list_s(fbs_ctx *ctxp, int stm);
int on_statement_list_ss(fbs_ctx *ctxp, int stl, int stm);
int on_statement_ss(fbs_ctx *ctxp, int sls);
int on_select_stmt_ssfw(fbs_ctx *ctxp, int sel, int fcl, int wcl);
int on_selection_sel(fbs_ctx *ctxp, int sel);
int on_selection_all(fbs_ctx *ctxp);
int on_scalar_exp_list_s(fbs_ctx *ctxp);
int on_scalar_exp_list_ss(fbs_ctx *ctxp, int sel, int sep);
int on_from_clause_ft(fbs_ctx *ctxp, int trl);
int on_where_clause_empty(fbs_ctx *ctxp);
int on_where_clause_ws(fbs_ctx *ctxp, int scd);
int on_table_ref_list_t(fbs_ctx *ctxp, int trf);
int on_table_ref_list_tt(fbs_ctx *ctxp, int trl, int trf);
int on_table_ref_n(fbs_ctx *ctxp, int nrf);
int on_search_condition_sos(fbs_ctx *ctxp, int sdl, int sdr);
int on_search_condition_sas(fbs_ctx *ctxp, int sdl, int sdr);
int on_search_condition_s(fbs_ctx *ctxp, int sdt);
int on_search_condition_p(fbs_ctx *ctxp, int pdt);
int on_predicate_c(fbs_ctx *ctxp, int cpd);
int on_predicate_l(fbs_ctx *ctxp, int lpd);
int on_comparison_predicate_scs(fbs_ctx *ctxp, int sel, int ser);
int on_like_predicate_snll(fbs_ctx *ctxp, int sep, int lkl);
int on_like_predicate_sll(fbs_ctx *ctxp, int sep, int lkl);
int on_scalar_exp_sps(fbs_ctx *ctxp, int sel, int ser);
int on_scalar_exp_sss(fbs_ctx *ctxp, int sel, int ser);
int on_scalar_exp_sms(fbs_ctx *ctxp, int sel, int ser);
int on_scalar_exp_sds(fbs_ctx *ctxp, int sel, int ser);
int on_scalar_exp_aspu(fbs_ctx *ctxp, int sep);
int on_scalar_exp_sspu(fbs_ctx *ctxp, int sep);
int on_scalar_exp_se(fbs_ctx *ctxp, int sep);
int on_scalar_exp_su(fbs_ctx *ctxp, int sun);
int on_scalar_unit_i(fbs_ctx *ctxp, int num);
int on_scalar_unit_n(fbs_ctx *ctxp, int nrf);
int on_name_ref_s(fbs_ctx *ctxp, int str);
int on_name_ref_ns(fbs_ctx *ctxp, int nrf, int str);
int on_like_literal_s(fbs_ctx *ctxp, int str);
int on_like_literal_i(fbs_ctx *ctxp, int num);

#endif/*FBS_SQL_PARSER*/
