



select * from  V$LOCK;



-----------通过object_name来获取该表的object_id
select o.object_id from dba_objects o where o.object_name='';

------通过object_id来查找该表的session
select l.OBJECT_ID,l.SESSION_ID from V$locked_Object l where l.OBJECT_ID='';

------通过session_id来得到要删除的进程id
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81


-----杀session 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';


-----------------------------------------------

select * from v$session s where s.SID=81;
select * from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81
