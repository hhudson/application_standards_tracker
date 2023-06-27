create or replace force view v_ast_apex_btn_redirect_url_translatable as
with standard_ref as (
    select 'APX-SC-000' src,
    'https://gbuconfluence.us.oracle.com/display/HCGBUDev/APEX+Security+Coding+Standards#APEXSecurityCodingStandards-' base_url
    from dual
)
select 
case when redirect_url = 'javascript:apex.confirm(''Are you sure you want to deactivate this user?'',''DEACTIVATE_USER'');'
          then 'N'
          else 'Y'
          end pass_yn,
apex_string.format('%0', aa.application_id) reference_code, /* the reference code should always pass the application_id as the 1st value */
aa.application_id,
s.src src,
s.base_url||s.src standard_ref_link
from  apex_application_page_buttons pb
inner join apex_applications aa on pb.application_id = aa.application_id
left join apex_application_build_options bo on aap.application_id = bo.application_id
                                            and aap.build_option = bo.build_option_name
cross join standard_ref s
where aap.page_id != 0
where aa.availability_status != 'Unavailable'
and (bo.build_option_status != 'Exclude' or bo.build_option_status is null)
order by aa.application_id
;

/* Requirements:
 *  • 1st column = pass_yn = 'Y'/'N' 
 *  • 2nd column = reference_code = unique reference code, will be used to uniquely identify the underlying issue
 *  • 3rd column = application_id = (use a dummy one if inapplicable)
 *  • 4th column = src = Standards Reference Code (an identifier to point to the documentation that explains the standard)
 *  • 5th column = standard_ref_link = url to the standards documentation
 * No need to :
 * • add application_name
 * • add application status
 * • add application type
 * • join on eba_stds_applications.apex_app_id
 */