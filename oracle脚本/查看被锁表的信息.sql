



select * from  V$LOCK;



-----------ͨ��object_name����ȡ�ñ��object_id
select o.object_id from dba_objects o where o.object_name='';

------ͨ��object_id�����Ҹñ��session
select l.OBJECT_ID,l.SESSION_ID from V$locked_Object l where l.OBJECT_ID='';

------ͨ��session_id���õ�Ҫɾ���Ľ���id
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81


-----ɱsession 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';


-----------------------------------------------

select * from v$session s where s.SID=81;
select * from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81
