--------------------------------------------------------
--  DDL for Materialized View MV_SVT_CARD_ACTIONS
--------------------------------------------------------

create materialized view MV_SVT_CARD_ACTIONS
    refresh on demand
    evaluate using current edition
    as
    with parsed_urls as (
        select
        pca.application_id,
        pca.application_name,
        'CARD_ACTIONS' as url_type,
        pca.link_target element_url,
        pca.action_id as element_id,
        pca.action_type element_label,
        pca.action_type_code element_name,
        pca.authorization_scheme element_authorization,
        pca.region_id parent_element_id,
        pca.card_id as opt_parent_element_id,
        pca.region_name parent_element_name,
        pca.authorization_scheme parent_element_authorization,
        pca.page_id,
        pca.page_name,
        pca.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => pca.application_id, p_url => pca.link_target) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => pca.application_id, p_url => pca.link_target) destination_page_id,
        pca.last_updated_by,
        pca.last_updated_on,
        pg.page_mode
        from  apex_appl_page_card_actions pca
        inner join v_eba_stds_applications esa on pca.application_id = esa.apex_app_id
        inner join apex_application_pages pg on  pca.application_id = pg.application_id
                                             and pca.page_id = pg.page_id
        where pca.link_target is not null
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
        pu.opt_parent_element_id,
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