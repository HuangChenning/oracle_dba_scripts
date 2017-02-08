/*
查找那些会话hold了rollback segments，导致其无法offline，通常在切换undo表空间后用
*/
SELECT *
  FROM V$SESSION
 WHERE SADDR IN
       (SELECT SES_ADDR
          FROM V$TRANSACTION
         WHERE XIDUSN IN
               (SELECT USN FROM V$ROLLSTAT WHERE STATUS = 'PENDING OFFLINE'))


/*
查找指定类型程序，在  rollback segments中hold（未提交和回退）的记录 ，xidusn指回滚段号，userd_urec指hold的记录数， used_ublk指占用的块，这个sql也可以用于大致统计rollback需要的时间。
*/
SELECT A.INST_ID,
       A.SID,
       A.USERNAME,
       A.PROGRAM,
       B.XIDUSN,
       B.USED_UREC,
       B.USED_UBLK
  FROM GV$SESSION A, GV$TRANSACTION B
 WHERE A.SADDR = B.SES_ADDR
   AND A.PROGRAM LIKE 'R1300Init%'
 ORDER BY A.INST_ID, A.SID
