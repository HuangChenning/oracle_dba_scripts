select 'alter system kill session ''' || s.sid || ',' || s.serial# || ''';' kill_session,
   decode(l.LOCKED_MODE,0,'none',1,'null',2,'行共享',3,'行独占',4,'共享锁',5,'共享行独占',6,'独占(X)') lock_mode,
   p.SPID,s.MACHINE,s.program,s.username ,'kill -9 '||p.spid kill_spid
  from v$session s, dba_objects o, v$locked_object l, v$process p
 where o.object_id = l.object_id
   and s.sid = l.session_id
   and s.paddr = p.addr
 --  and s.username = 'UserName'
;   



select * from v$locked_object;


select * from dba_objects where object_id='3190742';
