/* WIP
 *
 */

create or replace force view v_ast_db_plsql_6_translateable as
with formalout as (
    select uif.name, uif.signature, uif.line, lower(us.text) text, uif.object_type, uif.object_name
    from user_identifiers uif
    inner join user_source us on us.name = uif.object_name
                             and us.type = uif.object_type
                             and us.line = uif.line
    where uif.type = 'FORMAL OUT'
    and uif.usage = 'ASSIGNMENT'
    and uif.object_type = 'PACKAGE BODY'
    and uif.implicit = 'NO'
    ), 
    assgn as (
    select uia.name, uia.signature, uia.line, lower(us.text) text, uia.object_type, uia.object_name
    from user_identifiers uia
    inner join user_source us on us.name = uia.object_name
                             and us.type = uia.object_type
                             and us.line = uia.line
    where uia.type = 'VARIABLE'
    and uia.usage = 'ASSIGNMENT'
    and uia.object_type = 'PACKAGE BODY'
    and uia.implicit = 'NO'
    ),
    refrn as (
    select uir.name, uir.signature, uir.line, uir.object_type, uir.object_name
    from user_identifiers uir
    where uir.type = 'VARIABLE'
    and uir.usage = 'REFERENCE'
    and uir.object_type = 'PACKAGE BODY'
    and uir.implicit = 'NO'
    ),
    apxlm as (select line, name
                from user_source
                where type = 'PACKAGE BODY'
                and lower(text) like '%apex_lang.message%'
    )
select 
case when fo.text like '%apex_lang.message%'
     then 'Y'
     when alm.line is not null
     then 'Y'
     else 'N'
     end as pass_yn,
fo.object_name, fo.name format_out_parameter, fo.text formal_out_text, rf.name variable_name, an.text variable_text
from formalout fo
left join refrn rf on rf.object_type = fo.object_type
                   and rf.object_name = fo.object_name
                   and rf.line = fo.line
left join assgn an on an.signature = rf.signature
left join apxlm alm on alm.name = fo.object_name
                    and alm.line between an.line and (an.line+5)
-- where fo.object_name = 'EBA_STDS_PARSER'
;

/* No need to :
 * - add application_name
 * - add application status
 * - add application type
 * - join on eba_stds_applications.apex_app_id
 */