create or replace force view v_ast_apex_theme_refresh as
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
     end as pass_yn,
ath1.application_id reference_code, 
ath1.application_id, 
t1.template_count, 
ath2.application_id master_application_id, 
t2.template_count master_template_count
from apex_application_themes ath1
inner join apex_applications aa on ath1.application_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
inner join templates t1 on ath1.application_id = t1.application_id
inner join apex_application_themes ath2 on ath1.reference_id = ath2.theme_id
                                        and ath1.workspace = ath2.workspace
inner join templates t2 on ath2.application_id = t2.application_id
where ath1.is_current = 'Yes'
;