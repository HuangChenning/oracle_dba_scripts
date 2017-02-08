select /*+ ORDERED*/ sql_text from v$sqltext a
where (a.hash_value,a.address) in (
select decode(sql_hash_value,
0,prev_hash_value,
sql_hash_value),
decode(sql_hash_value,0,prev_sql_addr,sql_address)
from v$session b
where b.paddr=(select addr
from v$process c
where c.spid= '10527952'))
order by piece ASC

