/*ͨ��oracle �Ựsid����killָ��*/
select 'kill -9 '||b.spid
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and a.sid=4925



/*ͨ��OS���̺ţ�����kill oracle �Ự��ָ��*/
select 'alter system kill session '''||a.sid||','||a.serial#||''''
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and b.spid=13038824;



select 'alter system kill session '''||a.sid||','||a.serial#||''''
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and a.sid=11515;


alter system kill session '2996,28602';

/* 
��RAC �����£����ǻ��������﷨��ָ��INST_ID. ���ֵ���Դ�gv$session �л�ȡ��

SQL> ALTERSYSTEM KILL SESSION 'sid,serial#,@inst_id';

Kill session ����ʵ�ʲ���kill session�� �������Ҫ��session �Լ�kill �Լ��� 
����ǰ����£�����ȴ�Զ�����ݿ�ķ�Ӧ���߻ع�������ôsession �Ͳ�������kill �Լ���
�����ȴ���ǰ�Ĳ�����������ִ�С� ����������£�session �ͻᱻ���Ϊkilled ״̬�� ���ᾡ�챻kill��

���ǿ�����kill ���������immediate���﷨���£�
alter system kill session '2996,28602' immediate;

�����ڲ���֮ǰ��Ҫ��ȷ��session �Ƿ���ִ��rollback ������ ����ʹ������SQL ��ȷ�ϡ�

 

SET LINESIZE 200
COLUMN username FORMAT A15
SELECT s.username,
      s.sid,
      s.serial#,
      t.used_ublk,
      t.used_urec,
      rs.segment_name,
      r.rssize,
      r.status
FROM  v$transaction t,
      v$session s,
      v$rollstat r,
      dba_rollback_segs rs
WHERE s.saddr = t.ses_addr
AND   t.xidusn = r.usn
AND   rs.segment_id = t.xidusn
ORDER BY t.used_ublk DESC;

��������ǵ�session����ô��Ҫ��rollback ����ɣ�Ȼ������ڲ���ϵͳ����kill session��





 Alter system disconnect session ��һ����ѡ��kill session �ķ����� 
 ��kill session ���ͬ��disconnect session �����kill �� dedicated server process, 
 �������ͬ���ڲ���ϵͳ����kill ��server process��


�����﷨���£�

SQL> ALTER SYSTEM DISCONNECT SESSION'sid,serial#' POST_TRANSACTION;
SQL> ALTER SYSTEM DISCONNECT SESSION'sid,serial#' IMMEDIATE;


POST_TRANSACTION ѡ���ȴ��������֮���ڶϿ����ӡ�
IMMEDIATE ѡ��������Ͽ����ӣ�Ȼ����������recover������

��2��ѡ��Ҳ����һ��ʹ�ã����Ǳ���ָ������һ��������ͻᱨ��

SQL> alter system disconnect session'30,7';
alter system disconnect session '30,7'
                                     *
ERROR at line 1:
ORA-02000: missing POST_TRANSACTION orIMMEDIATE keyword
SQL>

 

SQL> alter system disconnect session'15,12' post_transaction immediate;
System altered.

ʹ��alter system disconnectsession ����Ͳ���Ҫ�л���ϵͳ��kill session��Ҳ�Ӷ�������kill ����̵ļ��ʡ�

*/
