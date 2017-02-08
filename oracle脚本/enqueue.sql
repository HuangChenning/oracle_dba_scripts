/*9i,enqueue,ORACLE锁争用 查看争用类型*/
select sid,
       event,
       p1,
       p1raw,
       chr(bitand(P1, -16777216) / 16777215) ||
       chr(bitand(P1, 16711680) / 65535) type,
       mod(P1, 16) "MODE"
  from v$session_wait
 where event = 'enqueue';


/*9i中使用*/
SELECT sid,
       CHR(BITAND(p1, -16777216) / 16777215) ||
       CHR(BITAND(p1, 16711680) / 65535) enq,
       DECODE(CHR(BITAND(p1, -16777216) / 16777215) ||
              CHR(BITAND(p1, 16711680) / 65535),
              'TX',
              'Transaction (RBS)',
              'TM',
              'DML Transaction',
              'TS',
              'Tablespace and Temp Seg',
              'TT',
              'Temporary Table',
              'ST',
              'Space Mgt (e.g., uet$, fet$)',
              'UL',
              'User Defined',
              CHR(BITAND(p1, -16777216) / 16777215) ||
              CHR(BITAND(p1, 16711680) / 65535)) enqueue_name,
       DECODE(BITAND(p1, 65535),
              1,
              'Null',
              2,
              'Sub-Share',
              3,
              'Sub-Exclusive',
              4,
              'Share',
              5,
              'Share/Sub-Exclusive',
              6,
              'Exclusive',
              'Other') lock_mode
  FROM v$session_wait
 WHERE event = 'enqueue' and 
 sid = 96;
 
 

