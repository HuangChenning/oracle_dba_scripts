/*xidusn:�ع���
xidslot�������
ubafil��ǰ����λ�ڵ��ļ���
ubablk��ǰ����λ�ڵ����ݿ��*/
select * from v$transaction;



/*�鿴�ع��ε�ͳ����Ϣ*/
select n.name,s.extents,s.rssize,s.optsize,s.hwmsize,s.xacts,s.status
from v$rollname n,v$rollstat s
where n.usn=s.usn;

/*
�鿴�ع��ε�ʹ��������ĸ��û�����ʹ�ûع��ε���Դ*/
select s.username,u.name
from v$transaction t,v$rollstat r,v$rollname u,v$session s
where s.taddr=t.addr
and t.xidusn=r.usn
and r.usn=u.usn
order by s.username;


/*
xacts��������������*/
select * from v$rollstat;




select file_name,bytes/1024/1024 mb from dba_data_files where tablespace_name like 'UNDOTBS1%';

/*
���undo segment��״̬
usn���ع��α�ʾ
rssize���ع���Ĭ�ϴ�С
xacts��������������

��һ��ʱ���������õ�����
writes���ع���д������bytes��
shrinks���ع�����������
extentds���ع�����չ����
wraps���ع��η�ת��wrap������
gets����ȡ�ع���ͷ����
waits���ع���ͷ�ȴ�����
*/
select usn,xacts,status,rssize/1024/1024 ,hwmsize/1024/1024 , shrinks from v$rollstat order by rssize;


