--liquibase formatted sql
--changeset mview_script:MV_SVT_NAV_BAR stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_NAV_BAR');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_NAV_BAR
/*
begin
  dbms_mview.refresh ('MV_SVT_NAV_BAR');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_NAV_BAR
-- /
create materialized view MV_SVT_NAV_BAR
refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select  nb.application_id, 
        nb.application_name,
        'NAV_BAR_URL' as url_type,
        nb.icon_target as element_url,
        nb.nav_bar_id as element_id,
        nb.icon_subtext as element_label, 
        nb.icon_image as element_name, 
        nb.authorization_scheme as element_authorization,
        nb.application_id parent_element_id,
        nb.application_name parent_element_name,
        nb.authorization_scheme parent_element_authorization,
        nb.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => nb.application_id, p_url => nb.icon_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => nb.application_id, p_url => nb.icon_target) destination_page_id,
        nb.last_updated_by,
        nb.last_updated_on
        from apex_application_nav_bar nb
        inner join v_svt_stds_applications esa on nb.application_id = esa.apex_app_id
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
        pu.parent_element_name,
        pu.parent_element_authorization,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
                                               
/