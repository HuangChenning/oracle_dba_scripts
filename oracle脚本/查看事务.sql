/*
The v$transaction view lists the active transaction in the system

xidusn:Undo segment number

addr=v$session.taddr
*/
select * from v$transaction;


select * from v$session;
/*
���used_urec�ֶβ������ӣ�˵�����������ڼ�����
������ֶβ����½���˵�����������ڻع�
*/

select a.sid, a.username, b.xidusn, b.used_urec, b.used_ublk
  from v$session a, v$transaction b
 where a.saddr = b.ses_addr
   and sid =;



select * from x$ktuxe where ktuxesta !='INACTIVE';



/*�鿴����ع��Ŀ�����
ktuxecfl:Transaction flags
ktuxesta:Transaction Status
*/
select  ADDR,ktuxeusn,ktuxeslt,ktuxesqn,KTUXESIZ from x$ktuxe where ktuxecfl = 'DEAD' and ktuxesta = 'ACTIVE'; 


/*�鿴����ع���ʱ�䣺*/
declare 
i_start number;
i_end number;
begin
  select ktuxesiz into i_start from x$ktuxe where ktuxeusn=785 and ktuxeslt=9;
  dbms_lock.sleep(60);
  select ktuxesiz into i_end from x$ktuxe where ktuxeusn=785 and ktuxeslt=9;
  dbms_output.put_line('time est min(s):'||round(i_end/(i_start - i_end),2)||',or hours'||round(i_end/(i_start - i_end)/60,2));
end;

/*�鿴����ع���ʱ�䣺*/

select f.undoblockstotal "Total",
       f.undoblocksdone "Done",
       f.undoblockstotal - f.undoblocksdone "ToDo",
       decode(cputime,
              0,
              'unknown',
              to_char(sysdate + (((undoblockstotal - undoblocksdone) /
                      (undoblocksdone / cputime)) / 86400),
                      'yyyy-mm-dd hh24:mi:ss')) "Estimated time to complete",
       to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
  from v$fast_start_transactions f;
