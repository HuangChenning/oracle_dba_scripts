set linesize 120
col operation format a55
col cost format 99999
col kbytes format 999999
col object format a25

select hash_value,
       child_number,
       lpad(' ', 2 * depth) || operation || ' ' || options ||
       decode(id, 0, substr(optimizer, 1, 6) || 'Cost=' || to_char(cost)) operation,
       object_name object,
       cost,
       round(bytes / 1024) kbytes
  from v$sql_plan
 where hash_value in (select a.sql_hash_value
                        from v$session a, v$session_wait b
                       where a.sid = b.sid
                         and b.event = '&waitevent')
 order by hash_value, child_number, id;

/*根据hash_sql查看SQL的执行计划*/

select hash_value,
       child_number,
       lpad(' ', 2 * depth) || operation || ' ' || options ||
       decode(id, 0, substr(optimizer, 1, 6) || 'Cost=' || to_char(cost)) operation,
       object_name object,
       cost,
       round(bytes / 1024) kbytes
  from v$sql_plan
 where hash_value = '1939865600'
  order by hash_value, child_number, id;



/*查看当前library cache中全表扫描的SQL*/

select sql_text from v$sqltext t,v$sql_plan p
where t.hash_value=p.hash_value
and p.operation='TABLE ACCESS'
and p.options='FULL'
ORDER BY p.hash_value,t.piece;


