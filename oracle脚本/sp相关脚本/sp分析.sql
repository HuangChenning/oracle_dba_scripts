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
 where s.dbid = 1441390165                                   ---�󶨱���
   and di.dbid = 1441390165                                  ---�󶨱���
   and s.instance_number = 1                                 ---�󶨱���
   and di.instance_number = 1                                ---�󶨱���
   and di.dbid = s.dbid
   and di.instance_number = s.instance_number
   and di.startup_time = s.startup_time
 order by db_name, instance_name, snap_id;
 
 
 
 
 
 ---��sp�����startup_time
 select parallel       para
     , version        versn
     , host_name      host_name
     , db_name        db_name
     , instance_name  inst_name
     , to_char(snap_time, 'YYYYMMDD HH24:MI:SS')  btime
  from stats$database_instance di
     , stats$snapshot          s
 where s.snap_id          = 730830                           ---�󶨱���
   and s.dbid             = 4247935964                       ---�󶨱���
   and s.instance_number  = 1                                ---�󶨱���
   and di.dbid            = s.dbid
   and di.instance_number = s.instance_number
   and di.startup_time    = s.startup_time;
   
---��sp�����end_time
 select to_char(snap_time, 'YYYYMMDD HH24:MI:SS')  etime
  from stats$snapshot     s
 where s.snap_id          = 730831                            ---�󶨱���
   and s.dbid             = 4247935964                        ---�󶨱���
   and s.instance_number  = 1;                                ---�󶨱���
   
   


---Top 5 Timed Events��Wait Events for DB ������Ҫ������stats$system_event���ű�
select * from stats$system_event
  


---Global Cache Service ������Ҫ������stats$sysstat

select * from stats$sysstat


----Background Wait Events for DB ������stats$bg_event_summary


select * from stats$bg_event_summary

select a.snap_id,
       dbid,
       instance_number,
       to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss')
  from stats$snapshot a
 where instance_number = 1
 order by snap_id desc


/*����ڵ���Elapsed time*/   
select round(((e.snap_time - b.snap_time) * 1440 * 60), 0)
  from stats$snapshot b, stats$snapshot e
 where e.snap_id = 46426
   and b.snap_id = 46425
   and e.instance_number = b.instance_number
   and e.instance_Number = 1

/*����ڵ���trans*/
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



/*�����sp������ָ�����ռ�instance activity stats
�������յ�֮��user calls��user commits�ı�ֵ
user calls/user commits�ı�ֵ���С��30�Ļ���˵��commit�ύ����Ƶ��
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

---SQL ordered by Gets for DB��SQL�����ڣ�
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
      
/*�������յ�֮��instance Activity Stats*/      
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
