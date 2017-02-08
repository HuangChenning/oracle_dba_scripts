/*v$session:数据库当前连接的session信息
v$session_wait:当前数据库连接的活动session正在等待的资源和事件信息
由于v$session记录的是动态信息，和session的生命周期有关，而不记录历史信息，
所有oracle提供另外一个视图v$system_event来记录数据库自启动以来所有等待事件的汇总信息，
通过v$system_event视图，用户可以迅速地获得数据库运行的总体概况。*/

select *
  from v$session_wait
 where event not in (select event from perfstat.stats$idle_event)


/*查看library cache pin*/
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
                  
                  
                  

/*##SESSION:当前实例名:会话ID current waiting event*/
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



/*根据会话查看sql*/
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
p1:oracle要读取文件的绝对文件号
p2:oracle从这个文件中开始读取的起始数据块块号
p3:读取的BLOCKS的数量
*/
select sid, event, p1text, p1, p2text, p2, p3text, p3
  from v$session_wait
 where event like 'library%'
 

