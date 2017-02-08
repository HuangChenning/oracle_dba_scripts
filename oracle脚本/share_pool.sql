SELECT 'crmc2',
       TO_CHAR(SYSDATE, 'mmdd hh24:mi:ss') AS CURTIME,
       POOL,
       NAME,
       ROUND(BYTES / 1024 / 1024) AS SHMEM
  FROM V$SGASTAT
 WHERE NAME LIKE 'free%'
   AND POOL = 'shared pool';
   
/*
共享池主要分成两部分：library cache和dictionary cache，
library cache中主要存储的是执行的一些SQL的语句，plsql语句等，
而dictionary cache中主要存储的是数据库的一些数据字典信息，
library cache中变动的内容较多，而dictionary cache内容相对来说比较固定，
一般来说share pool占用率高都是sql导致，所以share pool如果占用过高，
可以直接查看相关SQL
*/   
---通过下面的sql查询占用share pool内存大于10M的SQL：
SELECT SUBSTR(SQL_TEXT, 1, 100) "Stmt",
       COUNT(*),
       SUM(SHARABLE_MEM)/1024/1024 "Mem(Mb)",
       SUM(USERS_OPENING) "Open",
       SUM(EXECUTIONS) "Exec"
  FROM V$SQL
 GROUP BY SUBSTR(SQL_TEXT, 1, 100)
HAVING SUM(SHARABLE_MEM) > 10000000;





/*查看share_pool的子缓冲池*/
select addr, name, gets, misses, spin_gets
  from v$latch_children
 where name = 'shared pool';


/*share pool空间的分配和使用情况，可以根据内部视图x$ksmsp来观察
[K]ernal [S]torage [M]emory Management [S]GA Hea[P]
ksmchcom:注释字段，每个内存块被分配以后，注释会添加在该字段中
ksmchsiz:代表块大小
ksmchcls:代表类型，主要有4类
    free:free Chunks:不包含任何对象的Chunk，可以不受限制的被自由分配
    recreate：Recreatable Chunks：包含可以被临时移出内存的对象，在需要
             的时候，这个对象可以被重新创建。例如，许多存储共享SQL代码
             的内存都是可以重建的
    freeable：Freeable Chunks：包含session周期或调用的对象，随后可以释放。
              这部分内存有时候可以全部或则部分提前释放。但是注意，由于某些
              对象是中间过程产生的，这些对象不能被移出内存
    perm：Permanent Memory Chunks：包含永久对象，通常不能独立释放。
    
    
    
    alter system flush shared_pool;
*/

select * from x$ksmsp;


/*
查询v$shared_pool_reserved视图可以判断共享池问题的引发原因

如果request_failures>0且last_failure_size>shared_pool_reserved_min_alloc，
那么ORA-04031错误就可能是因为共享池保留空间缺少连续空间所致。
要解决这个问题，可以考虑加大shared_pool_reserved_min_alloc来降低缓冲进共享
池保留空间的对象数目，并增大shared_pool_reserved_size和shared_pool_size来加大
共享池保留空间的可用内存


如果request_failures>0且last_failure_size < shared_pool_reserved_min_alloc，
或则request_failure = 0且last_failure_size < shared_pool_reserved_min_alloc，
那么是由于在库高速缓冲缺少连续空间而导致0RA-04031错误，对于这类情况应该考虑
降低shared_pool_reserved_min_alloc,以放入更多的对象到共享池保留空间中并加大
shared_pool_size
*/
select free_space,
       avg_free_size,
       used_space,
       avg_used_size,
       request_failures,
       last_failure_size
  from v$shared_pool_reserved;


/*
使用dbms_shared_pool.keep系统包可以把指定对象pin到内存中,
要使用dbms_shared_pool系统包，首先要运行dbmspool.sql,该脚本
会自动调用prvtpool.plb脚本创建所需对象
*/


/*
查看当前会话中的 library Cache pin
Library Cache Pin的参数如下：
P1：KGL Handle address（Library Cache Handle Address）
P2：Pin address
P3：Encoded Mode & Namespace

Pn字段是十进制表示，PnRAW字段是十六进制表示
通过p1地址，查询x$kglob.kglhdadr视图就可以得到对象的具体信息
x$kglob的名称含义[K]ernel [G]eneric [L]ibrary Cache Manager [OB]ject
这里的kglnahsh代表对象的Hash value，由此可知，在pining对象上正经历
library cache pin的等待

v$session_wait.p1raw=x$kglob.kglhdadr
*/

select sid, seq#, event, p1, p1raw, p2, p2raw, p3, p3raw, state
  from v$session_wait
 where event like 'library%';


select addr, kglhdadr, kglhdpar, kglnaown, kglnaobj, kglnahsh, kglhdobj
  from x$kglob
 where kglhdadr = ''

/*
x$kglpn：[K]ernel [G]eneric [L]ibrary Cache Manager object [P]i[N]s
x$kglpn.kgpnhdl=x$kglob.kglhdadr=v$session_wait.p1raw
通过联合v$session，可以获得当前持有该handle的用户信息
*/

select a.sid,a.username,a.program,a.sql_hash_value,a.sql_address,b.addr,b.kglpnadr,b.kglpnuse,b.kglpnses,b.kglpnhdl,
b.kglpnlck,b.kglpnmod,b.kglpnreq
from v$session a,x$kglpn b
where a.saddr=b.kglpnuse and b.kgpnhdl='' and b.kglpnmod<>0;


/*
得到SID，就可以通过v$session.sql_hash_value\v$session.sql_address等字段关联v$sqltext、v$sqlarea等视图
获得当前session正在执行的操作
*/
select sql_text from v$sqlarea a where a.hash_value='';
