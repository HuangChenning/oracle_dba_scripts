select * from (
   select   substr(a.year_month,0,10) ������,a.������Ա ,
count(distinct a.��������) ��������,sum(b.���ܵ�) ���ܵ�,round(sum(b.���ܵ�)/15) ��Ŀ,sum(b.����) ����,sum(c.ִ��) ִ��,sum(d.ȱ��) ȱ��,sum(e.�޸�) �޸�,
sum(f.����ر�) ����ر�,sum(g.����) ����
 from 
(
---�������
select   rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
         d.ts_responsible ������Ա,
         to_char(d.ts_creation_date,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.req e
where d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description) 
---����ִ�е�������
union
select   rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
         e.RN_TESTER_NAME   ������Ա,
         to_char(e.RN_EXECUTION_DATE,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.run e,BOSS_BOSSTEST0723_DB.req f
 where 
  d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description) 
  and e.RN_TEST_ID =d.ts_test_id
union
--BUG����
SELECT   rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
         d.BG_DETECTED_BY ������Ա,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='�ѹر�'
union
--BUG����
SELECT   rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
         d.BG_DETECTED_BY ������Ա,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='�ѹر�'
union
--����ر�
select  rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
         RQ_USER_01 ������Ա,
       to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'), 'yyyy-mm-dd') year_month
  from boss_bosstest0723_db.req
 where RQ_USER_04 = '7-����ر�'
 and  RQ_REQ_TYPE not in ('6-����Ŀ¼') 
union
--����
select  rq_req_name ��������,
         RQ_REQ_TYPE ��������,
         RQ_USER_04 ����״̬,
      BG_DETECTED_BY ������Ա,
         to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='����' 
 
) a,
(
select   RQ_REQ_NAME ��������,
         count( distinct a.al_description ) ���ܵ�,
         d.ts_responsible ������Ա,
         count(*)    ����,
         to_char(d.ts_creation_date,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.TEST d,BOSS_BOSSTEST0723_DB.req e
where d.TS_SUBJECT   =a.al_item_id
  and b.al_item_id=a.AL_FATHER_ID
  and c.al_item_id=b.AL_FATHER_ID
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  group by  RQ_REQ_NAME,to_char(d.ts_creation_date,'yyyy-mm-dd'),d.ts_responsible
) b,
(
select   RQ_REQ_NAME ��������,
         count(*)         ִ��,
         e.RN_TESTER_NAME   ������Ա,
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
 select  RQ_REQ_NAME ��������,
       count(*)       ȱ��,
       BG_DETECTED_BY ������Ա,
       to_char(d.BG_DETECTION_DATE,'yyyy-mm-dd') year_month
 from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
where a.AL_FATHER_ID=b.al_item_id
and b.AL_FATHER_ID=c.al_item_id
and d.BG_SUBJECT   =a.al_item_id
and rq_req_name =any(a.al_description,b.al_description,c.al_description)
group by  RQ_REQ_NAME,to_char(d.BG_DETECTION_DATE,'yyyy-mm-dd'),BG_DETECTED_BY
) d,
(
  select  RQ_REQ_NAME ��������,
         count(*)             �޸�,
         BG_DETECTED_BY ������Ա,
         to_char(BG_CLOSING_DATE,'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='�ѹر�'
  group by  RQ_REQ_NAME,to_char(BG_CLOSING_DATE,'yyyy-mm-dd'),BG_DETECTED_BY
) e,
(
  select RQ_REQ_NAME ��������,
       1 ����ر�,
       RQ_USER_01 ������Ա,
       to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'), 'yyyy-mm-dd') year_month
  from boss_bosstest0723_db.req
 where RQ_USER_04 = '7-����ر�'
 and  RQ_REQ_TYPE not in ('6-����Ŀ¼') 
) f,
(
  select  RQ_REQ_NAME ��������,
         count(*)             ����,
         BG_DETECTED_BY ������Ա,
         to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd') year_month
   from BOSS_BOSSTEST0723_DB.ALL_LISTS a,BOSS_BOSSTEST0723_DB.ALL_LISTS b,BOSS_BOSSTEST0723_DB.ALL_LISTS c, BOSS_BOSSTEST0723_DB.bug d,BOSS_BOSSTEST0723_DB.req e
  where a.AL_FATHER_ID=b.al_item_id
  and b.AL_FATHER_ID=c.al_item_id
  and d.BG_SUBJECT   =a.al_item_id
  and rq_req_name =any(a.al_description,b.al_description,c.al_description)
  and  BG_STATUS='����'
  group by  RQ_REQ_NAME,to_char(nvl(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),sysdate),'yyyy-mm-dd'),BG_DETECTED_BY
) g
where a.��������=b.��������(+)
  and a.��������=c.��������(+)
  and a.��������=d.��������(+)
  and a.��������=e.��������(+)
  and a.��������=f.��������(+)
  and a.��������=g.��������(+)
  and a.year_month=b.year_month(+)
  and a.year_month=c.year_month(+)
  and a.year_month=d.year_month(+)
  and a.year_month=e.year_month(+)
  and a.year_month=f.year_month(+)
  and a.year_month=g.year_month(+)
  and a.������Ա=b.������Ա(+)
  and a.������Ա=c.������Ա(+)
  and a.������Ա=d.������Ա(+)
  and a.������Ա=e.������Ա(+)
  and a.������Ա=f.������Ա(+)
  and a.������Ա=g.������Ա(+)
  and ����״̬ not in( '8-����ȡ��')
group by  a.year_month, a.������Ա   
) where ������Ա like's%' order by ������ desc
