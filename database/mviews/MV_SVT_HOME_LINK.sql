--------------------------------------------------------
--  DDL for Materialized View MV_SVT_HOME_LINK
--------------------------------------------------------

create materialized view MV_SVT_HOME_LINK
    refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select
        aa.application_id,
        aa.application_name,
        'HOME_LINK' as url_type,
        aa.home_link element_url,
        aa.application_id as element_id,
        aa.alias element_label,
        aa.application_name element_name,
        aa.authorization_scheme element_authorization,
        aa.authorization_scheme parent_element_authorization,
        aa.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => aa.application_id, p_url => aa.home_link) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => aa.application_id, p_url => aa.home_link) destination_page_id,
        aa.last_updated_by,
        aa.last_updated_on
        from  apex_applications aa
        inner join v_eba_stds_applications esa on aa.application_id = esa.apex_app_id
        where aa.home_link is not null
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