--�鿴�������������ctime���������ס����Դ��ʱ��
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
 
 
 --ָ��sid��鿴Ҫɾ���Ľ��̺ţ�Ȼ����������ͨ��kill -9 spid��kill����Ự
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 3379

--ͨ��sid�鿴�ûỰ�����ĸ���������(machine�����������)
select s.MACHINE from 
v$session s where s.SID = 3260

--�鿴sql,ͨ��ָ��hash_value���鿴
 
select se.sql_hash_value from v$session se where se.SID = '3517';

select s.sql_text from v$sql s where hash_value='32702474';
 

select sql_text from v$sql s where S.HASH_VALUE = (select SE.SQL_HASH_VALUE from v$session se
where SE.SID = '3260');



--------����sessionID�鿴�ûỰ�ڵȴ�ʲô
select w.EVENT from v$session_wait w where w.SID='4189';


select * from v$session;


-----ɱsession 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';






-----��ȡ�ֵ���Ƿ�����
select s.sid, p.spid,s.PROGRAM,s.SQL_HASH_VALUE
from x$kqrfp x1, x$kqrfp x2, v$session s, v$process p
where x1.kqrfpses = x2.kqrfpses
and x1.kqrfpmod = 0
and x2.kqrfpreq = 3
and x1.kqrfpadd = x2.kqrfpadd 
and s.saddr = x1.kqrfpses
and s.paddr = p.addr;



-----------ͨ��object_name����ȡ�ñ��object_id
select o.object_id from dba_objects o where o.object_name='';

------ͨ��object_id�����Ҹñ��session
select l.OBJECT_ID,l.SESSION_ID from V$locked_Object l where l.OBJECT_ID='';

------ͨ��session_id���õ�Ҫɾ���Ľ���id
select p.SPID from v$process p ,v$session s where p.ADDR = s.PADDR and s.SID = 81


-----ɱsession 
------alter system kill session 'sid,serial#';
alter system kill session '81,31212';
 
