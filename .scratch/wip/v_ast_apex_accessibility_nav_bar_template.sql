create or replace force view v_ast_apex_accessibility_nav_bar_template as
 select 
case when ui.nav_bar_list_template = 'OHMS Accessible Navigation Bar'
     then 'Y'
     else 'N'
     end as pass_yn,
ui.application_id reference_code,
ui.application_id,
ui.display_name user_interface,
ui.nav_bar_type,
ui.nav_bar_list_template,
ui.nav_bar_list,
ui.nav_bar_template_options
from apex_appl_user_interfaces ui 
inner join apex_applications aa on ui.application_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
;