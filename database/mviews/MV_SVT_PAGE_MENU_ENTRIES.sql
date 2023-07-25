--------------------------------------------------------
--  DDL for Materialized View MV_SVT_PAGE_MENU_ENTRIES
--------------------------------------------------------

create materialized view MV_SVT_PAGE_MENU_ENTRIES
    refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select
        pme.application_id,
        pme.application_name,
        'PAGE_MENU_ENTRY' as url_type,
        pme.link_target element_url,
        pme.menu_entry_id as element_id,
        pme.label element_label,
        pme.label element_name,
        pme.authorization_scheme element_authorization,
        pme.parent_menu_entry_id parent_element_id,
        pme.authorization_scheme parent_element_authorization,
        pme.page_id,
        pme.page_name,
        pme.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => pme.application_id, p_url => pme.link_target) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => pme.application_id, p_url => pme.link_target) destination_page_id,
        pme.last_updated_by,
        pme.last_updated_on
        from  apex_appl_page_menu_entries pme
        inner join v_eba_stds_applications esa on pme.application_id = esa.apex_app_id
        where pme.link_target is not null
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
        -- pu.parent_element_name,
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
                                               
/