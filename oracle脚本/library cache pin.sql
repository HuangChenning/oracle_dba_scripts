/*V$ACCESS displaysinformation about locks that 
are currently imposed on library cache objects.
The locks are imposed to ensure that they are 
not aged out of the library cachewhile they are required for SQL execution.*/

select * from v$access;

/*
library cache pin通常是发生在编译或重新编译PL/SQL，view，types等object时。
在处理因“library cache pin”引起的性能变慢或挂起时，应检查object无效方面的原因。
通过object的'last_ddl'属性可看到这些变化。

object变得无效时，oracle会在第一次访问此object时试图去重新编译它，如果此时其他session
已经把此object pin到library cache中，就会出现问题，特别是有大量活动session并且存在较复杂
的dependence时
*/

-----------方法一：
/*
查看library cache的会话，其中PnRAW为16进制,seq#代表等待的次数(等待3秒就代表超时)
p1列是Library Cache Handle Address
*/
select * from v$session_wait where event like 'library cache%';

select sid,seq#,event,p1,p1raw,p2,p2raw,state from v$session_wait where event like 'library cache%';

/*
x$kglpn：X$KGLPN -- [K]ernel [G]eneric [L]ibrary Cache Manager object [p]i[N]s
它是与x$kgllk相对应的表，是关于pin的相关信息，它主要用于解决library cache pin
v$session_wait中的p1_raw与x$kglpn中的kglpnhdl关联

其中
desc x$kglpn
 Name       
 -----------
 ADDR       
 INDX       
 INST_ID    
 KGLPNADR   
 KGLPNUSE   会话地址(对应v$session的saddr)
 KGLPNSES   owner地址
 KGLPNHDL   句柄
 KGLPNLCK   
 KGLPNCNT   
 KGLPNMOD   持有pin的模式(0为no lock/pin held,1为null，2为share，3为exclusive)
 KGLPNREQ   请求pin的模式(0为no lock/pin held,1为null，2为share，3为exclusive)
 KGLPNDMK   
 KGLPNSPN   对应跟踪文件的savepoint的值
 
查看session正占着pin锁(kglpnmod=3),其他session正等待此pin锁(KGLPNREQ=2)
*/
select addr,
       indx,
       kglpnadr,
       kglpnuse,
       kglpnses,
       kglpnhdl,
       kglpnlck,
       kglpnmod,
       kglpnreq
  from x$kglpn
 where kglpnhdl like '%0700001C1DC80128%' ；


/*
X$KGLOB---[K]ernel [G]eneric [L]ibrary Cache Manager [OB]ject
引用该基表的视图有：
GV$ACCESS\GV$OBJECT_DEPENDENCY\GV$DB_OBJECT_CACHE\
GV$DB_PIPES\DBA_LOCK_INTERNAL\DBA_DDL_LOCKS

查询x$kglob(Library Cache Object)，
可找到相关的object，其SQL语句如下
v$session_wait中的p1_raw与x$kglob中的kglhdadr关联
KGLNAOBJ:相关object的名字
*/
select * from x$kglob where kglhdadr like '0700001C1DC80128%';


/*把v$session的saddrl与x$kglpn的KGLPNUSE关联，并查询v$session_wait，
即可查出占着pin锁的session目前正在做什么*/
SELECT a.sid,
       a.username,
       a.program,
       b.kglpnadr,
       b.kglpnuse,
       b.kglpnses,
       b.kglpnhdl,
       b.kglpnlck,
       b.kglpnmod,
       b.kglpnreq
  from v$session a, x$kglpn b
 where a.saddr = b.KGLPNUSE
   and b.kglpnhdl like '0700001C1DC80128%'
   and b.KGLPNMOD <> 0;


/*查看用户正在等待什么*/
select * from v$session_wait where sid=<sid>;

/*查出阻塞者正执行的SQL语句*/
select sid,sql_text
from v$session,v$sqlarea
where v$session.sql_address=v$sqlarea.address
and sid=;



---------方法二：
/*通过v$session_wait找到正在等待"library cache pin"的session(即等待者)，
其SQL语句如下：*/

select sid waiter, p1raw, p1text, p2raw, p2text
  from v$session_wait
 where wait_time = 0
   and event like 'library cache pin%';
   
   
/*通过查询dba_lock_internal和v$session_wait，
可得到与"library cache pin"等相关的object的名字，其SQL语句如下：*/
select session_id,
       lock_type,
       lock_id1,
       mode_held,
       mode_requested,
       lock_id2 lock_addr
  from dba_lock_internal
 where mode_requested <> 'None'
   and mode_requested <> mode_held
   and session_id in (select sid
                        from v$session_wait
                       where wait_time = 0
                         and event like 'library cache pin%')
                         


/*
查出"library cache pin"占有者（即阻塞者）的session id,
其SQL语句如下：
*/
select sid holder, kglpnuse Sess, kglpnmod held, kglpnreq req
  from x$kglpn, v$session
 where kglpnhdl in (select p1raw
                      from v$session_wait
                     where wait_time = 0
                       and event like 'library cache pin%')
   and kglpnmod <> 0
   and v$session.saddr = x$kglpn.kglpnuse;
   
/*
查出"library cache pin"占有者(阻塞者)正在等什么？
*/
select sid, substr(event, 1, 30), wait_time
  from v$session_wait
 where sid in (select sid
                 from x$kglpn, v$session
                where KGLPNHDL in
                      (select p1raw
                         from v$session_wait
                        where wait_time = 0
                          and event like 'library cache pin%')
                  and kglpnmod <> 0
                  and v$session.saddr = x$kglpn.kglpnuse)
                  

/*查出阻塞者正执行的SQL语句*/
select sid,sql_text
from v$session,v$sqlarea
where v$session.sql_address=v$sqlarea.address
and sid=;


/*
lock主要有三种模式: Null,share(2),Exclusive(3).
在读取访问对象时,通常需要获取Null(空)模式以及share(共享)模式的锁定.
在修改对象时,需要获得Exclusive(排他)锁定.

同样pin有三种模式,Null,shared(2)和exclusive(3).
只读模式时获得共享pin,修改模式获得排他pin.

模式为shared(2)的pin会阻塞任何exclusive(3)的pin请求。
模式为shared(3)的pin也会阻塞任何exclusive(2)的pin请求。

不同的操作会对对象请求不同的lock/pin
1、所有的DDL都会对被处理的对象请求排他类型的lock和pin

2、
当要对一个过程或者函数进行编译时，需要在library cache中pin该对象。
在pin该对象以前，需要获得该对象handle的锁定，如果获取失败，就会产生library cache lock等待。
如果成功获取handle的lock，则继续在library cache中pin该对象，
如果pin对象失败，则会产生library cache pin等待。
如果是存储过程或者函数，可以这样认为：如果存在library cache lock等待，
则一定存在library cache pin等待；反过来，如果存在library cache pin等待，
不一定会存在library cache lock等待；
但如果是表引起的，则一般只有library cache lock等待，则不一定存在library cache pin。

可能发生library cache pin和library cache lock的情况：
1、在存储过程或者函数正在运行时被编译。
2、在存储过程或者函数正在运行时被对它们进行授权、或者移除权限等操作。
3、对某个表执行DDL期间，有另外的会话对该表执行DML或者DDL。
4、PL/SQL对象之间存在复杂的依赖性

每个想使用或修改已经locked/pin的对象的SQL语句,将会等待事件'library cache pin'或'library cache lock'直到超时.
超时,通常发生在5分钟后,然后SQL语句会出现ORA-4021的错误.如果发现死锁,则会出现ORA-4020错误。

*/


/*library cache pin
查询v$session_wait视图中library cache pin对应的P1、P2、P3
P1 = Handle address
这个就是引起library cache pin等待的对象被pin到library cache中的handle。一般用P1RAW(十六进制)代替p1(十进制)
可以用以下sql查询那个用户下的那个对象正在被请求pin：
SELECT kglnaown "Owner", kglnaobj "Object"
FROM x$kglob
WHERE kglhdadr='&P1RAW'
; 
返回的OBJECT可能是具体的对象，也可能是一段SQL。

P2 = Pin address
自身的pin地址。一般用P2RAW(十六进制)代替P2(十进制)

P3 = Encoded Mode & Namespace 
*/




