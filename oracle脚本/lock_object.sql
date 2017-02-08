/*
0 - none
1 - null(NULL)
2 - row-S(SS) �й���RS�������������sub share
3 - row-X(SX) �ж�ռ��RX���������е��޸ģ�sub exclusive
4 - share(S)  ��������S������ֹ����DML������share
5 - S/Row-X(SSX) �����ж�ռ��SRX������ֹ�������������share/sub exclusive
6 - exclusive(X) ��ռ(X)����ռ����ʹ�ã�exclusive
*/
SELECT L.SESSION_ID,
       L.ORACLE_USERNAME,
       L.LOCKED_MODE,
       L.OS_USER_NAME,
       L.PROCESS,
       O.OWNER,
       O.OBJECT_NAME,
       O.OBJECT_TYPE
  FROM V$LOCKED_OBJECT L, DBA_OBJECTS O
 WHERE L.OBJECT_ID = O.OBJECT_ID;
