select 
case when nav_bar_list_template = 'OHMS Accessible Navigation Bar'
     then 'Y'
     else 'N'
     end as pass_fail,
application_id reference_code,
application_id,
       display_name user_interface,
       nav_bar_type,
       decode(
         nav_bar_type,
         'LIST', 'u-success',
       'u-danger') nav_bar_type_class,
       nav_bar_list_template,
       nav_bar_list,
       nav_bar_template_options
  from apex_appl_user_interfaces
 where 1=1
 --and nvl(nav_bar_list_template,'NULL') != 'OHMS Accessible Navigation Bar'
/
select * 
from apex_appl_user_interfaces
/
select * 
from apex_application_themes
where theme_id = (select reference_id
                    from apex_application_themes
                    where application_id = 17000103)
/
with master_sub as (
        select eba_stds_parser.accessibility_app_id() application_id
            from dual),
     master_templates as (
        select count(*) template_count
            from apex_application_templates aat
            cross join master_sub ms
            where aat.application_id = ms.application_id)
/
with templates as (
    select tp.application_id, count(*) template_count
        from apex_application_templates tp
        inner join apex_application_themes th on tp.application_id = th.application_id
                                              and tp.theme_number = th.theme_number
                                              and th.is_current = 'Yes'
        group by tp.application_id)
select 
case when t1.template_count = t2.template_count
     then 'Y'
     else 'N'
     end as pass_fail,
ath1.application_id reference_code, 
ath1.application_id, 
t1.template_count, 
ath2.application_id master_application_id, 
t2.template_count master_template_count
from apex_application_themes ath1
inner join templates t1 on ath1.application_id = t1.application_id
inner join apex_application_themes ath2 on ath1.reference_id = ath2.theme_id
                                        and ath1.workspace = ath2.workspace
inner join templates t2 on ath2.application_id = t2.application_id
where ath1.is_current = 'Yes'
/
select count(*)
from apex_application_templates tp
inner join apex_application_themes th on tp.application_id = th.application_id
                                      and tp.theme_number = th.theme_number
                                      and th.is_current = 'Yes'
where tp.application_id = 17001800
--group by is_subscribed
/
select * 
from apex_application_themes
where application_id = 17001800
/
select application_id, application_name
  from (select application_id,
               application_name,
               (select count(*)
                  from (select aat.internal_name
                            from apex_application_templates aat
                            cross join master_sub ms
                            where aat.application_id = ms.application_id
                        minus
                        select internal_name
                            from apex_application_templates
                            where application_id = a.application_id
                       ) -- end of minus
               ) missing_templates -- end of cound from minus
          from apex_applications a
          )
 where missing_templates > 0
 order by application_id  
 /
with master_sub as (
   select eba_stds_parser.accessibility_app_id() application_id
   from dual)
select 
case when t2.application_id = ms.application_id
     then 'Y'
     else 'N'
     end as pass_fail,
t1.application_id reference_code,
t1.application_id,
t1.workspace,
ms.application_id
from apex_application_themes t1
cross join master_sub ms
left join apex_application_themes t2 on t1.reference_id = t2.theme_id
where t1.is_current = 'Yes'
and   t1.application_id != ms.application_id
/
set serveroutput on
declare
l_pass boolean;
l_sql clob;
l_feedback varchar2(4000);
begin

eba_stds_parser.validate_view( p_view_name => :P14_QUERY_VIEW,
                               x_view_sql  => l_sql,
                               x_feedback  => l_feedback,
                               x_pass      => l_pass);
if l_pass then 
dbms_output.put_line('passed :'||l_feedback);
else
dbms_output.put_line('fd :'||l_feedback);
end if;
end;
/
select * 
from v_ast_apex_accessibility_theme_subscription
/
select t1.workspace,
   t1.application_id,
   case when t2.application_id = 800042
        then 'Y'
        else 'N'
        end as pass_fail
from apex_application_themes t1
left join apex_application_themes t2 on t1.reference_id = t2.theme_id
where t1.is_current = 'Yes'
and   t1.application_id != 800042
/
select application_id, reference_id, theme_id
from apex_application_themes
where 1=1
--and application_id  = 100
and reference_id is not null
/
select * 
from apex_applications
where application_id in (800042,8842)
/
select s.test_id, s.pass_fail_pct,
case when t.test_type = 'PASS_FAIL'
                 then case when s.pass_fail_pct < 100
                           then 'show'
                           else 'hide'
                           end
                 else 'hide'
                 end as validation_show_hide
from 
    eba_stds_standard_statuses s join eba_stds_applications a on a.id = s.application_id
    inner join eba_stds_standard_tests t on t.id = s.test_id and t.standard_id = s.standard_id
    inner join eba_stds_applications ea on s.application_id = ea.id
    left outer join eba_stds_test_validations tv on s.test_id = tv.test_id and a.apex_app_id = tv.application_id
where ea.apex_app_id = :P20_APPLICATION_ID
    and s.standard_id = :P20_ID
order by t.display_sequence nulls last, lower(t.name) 
/
select *
from eba_stds_test_validations
/
commit;
/
select * 
from eba_stds_test_validations
/
select 
    nf.id standard_id,
    na.id application_id,
    na.apex_app_id,
    na.apex_app_id||'. '||aa.application_name application_name,
    nt.name application_type,
    aa.last_updated_on,
    sss.test_id,
    sst.name test_name,
    sss.pass_fail_pct,
    stv.false_positive_yn,
    stv.legacy_yn
from eba_stds_standards nf
    inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
    inner join eba_stds_applications na on nftr.type_id = na.type_id
    inner join apex_applications aa on aa.application_id = na.apex_app_id
    inner join eba_stds_standard_statuses sss on sss.standard_id = nf.id
                                              and sss.application_id = na.id
    inner join eba_stds_standard_tests sst on sss.test_id  = sst.id
    left  join eba_stds_types nt on nt.id = na.type_id
    left  join eba_stds_test_validations stv on stv.test_id = sss.test_id
                                             and stv.application_id = na.apex_app_id 
order by na.apex_app_id
/
select * 
from v_eba_stds_application_test_pass_fail
/
select * 
from eba_stds_test_validations
/
select * 
from eba_stds_standard_tests
/
drop view v_eba_stds_applications
/
select 
    nf.id standard_id,
    na.id application_id,
    na.apex_app_id,
    na.apex_app_id||'. '||aa.application_name application_name,
    nt.name application_type,
    aa.last_updated_on,
    sss.test_id,
    sss.pass_fail_pct
from eba_stds_standards nf
    inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
    inner join eba_stds_applications na on nftr.type_id = na.type_id
    inner join apex_applications aa on aa.application_id = na.apex_app_id
    inner join eba_stds_standard_statuses sss on sss.standard_id = nf.id
                                              and sss.application_id = na.id
    left  join eba_stds_types nt on nt.id = na.type_id
    
/
with avg_pass_fail as (
    select sss.standard_id, sss.application_id, floor(avg(sss.pass_fail_pct)) pass_fail_pct
        from eba_stds_standard_statuses sss
        group by sss.standard_id, sss.application_id
    )
select 
    nf.id standard_id,
    na.id application_id,
    na.apex_app_id,
    na.apex_app_id||'. '||aa.application_name application_name,
    nt.name application_type,
    aa.last_updated_on,
    apf.pass_fail_pct
from eba_stds_standards nf
    inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
    inner join eba_stds_applications na on nftr.type_id = na.type_id
    inner join apex_applications aa on aa.application_id = na.apex_app_id
    left  join eba_stds_types nt on nt.id = na.type_id
    left  join avg_pass_fail apf on nf.id = apf.standard_id
                                 and na.id = apf.application_id
/
select * 
from eba_stds_standard_type_ref
/
--select apex_app_id, count(*)
--from (
select sss.standard_id, sss.application_id, floor(avg(sss.pass_fail_pct)) pct
from eba_stds_standard_statuses sss
--inner join eba_stds_applications na on sss.application_id = na.id
group by sss.standard_id, sss.application_id
/
--where sss.standard_id = 1
--and na.apex_app_id = 100
) z
group by apex_app_id
/
select 
    
    application_id,
    apex_app_id,
    application_name,
    application_type,
    last_updated_on,
   -- status,
    null link_col2
from (  select na.id application_id,
            na.apex_app_id,
            na.apex_app_id||'. '||aa.application_name application_name,
            nt.name application_type,
            aa.last_updated_on
        from eba_stds_standards nf
            inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
            inner join eba_stds_applications na on nftr.type_id = na.type_id
            inner join eba_stds_types nt on nt.id = na.type_id
            inner join apex_applications aa on aa.application_id = na.apex_app_id
    )
order by apex_app_id
/
select * 
from eba_stds_standard_statuses
/
delete
from eba_stds_test_validations
/
commit;
/