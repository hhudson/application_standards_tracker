--liquibase formatted sql
--changeset mview_script:MV_SVT_BUTTONS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_BUTTONS');

--------------------------------------------------------
--  DDL for Materialized View MV_SVT_BUTTONS
/*
begin
  dbms_mview.refresh ('MV_SVT_BUTTONS');
end;
*/
--------------------------------------------------------
-- drop materialized view MV_SVT_BUTTONS
-- /
create materialized view MV_SVT_BUTTONS
refresh on demand
evaluate using current edition
as
 with parsed_urls as (
        select 
        bl.application_id, 
        bl.application_name,
        'BUTTON_URL' as url_type,
        bl.redirect_url as element_url,
        bl.button_id as element_id,
        bl.label as element_label, 
        bl.button_name as element_name, 
        bl.authorization_scheme as element_authorization,
        bl.region_id as parent_element_id,
        bl.region as parent_element_name,
        apr.authorization_scheme parent_element_authorization,
        bl.page_id,
        bl.page_name,
        pg.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => bl.application_id, p_url => bl.redirect_url) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => bl.application_id, p_url => bl.redirect_url) destination_page_id,
        bl.last_updated_by,
        bl.last_updated_on,
        pg.page_mode,
        bl.workspace
        from apex_application_page_buttons bl
        inner join v_svt_stds_applications esa on bl.application_id = esa.apex_app_id
        inner join apex_application_page_regions apr on  bl.application_id = apr.application_id
                                                     and bl.region_id = apr.region_id
        inner join apex_application_pages pg on  bl.application_id = pg.application_id
                                             and bl.page_id = pg.page_id
        where bl.redirect_url is not null
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
        pu.page_id,
        pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;