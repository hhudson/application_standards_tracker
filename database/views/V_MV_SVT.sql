--liquibase formatted sql
--changeset view_script:V_MV_SVT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_MV_SVT
/*
This view replaces MV_SVT_STDS_PARSED_URLS

the below query is generated by the following function:
```
select SVT_MV_UTIL.mv_svt_query
from dual
```

The view is refreshed by automation but can manually be refreshed by the following command:
```
begin
    SVT_MV_UTIL.refresh_mv('V_MV_SVT');
end;
```
*/
--------------------------------------------------------

create or replace force editionable view V_MV_SVT as
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, null as parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_BC_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_BUTTONS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CARD_ACTIONS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CHART_S
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CLASSIC_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_HOME_LINK
union all
select application_id, application_name, url_type, element_url, element_id, null as element_label, null as element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_IG
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_IG_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, created_by, created_on
from MV_SVT_IR
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, created_by, created_on
from MV_SVT_IR_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, null as parent_element_authorization, null as page_id, null as page_name, null as page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_LIST_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_NAV_BAR
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, null as parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_PAGE_BRANCH
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, null as parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_PAGE_MENU_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_SEARCH_CONFIG
/

--rollback drop view V_MV_SVT;