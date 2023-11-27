--liquibase formatted sql
--changeset mview_script:MV_SVT_IR stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_IR');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_IR
/*
begin
  dbms_mview.refresh ('MV_SVT_IR');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_IR
-- /
create materialized view MV_SVT_IR
refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select  pir.application_id, 
        pir.application_name,
        'PAGE_IR_URL' as url_type,
        pir.detail_link_target as element_url,
        pir.interactive_report_id as element_id,
        pir.detail_link_text as element_label, 
        pir.alias element_name, 
        pir.detail_link_auth_scheme as element_authorization,
        pir.region_id parent_element_id,
        pir.region_name parent_element_name,
        pg.authorization_scheme parent_element_authorization,
        pir.page_id,
        pg.page_name,
        aa.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => pir.application_id, p_url => pir.detail_link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pir.application_id, p_url => pir.detail_link_target) destination_page_id,
        pir.created_by,
        pir.created_on,
        pir.updated_by last_updated_by,
        pir.updated_on last_updated_on,
        apg.page_mode
        from apex_application_page_ir pir
        inner join v_svt_stds_applications esa on pir.application_id = esa.apex_app_id
        inner join apex_applications aa on aa.application_id = esa.apex_app_id
        inner join apex_application_page_regions pg on  pir.application_id = pg.application_id
                                                    and pir.page_id = pg.page_id
                                                    and pir.region_id = pg.region_id
        inner join apex_application_pages apg on pir.application_id = apg.application_id
                                              and pir.page_id = apg.page_id
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
        -- pu.opt_parent_element_id,
        pu.parent_element_name,
        pu.parent_element_authorization,
        pu.page_id,
        pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.created_by,
        pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
                                               
/