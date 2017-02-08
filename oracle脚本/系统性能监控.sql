/*
v$sysstat
该视图中的数据常用于监控系统性能。如buffer cache命中率、软解析率等
也可以使用v$sysstat数据通过查询v$system_event视图来检查资源消耗和资源回收
*/

select * from v$sysstat where name in ('table scans(long tables)','table scans(short tables)');

/*查看全表扫描的系统统计信息*/
select * from v$sysstat where name like 'table scans%';

/*查看全表扫描及全表索引扫描的数量*/
select name, value
  from v$sysstat
 where name in ('table scans (short tables)',
                'table scans (long tables)',
                'table scans (cache partitions)',
                'table scans (direct read)',
                'table scan blocks gotten',
                'index fast full scans (full)',
                'index fast full scans (rowid ranges)',
                'index fast full scans (direct read)');


/*逻辑读*/
select * from v$sysstat where name = 'consistent gets';


select * from v$statname;


/*记录数据库自启动以来的所有等待事件情况*/
select * from v$system_event;
/*
V$SYSSTAT中的常用统计

　　V$SYSSTAT中包含多个统计项，这部分介绍了一些关键的v$sysstat统计项，
在调优方面相当有用。下列按字母先后排序：

数据库使用状态的一些关键指标：
CPU used by this session：所有session的cpu占用量，不包括后台进程。
这项统计的单位是百分之x秒.完全调用一次不超过10ms

db block changes：那部分造成SGA中数据块变化的insert,update或delete操作数 
这项统计可以大概看出整体数据库状态。在各项事务级别，这项统计指出脏缓存比率。

execute count：执行的sql语句数量(包括递归sql)

logons current：当前连接到实例的Sessions。如果当前有两个快照则取平均值。

logons cumulative：自实例启动后的总登陆次数。


parse count (hard)：在shared pool中解析调用的未命中次数。
当sql语句执行并且该语句不在shared pool或虽然在shared pool但因为两者存在部分差异而不能被使用时产生硬解析。
如果一条sql语句原文与当前存在的相同，
但查询表不同则认为它们是两条不同语句，则硬解析即会发生。
硬解析会带来cpu和资源使用的高昂开销，
因为它需要oracle在shared pool中重新分配内存，然后再确定执行计划，最终语句才会被执行。
parse count (total)：解析调用总数，包括软解析和硬解析。
当session执行了一条sql语句，该语句已经存在于shared pool并且可以被使用则产生软解析。
当语句被使用(即共享) 所有数据相关的现有sql语句(如最优化的执行计划)必须同样适用于当前的声明。
这两项统计可被用于计算软解析命中率。
parse time cpu：总cpu解析时间(单位：10ms)。包括硬解析和软解析。
parse time elapsed：完成解析调用的总时间花费。

physical reads：OS blocks read数。包括插入到SGA缓存区的物理读以及PGA中的直读这项统计并非i/o请求数。
physical writes：从SGA缓存区被DBWR写到磁盘的数据块以及PGA进程直写的数据块数量。
redo log space requests：在redo logs中服务进程的等待空间，表示需要更长时间的log switch。
redo size：redo发生的总次数(以及因此写入log buffer)，以byte为单位。这项统计显示出update活跃性。
session logical reads：逻辑读请求数。

sorts (memory) and sorts (disk)：
sorts(memory)是适于在SORT_AREA_SIZE(因此不需要在磁盘进行排序)的排序操作的数量。
sorts(disk)则是由于排序所需空间太大，SORT_AREA_SIZE不能满足而不得不在磁盘进行排序操作的数量。
这两项统计通常用于计算in-memory sort ratio。

sorts (rows): 列排序总数。这项统计可被'sorts (total)'统计项除尽以确定每次排序的列。该项可指出数据卷和应用特征。


table fetch by rowid：使用ROWID返回的总列数(由于索引访问或sql语句中使用了'where rowid=&rowid'而产生)
table scans (rows gotten)：全表扫描中读取的总列数
table scans (blocks gotten)：全表扫描中读取的总块数，不包括那些split的列。


user commits + user rollbacks：系统事务起用次数。当需要计算其它统计中每项事务比率时该项可以被做为除数。
例如，计算事务中逻辑读，可以使用下列公式：session logical reads / (user commits + user rollbacks)。

注：SQL语句的解析有软解析soft parse与硬解析hard parse之说，以下是5个步骤：
1：语法是否合法(sql写法)
2：语义是否合法(权限，对象是否存在)
3：检查该sql是否在公享池中存在
-- 如果存在,直接跳过4和5,运行sql. 此时算soft parse
4：选择执行计划
5：产生执行计划
-- 如果5个步骤全做,这就叫hard parse.

注意物理I/O

　　oracle报告物理读也许并未导致实际物理磁盘I/O操作。这完全有可能因为多数操作系统都有缓存文件，可能是那些块在被读取。块也可能存于磁盘或控制级缓存以再次避免实际I/O。Oracle报告有物理读也许仅仅表示被请求的块并不在缓存中。

由V$SYSSTAT得出实例效率比(Instance Efficiency Ratios)

下列是些典型的instance efficiency ratios 由v$sysstat数据计算得来，每项比率值应该尽可能接近1：

Buffer cache hit ratio：该项显示buffer cache大小是否合适。
公式：1-((physical reads-physical reads direct-physical reads direct (lob)) / session logical reads)
执行：
select 1-((a.value-b.value-c.value)/d.value) 
from v$sysstat a,v$sysstat b,v$sysstat c,v$sysstat d 
where a.name='physical reads' and
b.name='physical reads direct' and
c.name='physical reads direct (lob)' and
d.name='session logical reads';

Soft parse ratio：这项将显示系统是否有太多硬解析。该值将会与原始统计数据对比以确保精确。例如，软解析率仅为0.2则表示硬解析率太高。不过，如果总解析量(parse count total)偏低，这项值可以被忽略。
公式：1 - ( parse count (hard) / parse count (total) )
执行：
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
Where a.name='parse count (hard)' and b.name='parse count (total)';

In-memory sort ratio：该项显示内存中完成的排序所占比例。最理想状态下，在OLTP系统中，大部分排序不仅小并且能够完全在内存里完成排序。
公式：sorts (memory) / ( sorts (memory) + sorts (disk) )
执行：
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='sorts (memory)' and 
b.name='sorts (memory)' and c.name='sorts (disk)';

Parse to execute ratio：在生产环境，最理想状态是一条sql语句一次解析多数运行。
公式：1 - (parse count/execute count)
执行：
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
where a.name='parse count (total)' and b.name='execute count';

Parse CPU to total CPU ratio：该项显示总的CPU花费在执行及解析上的比率。如果这项比率较低，说明系统执行了太多的解析。
公式：1 - (parse time cpu / CPU used by this session)
执行：
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
where a.name='parse time cpu' and
b.name='CPU used by this session';

Parse time CPU to parse time elapsed：通常，该项显示锁竞争比率。这项比率计算
是否时间花费在解析分配给CPU进行周期运算(即生产工作)。解析时间花费不在CPU周期运算通常表示由于锁竞争导致了时间花费
公式：parse time cpu / parse time elapsed
执行：
select a.value/b.value 
from v$sysstat a,v$sysstat b 
where a.name='parse time cpu' and b.name='parse time elapsed';

从V$SYSSTAT获取负载间档(Load Profile)数据

　　负载间档是监控系统吞吐量和负载变化的重要部分，该部分提供如下每秒和每个事务的统计信息：logons cumulative, parse count (total), parse count (hard), executes, physical reads, physical writes, block changes, and redo size.

　　被格式化的数据可检查'rates'是否过高，或用于对比其它基线数据设置为识别system profile在期间如何变化。例如，计算每个事务中block changes可用如下公式：
db block changes / ( user commits + user rollbacks )
执行：
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='db block changes' and
b.name='user commits' and c.name='user rollbacks';


其它计算统计以衡量负载方式，如下：
Blocks changed for each read：这项显示出block changes在block reads中的比例。它将指出是否系统主要用于只读访问或是主要进行诸多数据操作(如：inserts/updates/deletes)
公式：db block changes / session logical reads
执行：
select a.value/b.value 
from v$sysstat a,v$sysstat b 
where a.name='db block changes' and 
b.name='session logical reads' ;

Rows for each sort：
公式：sorts (rows) / ( sorts (memory) + sorts (disk) )
执行：
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='sorts (rows)' and 
b.name='sorts (memory)' and c.name='sorts (disk)';


*/
