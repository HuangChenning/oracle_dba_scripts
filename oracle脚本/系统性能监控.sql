/*
v$sysstat
����ͼ�е����ݳ����ڼ��ϵͳ���ܡ���buffer cache�����ʡ�������ʵ�
Ҳ����ʹ��v$sysstat����ͨ����ѯv$system_event��ͼ�������Դ���ĺ���Դ����
*/

select * from v$sysstat where name in ('table scans(long tables)','table scans(short tables)');

/*�鿴ȫ��ɨ���ϵͳͳ����Ϣ*/
select * from v$sysstat where name like 'table scans%';

/*�鿴ȫ��ɨ�輰ȫ������ɨ�������*/
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


/*�߼���*/
select * from v$sysstat where name = 'consistent gets';


select * from v$statname;


/*��¼���ݿ����������������еȴ��¼����*/
select * from v$system_event;
/*
V$SYSSTAT�еĳ���ͳ��

����V$SYSSTAT�а������ͳ����ⲿ�ֽ�����һЩ�ؼ���v$sysstatͳ���
�ڵ��ŷ����൱���á����а���ĸ�Ⱥ�����

���ݿ�ʹ��״̬��һЩ�ؼ�ָ�꣺
CPU used by this session������session��cpuռ��������������̨���̡�
����ͳ�Ƶĵ�λ�ǰٷ�֮x��.��ȫ����һ�β�����10ms

db block changes���ǲ������SGA�����ݿ�仯��insert,update��delete������ 
����ͳ�ƿ��Դ�ſ����������ݿ�״̬���ڸ������񼶱�����ͳ��ָ���໺����ʡ�

execute count��ִ�е�sql�������(�����ݹ�sql)

logons current����ǰ���ӵ�ʵ����Sessions�������ǰ������������ȡƽ��ֵ��

logons cumulative����ʵ����������ܵ�½������


parse count (hard)����shared pool�н������õ�δ���д�����
��sql���ִ�в��Ҹ���䲻��shared pool����Ȼ��shared pool����Ϊ���ߴ��ڲ��ֲ�������ܱ�ʹ��ʱ����Ӳ������
���һ��sql���ԭ���뵱ǰ���ڵ���ͬ��
����ѯ��ͬ����Ϊ������������ͬ��䣬��Ӳ�������ᷢ����
Ӳ���������cpu����Դʹ�õĸ߰�������
��Ϊ����Ҫoracle��shared pool�����·����ڴ棬Ȼ����ȷ��ִ�мƻ����������Żᱻִ�С�
parse count (total)���������������������������Ӳ������
��sessionִ����һ��sql��䣬������Ѿ�������shared pool���ҿ��Ա�ʹ��������������
����䱻ʹ��(������) ����������ص�����sql���(�����Ż���ִ�мƻ�)����ͬ�������ڵ�ǰ��������
������ͳ�ƿɱ����ڼ�������������ʡ�
parse time cpu����cpu����ʱ��(��λ��10ms)������Ӳ�������������
parse time elapsed����ɽ������õ���ʱ�仨�ѡ�

physical reads��OS blocks read�����������뵽SGA��������������Լ�PGA�е�ֱ������ͳ�Ʋ���i/o��������
physical writes����SGA��������DBWRд�����̵����ݿ��Լ�PGA����ֱд�����ݿ�������
redo log space requests����redo logs�з�����̵ĵȴ��ռ䣬��ʾ��Ҫ����ʱ���log switch��
redo size��redo�������ܴ���(�Լ����д��log buffer)����byteΪ��λ������ͳ����ʾ��update��Ծ�ԡ�
session logical reads���߼�����������

sorts (memory) and sorts (disk)��
sorts(memory)��������SORT_AREA_SIZE(��˲���Ҫ�ڴ��̽�������)�����������������
sorts(disk)����������������ռ�̫��SORT_AREA_SIZE������������ò��ڴ��̽������������������
������ͳ��ͨ�����ڼ���in-memory sort ratio��

sorts (rows): ����������������ͳ�ƿɱ�'sorts (total)'ͳ���������ȷ��ÿ��������С������ָ�����ݾ��Ӧ��������


table fetch by rowid��ʹ��ROWID���ص�������(�����������ʻ�sql�����ʹ����'where rowid=&rowid'������)
table scans (rows gotten)��ȫ��ɨ���ж�ȡ��������
table scans (blocks gotten)��ȫ��ɨ���ж�ȡ���ܿ�������������Щsplit���С�


user commits + user rollbacks��ϵͳ�������ô���������Ҫ��������ͳ����ÿ���������ʱ������Ա���Ϊ������
���磬�����������߼���������ʹ�����й�ʽ��session logical reads / (user commits + user rollbacks)��

ע��SQL���Ľ����������soft parse��Ӳ����hard parse֮˵��������5�����裺
1���﷨�Ƿ�Ϸ�(sqlд��)
2�������Ƿ�Ϸ�(Ȩ�ޣ������Ƿ����)
3������sql�Ƿ��ڹ�����д���
-- �������,ֱ������4��5,����sql. ��ʱ��soft parse
4��ѡ��ִ�мƻ�
5������ִ�мƻ�
-- ���5������ȫ��,��ͽ�hard parse.

ע������I/O

����oracle���������Ҳ��δ����ʵ���������I/O����������ȫ�п�����Ϊ��������ϵͳ���л����ļ�����������Щ���ڱ���ȡ����Ҳ���ܴ��ڴ��̻���Ƽ��������ٴα���ʵ��I/O��Oracle�����������Ҳ�������ʾ������Ŀ鲢���ڻ����С�

��V$SYSSTAT�ó�ʵ��Ч�ʱ�(Instance Efficiency Ratios)

������Щ���͵�instance efficiency ratios ��v$sysstat���ݼ��������ÿ�����ֵӦ�þ����ܽӽ�1��

Buffer cache hit ratio��������ʾbuffer cache��С�Ƿ���ʡ�
��ʽ��1-((physical reads-physical reads direct-physical reads direct (lob)) / session logical reads)
ִ�У�
select 1-((a.value-b.value-c.value)/d.value) 
from v$sysstat a,v$sysstat b,v$sysstat c,v$sysstat d 
where a.name='physical reads' and
b.name='physical reads direct' and
c.name='physical reads direct (lob)' and
d.name='session logical reads';

Soft parse ratio�������ʾϵͳ�Ƿ���̫��Ӳ��������ֵ������ԭʼͳ�����ݶԱ���ȷ����ȷ�����磬������ʽ�Ϊ0.2���ʾӲ������̫�ߡ�����������ܽ�����(parse count total)ƫ�ͣ�����ֵ���Ա����ԡ�
��ʽ��1 - ( parse count (hard) / parse count (total) )
ִ�У�
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
Where a.name='parse count (hard)' and b.name='parse count (total)';

In-memory sort ratio��������ʾ�ڴ�����ɵ�������ռ������������״̬�£���OLTPϵͳ�У��󲿷����򲻽�С�����ܹ���ȫ���ڴ����������
��ʽ��sorts (memory) / ( sorts (memory) + sorts (disk) )
ִ�У�
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='sorts (memory)' and 
b.name='sorts (memory)' and c.name='sorts (disk)';

Parse to execute ratio��������������������״̬��һ��sql���һ�ν����������С�
��ʽ��1 - (parse count/execute count)
ִ�У�
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
where a.name='parse count (total)' and b.name='execute count';

Parse CPU to total CPU ratio��������ʾ�ܵ�CPU������ִ�м������ϵı��ʡ����������ʽϵͣ�˵��ϵͳִ����̫��Ľ�����
��ʽ��1 - (parse time cpu / CPU used by this session)
ִ�У�
select 1-(a.value/b.value) 
from v$sysstat a,v$sysstat b 
where a.name='parse time cpu' and
b.name='CPU used by this session';

Parse time CPU to parse time elapsed��ͨ����������ʾ���������ʡ�������ʼ���
�Ƿ�ʱ�仨���ڽ��������CPU������������(����������)������ʱ�仨�Ѳ���CPU��������ͨ����ʾ����������������ʱ�仨��
��ʽ��parse time cpu / parse time elapsed
ִ�У�
select a.value/b.value 
from v$sysstat a,v$sysstat b 
where a.name='parse time cpu' and b.name='parse time elapsed';

��V$SYSSTAT��ȡ���ؼ䵵(Load Profile)����

�������ؼ䵵�Ǽ��ϵͳ�������͸��ر仯����Ҫ���֣��ò����ṩ����ÿ���ÿ�������ͳ����Ϣ��logons cumulative, parse count (total), parse count (hard), executes, physical reads, physical writes, block changes, and redo size.

��������ʽ�������ݿɼ��'rates'�Ƿ���ߣ������ڶԱ�����������������Ϊʶ��system profile���ڼ���α仯�����磬����ÿ��������block changes�������¹�ʽ��
db block changes / ( user commits + user rollbacks )
ִ�У�
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='db block changes' and
b.name='user commits' and c.name='user rollbacks';


��������ͳ���Ժ������ط�ʽ�����£�
Blocks changed for each read��������ʾ��block changes��block reads�еı���������ָ���Ƿ�ϵͳ��Ҫ����ֻ�����ʻ�����Ҫ����������ݲ���(�磺inserts/updates/deletes)
��ʽ��db block changes / session logical reads
ִ�У�
select a.value/b.value 
from v$sysstat a,v$sysstat b 
where a.name='db block changes' and 
b.name='session logical reads' ;

Rows for each sort��
��ʽ��sorts (rows) / ( sorts (memory) + sorts (disk) )
ִ�У�
select a.value/(b.value+c.value) 
from v$sysstat a,v$sysstat b,v$sysstat c 
where a.name='sorts (rows)' and 
b.name='sorts (memory)' and c.name='sorts (disk)';


*/
