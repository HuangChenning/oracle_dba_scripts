SELECT S.SEQUENCE_OWNER,
       S.SEQUENCE_NAME,
       S.MIN_VALUE,
       S.MAX_VALUE,
       S.INCREMENT_BY,
       S.CACHE_SIZE,
       S.LAST_NUMBER
  FROM DBA_SEQUENCES S
 WHERE CACHE_SIZE < 2000
 AND s.sequence_owner NOT IN('SYS','SYSTEM','WMSYS')
 ORDER BY s.cache_size ;
 


/*
创建了一张中间表PERFSTAT.TEST_HCN，
来计算序列是否还在使用，以及使用的情况
CREATE TABLE perfstat.test_hcn AS SELECT S.SEQUENCE_OWNER,
       S.SEQUENCE_NAME,
       S.MIN_VALUE,
       S.MAX_VALUE,
       S.INCREMENT_BY,
       S.CACHE_SIZE,
       S.LAST_NUMBER
  FROM DBA_SEQUENCES S
 WHERE CACHE_SIZE < 2000
 AND s.sequence_owner NOT IN('SYS','SYSTEM','WMSYS')
 ORDER BY s.cache_size ;
 
SELECT A.SEQUENCE_OWNER,
       A.SEQUENCE_NAME,
       B.CACHE_SIZE,
       B.LAST_NUMBER CURR_NUMBER,
       A.LAST_NUMBER,
       b.increment_by,
       B.LAST_NUMBER - A.LAST_NUMBER,
       b.max_value
  FROM PERFSTAT.TEST_HCN A,
       (SELECT SEQUENCE_OWNER,
               SEQUENCE_NAME,
               MIN_VALUE,
               MAX_VALUE,
               INCREMENT_BY,
               CACHE_SIZE,
               LAST_NUMBER
          FROM DBA_SEQUENCES
         WHERE CACHE_SIZE < 2000
           AND SEQUENCE_OWNER NOT IN ('SYS', 'SYSTEM', 'WMSYS')) B
 WHERE A.SEQUENCE_OWNER = B.SEQUENCE_OWNER
   AND A.SEQUENCE_NAME = B.SEQUENCE_NAME
   ORDER BY B.LAST_NUMBER - A.LAST_NUMBER DESC */
