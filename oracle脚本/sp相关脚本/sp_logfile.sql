/*In the AWR or Statspack report, if  the  user calls/user commits (average user calls per commit)  
is less than 30, then  commits are happening too frequently: */


declare
  v_b_id             number;
  v_e_id             number;
  v_usercalls        number;
  v_usercommits      number;
  v_aver_call_commit number;
  v_ela_time         number;
  v_instance_number  number;
  v_trans            number;
  v_b_date           varchar2(50);
  v_e_date           varchar2(50);
  --v_ucom number;
  v_urol number;
  
  function get_date (i_b_snap_id number) return varchar2 is
    v_date varchar2(50);
  begin
    select to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss') into v_date
    from stats$snapshot a
    where instance_number = v_instance_number
    and snap_id=i_b_snap_id;
    return v_date;
  end;
  
  
  function SYSDIF(i_name varchar2,i_b_snap_id number,i_e_snap_id number) RETURN number is
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
  v_b_id            := 46450;
  v_e_id            := 46456;
  v_instance_number := 1;


  dbms_output.put_line('Statistic                                      Total     per Second    per Trans');
  dbms_output.put_line('--------------------------------- ------------------ -------------- ------------');
 
  for i in 1 .. (v_e_id - v_b_id) loop
 /*计算节点间的Elapsed time*/
  select round(((e.snap_time - b.snap_time) * 1440 * 60), 0)
    into v_ela_time
    from stats$snapshot b, stats$snapshot e
   where e.snap_id = (v_b_id+1)
     and b.snap_id = v_b_id
     and e.instance_number = b.instance_number
     and e.instance_Number = v_instance_number;

  /*计算节点间的trans*/
  v_urol        := sysdif('user rollbacks',v_b_id,(v_b_id+1));
  v_usercalls   := sysdif('user calls',v_b_id,(v_b_id+1));
  v_usercommits := sysdif('user commits',v_b_id,(v_b_id+1));
  v_trans       := v_urol + v_usercommits;


  dbms_output.put_line('times: '||get_date(v_b_id)||'  --------->  '||get_date(v_e_id));
  
  
  /*user calls*/
  dbms_output.put_line('user calls                       ' ||
                       '           ' || v_usercalls || '        ' ||
                       round((v_usercalls) / v_ela_time, 1) || '        ' ||
                       round((v_usercalls) / v_trans, 1));
  /*user commits*/
  dbms_output.put_line('user commits                       ' ||
                       '           ' || v_usercalls || '        ' ||
                       round((v_usercommits) / v_ela_time, 1) ||
                       '        ' || round((v_usercommits) / v_trans, 1));
  /*user calls/user commits*/
  dbms_output.put_line('user calls/user commits : ' ||
                       round(round((v_usercalls) / v_trans, 1) /
                             round((v_usercommits) / v_trans, 1),
                             1));
                             
  dbms_output.put_line('');   
  
  v_b_id :=v_b_id+1;                  
  
  end loop;
  
    exception when no_data_found then
      dbms_output.put_line('snapshot is not exist');
 
end;
