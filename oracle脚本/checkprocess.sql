select s.OSUSER from v$session s;

-----����ָ��ϵͳ�û���oracle�е�session��Ϣ������id���������ϵͳ�û�Ϊ��junsansi

select s.sid, s.SERIAL#, s.username, p.spid
  from v$session s, v$process p
 where s.PADDR = p.ADDR 
   and s.osuser = 'junsansi'



----�鿴���͵ȴ�

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
 
 
 
 
 
 /*���µ����������windowsƽ̨��*/
 -----Ҫ��windows����ʾoracle��ؽ���pid
 
SELECT s.SID, p.pid, p.spid signaled, s.osuser, s.program
  FROM v$process p, v$session s
 WHERE p.addr = s.paddr;
 
 
 ------����ͨ����v$bgprocess���Ӳ�ѯ����̨���̵����֣�

SELECTs.SID SID, p.spid threadid, p.program processname, bg.NAMENAME

FROMv$process p, v$session s, v$bgprocess bg

WHEREp.addr = s.paddr

  ANDp.addr = bg.paddr

  ANDbg.paddr <>'00';
