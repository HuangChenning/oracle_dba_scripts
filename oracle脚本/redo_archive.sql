/*从v$sysstat视图中得到的是自数据库启动以来的累积日志生成量，
可以根据实例启动时间来大致估算每天数据库的日志生成量
*/
select * from v$sysstat where name='redo size';

/*当log buffer space等待事件出现比较显著的时候，
可以考虑增大log buffer以减少竞争*/
select event#,name from V$event_Name where name='log buffer space';



/*查看归档日志的生成量*/
select * from v$archived_log;

select a.name, a.completion_time, blocks * block_size / 1024 / 1024 Mb
  from v$archived_log a
 where rownum < 11
   and completion_time between trunc(sysdate) - 2 and trunc(sysdate) - 1;
 
 
 /*计算某一天的总归档数*/
select trunc(completion_time), sum(Mb) / 1024 day_gb
  from (select a.name,
               a.completion_time,
               blocks * block_size / 1024 / 1024 Mb
          from v$archived_log a
         where rownum < 11
           and completion_time between trunc(sysdate) - 2 and
               trunc(sysdate) - 1)
 group by trunc(completion_time);
 
 
 /*计算最近日期的日志生成统计*/
 select trunc(completion_time), sum(mb) / 1024 day_gb
   from (select a.name,
                a.completion_time,
                blocks * block_size / 1024 / 1024 Mb
           from v$archived_log a)
  group by trunc(completion_time)


/*
redo size:redo信息的大小
redo wastage：浪费的redo大小
redo blocks written：lgwr写出的redo blocks的数量
额外的信息：每个redo block header需要占用16bytes
*/
select name, value
  from v$sysstat
 where name in ('redo size', 'redo wastage', 'redo blocks written');
 
 
 
 select * from redo_size
