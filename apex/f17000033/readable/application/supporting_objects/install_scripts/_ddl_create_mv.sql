  CREATE MATERIALIZED VIEW "MV_SVT_SEARCH_CONFIG" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => aasc.application_id, p_url => aasc.link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => aasc.application_id, p_url => aasc.link_target) destination_page_id,
        aasc.last_updated_by,
        aasc.last_updated_on
        from  apex_appl_search_configs aasc
        inner join v_svt_stds_applications esa on aasc.application_id = esa.apex_app_id
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_ASSIGNEE_COUNT" ("ASSIGNEE", "ASSIGNEE_COUNT")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  REFRESH FAST ON COMMIT
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS select assignee, count(*) assignee_count
from svt_plsql_apex_audit
group by assignee;

  CREATE MATERIALIZED VIEW "MV_SVT_PAGE_MENU_ENTRIES" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => pme.application_id, p_url => pme.link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pme.application_id, p_url => pme.link_target) destination_page_id,
        pme.last_updated_by,
        pme.last_updated_on
        from  apex_appl_page_menu_entries pme
        inner join v_svt_stds_applications esa on pme.application_id = esa.apex_app_id
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
        pu.parent_element_authorization,
        pu.page_id,
        pu.page_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_LIST_ENTRIES" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "OPT_PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
        select 
        ale.application_id, 
        ale.application_name,
        'LIST_ENTRY' url_type,
        ale.entry_target as element_url,
        ale.list_entry_id as element_id,
        ale.entry_text as element_label,
        ale.entry_text as element_name, 
        ale.authorization_scheme as element_authorization,
        ale.list_id as parent_element_id, 
        ale.list_entry_parent_id as opt_parent_element_id,
        ale.list_name as parent_element_name,
        svt_stds_parser.app_from_url  (p_origin_app_id => ale.application_id, p_url => ale.entry_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => ale.application_id, p_url => ale.entry_target) destination_page_id,
        ale.last_updated_by,
        ale.last_updated_on,
        ale.workspace
        from apex_application_list_entries ale
        inner join v_svt_stds_applications esa on ale.application_id = esa.apex_app_id
        where ale.entry_text is not null
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
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_NAV_BAR" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_PAGE_BRANCH" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
        select 
        apb.application_id, 
        apb.application_name,
        'PAGE_BRANCH' url_type,
        apb.branch_action element_url,
        apb.branch_id as element_id,
        apb.branch_action as element_label,
        apb.branch_action as element_name, 
        apb.authorization_scheme as element_authorization,
        apb.page_id,
        apb.page_name,
        pg.authorization_scheme page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => apb.application_id, p_url => apb.branch_action) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => apb.application_id, p_url => apb.branch_action) destination_page_id,
        apb.last_updated_by,
        apb.last_updated_on,
        pg.page_mode,
        apb.workspace
        from apex_application_page_branches apb
        inner join v_svt_stds_applications esa on apb.application_id = esa.apex_app_id
        inner join apex_application_pages pg on apb.application_id = pg.application_id
                                            and apb.page_id = pg.page_id
        where apb.branch_action is not null
        and apb.branch_type in ('Branch to Page','Branch to Page or URL')
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_IR_COLS" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "CREATED_BY", "CREATED_ON", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => pic.application_id, p_url => pic.column_link) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pic.application_id, p_url => pic.column_link) destination_page_id,
        pic.created_by,
        pic.created_on,
        pic.updated_by,
        pic.updated_on,
        pg.page_mode,
        pic.workspace
        from apex_application_page_ir_col pic
        inner join v_svt_stds_applications esa on pic.application_id = esa.apex_app_id
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
        pu.page_mode,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_IR" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "CREATED_BY", "CREATED_ON", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
        select  pir.application_id, 
        pir.application_name,
        'PAGE_IR_URL' as url_type,
        pir.detail_link_target as element_url,
        pir.interactive_report_id as element_id,
        pir.detail_link_text as element_label, 
        pir.alias element_name, 
        pir.detail_link_auth_scheme as element_authorization,
        pir.region_id parent_element_id,
        pir.region_name parent_element_name,
        pg.authorization_scheme parent_element_authorization,
        pir.page_id,
        pg.page_name,
        aa.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => pir.application_id, p_url => pir.detail_link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pir.application_id, p_url => pir.detail_link_target) destination_page_id,
        pir.created_by,
        pir.created_on,
        pir.updated_by last_updated_by,
        pir.updated_on last_updated_on,
        apg.page_mode
        from apex_application_page_ir pir
        inner join v_svt_stds_applications esa on pir.application_id = esa.apex_app_id
        inner join apex_applications aa on aa.application_id = esa.apex_app_id
        inner join apex_application_page_regions pg on  pir.application_id = pg.application_id
                                                    and pir.page_id = pg.page_id
                                                    and pir.region_id = pg.region_id
        inner join apex_application_pages apg on pir.application_id = apg.application_id
                                              and pir.page_id = apg.page_id
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
        pu.created_by,
        pu.created_on,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_HOME_LINK" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => aa.application_id, p_url => aa.home_link) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => aa.application_id, p_url => aa.home_link) destination_page_id,
        aa.last_updated_by,
        aa.last_updated_on
        from  apex_applications aa
        inner join v_svt_stds_applications esa on aa.application_id = esa.apex_app_id
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_IG" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_IG_COLS" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => pigc.application_id, p_url => pigc.link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pigc.application_id, p_url => pigc.link_target) destination_page_id,
        pigc.last_updated_by,
        pigc.last_updated_on,
        pg.page_mode,
        pigc.workspace
        from apex_appl_page_ig_columns pigc
        inner join v_svt_stds_applications esa on pigc.application_id = esa.apex_app_id
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
        pu.page_mode,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_CARD_ACTIONS" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "OPT_PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => pca.application_id, p_url => pca.link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pca.application_id, p_url => pca.link_target) destination_page_id,
        pca.last_updated_by,
        pca.last_updated_on,
        pg.page_mode
        from  apex_appl_page_card_actions pca
        inner join v_svt_stds_applications esa on pca.application_id = esa.apex_app_id
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
        pu.last_updated_by,
        pu.last_updated_on,
        pu.page_mode
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_CHART_S" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
        select
        pcs.application_id,
        pcs.application_name,
        'CHART_LINK' as url_type,
        pcs.link_target element_url,
        pcs.series_id as element_id,
        pcs.series_name element_label,
        pcs.series_name element_name,
        pcs.authorization_scheme element_authorization,
        pcs.chart_id parent_element_id,
        pcs.region_name parent_element_name,
        pcs.authorization_scheme parent_element_authorization,
        pcs.page_id,
        pcs.page_name,
        pcs.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => pcs.application_id, p_url => pcs.link_target) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => pcs.application_id, p_url => pcs.link_target) destination_page_id,
        pcs.last_updated_by,
        pcs.last_updated_on
        from  apex_application_page_chart_s pcs
        inner join v_svt_stds_applications esa on pcs.application_id = esa.apex_app_id
        where pcs.link_target is not null
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
        pu.last_updated_on
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_CLASSIC_COLS" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
        svt_stds_parser.app_from_url  (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_page_id,
        prc.last_updated_by,
        prc.last_updated_on,
        pg.page_mode,
        prc.workspace
        from  apex_application_page_rpt_cols prc
        inner join v_svt_stds_applications esa on prc.application_id = esa.apex_app_id
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
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_BC_ENTRIES" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "OPT_PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
        select  bce.application_id, 
        bce.application_name,
        'BC_URL' as url_type,
        bce.url as element_url,
        bce.breadcrumb_entry_id  as element_id,
        bce.entry_label element_label, 
        bce.entry_long_label element_name, 
        bce.authorization_scheme element_authorization,
        bce.breadcrumb_id parent_element_id,
        bce.parent_breadcrumb_id as opt_parent_element_id,
        aab.breadcrumb_name parent_element_name,
        aa.authorization_scheme as page_authorization,
        svt_stds_parser.app_from_url  (p_origin_app_id => bce.application_id, p_url => bce.url) destination_app_id,
        svt_stds_parser.page_from_url (p_origin_app_id => bce.application_id, p_url => bce.url) destination_page_id,
        bce.last_updated_by,
        bce.last_updated_on,
        null page_mode,
        bce.workspace
        from apex_application_bc_entries bce
        inner join apex_application_breadcrumbs aab on bce.breadcrumb_id = aab.breadcrumb_id
                                                    and bce.application_id = aab.application_id
        inner join v_svt_stds_applications esa on bce.application_id = esa.apex_app_id
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
        pu.opt_parent_element_id,
        pu.parent_element_name,
        pu.page_authorization,
        pu.destination_app_id,
        pu.destination_page_id,
        aap.page_name destination_page_name,
        aap.application_name destination_app_name,
        pu.last_updated_by,
        pu.last_updated_on,
        pu.workspace
    from parsed_urls pu
    left outer join apex_application_pages aap on  pu.destination_app_id = aap.application_id
                                               and pu.destination_page_id = aap.page_id;

  CREATE MATERIALIZED VIEW "MV_SVT_ISSUES_CREATED_BY_DAY" ("ACTION_DATE", "QUANTITY", "ACTION_NAME", "CUMUL_ISSUES")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with std as (select trunc(created) action_date, 
                    action_name, 
                    case when action_name = 'INSERT'
                         then count(*) 
                         else count(*) * -1
                         end quantity
                from svt_audit_on_audit
                group by trunc(created), action_name)
    select action_date, quantity, action_name,
        sum ( quantity ) over ( 
            order by action_date 
            rows unbounded preceding 
        ) cumul_issues
    from   std;

  CREATE MATERIALIZED VIEW "MV_SVT_BUTTONS" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "WORKSPACE")
 SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 COLUMN STORE COMPRESS FOR QUERY HIGH ROW LEVEL LOCKING LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
   
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS EVALUATE USING CURRENT EDITION  DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS with parsed_urls as (
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
                                               and pu.destination_page_id = aap.page_id;


   COMMENT ON MATERIALIZED VIEW "MV_SVT_ASSIGNEE_COUNT"  IS 'snapshot table for snapshot ILA.MV_SVT_ASSIGNEE_COUNT';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_BC_ENTRIES"  IS 'snapshot table for snapshot ILA.MV_SVT_BC_ENTRIES';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_BUTTONS"  IS 'snapshot table for snapshot ILA.MV_SVT_BUTTONS';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_CARD_ACTIONS"  IS 'snapshot table for snapshot ILA.MV_SVT_CARD_ACTIONS';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_CHART_S"  IS 'snapshot table for snapshot ILA.MV_SVT_CHART_S';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_CLASSIC_COLS"  IS 'snapshot table for snapshot ILA.MV_SVT_CLASSIC_COLS';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_HOME_LINK"  IS 'snapshot table for snapshot ILA.MV_SVT_HOME_LINK';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_IG"  IS 'snapshot table for snapshot ILA.MV_SVT_IG';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_IG_COLS"  IS 'snapshot table for snapshot ILA.MV_SVT_IG_COLS';


   COMMENT ON MATERIALIZED VIEW "MV_SVT_IR"  IS 'snapshot table for snapshot ILA.MV_SVT_IR';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_IR_COLS"  IS 'snapshot table for snapshot ILA.MV_SVT_IR_COLS';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_ISSUES_CREATED_BY_DAY"  IS 'snapshot table for snapshot ILA.MV_SVT_ISSUES_CREATED_BY_DAY';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_LIST_ENTRIES"  IS 'snapshot table for snapshot ILA.MV_SVT_LIST_ENTRIES';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_NAV_BAR"  IS 'snapshot table for snapshot ILA.MV_SVT_NAV_BAR';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_PAGE_BRANCH"  IS 'snapshot table for snapshot ILA.MV_SVT_PAGE_BRANCH';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_PAGE_MENU_ENTRIES"  IS 'snapshot table for snapshot ILA.MV_SVT_PAGE_MENU_ENTRIES';

   COMMENT ON MATERIALIZED VIEW "MV_SVT_SEARCH_CONFIG"  IS 'snapshot table for snapshot ILA.MV_SVT_SEARCH_CONFIG'; 