/*xidusn:回滚段
xidslot：事务槽
ubafil：前镜像位于的文件号
ubablk：前镜像位于的数据块号*/
select * from v$transaction;



/*查看回滚段的统计信息*/
select n.name,s.extents,s.rssize,s.optsize,s.hwmsize,s.xacts,s.status
from v$rollname n,v$rollstat s
where n.usn=s.usn;

/*
查看回滚段的使用情况，哪个用户正在使用回滚段的资源*/
select s.username,u.name
from v$transaction t,v$rollstat r,v$rollname u,v$session s
where s.taddr=t.addr
and t.xidusn=r.usn
and r.usn=u.usn
order by s.username;


/*
xacts：代表活动事务数量*/
select * from v$rollstat;




select file_name,bytes/1024/1024 mb from dba_data_files where tablespace_name like 'UNDOTBS1%';

/*
检查undo segment的状态
usn：回滚段标示
rssize：回滚段默认大小
xacts：代表活动事务数量

在一段时间内增量用到的列
writes：回滚段写入数（bytes）
shrinks：回滚段收缩次数
extentds：回滚段扩展次数
wraps：回滚段翻转（wrap）次数
gets：获取回滚段头次数
waits：回滚段头等待次数
*/
select usn,xacts,status,rssize/1024/1024 ,hwmsize/1024/1024 , shrinks from v$rollstat order by rssize;


