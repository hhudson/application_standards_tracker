--liquibase formatted sql
--changeset view_script:V_SVT_NAV_MENU stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_NAV_MENU

-- This view used by the Search configuration `V_SVT_NAV_MENU`
--------------------------------------------------------

create or replace force editionable view V_SVT_NAV_MENU as
select aale.list_entry_id,
       aale.entry_text, 
       aale.entry_target, 
       apex_plugin_util.replace_substitutions (
        p_value => aale.entry_target) entry_url,
       aale.entry_attribute_04 addl_info, 
       aale.authorization_scheme,
       aale.entry_image,
       svt_menu_util.is_authorized_yn (p_authorization_name => aale.authorization_scheme ) is_authorized_yn
from apex_application_list_entries aale
inner join apex_applications aa on aa.application_id = aale.application_id
                                --and aa.navigation_list = aale.list_name (now using nav bar)
where aale.application_id = v('APP_ID')
and svt_menu_util.is_authorized_yn (p_authorization_name => aale.authorization_scheme ) = 'Y'
/

--rollback drop view V_SVT_NAV_MENU;