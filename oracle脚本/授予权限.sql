
select * from dba_tab_privs where table_name='DDAYSHOPINFOHIS' and grantee='';

grant select on DDAYSHOPINFOHIS to AIOXMONITOR;


/*settledb 10.109.208.28 ¡ıµ§ stq002 Õ¨stq169 
select * from dba_sys_privs where grantee=upper('stq169'); 

select * from dba_user_privs where username=upper('stq169'); 

select * from dba_tab_privs where grantee=upper('stq169');

select * from dba_user_privs where username=upper('stq002'); 
*/

/*
select * from dba_users where username=upper('stq169'); BOSS_JFUSER
select * from dba_users where username=upper('stq002'); 

create user stq002 identified by stq002_123;
alter user stq002 profile  BOSS_JFUSER;

grant CONNECT,LOWPRIVL to stq002;
*/



