
--�鿴��ǰ���ݿ�ȴ��¼� waited�Ľű�
select * from 
(select substr(a.event,1,25) waited,substr(b.program,1,25) program ,count(*)
from v$session_wait a,v$session b
where a.sid=b.sid  
and a.WAIT_TIME=0
and a.event not like '%SQL%'
and a.event not like '%message%'
and a.event not like '%time%'
and a.event not like 'PX Deq:%'
and a.event not like 'jobq slave%'
group by substr(a.event,1,25),substr(b.program,1,25)
order by count(*) desc)
where rownum<11 



-----�鿴����ÿ���ȴ������ dbwait�Ľű�
select substr(a.event,1,25) event,substr(b.program,1,39) program ,b.sid||':'||decode(sql_hash_value,0,prev_hash_value,sql_hash_value) sess_sql_hash,b.username
,substr(b.osuser||'@'||b.machine||'@'||b.process||'@'||c.spid,1,31) client,to_char(b.logon_time,'mm-dd hh24:mi') logon_time
from v$session_wait a,v$session b,v$process c
where a.sid=b.sid  and b.paddr=c.addr
and a.event not like '%SQL%'
and a.event not like '%message%'
and a.event not like '%time%'
and a.event not like 'PX Deq:%'
and a.event not like 'jobq slave%'




-----ͨ��hash_value�鿴�����SQL��䣬dbhashsql�Ľű�

select to_char(sysdate, 'yyyymmdd hh24:mi:ss') as curtime,
       hash_value,
       sql_text
  from v$sqltext
 where hash_value = '3534008370'
 order by piece;
 
 
 --ͨ��sid�鿴�ûỰ�����ĸ���������(machine�����������)
select s.MACHINE from 
v$session s where s.SID = 1902
