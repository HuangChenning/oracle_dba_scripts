select * from (
select a.��������,
       a.����״̬,
       to_char(to_date(a.�ر�ʱ��, 'yyyy-mm-dd hh24:mi:ss'), 'yyyymmdd') �ر�����,
       ������Ա,
       b.ʵ�ʿ�ʼʱ��,
       a.��������,
       b.���ܵ�,
       to_number(a.������) ������,
       b.�������,
       c.����ִ��,
       d.����ȱ��,
       e.ȱ���޸�,
       a.������
  from (select rq_req_name ��������,
               RQ_REQ_TYPE ��������,
               RQ_USER_01	 ������Ա,
               RQ_USER_07  ������,
               RQ_USER_05  ������,
               RQ_USER_08  �ر�ʱ��,
               RQ_USER_04  ����״̬
          from BOSS_BOSSTEST0723_DB.req
         where RQ_REQ_TYPE <> '6-����Ŀ¼'
           and RQ_USER_04 not in( '8-����ȡ��','2-���ɹ���','1-���󴴽�')
           ) a,
       (select RQ_REQ_NAME ��������,
               count(distinct a.al_description) ���ܵ�,
               count(*) �������,
               min(to_char(d.ts_creation_date, 'yyyy-mm-dd')) ʵ�ʿ�ʼʱ��
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
       (select RQ_REQ_NAME ��������,
                   count(distinct a.al_description) ���ܵ�,
                   sum(case nvl(d.TS_SUBJECT, 0) when 0 then 0 else 1 end) ����ִ��,
                   min(to_char(d.ts_creation_date, 'yyyy-mm-dd')) ʵ�ʿ�ʼʱ��
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
       (select RQ_REQ_NAME ��������, count(*) ����ȱ��
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
       (select RQ_REQ_NAME ��������, count(*) ȱ���޸�
          from BOSS_BOSSTEST0723_DB.ALL_LISTS a,
               BOSS_BOSSTEST0723_DB.ALL_LISTS b,
               BOSS_BOSSTEST0723_DB.ALL_LISTS c,
               BOSS_BOSSTEST0723_DB.bug       d,
               BOSS_BOSSTEST0723_DB.req       e
         where a.AL_FATHER_ID = b.al_item_id
           and b.AL_FATHER_ID = c.al_item_id
           and d.BG_SUBJECT = a.al_item_id
           and rq_req_name =any(a.al_description,b.al_description,c.al_description)
           and BG_STATUS = '�ѹر�'
         group by RQ_REQ_NAME) e
where a.�������� = b.��������(+)
   and a.�������� = c.��������(+)
   and a.�������� = d.��������(+)
   and a.�������� = e.��������(+)
 order by a.����״̬, a.�������� desc   ) where ������Ա like 'srd%' order by ʵ�ʿ�ʼʱ�� desc
