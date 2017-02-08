/****≤‚ ‘–Ë«Û÷ÿ∏¥ºÏ≤È*****/ 
select count(*), rq_req_name 
  from boss_bosstest0723_db.req 
 group by rq_req_name 
having count(*) > 1; 
/****≤‚ ‘º∆ªÆ÷ÿ∏¥ºÏ≤È****/ 
select count(*), AL_DESCRIPTION ,b.RQ_USER_01 
 from boss_bosstest0723_db.all_lists a, boss_bosstest0723_db.req b 
 where a.al_description=b.rq_req_name 
 group by AL_DESCRIPTION,b.RQ_USER_01 
having count(*) > 1 ; 
/*******–Ë«Û∏≤∏«ºÏ≤È*********/ 
 select rq_req_id, 
       d.ts_test_id 
  from BOSS_BOSSTEST0723_DB.ALL_LISTS a, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS b, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS c, 
       BOSS_BOSSTEST0723_DB.TEST      d, 
       BOSS_BOSSTEST0723_DB.req       e, 
       boss_bosstest0723_db.req_cover f 
 where d.TS_SUBJECT = a.al_item_id 
   and b.al_item_id = a.AL_FATHER_ID 
   and c.al_item_id = b.AL_FATHER_ID 
   and rq_req_name = 
       any(a.al_description, b.al_description, c.al_description) 
   and d.ts_test_id = f.rc_entity_id 
   and  f.rc_entity_type='TEST' 
    and  rq_req_id<>f.rc_req_id; 
 select rq_req_id, 
       d.ts_test_id 
  from BOSS_BOSSTEST0723_DB.ALL_LISTS a, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS b, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS c, 
       BOSS_BOSSTEST0723_DB.TEST      d, 
       BOSS_BOSSTEST0723_DB.req       e, 
       boss_bosstest0723_db.req_cover f 
 where d.TS_SUBJECT = a.al_item_id 
   and b.al_item_id = a.AL_FATHER_ID 
   and c.al_item_id = b.AL_FATHER_ID 
   and rq_req_name = 
       any(a.al_description, b.al_description, c.al_description) 
   and d.ts_test_id = f.rc_entity_id 
   and  f.rc_entity_type='TEST' 
    and f.rc_entity_id is null; 
/********≤‚ ‘»±œ›ºÏ≤È**********/ 

select c.al_description,a.* 
  from boss_bosstest0723_db.bug a, boss_bosstest0723_db.link b,boss_bosstest0723_db.all_lists c 
 where a.bg_bug_id=b.ln_bug_id(+) 
   and a.Bg_user_01 <> '6-QTP≤‚ ‘»±œ›' 
   and a.bg_subject=c.al_item_id(+) 
   and b.ln_bug_id is null; 
select * 
 from boss_bosstest0723_db.bug   a,boss_bosstest0723_db.link b 
where a.bg_bug_id = b.ln_bug_id(+) 
and LN_ENTITY_TYPE(+) = 'STEP' 
and bg_detection_date>to_date('20090326','yyyymmdd') 
and LN_ENTITY_TYPE(+) is null; 
select a.bg_bug_id,c.st_step_name,e.ts_name,f.al_description,i.rq_req_name 
  from boss_bosstest0723_db.bug       a, 
       boss_bosstest0723_db.link      b, 
       boss_bosstest0723_db.step      c, 
       boss_bosstest0723_db.dessteps d, 
       boss_bosstest0723_db.test      e, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS f, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS g, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS h, 
       BOSS_BOSSTEST0723_DB.req       i 
 where a.bg_bug_id = b.ln_bug_id 
   and a.Bg_user_01 <> '6-QTP≤‚ ‘»±œ›' 
   and c.st_id = b.ln_entity_id 
   and c.st_test_id = d.ds_test_id 
   and c.st_desstep_id = d.ds_id 
   and d.ds_test_id=e.ts_test_id 
   and e.TS_SUBJECT = f.al_item_id 
   and g.al_item_id = f.AL_FATHER_ID 
   and h.al_item_id = g.AL_FATHER_ID 
   and i.rq_req_name = 
      any(f.al_description, g.al_description, h.al_description) 
   and LN_ENTITY_TYPE = 'STEP'; 
    
select a.bg_bug_id,c.st_step_name,e.ts_name,f.al_description,i.rq_req_name 
  from boss_bosstest0723_db.bug       a, 
       boss_bosstest0723_db.link      b, 
       boss_bosstest0723_db.step      c, 
       boss_bosstest0723_db.dessteps d, 
       boss_bosstest0723_db.test      e, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS f, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS g, 
       BOSS_BOSSTEST0723_DB.ALL_LISTS h, 
       BOSS_BOSSTEST0723_DB.req       i 
 where a.bg_bug_id = b.ln_bug_id 
   and a.Bg_user_01 <> '6-QTP≤‚ ‘»±œ›' 
   and c.st_id = b.ln_entity_id 
   and c.st_test_id = d.ds_test_id 
   and c.st_desstep_id = d.ds_id 
   and d.ds_test_id=e.ts_test_id 
   and e.TS_SUBJECT = f.al_item_id 
   and g.al_item_id = f.AL_FATHER_ID 
   and h.al_item_id = g.AL_FATHER_ID 
   and i.rq_req_name = 
      any(f.al_description, g.al_description, h.al_description) 
   and LN_ENTITY_TYPE = 'TEST';
