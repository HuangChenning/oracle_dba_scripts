select module,
       round(CPU_TIME / 1000000,0) CPU_TIME,
       round(sum(CPU_TIME) over() / 1000000,0) TOTAL_CPU_TIME,
       round(CPU_TIME / sum(CPU_TIME) over() * 100, 0) perf
  from (
  select  b.module ,b.cpu_time - nvl(a.cpu_time,0) cpu_time from 
  (select /*+PARALLEL(a,48) parallel(b,48)*/
         substr(nvl(b.module,'Null'),
                1,
                (case when instr(nvl(b.module,'Null'), '@') - 1 > 0 then instr(nvl(b.module,'Null'), '@') - 1 else length(nvl(b.module,'Null')) end)) module,
                 sum(B.CPU_TIME) cpu_time
                 from  perfstat.stats$sql_summary b
                 where b.snap_id = &end_snapid and
                       b.cpu_time >0               
                 group by  substr(nvl(b.module,'Null'),
                         1,
                         (case
                           when instr(nvl(b.module,'Null'), '@') - 1 > 0 then
                            instr(nvl(b.module,'Null'), '@') - 1
                           else
                            length(nvl(b.module,'Null'))
                         end))) b,
                         (select /*+PARALLEL(a,48) parallel(b,48)*/
         substr(nvl(a.module,'Null'),
                1,
                (case when instr(nvl(a.module,'Null'), '@') - 1 > 0 then instr(nvl(a.module,'Null'), '@') - 1 else length(nvl(a.module,'Null')) end)) module,
                 sum(a.CPU_TIME) cpu_time
                 from  perfstat.stats$sql_summary a
                 where a.snap_id =  &end_snapid -1 and
                       a.cpu_time>0
                 group by  substr(nvl(a.module,'Null'),
                         1,
                         (case
                           when instr(nvl(a.module,'Null'), '@') - 1 > 0 then
                            instr(nvl(a.module,'Null'), '@') - 1
                           else
                            length(nvl(a.module,'Null'))
                         end))) a
         where 
           b.module = a.module (+)
           and b.cpu_time > a.cpu_time
      )
 order by 4 desc;
