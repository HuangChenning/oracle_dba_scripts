/*��v$sysstat��ͼ�еõ����������ݿ������������ۻ���־��������
���Ը���ʵ������ʱ�������¹���ÿ�����ݿ����־������
*/
select * from v$sysstat where name='redo size';

/*��log buffer space�ȴ��¼����ֱȽ�������ʱ��
���Կ�������log buffer�Լ��پ���*/
select event#,name from V$event_Name where name='log buffer space';



/*�鿴�鵵��־��������*/
select * from v$archived_log;

select a.name, a.completion_time, blocks * block_size / 1024 / 1024 Mb
  from v$archived_log a
 where rownum < 11
   and completion_time between trunc(sysdate) - 2 and trunc(sysdate) - 1;
 
 
 /*����ĳһ����ܹ鵵��*/
select trunc(completion_time), sum(Mb) / 1024 day_gb
  from (select a.name,
               a.completion_time,
               blocks * block_size / 1024 / 1024 Mb
          from v$archived_log a
         where rownum < 11
           and completion_time between trunc(sysdate) - 2 and
               trunc(sysdate) - 1)
 group by trunc(completion_time);
 
 
 /*����������ڵ���־����ͳ��*/
 select trunc(completion_time), sum(mb) / 1024 day_gb
   from (select a.name,
                a.completion_time,
                blocks * block_size / 1024 / 1024 Mb
           from v$archived_log a)
  group by trunc(completion_time)


/*
redo size:redo��Ϣ�Ĵ�С
redo wastage���˷ѵ�redo��С
redo blocks written��lgwrд����redo blocks������
�������Ϣ��ÿ��redo block header��Ҫռ��16bytes
*/
select name, value
  from v$sysstat
 where name in ('redo size', 'redo wastage', 'redo blocks written');
 
 
 
 select * from redo_size
