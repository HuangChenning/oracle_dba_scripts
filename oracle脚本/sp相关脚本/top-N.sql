/* 
twt:= TOTAL_EVENT_TIME 
Returns the total amount of time waited for events for
         the interval specified by the begin and end snapshot id's
         (bid, eid) by foreground processes.  This excludes idle
         wait events.
*/

   
select sum(time_waited_micro)
  from stats$system_event
 where snap_id = 46420
   and dbid = 2136217699
   and instance_number = 1
   and event not in (select event from stats$idle_event);
--- select 14888924874411 - 14833559916430 from dual;   55364957981

/*tcpu := SYSDIF('CPU used by this session');

select (b.value - a.value)
      from (select *
              from stats$sysstat
             where name = 'CPU used by this session'
               and snap_id = 46425) a,
           (select *
              from stats$sysstat
             where name = 'CPU used by this session'
               and snap_id = 46426) b
     where a.name = b.name
       and a.instance_number = b.instance_number
       and a.instance_number = 1;
       
       ---3841011
*/

         
select event, waits, time, pctwtt
  from (select event, waits, time, pctwtt
          from (select e.event event,
                       e.total_waits - nvl(b.total_waits, 0) waits,
                       round((e.time_waited_micro -
                             nvl(b.time_waited_micro, 0)) / 1000000,
                             0) time,
                       round(decode(55364957981 + 3841011 * 10000,
                                    0,
                                    0,
                                    100 * (e.time_waited_micro -
                                    nvl(b.time_waited_micro, 0)) /
                                    (55364957981 + 3841011 * 10000)),
                             2) pctwtt
                  from stats$system_event b, stats$system_event e
                 where b.snap_id(+) = 46425
                   and e.snap_id = 46426
                   and b.dbid(+) = 2136217699
                   and e.dbid = 2136217699
                   and b.instance_number(+) = 1
                   and e.instance_number = 1
                   and b.event(+) = e.event
                   and e.total_waits > nvl(b.total_waits, 0)
                   and e.event not in (select event from stats$idle_event)
                union all
                select 'CPU time' event,
                       to_number(null) waits,
                       round(3841011 / 100, 0) time,
                       round(decode(55364957981 + 3841011 * 10000,
                                    0,
                                    0,
                                    100 * 3841011 * 10000 /
                                    (55364957981 + 3841011 * 10000)),
                             2) pctwait
                  from dual
                 where 3841011 > 0)
         order by time desc, waits desc)
where rownum <= 5

