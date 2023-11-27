--liquibase formatted sql
--changeset mview_script:MV_SVT_LIST_ENTRIES stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_LIST_ENTRIES');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_LIST_ENTRIES
/*
begin
  dbms_mview.refresh ('MV_SVT_LIST_ENTRIES');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_LIST_ENTRIES
-- /
create materialized view MV_SVT_LIST_ENTRIES
refresh on demand
evaluate using current edition
as
with parsed_urls as (
        select 
        ale.application_id, 
        ale.application_name,
        'LIST_ENTRY' url_type,
        ale.entry_target as element_url,
        ale.list_entry_id as element_id,
        ale.entry_text as element_label,
        ale.entry_text as element_name, 
        ale.authorization_scheme as element_authorization,
        ale.list_id as parent_element_id, 
        ale.list_entry_parent_id as opt_parent_element_id,
        ale.list_name as parent_element_name,
        svt_stds_parser.app_from_url  (p_origin_app_id => ale.application_id, p_url => ale.entry_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => ale.application_id, p_url => ale.entry_target) destination_page_id,
        ale.last_updated_by,
        ale.last_updated_on,
        ale.workspace
        from apex_application_list_entries ale
        inner join v_eba_stds_applications esa on ale.application_id = esa.apex_app_id
        where ale.entry_text is not null
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
        --pu.parent_element_authorization,
        --pu.page_id,
        --pu.page_name,
        --pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        --pu.created_by,
        --pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        --pu.page_mode
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;