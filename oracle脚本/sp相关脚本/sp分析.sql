-- Current Instance
select d.dbid            dbid
     , d.name            db_name
     , i.instance_number inst_num
     , i.instance_name   inst_name
  from v$database d,
       v$instance i;

---Instances in this Statspack schema
select distinct 
       dbid            dbbid
     , instance_number instt_num
     , db_name         dbb_name
     , instance_name   instt_name
     , host_name       host
  from stats$database_instance;
  
  
---Completed Snapshots
select to_char(s.startup_time, ' dd Mon "at" HH24:mi:ss') instart_fmt,
       di.instance_name inst_name,
       di.db_name db_name,
       s.snap_id snap_id,
       to_char(s.snap_time, 'dd Mon YYYY HH24:mi') snapdat,
       s.snap_level lvl,
       substr(s.ucomment, 1, 60) commnt
  from stats$snapshot s, stats$database_instance di
 where s.dbid = 1441390165                                   ---绑定变量
   and di.dbid = 1441390165                                  ---绑定变量
   and s.instance_number = 1                                 ---绑定变量
   and di.instance_number = 1                                ---绑定变量
   and di.dbid = s.dbid
   and di.instance_number = s.instance_number
   and di.startup_time = s.startup_time
 order by db_name, instance_name, snap_id;
 
 
 
 
 
 ---该sp报告的startup_time
 select parallel       para
     , version        versn
     , host_name      host_name
     , db_name        db_name
     , instance_name  inst_name
     , to_char(snap_time, 'YYYYMMDD HH24:MI:SS')  btime
  from stats$database_instance di
     , stats$snapshot          s
 where s.snap_id          = 730830                           ---绑定变量
   and s.dbid             = 4247935964                       ---绑定变量
   and s.instance_number  = 1                                ---绑定变量
   and di.dbid            = s.dbid
   and di.instance_number = s.instance_number
   and di.startup_time    = s.startup_time;
   
---该sp报告的end_time
 select to_char(snap_time, 'YYYYMMDD HH24:MI:SS')  etime
  from stats$snapshot     s
 where s.snap_id          = 730831                            ---绑定变量
   and s.dbid             = 4247935964                        ---绑定变量
   and s.instance_number  = 1;                                ---绑定变量
   
   


---Top 5 Timed Events和Wait Events for DB 数据主要来自于stats$system_event这张表
select * from stats$system_event
  


---Global Cache Service 数据主要来自于stats$sysstat

select * from stats$sysstat


----Background Wait Events for DB 来自于stats$bg_event_summary


select * from stats$bg_event_summary

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

---SQL ordered by Gets for DB等SQL来自于：
/*from stats$sql_summary e
          , stats$sql_summary b
          , stats$sqltext     st 
      where b.snap_id(+)         = :bid
        and b.dbid(+)            = e.dbid
        and b.instance_number(+) = e.instance_number
        and b.hash_value(+)      = e.hash_value
        and b.address(+)         = e.address
        and b.text_subset(+)     = e.text_subset
        and e.snap_id            = :eid
        and e.dbid               = :dbid
        and e.instance_number    = :inst_num
        and e.hash_value         = st.hash_value 
        and e.text_subset        = st.text_subset
        and st.piece             < &&num_rows_per_hash
        and e.executions         > nvl(b.executions,0)
      order by (e.buffer_gets - nvl(b.buffer_gets,0)) desc, e.hash_value, st.piece*/
      
/*两个快照点之间instance Activity Stats*/      
select a.snap_id begin_snap_id,
       b.snap_id end_snap_id,
       to_char(c.snap_time, 'yyyy-mm-dd hh24:mi:ss') begin_snap_time,
       to_char((c.snap_time + (1 / 24)), 'yyyy-mm-dd hh24:mi:ss') end_snap_time,
       b.name,
       b.value - a.value
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
