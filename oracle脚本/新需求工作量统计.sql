select * from (select a.��������,
       a.��������,
       a.������,
       a.���󴴽�,
       a.����״̬,
       a.������Ա,
       a.������Ա,
       a.�ƻ���ʼʱ��,
       a.�ƻ�����ʱ��,
       H.ʵ�ʿ�ʼʱ��,
       H.���ܵ�,
       H.�������,
       b.�������ܵ�,
       b.��������,
       c.����ִ��,
       I.ִ�кϼ�,
       d.����ȱ��,
       J.ȱ�ݺϼ�,
       e.ȱ���޸�,
       K.�޸�����,
       f.ȱ������
  from (
        ---������� select * from BOSS_BOSSTEST0723_DB.TEST
        select RQ_REQ_NAME      ��������,
                RQ_REQ_TYPE      ��������,
                RQ_USER_07       ������,
                RQ_REQ_AUTHOR    ���󴴽�,
                RQ_USER_04       ����״̬,
                d.ts_responsible ������Ա,
                RQ_USER_06       ������Ա,
                RQ_USER_02       �ƻ���ʼʱ��,
                RQ_USER_03       �ƻ�����ʱ��
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
        ---����ִ�е�������
        union
        select RQ_REQ_NAME      ��������,
               RQ_REQ_TYPE      ��������,
               RQ_USER_07       ������,
               RQ_REQ_AUTHOR    ���󴴽�,
               RQ_USER_04       ����״̬,
               e.RN_TESTER_NAME ������Ա,
               RQ_USER_06       ������Ա,
               RQ_USER_02       �ƻ���ʼʱ��,
               RQ_USER_03       �ƻ�����ʱ��
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
        --BUG����
        select RQ_REQ_NAME    ��������,
               RQ_REQ_TYPE    ��������,
               RQ_USER_07     ������,
               RQ_REQ_AUTHOR  ���󴴽�,
               RQ_USER_04     ����״̬,
               BG_DETECTED_BY ������Ա,
               RQ_USER_06     ������Ա,
               RQ_USER_02     �ƻ���ʼʱ��,
               RQ_USER_03     �ƻ�����ʱ��
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
           and BG_STATUS = '�ѹر�'
        --BUG�ر�
        union
        select RQ_REQ_NAME    ��������,
               RQ_REQ_TYPE    ��������,
               RQ_USER_07     ������,
               RQ_REQ_AUTHOR  ���󴴽�,
               RQ_USER_04     ����״̬,
               BG_DETECTED_BY ������Ա,
               RQ_USER_06     ������Ա,
               RQ_USER_02     �ƻ���ʼʱ��,
               RQ_USER_03     �ƻ�����ʱ��
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
           and BG_STATUS = '�ѹر�'
        ----ȱ������
        --BUG�ر�
        union
        select RQ_REQ_NAME    ��������,
               RQ_REQ_TYPE    ��������,
               RQ_USER_07     ������,
               RQ_REQ_AUTHOR  ���󴴽�,
               RQ_USER_04     ����״̬,
               BG_DETECTED_BY ������Ա,
               RQ_USER_06     ������Ա,
               RQ_USER_02     �ƻ���ʼʱ��,
               RQ_USER_03     �ƻ�����ʱ��
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
           and BG_STATUS = '����'
        union
        select RQ_REQ_NAME    ��������,
               RQ_REQ_TYPE    ��������,
               RQ_USER_07     ������,
               RQ_REQ_AUTHOR  ���󴴽�,
               RQ_USER_04     ����״̬,
               RQ_USER_01     ������Ա,
               RQ_USER_06     ������Ա,
               RQ_USER_02     �ƻ���ʼʱ��,
               RQ_USER_03     �ƻ�����ʱ��
          from boss_bosstest0723_db.req
         where RQ_USER_04 = '7-����ر�'
            and to_char(to_date(RQ_USER_08, 'yyyy-mm-dd hh24:mi:ss'),
                     'yyyymmdd') = to_char(sysdate-1, 'yyyymmdd')
           and RQ_REQ_TYPE not in ('6-����Ŀ¼')) a,
       (select RQ_REQ_NAME ��������,
               count(distinct a.al_item_id) �������ܵ�,
               count(*) ��������,
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
       (select RQ_REQ_NAME ��������,
               count(*) ����ִ��,
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
       (select RQ_REQ_NAME ��������,
               count(*) ����ȱ��,
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
       (select RQ_REQ_NAME ��������,
               count(*) ȱ���޸�,
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
           and BG_STATUS = '�ѹر�'
         group by RQ_REQ_NAME, BG_DETECTED_BY) e,
       (select RQ_REQ_NAME ��������,
               count(*) ȱ������,
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
           and BG_STATUS = '�����޸�'
         group by RQ_REQ_NAME, BG_DETECTED_BY) f,
       (select RQ_REQ_NAME ��������,
               count(distinct a.al_description) ���ܵ�,
               sum(case nvl(d.TS_SUBJECT, 0)
                     when 0 then
                      0
                     else
                      1
                   end) �������,
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
           and rq_req_name =
               any(a.al_description, b.al_description, c.al_description)
         group by RQ_REQ_NAME) H,
       (select RQ_REQ_NAME ��������, count(*) ִ�кϼ�
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
       (select RQ_REQ_NAME ��������, count(*) ȱ�ݺϼ�
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
       (select RQ_REQ_NAME ��������, count(*) �޸�����
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
           and BG_STATUS = '�ѹر�'
         group by RQ_REQ_NAME) K
 where a.�������� = H.��������(+)
   and a.�������� = I.��������(+)
   and a.�������� = J.��������(+)
   and a.�������� = K.��������(+)
   and a.�������� = b.��������(+)
   and a.�������� = c.��������(+)
   and a.�������� = d.��������(+)
   and a.�������� = e.��������(+)
   and a.�������� = f.��������(+)
   and a.������Ա = b.user_name(+)
   and a.������Ա = c.user_name(+)
   and a.������Ա = d.user_name(+)
   and a.������Ա = e.user_name(+)
   and a.������Ա = f.user_name(+)) order by ʵ�ʿ�ʼʱ�� desc
