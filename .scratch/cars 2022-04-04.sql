select * from table(ut.run('eba_stds_parser_app_from_url_ut'));
 alter package eba_stds_parser_app_from_url_ut compile;
 alter package eba_stds_parser compile;
/
select 
eba_stds_parser.is_valid_url (p_origin_app_id => bl.application_id,
                              p_url           => bl.redirect_url
                              ) pass_fail
from apex_application_page_buttons bl
inner join apex_applications aa1 on bl.application_id = aa1.application_id
                                 and aa1.availability_status != 'Unavailable'
order by bl.application_id, bl.page_id, bl.redirect_url
;
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
--and application_id = 261
  --  AND page_id = 19
    AND message LIKE '%eba_stds_parser%'
    and id > 23065753104
ORDER BY message_timestamp DESC
/
/
set serveroutput on
begin
  apex_session.create_session(p_app_id=>17000033,p_page_id=>19,p_username=>'HAYHUDSO');   
    
  apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace); --c_log_level_info); 

  dbms_output.put_line('To view debug messages:');
  dbms_output.put_line('select * from apex_debug_messages where session_id = '
    ||apex_util.get_session_state('APP_SESSION') ||' order by message_timestamp');

end;
/
 /
select * 
from v_ast_db_utplsql_package_naming
/
select case when count(*) = 1
                                then 'Y'
                                else 'N'
                                end --into l_valid_app_and_page_yn
                from sys.dual where exists (
                    select aap.page_id 
                    from apex_application_pages aap
                    inner join apex_applications aa on aa.application_id = aap.application_id 
                    where aap.page_access_protection != 'No URL Access'
                    and aa.availability_status != 'Unavailable'
                    and aap.application_id = :l_application_id --17000033
                    and aap.page_id  = :l_page_id -- 0
                );
/
select eba_stds_parser.is_valid_url(p_origin_app_id => 123,
                                           p_url => 'f?p=STANDARDS:HOME')
                                           from dual
/
set define off
select eba_stds_parser.page_from_url ( p_origin_app_id => 123,
                                                   p_url => 'f?p=&APP_ID.:#:&SESSION.::&DEBUG.::::')
                                                   from dual;
/
with deflt as (
   select eba_stds_parser.default_app_id() application_id
   from dual)
select 
case when ao.owner != 'UT_CARS'
     then 'N'
     else case when ap.object_name is not null
               then 'Y'
               else 'N'
               end
     end pass_fail,
apex_string.format('%0:%1:%2:%3', deflt.application_id, ao.object_name, ao.object_type, 1) reference_code,
deflt.application_id,
ao.owner, ao.object_name    
from all_objects ao
left join all_procedures ap on ap.object_name||'_'||ap.procedure_name||'_UT' = ao.object_name
cross join deflt
where ao.object_name like '%\_UT' escape '\'
and ao.object_type = 'PACKAGE'
order by ao.owner, ao.object_name
;
/
select 
case when ao.owner != 'UT_CARS'
     then 'N'
     else case when ap.object_name is not null
               then 'Y'
               else 'N'
               end
     end pass_fail,
ao.owner, ao.object_name    
from all_objects ao
left join all_procedures ap on ap.object_name||'_'||ap.procedure_name||'_UT' = ao.object_name
where ao.object_name like '%\_UT' escape '\'
and ao.object_type = 'PACKAGE'
order by ao.owner, ao.object_name
/
select * 
from all_procedures
where object_name = 'eba_stds_parser_app_from_url_ut' collate binary_ci
/
select * from dba_objects where object_name like 'S\_%' escape '\';
/
select DISTINCT table_name
from all_tab_cols
where table_name LIKE 'ALL_%'
--and table_name like '%PACK%'
and owner = 'SYS'
order by table_name
/
select * from table(ut.run('eba_stds_parser_app_from_url_ut'));
alter package eba_stds_parser_app_from_url_ut compile;
alter package EBA_STDS_PARSER compile;
 /
 drop package eba_stds_app_from_url_ut
 /
 select application_id
   -- into l_application_id
    from apex_applications 
    where alias = 'STANDARDS';
/
select * 
from v_eba_stds_parsed_urls
/
select
    prc.application_id,
    prc.application_name,
    'COLUMN_URL' as url_type,
    prc.column_link_url element_url,
    prc.region_report_column_id as element_id,
    prc.heading element_label,
    prc.column_alias element_name,
    prc.authorization_scheme element_authorization,
    prc.region_id parent_element_id,
    prc.region_name parent_element_name,
    apr.authorization_scheme parent_element_authorization,
    prc.page_id,
    prc.page_name,
    pg.authorization_scheme as page_authorization_scheme,
    eba_stds_parser.app_from_url ( p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_app_id,
    eba_stds_parser.page_from_url (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_page_id
from  apex_application_page_rpt_cols prc
inner join apex_application_page_regions apr on prc.region_id = apr.region_id
inner join apex_application_pages pg on prc.page_id = pg.page_id
where prc.column_link_url is not null
/
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
--and application_id = 261
  --  AND page_id = 19
    AND message LIKE '%eba_stds_parser%'
    and message like '%Unhandled Exception%'
    and id > 23061751000
ORDER BY message_timestamp DESC
/
/
set serveroutput on
begin
  apex_session.create_session(p_app_id=>17000033,p_page_id=>19,p_username=>'HAYHUDSO');   
    
  apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace); --c_log_level_info); 

  dbms_output.put_line('To view debug messages:');
  dbms_output.put_line('select * from apex_debug_messages where session_id = '
    ||apex_util.get_session_state('APP_SESSION') ||' order by message_timestamp');

end;
/

/
set define off
/
/
select destination_app_id, destination_page_id, count(*)
from v_eba_stds_parsed_urls
group by destination_app_id, destination_page_id
/
--create or replace force view v_eba_stds_parsed_urls as
with
    function app_from_url ( p_origin_app in apex_applications.application_id%type,
                            p_url        in varchar2) return apex_applications.application_id%type
    is 
    l_url_params         apex_t_varchar2;
    l_destination_app_id apex_applications.application_id%type;
    begin
        l_url_params := apex_string.split(p_url,':',2);
        
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'f?p=%'
                    then case when l_url_params(1) like 'f?p=&APP_ID.%'
                              then p_origin_app
                              when l_url_params(1) like 'f?p=&%'
                              then null
                              when l_url_params(1) like 'f?p=#%'
                              then null
                              else substr(l_url_params(1),5)
                              end
                    else null
                    end;
    end app_from_url;
    function page_from_url (p_url in varchar2) return apex_application_pages.page_id%type
    is 
    l_url_params          apex_t_varchar2;
    l_destination_page_id apex_application_pages.page_id%type;
    
    e_subscript_beyond_count exception;
    pragma exception_init(e_subscript_beyond_count, -6533);
    e_not_a_number exception;
    pragma exception_init(e_not_a_number, -6502);
    begin
        l_url_params := apex_string.split(p_url,':',3);
        
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'f?p=%'
                    then l_url_params(2)
                    else null
                    end;
    exception 
        when e_subscript_beyond_count then return null;
        when e_not_a_number then return 'NAN';
    end page_from_url;
select
prc.application_id,
prc.application_name,
'COLUMN_URL' as url_type,
prc.column_link_url element_url,
prc.region_report_column_id as element_id,
prc.heading element_label,
prc.column_alias element_name,
prc.authorization_scheme element_authorization,
prc.region_id parent_element_id,
prc.region_name parent_element_name,
apr.authorization_scheme parent_element_authorization,
prc.page_id,
prc.page_name,
app_from_url ( p_origin_app => prc.application_id, p_url => prc.column_link_url) destination_app_id,
page_from_url (p_url => prc.column_link_url) destination_page_id
from  apex_application_page_rpt_cols prc
inner join apex_application_page_regions apr on prc.region_id = apr.region_id
where prc.column_link_url is not null
union all
select 
bl.application_id, 
bl.application_name,
'BUTTON_URL' as url_type,
bl.redirect_url as element_url,
bl.button_id as element_id,
bl.label as element_label, 
bl.button_name as element_name, 
bl.authorization_scheme as element_authorization,
bl.region_id as parent_element_id,
bl.region as parent_element_name,
apr.authorization_scheme parent_element_authorization,
bl.page_id,
bl.page_name,
app_from_url ( p_origin_app => bl.application_id, p_url => bl.redirect_url) destination_app_id,
page_from_url (p_url => bl.redirect_url) destination_page_id
from apex_application_page_buttons bl
inner join apex_application_page_regions apr on bl.region_id = apr.region_id
where bl.redirect_url is not null
union all
select 
ale.application_id, 
ale.application_name,
'LIST_ENTRY' url_type,
ale.entry_target as element_url,
ale.list_entry_id as element_id,
ale.entry_text as element_label,
ale.entry_text as elemenet_name, 
ale.authorization_scheme as element_authorization,
ale.list_id as parent_element_id, 
ale.list_name as parent_element_name,
null as parent_element_authorization,
null as page_id,
null as page_name,
app_from_url ( p_origin_app => ale.application_id, p_url => ale.entry_target) destination_app_id,
page_from_url (p_url => ale.entry_target) destination_page_id
from apex_application_list_entries ale
where ale.entry_text is not null
/
select *
from all_tab_cols
where table_name LIKE '%APEX_APPLICATION_LISTS%'
--and column_name like '%AUTH%'
and owner = 'APEX_200100'
/
select authorization_scheme
from APEX_APPLICATION_PAGE_REGIONS
/
select *
from APEX_APPLICATION_LISTS
/
with
    function app_from_url ( p_origin_app in apex_applications.application_id%type,
                            p_url        in varchar2) return apex_applications.application_id%type
    is 
    l_url_params         apex_t_varchar2;
    l_destination_app_id apex_applications.application_id%type;
    begin
        l_url_params := apex_string.split(p_url, ':',2);
        
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'f?p=%'
                    then case when l_url_params(1) like 'f?p=&APP_ID.%'
                              then p_origin_app
                              when l_url_params(1) like 'f?p=&%'
                              then null
                              when l_url_params(1) like 'f?p=#%'
                              then null
                              else substr(l_url_params(1),5)
                              end
                    else null
                    end;
    end app_from_url;
    
    function page_from_url (p_url in varchar2) return apex_application_pages.page_id%type
    is 
    l_url_params          apex_t_varchar2;
    l_destination_page_id apex_application_pages.page_id%type;
    
    e_subscript_beyond_count exception;
    pragma exception_init(e_subscript_beyond_count, -6533);
    e_not_a_number exception;
    pragma exception_init(e_not_a_number, -6502);
    begin
        l_url_params := apex_string.split(p_url, ':',3);
        
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'f?p=%'
                    then l_url_params(2)
                    else null
                    end;
    exception 
        when e_subscript_beyond_count then return null;
        when e_not_a_number then return null;
    end page_from_url;
select ale.application_id, ale.application_name
, 'LIST_ENTRY' url_type
, ale.entry_target as element_url
, ale.list_entry_id as element_id
, ale.entry_text as element_label
, ale.list_id as parent_element_id
, ale.list_name as parent_element_name
, app_from_url ( p_origin_app => ale.application_id, p_url => ale.entry_target) destination_app_id
, page_from_url (p_url => ale.entry_target) destination_page_id
from apex_application_list_entries ale
where ale.entry_text is not null
/
