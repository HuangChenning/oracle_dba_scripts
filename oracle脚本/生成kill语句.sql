/*通过oracle 会话sid生成kill指令*/
select 'kill -9 '||b.spid
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and a.sid=4925



/*通过OS进程号，生成kill oracle 会话的指令*/
select 'alter system kill session '''||a.sid||','||a.serial#||''''
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and b.spid=13038824;



select 'alter system kill session '''||a.sid||','||a.serial#||''''
from v$session a ,v$process b
where a.paddr=b.addr and a.type!='BACKGROUND' and a.sid=11515;


alter system kill session '2996,28602';

/* 
在RAC 环境下，我们还可以在语法中指定INST_ID. 这个值可以从gv$session 中获取：

SQL> ALTERSYSTEM KILL SESSION 'sid,serial#,@inst_id';

Kill session 命令实际不会kill session。 该命令仅要求session 自己kill 自己。 
在以前情况下，比如等待远程数据库的反应或者回滚事务，那么session 就不会立即kill 自己，
其必须等待当前的操作结束才能执行。 在这种情况下，session 就会被标记为killed 状态。 它会尽快被kill。

我们可以在kill 命令中添加immediate，语法如下：
alter system kill session '2996,28602' immediate;

不过在操作之前，要先确认session 是否在执行rollback 操作。 可以使用如下SQL 来确认。

 

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

如果有我们的session，那么就要等rollback 先完成，然后才能在操作系统级别kill session。





 Alter system disconnect session 是一个可选的kill session 的方法。 
 与kill session 命令不同，disconnect session 命令会kill 掉 dedicated server process, 
 该命令等同于在操作系统级别kill 掉server process。


具体语法如下：

SQL> ALTER SYSTEM DISCONNECT SESSION'sid,serial#' POST_TRANSACTION;
SQL> ALTER SYSTEM DISCONNECT SESSION'sid,serial#' IMMEDIATE;


POST_TRANSACTION 选项会等待事务完成之后在断开连接。
IMMEDIATE 选项会立即断开连接，然后事务会进行recover操作。

这2个选项也可以一起使用，但是必须指定其中一个，否则就会报错：

SQL> alter system disconnect session'30,7';
alter system disconnect session '30,7'
                                     *
ERROR at line 1:
ORA-02000: missing POST_TRANSACTION orIMMEDIATE keyword
SQL>

 

SQL> alter system disconnect session'15,12' post_transaction immediate;
System altered.

使用alter system disconnectsession 命令就不需要切换到系统来kill session，也从而减少了kill 错进程的几率。

*/
