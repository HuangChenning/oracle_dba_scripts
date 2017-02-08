/*
������Щ�Ựhold��rollback segments���������޷�offline��ͨ�����л�undo��ռ����
*/
SELECT *
  FROM V$SESSION
 WHERE SADDR IN
       (SELECT SES_ADDR
          FROM V$TRANSACTION
         WHERE XIDUSN IN
               (SELECT USN FROM V$ROLLSTAT WHERE STATUS = 'PENDING OFFLINE'))


/*
����ָ�����ͳ�����  rollback segments��hold��δ�ύ�ͻ��ˣ��ļ�¼ ��xidusnָ�ع��κţ�userd_urecָhold�ļ�¼���� used_ublkָռ�õĿ飬���sqlҲ�������ڴ���ͳ��rollback��Ҫ��ʱ�䡣
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
