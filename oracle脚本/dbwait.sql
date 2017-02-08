select substr(a.event,1,25) event,substr(b.program,1,39) program ,b.sid||':'||decode(sql_hash_value,0,prev_hash_value,sql_hash_value) sess_sql_hash,b.username
,substr(b.osuser||'@'||b.machine||'@'||b.process||'@'||c.spid,1,31) client,to_char(b.logon_time,'mm-dd hh24:mi') logon_time
from v\$session_wait a,v\$session b,v\$process c
where a.sid=b.sid  and b.paddr=c.addr
and a.event not like '%SQL%'
and a.event not like '%message%'
and a.event not like '%time%'
and a.event not like 'PX Deq:%'
and a.event not like 'jobq slave%'
