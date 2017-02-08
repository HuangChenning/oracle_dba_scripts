select * from (select a.需求名称,
       a.需求类型,
       a.需求编号,
       a.需求创建,
       a.需求状态,
       a.测试人员,
       a.开发人员,
       a.计划开始时间,
       a.计划结束时间,
       H.实际开始时间,
       H.功能点,
       H.设计用例,
       b.操作功能点,
       b.新增用例,
       c.用例执行,
       I.执行合计,
       d.新增缺陷,
       J.缺陷合计,
       e.缺陷修复,
       K.修复总数,
       f.缺陷遗留
  from (
        ---用例设计 select * from BOSS_BOSSTEST0723_DB.TEST
        select RQ_REQ_NAME      需求名称,
                RQ_REQ_TYPE      需求类型,
                RQ_USER_07       需求编号,
                RQ_REQ_AUTHOR    需求创建,
                RQ_USER_04       需求状态,
                d.ts_responsible 测试人员,
                RQ_USER_06       开发人员,
                RQ_USER_02       计划开始时间,
                RQ_USER_03       计划结束时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
                BOSS_BOSSTEST0723_DB.ALL_LISTS b,
                BOSS_BOSSTEST0723_DB.ALL_LISTS c,
                BOSS_BOSSTEST0723_DB.TEST      d,
                BOSS_BOSSTEST0723_DB.req       e
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(d.ts_creation_date, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
        ---测试执行的新需求
        union
        select RQ_REQ_NAME      需求名称,
               RQ_REQ_TYPE      需求类型,
               RQ_USER_07       需求编号,
               RQ_REQ_AUTHOR    需求创建,
               RQ_USER_04       需求状态,
               e.RN_TESTER_NAME 测试人员,
               RQ_USER_06       开发人员,
               RQ_USER_02       计划开始时间,
               RQ_USER_03       计划结束时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.run       e,
               BOSS_BOSSTEST0723_DB.req       f
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and e.RN_TEST_ID = d.ts_test_id
           and to_char(e.RN_EXECUTION_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
        union
        --BUG创建
        select RQ_REQ_NAME    需求名称,
               RQ_REQ_TYPE    需求类型,
               RQ_USER_07     需求编号,
               RQ_REQ_AUTHOR  需求创建,
               RQ_USER_04     需求状态,
               BG_DETECTED_BY 测试人员,
               RQ_USER_06     开发人员,
               RQ_USER_02     计划开始时间,
               RQ_USER_03     计划结束时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(BG_DETECTION_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
           and BG_STATUS = '已关闭'
        --BUG关闭
        union
        select RQ_REQ_NAME    需求名称,
               RQ_REQ_TYPE    需求类型,
               RQ_USER_07     需求编号,
               RQ_REQ_AUTHOR  需求创建,
               RQ_USER_04     需求状态,
               BG_DETECTED_BY 测试人员,
               RQ_USER_06     开发人员,
               RQ_USER_02     计划开始时间,
               RQ_USER_03     计划结束时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(BG_CLOSING_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
           and BG_STATUS = '已关闭'
        ----缺陷遗留
        --BUG关闭
        union
        select RQ_REQ_NAME    需求名称,
               RQ_REQ_TYPE    需求类型,
               RQ_USER_07     需求编号,
               RQ_REQ_AUTHOR  需求创建,
               RQ_USER_04     需求状态,
               BG_DETECTED_BY 测试人员,
               RQ_USER_06     开发人员,
               RQ_USER_02     计划开始时间,
               RQ_USER_03     计划结束时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),
                       'yyyymmdd') = to_char(sysdate-1, 'yyyymmdd')
           and BG_STATUS = '遗留'
        union
        select RQ_REQ_NAME    需求名称,
               RQ_REQ_TYPE    需求类型,
               RQ_USER_07     需求编号,
               RQ_REQ_AUTHOR  需求创建,
               RQ_USER_04     需求状态,
               RQ_USER_01     测试人员,
               RQ_USER_06     开发人员,
               RQ_USER_02     计划开始时间,
               RQ_USER_03     计划结束时间
          from boss_bosstest0723_db.req
         where RQ_USER_04 = '7-需求关闭'
            and to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),
                     'yyyymmdd') = to_char(sysdate-1, 'yyyymmdd')
           and RQ_REQ_TYPE not in ('6-需求目录')) a,
       (select RQ_REQ_NAME 需求名称,
               count(distinct a.al_item_id) 操作功能点,
               count(*) 新增用例,
               d.ts_responsible user_name
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.req       e
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(d.ts_creation_date, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
         group by RQ_REQ_NAME, d.ts_responsible) b,
       (select RQ_REQ_NAME 需求名称,
               count(*) 用例执行,
               e.RN_TESTER_NAME user_name
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.run       e,
               BOSS_BOSSTEST0723_DB.req       f
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and e.RN_TEST_ID = d.ts_test_id
           and to_char(e.RN_EXECUTION_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
         group by RQ_REQ_NAME, e.RN_TESTER_NAME) c,
       (select RQ_REQ_NAME 需求名称,
               count(*) 新增缺陷,
               BG_DETECTED_BY user_name
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(d.BG_DETECTION_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
         group by RQ_REQ_NAME, BG_DETECTED_BY) d,
       (select RQ_REQ_NAME 需求名称,
               count(*) 缺陷修复,
               BG_DETECTED_BY user_name
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(d.BG_CLOSING_DATE, 'yyyymmdd') =
               to_char(sysdate-1, 'yyyymmdd')
           and BG_STATUS = '已关闭'
         group by RQ_REQ_NAME, BG_DETECTED_BY) e,
       (select RQ_REQ_NAME 需求名称,
               count(*) 缺陷遗留,
               BG_DETECTED_BY user_name
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),
                       'yyyymmdd') = to_char(sysdate-1, 'yyyymmdd')
           and BG_STATUS = '遗留修复'
         group by RQ_REQ_NAME, BG_DETECTED_BY) f,
       (select RQ_REQ_NAME 需求名称,
               count(distinct a.al_description) 功能点,
               sum(case nvl(d.TS_SUBJECT, 0)
                     when 0 then
                      0
                     else
                      1
                   end) 设计用例,
               min(to_char(d.ts_creation_date, 'yyyy-mm-dd')) 实际开始时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.al_item_id = d.TS_SUBJECT(+)
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and a.al_item_id not in
               (select AL_FATHER_ID from BOSS_BOSSTEST0723_DB.ALL_LISTS)
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
         group by RQ_REQ_NAME) H,
       (select RQ_REQ_NAME 需求名称, count(*) 执行合计
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.run       e,
               BOSS_BOSSTEST0723_DB.req       f
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and e.RN_TEST_ID = d.ts_test_id
         group by RQ_REQ_NAME) I,
       (select RQ_REQ_NAME 需求名称, count(*) 缺陷合计
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
         group by RQ_REQ_NAME) J,
       (select RQ_REQ_NAME 需求名称, count(*) 修复总数
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
           and BG_STATUS = '已关闭'
         group by RQ_REQ_NAME) K
 where a.需求名称 = H.需求名称(+)
   and a.需求名称 = I.需求名称(+)
   and a.需求名称 = J.需求名称(+)
   and a.需求名称 = K.需求名称(+)
   and a.需求名称 = b.需求名称(+)
   and a.需求名称 = c.需求名称(+)
   and a.需求名称 = d.需求名称(+)
   and a.需求名称 = e.需求名称(+)
   and a.需求名称 = f.需求名称(+)
   and a.测试人员 = b.user_name(+)
   and a.测试人员 = c.user_name(+)
   and a.测试人员 = d.user_name(+)
   and a.测试人员 = e.user_name(+)
   and a.测试人员 = f.user_name(+)) order by 实际开始时间 desc
