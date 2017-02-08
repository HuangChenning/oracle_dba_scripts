select * from (
select a.需求名称,
       a.需求状态,
       to_char(to_date(a.关闭时间, 'yyyy-mm-dd hh24:mi:ss'), 'yyyymmdd') 关闭年月,
       测试人员,
       b.实际开始时间,
       a.需求类型,
       b.功能点,
       to_number(a.工作量) 工作量,
       b.用例设计,
       c.用例执行,
       d.测试缺陷,
       e.缺陷修复,
       a.需求编号
  from (select rq_req_name 需求名称,
               RQ_REQ_TYPE 需求类型,
               RQ_USER_01	 测试人员,
               RQ_USER_07  需求编号,
               RQ_USER_05  工作量,
               RQ_USER_08  关闭时间,
               RQ_USER_04  需求状态
          from BOSS_BOSSTEST0723_DB.req
         where RQ_REQ_TYPE <> '6-需求目录'
           and RQ_USER_04 not in( '8-需求取消','2-集成构建','1-需求创建')
           ) a,
       (select RQ_REQ_NAME 需求名称,
               count(distinct a.al_description) 功能点,
               count(*) 用例设计,
               min(to_char(d.ts_creation_date, 'yyyy-mm-dd')) 实际开始时间
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.TEST      d,
               BOSS_BOSSTEST0723_DB.req       e
         where d.TS_SUBJECT = a.al_item_id
           and b.al_item_id = a.AL_FATHER_ID
           and c.al_item_id = b.AL_FATHER_ID
           and rq_req_name =any(a.al_description,b.al_description,c.al_description)
         group by RQ_REQ_NAME) b,
       (select RQ_REQ_NAME 需求名称,
                   count(distinct a.al_description) 功能点,
                   sum(case nvl(d.TS_SUBJECT, 0) when 0 then 0 else 1 end) 用例执行,
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
               and rq_req_name =any(a.al_description,b.al_description,c.al_description)
               group by RQ_REQ_NAME) c,
       (select RQ_REQ_NAME 需求名称, count(*) 测试缺陷
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =any(a.al_description,b.al_description,c.al_description)
         group by RQ_REQ_NAME) d,
       (select RQ_REQ_NAME 需求名称, count(*) 缺陷修复
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =any(a.al_description,b.al_description,c.al_description)
           and BG_STATUS = '已关闭'
         group by RQ_REQ_NAME) e
where a.需求名称 = b.需求名称(+)
   and a.需求名称 = c.需求名称(+)
   and a.需求名称 = d.需求名称(+)
   and a.需求名称 = e.需求名称(+)
 order by a.需求状态, a.需求名称 desc   ) where 测试人员 like 'srd%' order by 实际开始时间 desc
