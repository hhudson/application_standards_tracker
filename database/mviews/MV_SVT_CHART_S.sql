--liquibase formatted sql
--changeset mview_script:MV_SVT_CHART_S stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_CHART_S');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_CHART_S
/*
begin
  dbms_mview.refresh ('MV_SVT_CHART_S');
end;
*/
--------------------------------------------------------

create materialized view MV_SVT_CHART_S
    refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select
        pcs.application_id,
        pcs.application_name,
        'CHART_LINK' as url_type,
        pcs.link_target element_url,
        pcs.series_id as element_id,
        pcs.series_name element_label,
        pcs.series_name element_name,
        pcs.authorization_scheme element_authorization,
        pcs.chart_id parent_element_id,
        pcs.region_name parent_element_name,
        pcs.authorization_scheme parent_element_authorization,
        pcs.page_id,
        pcs.page_name,
        pcs.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => pcs.application_id, p_url => pcs.link_target) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => pcs.application_id, p_url => pcs.link_target) destination_page_id,
        pcs.last_updated_by,
        pcs.last_updated_on
        from  apex_application_page_chart_s pcs
        inner join v_eba_stds_applications esa on pcs.application_id = esa.apex_app_id
        where pcs.link_target is not null
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
        -- pu.created_by,
        -- pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on
        -- pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;                                               