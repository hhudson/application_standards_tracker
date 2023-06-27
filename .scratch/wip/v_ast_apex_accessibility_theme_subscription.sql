create or replace force view v_ast_apex_accessibility_theme_subscription as
with master_sub as (
   select eba_stds_parser.accessibility_app_id() application_id
   from dual)
select 
case when t2.application_id = ms.application_id
     then 'Y'
     else 'N'
     end as pass_yn,
t1.application_id reference_code,
t1.application_id,
t1.workspace,
t2.application_id theme_subscription_app_id,
ms.application_id master_accessibility_app_id
from apex_application_themes t1
inner join apex_applications aa on t1.application_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
cross join master_sub ms
left join apex_application_themes t2 on t1.reference_id = t2.theme_id
where t1.is_current = 'Yes'
and   t1.application_id != ms.application_id
/