  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_MV_SVT" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "OPT_PARENT_ELEMENT_ID", "CREATED_BY", "CREATED_ON") AS 
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
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PROBLEM_ASSIGNEES" ("ASSIGNEE", "DISPLAY_ASSIGNEE") AS 
  select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee not like '%@%'
union all
select assignee, 'null' display_assignee
from mv_svt_assignee_count
where assignee is null
union all
select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee in (select lower(column_value)
                   from table(apex_string.split(svt_preferences.get('SVT_DO_NOT_ASSIGN'), ':'))
                   )
; 