/*
�鿴��ǰϵͳ��sql�������
(total - hard)/total��ֵ�������������

*/
select * from v$sysstat where name like '%parse%';

select (7529-983)/7529 from dual;



select * from v$sqlarea s order by s.version_count desc;

/*����ͼ������SQL���ܹ���ľ���ԭ��*/
select * from v$sql_shared_cursor
