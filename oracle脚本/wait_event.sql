/*v$session:���ݿ⵱ǰ���ӵ�session��Ϣ
v$session_wait:��ǰ���ݿ����ӵĻsession���ڵȴ�����Դ���¼���Ϣ
����v$session��¼���Ƕ�̬��Ϣ����session�����������йأ�������¼��ʷ��Ϣ��
����oracle�ṩ����һ����ͼv$system_event����¼���ݿ��������������еȴ��¼��Ļ�����Ϣ��
ͨ��v$system_event��ͼ���û�����Ѹ�ٵػ�����ݿ����е�����ſ���*/

select *
  from v$session_wait
 where event not in (select event from perfstat.stats$idle_event)


/*�鿴library cache pin*/
select sid, substr(event, 1, 30), wait_time
  from v$session_wait
 where sid in (select sid
                 from x$kglpn, v$session
                where KGLPNHDL in
                      (select p1raw
                         from v$session_wait
                        where wait_time = 0
                          and event like 'library cache pin%')
                  and KGLPNMOD <> 0
                  and v$session.saddr = x$kglpn.kglpnuse);
                  
                  
                  

/*##SESSION:��ǰʵ����:�ỰID current waiting event*/
select to_char(sysdate, 'mmdd hh24:mi:ss') as curtime,
       a.sid || ',' || a.serial# as sess,
       a.program,
       a.username,
       to_char(a.logon_time, 'mmdd hh24:mi:ss') as logon_time,
       a.machine || '@' || a.osuser || '@' || a.process as client,
       decode(a.sql_hash_value, 0, a.prev_hash_value, a.sql_hash_value) as hash_value,
       b.event || ':' || b.p1 || ':' || b.p2 as event
  from v$session a, v$session_wait b
 where a.sid = $1
   and a.sid = b.sid;



/*���ݻỰ�鿴sql*/
select sql_text
  from v$sqltext
 where HASH_VALUE =
       (select decode(sql_hash_value, 0, prev_hash_value, sql_hash_value) hash_value_p
          from v$session
         where sid = 76)
 order by piece

/*row_wait_obj#=dba_objects.object_id*/
select sid,row_wait_obj#,sql_hash_value as objid from v$session where sid=$2


select * from dba_objects o where o.object_id=11812596


/*
select name,parameter1,parameter2,parameter3
from v$event_name where name='db file sequential read'
p1:oracleҪ��ȡ�ļ��ľ����ļ���
p2:oracle������ļ��п�ʼ��ȡ����ʼ���ݿ���
p3:��ȡ��BLOCKS������
*/
select sid, event, p1text, p1, p2text, p2, p3text, p3
  from v$session_wait
 where event like 'library%'
 

