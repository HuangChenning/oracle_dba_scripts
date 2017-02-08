select a.snap_id,
       dbid,
       instance_number,
       to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss')
  from stats$snapshot a
 where instance_number = 1
 order by snap_id desc

/*计算节点间的Elapsed time*/   
select round(((e.snap_time - b.snap_time) * 1440 * 60), 0)
  from stats$snapshot b, stats$snapshot e
 where e.snap_id = 46426
   and b.snap_id = 46425
   and e.instance_number = b.instance_number
   and e.instance_Number = 1

/*计算节点间的trans*/
select b.name,
       (b.value - a.value) total
  from (select *
          from stats$sysstat
         where name in ('user rollbacks', 'user commits')
           and snap_id = 46425) a,
       (select *
          from stats$sysstat
         where name in ('user rollbacks', 'user commits')
           and snap_id = 46426) b
 where a.name = b.name
 and a.instance_number=b.instance_number
 and a.instance_number=1
 
 
 select 229607+216189 from dual;  --445796



/*计算出sp报告中指定快照间instance activity stats
两个快照点之间user calls与user commits的比值
user calls/user commits的比值如果小于30的话，说明commit提交过于频繁
*/      
select a.snap_id begin_snap_id,
       b.snap_id end_snap_id,
       to_char(c.snap_time, 'yyyy-mm-dd hh24:mi:ss') begin_snap_time,
       to_char((c.snap_time + (1 / 24)), 'yyyy-mm-dd hh24:mi:ss') end_snap_time,
       b.name,
       (b.value - a.value) total,
       round((b.value - a.value)/3599,1) "per Second",
       round((b.value - a.value)/445796,1) "per Trans"
  from (select *
          from stats$sysstat
         where name in ('user calls', 'user commits')
           and snap_id = 46425) a,
       (select *
          from stats$sysstat
         where name in ('user calls', 'user commits')
           and snap_id = 46426) b,
       stats$snapshot c
 where a.name = b.name
   and a.snap_id = c.snap_id
 
 
 

