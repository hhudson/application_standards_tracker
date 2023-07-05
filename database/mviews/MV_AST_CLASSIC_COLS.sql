--------------------------------------------------------
--  DDL for Materialized View mv_ast_classic_cols
--------------------------------------------------------
--drop materialized view mv_ast_classic_cols
--/
create materialized view mv_ast_classic_cols
refresh on demand
evaluate using current edition
as
 with parsed_urls as (
        select
        prc.application_id,
        prc.application_name,
        'C_COLUMN_URL' as url_type,
        prc.column_link_url element_url,
        prc.region_report_column_id as element_id,
        prc.heading element_label,
        prc.column_alias element_name,
        prc.authorization_scheme element_authorization,
        prc.region_id parent_element_id,
        prc.region_name parent_element_name,
        apr.authorization_scheme parent_element_authorization,
        prc.page_id,
        prc.page_name,
        pg.authorization_scheme as page_authorization,
        eba_stds_parser.app_from_url  (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_app_id,
        eba_stds_parser.page_from_url (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_page_id,
        prc.last_updated_by,
        prc.last_updated_on,
        pg.page_mode
        from  apex_application_page_rpt_cols prc
        inner join v_eba_stds_applications esa on prc.application_id = esa.apex_app_id
        inner join apex_application_page_regions apr on  prc.application_id = apr.application_id
                                                     and prc.page_id = apr.page_id
                                                     and prc.region_id = apr.region_id
        inner join apex_application_pages pg on  prc.application_id = pg.application_id
                                             and prc.page_id = pg.page_id
        where prc.column_link_url is not null
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
        --pu.created_by,
        --pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id
;