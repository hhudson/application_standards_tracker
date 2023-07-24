--liquibase formatted sql
--changeset view_script:V_SVT_NAV_MENU stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_NAV_MENU

-- This view used by the Search configuration `V_SVT_NAV_MENU`
--------------------------------------------------------

create or replace force editionable view V_SVT_NAV_MENU as
select spu.element_id list_entry_id,
       spu.element_label entry_text, 
       spu.destination_page_id,  
       aale.entry_attribute_01, 
       spu.element_authorization,
       aale.entry_image,
       SVT_menu_util.is_authorized_yn (p_authorization_name => spu.element_authorization ) is_authorized_yn
from v_mv_SVT spu
inner join apex_application_list_entries aale on spu.element_id = aale.list_entry_id
                                              and spu.application_id = aale.application_id
inner join apex_applications aa on aa.application_id = spu.application_id
                                and aa.navigation_list = spu.parent_element_name
where spu.application_id = v('APP_ID')
and SVT_menu_util.is_authorized_yn (p_authorization_name => spu.element_authorization ) = 'Y'
/

--rollback drop view V_SVT_NAV_MENU;