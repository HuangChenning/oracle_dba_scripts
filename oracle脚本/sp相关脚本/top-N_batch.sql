/*
显示连续的几个快照点之间的top-n event
可以根据v_rownum的大小来控制显示排名前几的等待事件

Sat May 12 18:55:40 BEIST 2012
Written By: huangcn
*/

declare
  v_b_id            number;
  v_e_id            number;
  v_instance_number number;
  v_dbid            number;
  v_twt             number;
  v_tcpu            number;
  v_rownum          number;

  cursor mycur(i_b_id            number,
               i_e_id            number,
               i_dbid            number,
               i_instance_number number,
               i_twt             number,
               i_tcpu            number,
               i_rownum          number) is
    select event, waits, time, pctwtt
      from (select event, waits, time, pctwtt
              from (select e.event event,
                           e.total_waits - nvl(b.total_waits, 0) waits,
                           round((e.time_waited_micro -
                                 nvl(b.time_waited_micro, 0)) / 1000000,
                                 0) time,
                           round(decode(i_twt + i_tcpu * 10000,
                                        0,
                                        0,
                                        100 * (e.time_waited_micro -
                                        nvl(b.time_waited_micro, 0)) /
                                        (i_twt + i_tcpu * 10000)),
                                 2) pctwtt
                      from stats$system_event b, stats$system_event e
                     where b.snap_id(+) = i_b_id
                       and e.snap_id = (i_e_id)
                       and b.dbid(+) = i_dbid
                       and e.dbid = i_dbid
                       and b.instance_number(+) = i_instance_number
                       and e.instance_number = i_instance_number
                       and b.event(+) = e.event
                       and e.total_waits > nvl(b.total_waits, 0)
                       and e.event not in
                           (select event from stats$idle_event)
                    union all
                    select 'CPU time' event,
                           to_number(null) waits,
                           round(v_tcpu / 100, 0) time,
                           round(decode(i_twt + i_tcpu * 10000,
                                        0,
                                        0,
                                        100 * i_tcpu * 10000 /
                                        (i_twt + i_tcpu * 10000)),
                                 2) pctwait
                      from dual
                     where v_tcpu > 0)
             order by time desc, waits desc)
     where rownum <= i_rownum;

  function get_date(i_b_snap_id number) return varchar2 is
    v_date varchar2(50);
  begin
    select to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss')
      into v_date
      from stats$snapshot a
     where instance_number = v_instance_number
       and snap_id = i_b_snap_id;
    return v_date;
  end get_date;

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

  function TOTAL_EVENT_TIME(i_b_snap_id number, i_e_snap_id number)
    return number is
    bwaittime number;
    ewaittime number;
  
    cursor WAITS(i_snap_id number) is
      select sum(time_waited_micro)
        from stats$system_event
       where snap_id = i_snap_id
         and dbid = v_dbid
         and instance_number = v_instance_number
         and event not in (select event from stats$idle_event);
  begin
    if not WAITS%ISOPEN then
      open WAITS(i_b_snap_id);
    end if;
    fetch WAITS
      into bwaittime;
    if WAITS%NOTFOUND then
      raise_application_error(-20100,
                              'Missing start value for stats$system_event');
    end if;
    close WAITS;
  
    if not WAITS%ISOPEN then
      open WAITS(i_e_snap_id);
    end if;
    fetch WAITS
      into ewaittime;
    if WAITS%NOTFOUND then
      raise_application_error(-20100,
                              'Missing end value for stats$system_event');
    end if;
    close WAITS;
  
    return ewaittime - bwaittime;
  
  end TOTAL_EVENT_TIME;

begin
  /*
  初始化
  v_b_id      ：开始的snap_id
  v_e_id      ：结束的snap_id
  v_dbid      
  v_instance_number
  v_rownum
     
  以上变量可以从这条SQL获取
  
  select *
     from stats$snapshot
  */
  v_b_id            := 46450;
  v_e_id            := 46456;
  v_dbid            := 2136217699;
  v_instance_number := 1;
  v_rownum          := 5;

  for i in 1 .. (v_e_id - v_b_id) loop
    v_twt  := TOTAL_EVENT_TIME(v_b_id, (v_b_id + 1));
    v_tcpu := SYSDIF('CPU used by this session', v_b_id, (v_b_id + 1));
  
    dbms_output.put_line('Top 5 Timed Events  ' || get_date(v_b_id) ||
                         ' ----> ' || get_date((v_b_id + 1)) || '  snap: ' ||
                         v_b_id || ' ----->  ' || (v_b_id + 1));
    dbms_output.put_line('~~~~~~~~~~~~~~~~~~');
  
    dbms_output.put_line('Event                                               Waits    Time (s)' ||
                         ' Total Ela Time %');
  
    for v_re in mycur(v_b_id,
                      (v_b_id + 1),
                      v_dbid,
                      v_instance_number,
                      v_twt,
                      v_tcpu,
                      v_rownum) loop
    
      dbms_output.put_line(RPad(v_re.event, 52, ' ') ||
                           rpad(nvl(to_char(v_re.waits), ' '), 10, ' ') ||
                           rpad(v_re.time, 10, ' ') ||
                           rpad(v_re.pctwtt, 8, ' '));
    end loop;
  
    dbms_output.put_line(' ');
    v_b_id := v_b_id + 1;
  
  end loop;
end;
