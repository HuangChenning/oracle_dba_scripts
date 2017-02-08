SELECT s.username,
       s.sid,
       pr.PID,
       s.OSUSER,
       s.MACHINE,
       s.PROGRAM,
       rs.segment_id,
       r.usn,
       rs.segment_name,      
       r.rssize/1024/1024,
       sq.sql_text
  FROM v$transaction t, v$session s, v$rollstat r, dba_rollback_segs rs ,v$sqltext  sq,v$process pr
WHERE s.saddr = t.ses_addr
   AND t.xidusn = r.usn 
   AND rs.segment_id = t.xidusn
   AND s.sql_address=sq.address
   AND s.sql_hash_value = sq.hash_value
   AND s.PADDR=pr.ADDR
ORDER BY t.used_ublk DESC ,sq.PIECE;
