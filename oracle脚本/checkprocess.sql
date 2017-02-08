select s.OSUSER from v$session s;

-----查找指定系统用户在oracle中的session信息及进程id，假设操作系统用户为：junsansi

select s.sid, s.SERIAL#, s.username, p.spid
  from v$session s, v$process p
 where s.PADDR = p.ADDR 
   and s.osuser = 'junsansi'



----查看锁和等待

SELECT /*+ rule */
 lpad(' ', decode(l.xidusn, 0, 3, 0)) || l.oracle_username User_name,
 o.owner,
 o.object_name,
 o.object_type,
 s.sid,
 s.serial#,
 p.spid
  FROM v$locked_object l, dba_objects o, v$session s, v$process p
 WHERE l.object_id = o.object_id
   AND l.session_id = s.sid and s.paddr = p.addr
 ORDER BY o.object_id, xidusn DESC
 
 
 
 
 
 /*以下的语句是用于windows平台的*/
 -----要在windows中显示oracle相关进程pid
 
SELECT s.SID, p.pid, p.spid signaled, s.osuser, s.program
  FROM v$process p, v$session s
 WHERE p.addr = s.paddr;
 
 
 ------可以通过和v$bgprocess连接查询到后台进程的名字：

SELECTs.SID SID, p.spid threadid, p.program processname, bg.NAMENAME

FROMv$process p, v$session s, v$bgprocess bg

WHEREp.addr = s.paddr

  ANDp.addr = bg.paddr

  ANDbg.paddr <>'00';
