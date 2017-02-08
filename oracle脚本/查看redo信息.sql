-------查看redo log文件的信息---------
select trim(a.GROUP#) GROUP#,a.THREAD# THREAD#,b.MEMBER MEMBER,a.BYTES/1024/1024 "SIZE(M)"  
from v$log a,v$logfile b where a.GROUP#=b.GROUP#
order by to_number(a.GROUP#), a.THREAD#,b.MEMBER;


--------查看redo log的大小状态等
select trim(GROUP#) GROUP# ,THREAD# , SEQUENCE#    ,  BYTES    ,MEMBERS, archived, STATUS
from v$log
order by to_number(group#);

