---�鿴�鵵15����������ɵĹ鵵�ļ�

select * from v$archived_log a where a.completion_time > sysdate - 15/1440 

/*
����鵵��־��������*/

select name, completion_time, block_size / 1024 / 1024 MB
  from v$archived_log
 where completion_time between trunc(sysdate) - 2 and trunc(sysdate) - 1;
 
/* 
 ����ĳ��ȫ�����־������*/
 
 select trunc(completion_time), sum(Mb) DAY_MB
   from (select name, completion_time, block_size / 1024 / 1024 MB
           from v$archived_log
          where completion_time between trunc(sysdate) - 2 and
                trunc(sysdate) - 1)
  group by trunc(completion_time)


/*
����������ڵ���־����ͳ��*/

select trunc(completion_time), sum(mb) day_mb
  from (select name, completion_time, block_size / 1024 / 1024 MB
          from v$archived_log)
 group by trunc(completion_time)
 order by trunc(completion_time)
