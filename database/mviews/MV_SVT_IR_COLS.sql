--------------------------------------------------------
--  DDL for Materialized View MV_SVT_IR_COLS
--------------------------------------------------------

create materialized view MV_SVT_IR_COLS
refresh on demand
evaluate using current edition
as
with parsed_urls as (
        select
        pic.application_id,
        pic.application_name,
        'IR_COLUMN_URL' as url_type,
        pic.column_link element_url,
        pic.column_id as element_id,
        pic.report_label element_label,
        pic.column_alias element_name,
        pic.authorization_scheme element_authorization,
        pic.region_id parent_element_id,
        pic.region_name parent_element_name,
        apr.authorization_scheme parent_element_authorization,
        pic.page_id,
        apr.page_name,
        pg.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => pic.application_id, p_url => pic.column_link) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => pic.application_id, p_url => pic.column_link) destination_page_id,
        pic.created_by,
        pic.created_on,
        pic.updated_by,
        pic.updated_on,
        pg.page_mode
        from apex_application_page_ir_col pic
        inner join v_eba_stds_applications esa on pic.application_id = esa.apex_app_id
        inner join apex_application_page_regions apr on  pic.application_id = apr.application_id
                                                and pic.page_id = apr.page_id
                                                and pic.region_id = apr.region_id
        inner join apex_application_pages pg on  pic.application_id = pg.application_id
                                            and pic.page_id = pg.page_id
        where pic.column_link is not null
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
        --opt_parent_element_id,
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
        pu.updated_by last_updated_by,
        pu.updated_on last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;