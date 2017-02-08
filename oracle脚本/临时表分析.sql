select *
  from perfstat.analyze_tablelist a
 where TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120225%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')
   and table_name like 'WOBMESSAGEHEADER%'
   

select a.*
  from perfstat.analyze_tablelist a
 where TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120330%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')
   and table_name like 'WOBMESSAGEHEADER%' 

/*

利用下面的存储过程来添加需要做表分析的表*/   
   

   
-----------------------------------------------------------------------   
DCUSTPAYOWEDET20120399

select * from perfstat.mv_tab_config b
                           where db_id=209 and b.db_name like 'acc1%'


DBACCADM	WPAY201203              acc1
ONEBOSS	WOBMESSAGEHEADER201203    cen
ONEBOSS	WOBWARNMSG                cen
                 
acc1 184
cen 209

/*插入要做临时表分析的表*/
insert into perfstat.analyze_tablelist  select a.*
  from perfstat.analyze_tablelist a
 where TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120327%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')
   and table_name like 'WOBMESSAGEHEADER%'


/*修改时间*/
update perfstat.analyze_tablelist a set analyze_date=(select analyze_date
  from perfstat.analyze_tablelist a
 where TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120329%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')  and rownum=1)
   where rownum=1 and TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120327%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')
   and table_name like 'WOBMESSAGEHEADER%';



insert into perfstat.analyze_tablelist
select *
from perfstat.analyze_tablelist
where table_name like 'WPAY-YYYYMM-%'
and rownum = 1 
and fk_server_id=184;



select *
from perfstat.analyze_tablelist
where table_name like 'WPAY-YYYYMM-%' and rownum=1;



update perfstat.analyze_tablelist a set analyze_date=(select analyze_date
  from perfstat.analyze_tablelist a
 where TO_CHAR(ANALYZE_DATE, 'yyyymmdd') like '20120329%'
   and a.fk_server_id in (select b.db_id
                            from perfstat.mv_tab_config b
                           where b.db_name like 'crm%'
                              or b.db_name like 'acc%'
                              or b.db_name = 'cen1')  and rownum=1)
where table_name like 'WPAY-YYYYMM-%'
and rownum = 1 
and fk_server_id=184;

