
/*select * 
  from QCSITEADMIN_DB.PROJECT_SESSIONS a, QCSITEADMIN_DB.LOGIN_SESSIONS b 
 where a.PS_LS_ID = b.LS_ID; */

SELECT ls_user_name, ls_client_type, ls_client_host, ps_project_name,
       ps_connect_time, ls_login_time, ls_last_action_time,
       ls_last_touch_time
  FROM qcsiteadmin_db.project_sessions a, qcsiteadmin_db.login_sessions b
 WHERE a.ps_ls_id = b.ls_id order by ls_client_type;
 
