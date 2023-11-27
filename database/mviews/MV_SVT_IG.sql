--liquibase formatted sql
--changeset mview_script:MV_SVT_IG stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_IG');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_IG
/*
begin
  dbms_mview.refresh ('MV_SVT_IG');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_IG
-- /
create materialized view MV_SVT_IG
refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select  pig.application_id, 
        pig.application_name,
        'PAGE_IG_URL' as url_type,
        pig.icon_view_link_target as element_url,
        pig.interactive_grid_id as element_id,
        pig.public_report_auth_scheme element_authorization,
        pig.region_id parent_element_id,
        pig.region_name parent_element_name,
        pg.authorization_scheme parent_element_authorization,
        pig.page_id,
        pg.page_name,
        aa.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => pig.application_id, p_url => pig.icon_view_link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pig.application_id, p_url => pig.icon_view_link_target) destination_page_id,
        pig.last_updated_by,
        pig.last_updated_on,
        apg.page_mode
        from apex_appl_page_igs pig
        inner join v_svt_stds_applications esa on pig.application_id = esa.apex_app_id
        inner join apex_applications aa on aa.application_id = esa.apex_app_id
        inner join apex_application_page_regions pg on pig.application_id = pg.application_id
                                                    and pig.page_id = pg.page_id
        inner join apex_application_pages apg on pig.application_id = apg.application_id
                                              and pig.page_id = apg.page_id
 )
    select
        pu.application_id, 
        pu.application_name,
        pu.url_type,
        pu.element_url,
        pu.element_id,
        pu.element_authorization,
        pu.parent_element_id,
        pu.parent_element_name,
        pu.parent_element_authorization,
        pu.page_id,
        pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
                                               
/