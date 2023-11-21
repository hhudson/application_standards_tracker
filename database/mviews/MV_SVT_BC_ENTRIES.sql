--liquibase formatted sql
--changeset mview_script:MV_SVT_BC_ENTRIES stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_BC_ENTRIES');
--------------------------------------------------------
--  DDL for Materialized View MV_SVT_BC_ENTRIES
/*
begin
  dbms_mview.refresh ('MV_SVT_BC_ENTRIES');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_BC_ENTRIES
-- /
create materialized view MV_SVT_BC_ENTRIES
    refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select  bce.application_id, 
        bce.application_name,
        'BC_URL' as url_type,
        bce.url as element_url,
        bce.breadcrumb_entry_id  as element_id,
        bce.entry_label element_label, 
        bce.entry_long_label element_name, 
        bce.authorization_scheme element_authorization,
        bce.breadcrumb_id parent_element_id,
        bce.parent_breadcrumb_id as opt_parent_element_id,
        aab.breadcrumb_name parent_element_name,
        aa.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => bce.application_id, p_url => bce.url) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => bce.application_id, p_url => bce.url) destination_page_id,
        bce.last_updated_by,
        bce.last_updated_on,
        null page_mode,
        bce.workspace
        from apex_application_bc_entries bce
        inner join apex_application_breadcrumbs aab on bce.breadcrumb_id = aab.breadcrumb_id
                                                    and bce.application_id = aab.application_id
        inner join v_eba_stds_applications esa on bce.application_id = esa.apex_app_id
        inner join apex_applications aa on aa.application_id = esa.apex_app_id
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
        pu.parent_element_id,
        pu.opt_parent_element_id,
        pu.parent_element_name,
        -- pu.parent_element_authorization,
        -- pu.page_id,
        -- pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        -- pu.created_by,
        -- pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        -- pu.page_mode
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
                                               
/