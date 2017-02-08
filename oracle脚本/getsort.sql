select /*+ rule*/
distinct a.sid,
         a.process,
         a.serial#,
         to_char(a.logon_time, 'yyyymmdd hh24:mi:ss') logon,
         a.osuser,
         tablespace,
         b.sql_text
  from v$session a, v$sql b, v$sort_usage c
 where a.sql_address = b.address(+)
   and a.sql_address = c.sqladdr;
