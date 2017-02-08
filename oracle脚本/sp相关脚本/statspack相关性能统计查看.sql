/*Top SQL statements ordered by CPU TIME*/


set pages 200 lines 120
col module for a16
select A.hash_value,
       A.text_subset,
       A.module,
       trunc((B.cpu_time - A.cpu_time) / 1000) "CPU_TIME(ms)",
       B.executions - A.executions executions,
       trunc(decode(B.executions - A.executions,
                    0,
                    0,
                    (B.cpu_time - A.cpu_time) /
                    (B.executions - A.executions)) / 1000) "CPU_TIME_PER_EXEC(ms)"
  from STATS$SQL_SUMMARY A, STATS$SQL_SUMMARY B
 where A.hash_value = B.hash_value
   and A.snap_id = 104719
   and B.snap_id = 104732
 order by "CPU_TIME(ms)" desc;


/*

Top SQL statements ordered by ELAPSED TIME*/


set pages 200 lines 120
col module for a16
select A.hash_value,
       A.text_subset,
       A.module,
       trunc((B.elapsed_time - A.elapsed_time) / 1000) "ELAPSED_TIME(ms)",
       B.executions - A.executions executions,
       trunc(decode(B.executions - A.executions,
                    0,
                    0,
                    (B.elapsed_time - A.elapsed_time) /
                    (B.executions - A.executions)) / 1000) "ELAPSED_TIME_PER_EXEC(ms)"
  from STATS$SQL_SUMMARY A, STATS$SQL_SUMMARY B
 where A.hash_value = B.hash_value
   and A.snap_id = &begin_snap
   and B.snap_id = &end_snap
 order by "ELAPSED_TIME(ms)" desc;

/*查看指定时间段内，消耗各种资源的SQL语句*/
select s.snap_id ,
               s.text_subset ,
               s.hash_value ,
               s.cpu_time ,
               s.elapsed_time,
               s.executions ,
               s.buffer_gets ,
               s.disk_reads,
               s.hash_value,
               s.sharable_mem,
               s.command_type,
               s.parse_calls,
               s.sorts,
               s.module,
               s.version_count,
               s.address
          from perfstat.STATS$SQL_SUMMARY s
         where s.snap_id in
               (select snap_id
                  from perfstat.stats$snapshot
                 where snap_time between
                       to_date('2012-03-09 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and
                       to_date('2012-03-09 02:00:00', 'yyyy-mm-dd hh24:mi:ss')
                   and instance_number = 2)
        /*order by s.elapsed_time desc*/
         order by s.executions desc
  /*order by s.cpu_time desc;*/


select * from perfstat.stats$sql_summary;

select * from perfstat.stats$sqltext t where t.hash_value=2971269793 






select * from perfstat.stats$snapshot where snap_time between
                       to_date('2012-03-07 23:00:00', 'yyyy-mm-dd hh24:mi:ss') and
                       to_date('2012-03-08 01:00:00', 'yyyy-mm-dd hh24:mi:ss')
              and instance_number=2;
