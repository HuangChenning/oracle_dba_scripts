select * from(select d.al_description 归档项目, 
       c.al_description 归档文件夹, 
       a.RQ_REQ_TYPE    需求类型,   
       rq_user_04       需求状态, 
       rq_user_05       工作量, 
       b.al_description 需求文件夹, 
       a.rq_req_name    需求名称 
  from BOSS_BOSSTEST0723_DB.req       a, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS b, 
       boss_bosstest0723_db.all_lists c, 
       boss_bosstest0723_db.all_lists d 
 where a.rq_req_name(+) = b.al_description 
   and b.al_father_id = c.al_item_id 
   and c.al_father_id = d.al_item_id 
   and c.al_description = 
       any('Q_SCMob_ZhaoBH_AC_MOD_DOC', 
           'Q_SCMob_ZhaoBH_AC_MOD_2008', 
           'Q_SCMob_ZhaoBH_AC_MOD_2009', 
           'R_SCMob_ZhaoBH_AC_MOD_DOC', 
           'R_SCMob_ZhaoBH_AC_MOD_2009', 
           'R_SCMob_ZhaoBH_AC_SRV_2008', 
           'R_SCMob_zhaobh_CRM_PD3_2008', 
           'R_SCMob_zhaobh_CRM_PD3_2009', 
           'R_SCMob_zhaobh_CRM_PD3_2009_CUR', 
           'R_SCMob_zhaobh_CRM_SRV_2009', 
           'R_SCMob_zhaobh_CRM_SRV_2009_CUR')) where 需求名称 like'Q%'
