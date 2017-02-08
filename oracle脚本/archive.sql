---查看归档15分钟最近生成的归档文件

select * from v$archived_log a where a.completion_time > sysdate - 15/1440 

/*
计算归档日志的生产量*/

select name, completion_time, block_size / 1024 / 1024 MB
  from v$archived_log
 where completion_time between trunc(sysdate) - 2 and trunc(sysdate) - 1;
 
/* 
 计算某日全天的日志生产：*/
 
 select trunc(completion_time), sum(Mb) DAY_MB
   from (select name, completion_time, block_size / 1024 / 1024 MB
           from v$archived_log
          where completion_time between trunc(sysdate) - 2 and
                trunc(sysdate) - 1)
  group by trunc(completion_time)


/*
计算最近日期的日志生成统计*/

select trunc(completion_time), sum(mb) day_mb
  from (select name, completion_time, block_size / 1024 / 1024 MB
          from v$archived_log)
 group by trunc(completion_time)
 order by trunc(completion_time)
