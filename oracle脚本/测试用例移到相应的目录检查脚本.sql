select * from(select d.al_description �鵵��Ŀ, 
       c.al_description �鵵�ļ���, 
       a.RQ_REQ_TYPE    ��������,   
       rq_user_04       ����״̬, 
       rq_user_05       ������, 
       b.al_description �����ļ���, 
       a.rq_req_name    �������� 
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
           'R_SCMob_zhaobh_CRM_SRV_2009_CUR')) where �������� like'Q%'
