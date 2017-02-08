/*getsqlbysid.sql*/
select sql_text
  from v$sqltext a
 where a.hash_value =
       (select sql_hash_value from v$session b where b.sid = '&sid')
 order by piece asc;
