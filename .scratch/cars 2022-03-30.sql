set define off
select * 
from v_ast_apex_valid_list_links
/
select aap1.application_id, aap1.page_id, aap1.page_name
, apb.page_id button_page_id, apb.button_name
, apb.authorization_scheme button_authorization
, aap2.authorization_scheme button_page_authorization
, prc.page_id column_page_id, prc.region_name column_region_name, prc.heading column_heading
, prc.authorization_scheme column_authorization
, aap3.authorization_scheme column_page_authorization
from apex_application_pages aap1
inner join eba_stds_applications esa on aap1.application_id = esa.apex_app_id
left join apex_application_page_buttons apb on aap1.application_id = apb.application_id
                                            and apb.redirect_url like 'f?p=&APP_ID.:'||aap1.page_id||':%'
left join apex_application_pages aap2 on  aap2.application_id = apb.application_id
                                      and apb.page_id = aap2.page_id
left join APEX_APPLICATION_PAGE_RPT_COLS prc on  aap1.application_id = prc.application_id
                                             and prc.column_link_url like 'f?p=&APP_ID.:'||aap1.page_id||':%'
left join apex_application_pages aap3 on  aap3.application_id = prc.application_id
                                      and prc.page_id = aap3.page_id
where aap1.authorization_scheme is null
and aap1.page_id not in (0,101,9999)
order by aap1.application_id, aap1.page_id desc
/
select application_id, button_id, redirect_url, ru.column_value
        from apex_application_page_buttons apb
        cross join table(apex_string.split(apb.redirect_url,':',3)) ru
        where ru.column_value 
        order by  apb.application_id, apb.button_id, apb.redirect_url
/
select
        le.application_id, 
        le.application_name,
        le.list_name,
        le.list_id, 
        le.list_entry_parent_id,
        le.list_entry_id,
        le.display_sequence,
        le.entry_target, 
        substr(et.column_value, 5) target_app_id,
        le.entry_text
        from apex_application_list_entries le
        cross join table(apex_string.split(le.entry_target,':',2)) et 
        where et.column_value like 'f?p=%'
        and et.column_value not like 'f?p=&%'
/
with blinks as (
        select application_id, redirect_url,  substr(ru.column_value, 5) target_app_id
        from apex_application_page_buttons apb
        cross join table(apex_string.split(apb.redirect_url,':')) ru
        where apb.redirect_url like 'f?p=%'
        and ru.column_value like 'f?p=%'
        and ru.column_value not like 'f?p=&%'
        and ru.column_value not like 'f?p=DATAHUB_PORTAL%')
select 
case when aa2.availability_status = 'Unavailable'
     then 'N'
     when aa2.availability_status is null 
     then 'N'
     else 'Y'
     end as pass_fail,
bl.application_id, bl.redirect_url, bl.target_app_id
from blinks bl
inner join apex_applications aa1 on bl.application_id = aa1.application_id
                                 and aa1.availability_status != 'Unavailable'
left join apex_applications aa2 on bl.target_app_id = aa2.application_id
/
select * 
from APEX_APPLICATION_PAGE_RPT_COLS aapr
where aapr.COLUMN_LINK_URL is not null
and aapr.application_id = 261
/
/
select * 
from all_tab_cols
where 1=1
--and table_name like '%BUTTON%'
and column_name like '%LINK%'
and table_name not like 'WWV%'
and column_name not in ('AUTODETECT_JS_FILE_URLS',
'LOGIN_URL',
'JAVASCRIPT_FILE_URLS',
'UI_DETECTION_CSS_URLS',
'LOGOUT_URL',
'FRIENDLY_URL',
'SESSION_LIFETIME_EXCEEDED_URL',
'SESSION_IDLE_TIME_EXCEEDED_URL',
'HOME_URL',
'LOGIN_URL',
'JAVASCRIPT_FILE_URLS',
'CSS_FILE_URLS',
'COMBINED_FILE_URL',
'SINGLE_FILE_URLS',
'ON_DUP_SUBMISSION_GOTO_URL',
'JAVASCRIPT_FILE_URLS',
'CSS_FILE_URLS',
'INVALID_SESSION_URL',
'CUSTOM_LIBRARY_FILE_URLS',
'THEME_ROLLER_INPUT_FILE_URLS',
'THEME_ROLLER_OUTPUT_FILE_URL',
'ABOUT_URL',
'BASE_URL',
'URL_ENDPOINT',
'AUTH_URL_ENDPOINT',
'URL_PATTERN')
and table_name not in ('APEX_APPLICATION_PAGE_BUTTONS','APEX_APPLICATION_PAGE_REGIONS')
and owner = 'APEX_200100'
/

set define off
select aap1.page_id, aap1.page_name
--, apb.page_id, apb.redirect_url
, apb.authorization_scheme button_authorization
, aap2.authorization_scheme button_page_authorization
from apex_application_pages aap1
left join apex_application_page_buttons apb on aap1.application_id = apb.application_id
                                            and apb.redirect_url like 'f?p=&APP_ID.:'||aap1.page_id||':%'
left join apex_application_pages aap2 on   aap2.application_id = apb.application_id
                                      and apb.page_id = aap2.page_id
where aap1.application_id  = 261
order by aap1.page_id
/
select *
from APEX_APPLICATION_PAGE_BUTTONS
/
select * --aa.application_id||'. '||aa.application_name d, aa.application_id r
from eba_stds_standard_tests st
inner join eba_stds_standard_type_ref str on str.standard_id = st.standard_id
inner join eba_stds_applications a on a.type_id = str.type_id
inner join apex_applications aa on aa.application_id = a.apex_app_id
where 1=1
and st.id = :P19_TEST_ID --290954809810139744673844516645939858254
and aa.application_id = 261
order by aa.application_id
/
select * 
from eba_stds_applications a 
inner join eba_stds_standard_type_ref str on a.type_id = str.type_id
inner join apex_applications aa on aa.application_id = a.apex_app_id
inner join eba_stds_standard_tests st on str.standard_id = st.standard_id
where apex_app_id = 261 
and st.id = :P19_TEST_ID --290954809810139744673844516645939858254
/
select * 
from eba_stds_standard_tests st
where st.id = :P19_TEST_ID --290954809810139744673844516645939858254
/
select * 
from v_ast_apex_valid_list_links
where ref_count > 1
/
with tapps as (
        select
        le.application_id, 
        le.application_name,
        le.list_name,
        le.list_id, 
        le.list_entry_parent_id,
        le.list_entry_id,
        le.display_sequence,
        le.entry_target, 
        substr(et.column_value, 5) target_app_id,
        le.entry_text
        from apex_application_list_entries le
        cross join table(apex_string.split(le.entry_target,':')) et 
        where et.column_value like 'f?p=%'
        and et.column_value not like 'f?p=&%'
        ),
    plug_link_count as (
        select pl.list_id, count(*) lcount
            from APEX_APPLICATION_PAGE_REGIONS PL --apex_200100.wwv_flow_page_plugs pl
            group by pl.list_id
        ),
    nav_link_count as (
        select ui.navigation_list_id, count(*) lcount
            from apex_appl_user_interfaces ui
            group by ui.navigation_list_id
        ),
    nav_bar_link_count as (
        select ui.nav_bar_list_id, count(*) lcount
            from apex_appl_user_interfaces ui
            group by ui.nav_bar_list_id
        )
select
case when aa2.availability_status = 'Unavailable'
     then 'N'
     when aa2.availability_status is null 
     then 'N'
     else 'Y'
     end as pass_fail,
apex_string.format('%0:%1:%2', t.application_id, t.list_id, t.list_entry_id) reference_code,
t.application_id, 
t.entry_target, 
t.target_app_id, 
aa2.availability_status target_app_status, 
t.list_name,
t.list_id, 
t.list_entry_id,
t.entry_text,
coalesce(plc.lcount,0) + coalesce(nlc.lcount,0) + coalesce(nblc.lcount,0)  ref_count
from tapps t
inner join apex_applications aa1 on t.application_id = aa1.application_id
                                 and aa1.availability_status != 'Unavailable'
left join apex_applications aa2 on t.target_app_id = aa2.application_id
left join plug_link_count plc on plc.list_id = t.list_id
left join nav_link_count nlc on nlc.navigation_list_id = t.list_id
left join nav_bar_link_count nblc on nblc.nav_bar_list_id = t.list_id
where t.application_id  = 261
--AND T.list_id = 3856369729810501628
;
/
select *
from apex_200100.wwv_flow_user_interfaces ui
where flow_id = 261
and navigation_list_id = 3856369729810501628
--and id = 5481301517634224211
/
select * 
from (
        select ui.navigation_list_id, count(*) lcount
            from APEX_APPL_USER_INTERFACES ui --apex_200100.wwv_flow_user_interfaces ui
            group by ui.navigation_list_id
        ) where navigation_list_id = 3856369729810501628
/
select * 
from apex_application_lists
where application_id = 261
and navigation_id = 
/
select *
from all_tab_cols
where 1=1
--AND table_name like '%PLUG%'
and table_name not in ('WWV_FLOW_PAGE_PLUGS','WWV_FLOW_USER_INTERFACES','APEX_APPLICATION_PAGES','APEX_APPL_USER_INTERFACES')
--and table_name != 'WWV_FLOW_USER_INTERFACES'
--and table_name not like 'WWV%'
and column_name like '%LIST_ID%'
and owner = 'APEX_200100'
/
select * 
from APEX_APPLICATION_PAGE_REGIONS
where list_id is not null
and application_id = 261
/
select * 
from APEX_200100.WWV_FLOW_PAGE_PLUGS pl
inner join apex_application_list_entries le on le.list_id = pl.list_id;
/
select NAVIGATION_LIST_ID
from APEX_APPLICATION_PAGES
/
select count(*)
           from APEX_200100.wwv_flow_page_plugs p
          where p.list_id           = :lid
            and p.flow_id           = :lflow_id
            and p.security_group_id = :lsecurity_group_id 
/
select count(*)
           from APEX_200100.wwv_flow_steps s
          where s.navigation_list_id = :lid
            and s.flow_id            = :lflow_id
            and s.security_group_id  = :lsecurity_group_id 
/

/
          where :lid                 in (ui.navigation_list_id, ui.nav_bar_list_id)
            and ui.flow_id            = :lflow_id
            and ui.security_group_id  = :lsecurity_group_id
/
select /* APEX 4000P405a */ id,
       l.name name,
      (select count(*) from wwv_flow_list_items where list_id = l.id) entries,
      ( select count(*)
           from wwv_flow_page_plugs p
          where p.list_id           = l.id
            and p.flow_id           = l.flow_id
            and p.security_group_id = l.security_group_id ) +
       ( select count(*)
           from wwv_flow_steps s
          where s.navigation_list_id = l.id
            and s.flow_id            = l.flow_id
            and s.security_group_id  = l.security_group_id ) +
       ( select count(*)
           from wwv_flow_user_interfaces ui
          where l.id                 in (ui.navigation_list_id, ui.nav_bar_list_id)
            and ui.flow_id            = l.flow_id
            and ui.security_group_id  = l.security_group_id ) as ref,
       --
       coalesce(l.last_updated_on,l.created_on) list_last_updated,
       --
       decode(substr(list_query,1,1),null,system_message."STATIC",decode(substr(upper(list_query),1,6),'STATIC',
          system_message."STATIC",system_message."DYNAMIC")) list_type,
       --
      (select PATCH_NAME
         from WWV_FLOW_PATCHES p
        where security_group_id = :flow_security_group_id
          and flow_id = :fb_flow_id and p.id = l.REQUIRED_PATCH) build_option,
       --
       LIST_COMMENT,
       flow_id appliation_id,
       'icon-sc-list' icon_class,
       replace(replace(l.name,'_',' '),'.',' ') icon_title,
       --
       'f?p=&APP_ID.:4050:'||:app_session||'::NO:4050:F4000_P4050_LIST_ID:'||id edit_link,
       --
      (select decode(count(nav_bar_list_id),0,'N','Y') from wwv_flow_user_interfaces where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and nav_bar_list_id = l.id) navbar,
       --
      (select decode(count(nav_bar_list_id),0,0,1) from wwv_flow_user_interfaces where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and nav_bar_list_id = l.id) is_navbar,
       --
       case
         when exists (select 1 from wwv_flow_user_interfaces where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and navigation_list_id = l.id) then 'Y'
         when exists (select 1 from wwv_flow_steps where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and navigation_list_id = l.id) then 'Y'
         else 'N'
       end global_nav,
       --
       case
         when exists (select 1 from wwv_flow_user_interfaces where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and navigation_list_id = l.id) then 1
         when exists (select 1 from wwv_flow_steps where flow_id = :fb_flow_id and security_group_id = :flow_security_group_id and navigation_list_id = l.id) then 1
         else 0
       end is_navmenu
from   APEX_200100.wwv_flow_lists l,
      (select wwv_flow_lang.system_message('F4000.DYNAMIC') "DYNAMIC",
              wwv_flow_lang.system_message('F4000.STATIC') "STATIC",
              wwv_flow_lang.system_message('NO') n, wwv_flow_lang.system_message('YES') y
         from sys.dual) system_message
where  l.flow_id = :fb_flow_id
and    l.security_group_id = :flow_security_group_id
/
select * 
from APEX_200100.wwv_flow_lists
/
select * 
from apex_application_lists
/
delete
      from eba_stds_applications
      where type_id  = (select id from eba_stds_types where name = :gc_dummy_name);
delete
      from eba_stds_standards 
      where name  = :gc_dummy_name;
delete from eba_stds_types
      where name = :gc_dummy_name;
DELETE
      from eba_stds_standard_tests 
      where name = :gc_dummy_name;