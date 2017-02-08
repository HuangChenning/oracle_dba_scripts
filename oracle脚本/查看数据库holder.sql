--查看锁表情况，其中ctime代表的是锁住该资源的时间
SELECT DECODE(REQUEST, 0, 'Holder: ', 'Waiter: ') || SID SESS,
       ID1,
       ID2,
       LMODE,
       REQUEST,
       TYPE,
       a.CTIME
  FROM V$LOCK a
 WHERE (ID1, ID2, TYPE) IN
       (SELECT ID1, ID2, TYPE FROM V$LOCK WHERE REQUEST > 0) AND CTIME>50
 ORDER BY ID1, REQUEST;
 
 
 --指定sid后查看要删除的进程号，然后在主机上通过kill -9 spid来kill这个会话
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 3379

--通过sid查看该会话是由哪个主机发起(machine代表发起的主机)
select s.MACHINE from 
v$session s where s.SID = 3260

--查看sql,通过指定hash_value来查看
 
select se.sql_hash_value from v$session se where se.SID = '3517';

select s.sql_text from v$sql s where hash_value='32702474';
 

select sql_text from v$sql s where S.HASH_VALUE = (select SE.SQL_HASH_VALUE from v$session se
where SE.SID = '3260');



--------根据sessionID查看该会话在等待什么
select w.EVENT from v$session_wait w where w.SID='4189';


select * from v$session;


-----杀session 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';






-----获取字典表是否锁表
select s.sid, p.spid,s.PROGRAM,s.SQL_HASH_VALUE
from x$kqrfp x1, x$kqrfp x2, v$session s, v$process p
where x1.kqrfpses = x2.kqrfpses
and x1.kqrfpmod = 0
and x2.kqrfpreq = 3
and x1.kqrfpadd = x2.kqrfpadd 
and s.saddr = x1.kqrfpses
and s.paddr = p.addr;



-----------通过object_name来获取该表的object_id
select o.object_id from dba_objects o where o.object_name='';

------通过object_id来查找该表的session
select l.OBJECT_ID,l.SESSION_ID from V$locked_Object l where l.OBJECT_ID='';

------通过session_id来得到要删除的进程id
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81


-----杀session 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';
 
