/*
          -------------------------------------------------------------
^LWait Events for DB: CENDB  Instance: cen1  Snaps: 46425 -46426
-> s  - second
-> cs - centisecond -     100th of a second
-> ms - millisecond -    1000th of a second
-> us - microsecond - 1000000th of a second
-> ordered by wait time desc, waits desc (idle events last)

urol := SYSDIF('user rollbacks');
ucom := SYSDIF('user commits');
tran := ucom + urol;
*/

declare
  v_b_id            number;
  v_e_id            number;
  v_instance_number number;
  v_dbid            number;
  v_trans           number;
  v_b_date          varchar2(50);
  v_e_date          varchar2(50);
  v_ucom            number;
  v_urol            number;

  cursor mycur(i_b_id            number,
               i_e_id            number,
               i_dbid            number,
               i_instance_number number,
               i_trans           number) is
    select e.event event,
           e.total_waits - nvl(b.total_waits, 0) waits,
           e.total_timeouts - nvl(b.total_timeouts, 0) timeouts,
           round((e.time_waited_micro - nvl(b.time_waited_micro, 0)) /
                 1000000,
                 0) time,
           round(decode((e.total_waits - nvl(b.total_waits, 0)),
                        0,
                        to_number(NULL),
                        ((e.time_waited_micro - nvl(b.time_waited_micro, 0)) / 1000) /
                        (e.total_waits - nvl(b.total_waits, 0))),
                 0) wt,
           round((e.total_waits - nvl(b.total_waits, 0)) / i_trans, 1) txwaits,
           decode(i.event, null, 0, 99) idle
      from stats$system_event b, stats$system_event e, stats$idle_event i
     where b.snap_id(+) = i_b_id
       and e.snap_id = i_e_id
       and b.dbid(+) = i_dbid
       and e.dbid = i_dbid
       and b.instance_number(+) = i_instance_number
       and e.instance_number = i_instance_number
       and b.event(+) = e.event
       and e.total_waits > nvl(b.total_waits, 0)
       and e.event not in ('smon timer',
                           'pmon timer',
                           'dispatcher timer',
                           'dispatcher listen timer')
       and e.event not like 'rdbms ipc%'
       and i.event(+) = e.event
     order by idle, time desc, waits desc;

  function get_date(i_b_snap_id number) return varchar2 is
    v_date varchar2(50);
  begin
    select to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss')
      into v_date
      from stats$snapshot a
     where instance_number = v_instance_number
       and snap_id = i_b_snap_id;
    return v_date;
  end;

  function SYSDIF(i_name varchar2, i_b_snap_id number, i_e_snap_id number)
    RETURN number is
    v_val number;
  begin
    select (b.value - a.value)
      into v_val
      from (select *
              from stats$sysstat
             where name = (i_name)
               and snap_id = i_b_snap_id) a,
           (select *
              from stats$sysstat
             where name = (i_name)
               and snap_id = i_e_snap_id) b
     where a.name = b.name
       and a.instance_number = b.instance_number
       and a.instance_number = v_instance_number;
    return v_val;
  end sysdif;

begin
  v_b_id            := 46425;
  v_e_id            := 46426;
  v_instance_number := 1;
  v_dbid            := 2136217699;

  for i in 1 .. (v_e_id - v_b_id) loop
  
    v_urol  := sysdif('user rollbacks', v_b_id, (v_b_id + 1));
    v_ucom  := sysdif('user commits', v_b_id, (v_b_id + 1));
    v_trans := v_urol + v_ucom;
  
    dbms_output.put_line(get_date(v_b_id) || ' ----> ' ||
                         get_date((v_b_id + 1)) || '  snap: ' || v_b_id ||
                         ' ----->  ' || (v_b_id + 1));
    dbms_output.put_line(' ');
  
    dbms_output.put_line('Event                                          Waits        Timeouts ' ||
                         ' Total Wait Time(s)  ' || 'Avg wait(ms)  ' ||
                         'Waits/txn');
  
    dbms_output.put_line('----------------------------            ------------      ----------          ----------        ------   --------');
    for v_cur in mycur(v_b_id, v_e_id, v_dbid, v_instance_number, v_trans) loop
      dbms_output.put_line(rpad(v_cur.event, 42, ' ') || ' ' ||
                           rpad(v_cur.waits, 20, ' ') || ' ' ||
                           rpad(v_cur.timeouts, 15, ' ') || ' ' ||
                           rpad(v_cur.time, 18, ' ') || ' ' ||
                           rpad(v_cur.wt, 8, ' ') || ' ' ||
                           rpad(v_cur.txwaits, 12, ' '));
      /*  dbms_output.put_line(v_cur.timeouts);*/
    end loop;
  
  end loop;
end;
