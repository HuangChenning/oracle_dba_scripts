------查出hash_value 的值

select decode(sql_hash_value,0,prev_hash_value,sql_hash_value) hash_value_p from v$session where sid=;

----通过hash_value的值来查看该sql语句是什么
select sql_text
from v$sqltext
where HASH_VALUE = 
order by piece
