--------------------------------------------------------
--  DDL for Materialized View MV_AST_SEARCH_CONFIG
--------------------------------------------------------

create materialized view MV_AST_SEARCH_CONFIG
refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select
        aasc.application_id,
        aasc.application_name,
        'SEARCH_CONFIG' as url_type,
        aasc.link_target element_url,
        aasc.search_config_id as element_id,
        aasc.label element_label,
        aasc.static_id element_name,
        aasc.authorization_scheme element_authorization,
        aasc.authorization_scheme parent_element_authorization,
        aasc.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => aasc.application_id, p_url => aasc.link_target) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => aasc.application_id, p_url => aasc.link_target) destination_page_id,
        aasc.last_updated_by,
        aasc.last_updated_on
        from  apex_appl_search_configs aasc
        inner join v_eba_stds_applications esa on aasc.application_id = esa.apex_app_id
        where aasc.link_target is not null
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
        -- pu.parent_element_id,
        -- pu.opt_parent_element_id,
        -- pu.parent_element_name,
        pu.parent_element_authorization,
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
        pu.last_updated_on
        -- pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
                                               
/