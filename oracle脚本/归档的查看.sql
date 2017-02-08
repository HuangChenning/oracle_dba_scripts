select trunc(sum(blocks*block_size)/1024/1024) "MB" 
  from v$archived_log a
 where a.completion_time between
       to_date('2012-03-09 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and
       to_date('2012-03-09 01:00:00', 'yyyy-mm-dd hh24:mi:ss');




select name, completion_time from v$archived_log where name like '%%';
