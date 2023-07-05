--------------------------------------------------------
--  DDL for Materialized View MV_AST_IG_COLS
--------------------------------------------------------

create materialized view MV_AST_IG_COLS
refresh on demand
evaluate using current edition
as
with parsed_urls as (
        select
        pigc.application_id,
        pigc.application_name,
        'IG_COLUMN_URL' as url_type,
        pigc.link_target element_url,
        pigc.column_id as element_id,
        pigc.heading element_label,
        pigc.source_expression element_name,
        pigc.authorization_scheme element_authorization,
        pigc.region_id parent_element_id,
        pigc.region_name parent_element_name,
        apr.authorization_scheme parent_element_authorization,
        pigc.page_id,
        apr.page_name,
        pg.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => pigc.application_id, p_url => pigc.link_target) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => pigc.application_id, p_url => pigc.link_target) destination_page_id,
        pigc.last_updated_by,
        pigc.last_updated_on,
        pg.page_mode
        from apex_appl_page_ig_columns pigc
        inner join v_eba_stds_applications esa on pigc.application_id = esa.apex_app_id
        inner join apex_application_page_regions apr on  pigc.application_id = apr.application_id
                                                and pigc.page_id = apr.page_id
                                                and pigc.region_id = apr.region_id
        inner join apex_application_pages pg on  pigc.application_id = pg.application_id
                                            and pigc.page_id = pg.page_id
        where pigc.link_target is not null
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
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;