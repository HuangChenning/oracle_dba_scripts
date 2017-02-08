select * from v$rollstat rs where rs.USN=492;



select * from v$rollname rn where rn.usn=492;

select rn.name, rs.USN,rs.RSSIZE
  from v$rollname rn, v$rollstat rs
 where rn.usn = rs.USN
   and rs.USN = 492



select * from v$transaction t where t.XIDUSN=492;

select * from v$session s where s.SADDR='07000020AF191D88';

select * from v$sqltext st where st.HASH_VALUE='1867915783';

select * from v$process p where p.ADDR='07000020AEB75A58';

------------------------查看事务--------

select rn.name,
       rs.usn,
       rs.rssize,
       rs.STATUS,
       t.STATUS,
       s.STATUS,
       s.MACHINE,
       sq.SQL_TEXT,
       s.PROGRAM,
       s.PREV_HASH_VALUE
  from v$rollname    rn,
       v$rollstat    rs,
       v$transaction t,
       v$session     s,
       v$sqltext     sq,
       v$process pr
 where rn.usn = rs.usn
   and t.XIDUSN = rn.usn
   and t.SES_ADDR = s.SADDR
   and sq.HASH_VALUE = s.PREV_HASH_VALUE
   and s.PADDR = pr.ADDR;
   
   
