select * from (
   select   substr(a.year_month,0,10) 年月日,a.测试人员 ,
count(distinct a.需求名称) 需求数量,sum(b.功能点) 功能点,round(sum(b.功能点)/15) 项目,sum(b.用例) 用例,sum(c.执行) 执行,sum(d.缺陷) 缺陷,sum(e.修复) 修复,
sum(f.需求关闭) 需求关闭,sum(g.遗留) 遗留
 from 
(
---用例设计
select   rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
         d.ts_responsible 测试人员,
         to_char(d.ts_creation_date,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.req e
where d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description) 
---测试执行的新需求
union
select   rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
         e.RN_TESTER_NAME   测试人员,
         to_char(e.RN_EXECUTION_DATE,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.run e,BOSS_BOSSTEST0723_DB.req f
 where 
  d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description) 
  and e.RN_TEST_ID =d.ts_test_id
union
--BUG处理
SELECT   rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
         d.BG_DETECTED_BY 测试人员,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='已关闭'
union
--BUG处理
SELECT   rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
         d.BG_DETECTED_BY 测试人员,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='已关闭'
union
--需求关闭
select  rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
         RQ_USER_01 测试人员,
       to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'), 'yyyy-mm-dd') year_month
  from boss_bosstest0723_db.req
 where RQ_USER_04 = '7-需求关闭'
 and  RQ_REQ_TYPE not in ('6-需求目录') 
union
--遗留
select  rq_req_name 需求名称,
         RQ_REQ_TYPE 需求类型,
         RQ_USER_04 需求状态,
      BG_DETECTED_BY 测试人员,
         to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='遗留' 
 
) a,
(
select   RQ_REQ_NAME 需求名称,
         count( distinct a.al_description ) 功能点,
         d.ts_responsible 测试人员,
         count(*)    用例,
         to_char(d.ts_creation_date,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.req e
where d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  group by  RQ_REQ_NAME,to_char(d.ts_creation_date,'yyyy-mm-dd'),d.ts_responsible
) b,
(
select   RQ_REQ_NAME 需求名称,
         count(*)         执行,
         e.RN_TESTER_NAME   测试人员,
         to_char(e.RN_EXECUTION_DATE,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.run e,BOSS_BOSSTEST0723_DB.req f
 where 
  d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
and e.RN_TEST_ID =d.ts_test_id
group by  RQ_REQ_NAME,to_char(e.RN_EXECUTION_DATE,'yyyy-mm-dd'),e.RN_TESTER_NAME  
) c,
(
 select  RQ_REQ_NAME 需求名称,
       count(*)       缺陷,
       BG_DETECTED_BY 测试人员,
       to_char(d.BG_DETECTION_DATE,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
where a.AL_FATHER_ID=b.al_item_id
and b.AL_FATHER_ID=c.al_item_id
and d.BG_SUBJECT   =a.al_item_id
and rq_req_name =any(a.al_description,b.al_description,c.al_description)
group by  RQ_REQ_NAME,to_char(d.BG_DETECTION_DATE,'yyyy-mm-dd'),BG_DETECTED_BY
) d,
(
  select  RQ_REQ_NAME 需求名称,
         count(*)             修复,
         BG_DETECTED_BY 测试人员,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='已关闭'
  group by  RQ_REQ_NAME,to_char(BG_CLOSING_DATE,'yyyy-mm-dd'),BG_DETECTED_BY
) e,
(
  select RQ_REQ_NAME 需求名称,
       1 需求关闭,
       RQ_USER_01 测试人员,
       to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'), 'yyyy-mm-dd') year_month
  from boss_bosstest0723_db.req
 where RQ_USER_04 = '7-需求关闭'
 and  RQ_REQ_TYPE not in ('6-需求目录') 
) f,
(
  select  RQ_REQ_NAME 需求名称,
         count(*)             遗留,
         BG_DETECTED_BY 测试人员,
         to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='遗留'
  group by  RQ_REQ_NAME,to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd'),BG_DETECTED_BY
) g
where a.需求名称=b.需求名称(+)
  and a.需求名称=c.需求名称(+)
  and a.需求名称=d.需求名称(+)
  and a.需求名称=e.需求名称(+)
  and a.需求名称=f.需求名称(+)
  and a.需求名称=g.需求名称(+)
  and a.year_month=b.year_month(+)
  and a.year_month=c.year_month(+)
  and a.year_month=d.year_month(+)
  and a.year_month=e.year_month(+)
  and a.year_month=f.year_month(+)
  and a.year_month=g.year_month(+)
  and a.测试人员=b.测试人员(+)
  and a.测试人员=c.测试人员(+)
  and a.测试人员=d.测试人员(+)
  and a.测试人员=e.测试人员(+)
  and a.测试人员=f.测试人员(+)
  and a.测试人员=g.测试人员(+)
  and 需求状态 not in( '8-需求取消')
group by  a.year_month, a.测试人员   
) where 测试人员 like's%' order by 年月日 desc
