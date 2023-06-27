ALTER PACKAGE EBA_STDS_PARSER COMPILE PACKAGE; 
ALTER PACKAGE EBA_STDS_PARSER COMPILE BODY;
select * from table(ut.run('ut_ast_create_and_run_tests'));
/
Call params for test are not valid: procedure UT_CARS.SCH_REGISTRANT_DUPLICATE_MERGE_REGISTRANT_UT.MERGE_REGISTRANT_CHANGE_ALL_INFO does not exist.
*/
/
select * 
from all_objects
where object_name in('SCH_REGISTRANT_DUPLICATE_MERGE_REGISTRANT_UT', 'EBA_STDS_PARSER','UTT_COMMON_PKG')
/
drop package SCH_REGISTRANT_DUPLICATE_MERGE_REGISTRANT_UT
/
set serveroutput on
declare
l_start      timestamp with local time zone;
l_duration   interval day to second;
l_dur_ms     number;
begin
l_start := localtimestamp;
dbms_output.put_line(l_start);
dbms_session.sleep(3);
l_duration := localtimestamp - l_start;
dbms_output.put_line(l_duration);
l_dur_ms := extract(   day from l_duration) * 24*60*60*1000
          + extract(  hour from l_duration) * 60*60*1000
          + extract(minute from l_duration) * 60*1000
          + extract(second from l_duration) * 1000;
dbms_output.put_line(l_dur_ms);
end;
/
select * 
from all_tab_cols
where owner = 'APEX_200100'
and column_name like '%SESSION%'
and column_name in ('MAXIMUM_SESSION_LIFE_SECONDS','MAXIMUM_SESSION_IDLE_SECONDS')
/
select workspace, MAXIMUM_SESSION_LIFE_SECONDS,MAXIMUM_SESSION_IDLE_SECONDS
from APEX_WORKSPACES
where workspace = 'COVID_CARS'
/
select  aa.workspace, 
        aa.application_id, 
        aa.application_name, 
        coalesce(aa.maximum_session_idle_seconds, aw.maximum_session_idle_seconds) maximum_session_idle_seconds,
        coalesce(aa.maximum_session_life_seconds, aw.maximum_session_life_seconds) maximum_session_life_seconds
from apex_applications aa
inner join apex_workspaces aw on aa.workspace = aw.workspace
where aa.application_id = 713000 --between 700000 and 799999
order by aa.application_id
/
select * 
from v_ast_apex_valid_col_links
where pass_fail = 'N'
/
select * 
from apex_application_pages
where application_id = 17000700
and page_id = 13
/
select 
eba_stds_parser.is_valid_url (p_origin_app_id => prc.application_id,
                              p_url           => prc.column_link_url
                              ) pass_fail,
apex_string.format('%0:%1', prc.application_id, prc.region_id) reference_code,
prc.application_id,
prc.region_name,
prc.page_id,
prc.page_name,
prc.heading
from  apex_application_page_rpt_cols prc 
inner join apex_applications aa on  aa.application_id = prc.application_id
                                and aa.availability_status != 'Unavailable'
order by aa.application_id, prc.region_id, prc.column_link_url
/
select * 
from v_ast_db_plsql_all
/
select eba_stds_parser.default_app_id() application_id
   from dual
/
select * 
from apex_applications
where application_id =  17000033    
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
    and application_id = 261
    AND page_id = 19
    AND message LIKE '%eba_stds_parser%'
   -- and session_id = 8872292222130
   and id > 22894756000
ORDER BY message_timestamp DESC
/
select * 
from v_ast_apex_valid_link_buttons
where pass_fail = 'N'
/
select * 
from apex_application_pages
where application_id = 750110   
and page_id = 10022
/
select button_name,  label, region, page_name
from apex_application_page_buttons
/
set serveroutput on
begin
  apex_session.create_session(p_app_id=>261,p_page_id=>19,p_username=>'HAYHUDSO');   
    
  apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace); --c_log_level_info); 

  dbms_output.put_line('To view debug messages:');
  dbms_output.put_line('select * from apex_debug_messages where session_id = '
    ||apex_util.get_session_state('APP_SESSION') ||' order by message_timestamp');

end;
/
/
select * 
from apex_application_pages
where application_id = 109
and page_alias = 'HOME'
/
select * 
from v_ast_apex_valid_list_links
where pass_fail = 'N'
/
select * 
from apex_application_pages 
where application_id = 898
/
select ale.entry_target
, eba_stds_parser.is_valid_url (p_origin_app_id => ale.application_id, p_url => ale.entry_target) is_valid
from apex_application_list_entries ale
where 1=1
--and ale.entry_target not like 'f?p=&APP_ID.%'
--and ale.entry_target not in ('#')
--and ale.entry_target like 'f?p=%'
and ale.application_id  = 261
and rownum < 1000
order by ale.entry_target

/
select * 
from apex_application_pages
where application_id  = 261
and page_access_protection != 'No URL Access'
and page_id = 1
/
select count(*)
            from sys.dual where exists (
                select application_id 
                from apex_applications 
                where availability_status != 'Unavailable'
             --   and application_id = p_app_id;
            )
