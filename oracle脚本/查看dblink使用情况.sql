----�鿴dblink----
select owner,db_link,username,host,to_char(created,'yyyy-mm-dd') 
from dba_db_links
order by created;




--------�鿴dblinkʹ�ô���

  select machine||'->offondb' as conname,count(*) conns from v$session
  where machine not like 'as%'
  group by machine
  having count(*) >100
  order by  conns desc;
