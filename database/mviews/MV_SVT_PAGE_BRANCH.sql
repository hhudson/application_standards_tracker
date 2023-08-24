--liquibase formatted sql
--changeset mview_script:MV_SVT_PAGE_BRANCH stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_PAGE_BRANCH');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_PAGE_BRANCH
--------------------------------------------------------
-- drop materialized view MV_SVT_PAGE_BRANCH
-- /
create materialized view MV_SVT_PAGE_BRANCH
refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select 
        apb.application_id, 
        apb.application_name,
        'PAGE_BRANCH' url_type,
        apb.branch_action element_url,
        apb.branch_id as element_id,
        apb.branch_action as element_label,
        apb.branch_action as element_name, 
        apb.authorization_scheme as element_authorization,
        apb.page_id,
        apb.page_name,
        pg.authorization_scheme page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => apb.application_id, p_url => apb.branch_action) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => apb.application_id, p_url => apb.branch_action) destination_page_id,
        apb.last_updated_by,
        apb.last_updated_on,
        pg.page_mode,
        apb.workspace
        from apex_application_page_branches apb
        inner join v_eba_stds_applications esa on apb.application_id = esa.apex_app_id
        inner join apex_application_pages pg on apb.application_id = pg.application_id
                                            and apb.page_id = pg.page_id
        where apb.branch_action is not null
        and apb.branch_type in ('Branch to Page','Branch to Page or URL')
 )
    select
        pu.application_id, 
        pu.application_name,
        pu.url_type,
        pu.element_url,
        pu.element_id,
        pu.element_label, 
        pu.element_name, 
        pu.element_authorization,
        --pu.parent_element_id,
        --pu.opt_parent_element_id,
        --pu.parent_element_name,
        --pu.parent_element_authorization,
        pu.page_id,
        pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        --pu.created_by,
        --pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;