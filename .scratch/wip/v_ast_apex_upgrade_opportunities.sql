create or replace force view v_ast_apex_upgrade_opportunities as
select flow_id app_id, 
       security_group_id workspace_id,
       ob,
       migration_type,
       aale.display_value,
       migration_type as migration_type_code,
       object_count
  from ( select i.flow_id, 
                i.security_group_id,
                1 ob, 
                'NUMBER_FIELD'    as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items i,
                apex_200100.wwv_flow_step_validations v
          where i.display_as        in ('TEXT','NATIVE_TEXT_FIELD')
            and v.flow_id           = i.flow_id
            and v.flow_step_id      = i.flow_step_id
            and v.validation_type   = 'ITEM_IS_NUMERIC'
            and v.validation        = i.name
            and v.validation_condition_type is null
            and v.when_button_pressed       is null
         having count(*) > 0
         group by i.flow_id, i.security_group_id   
         union
         select i.flow_id, 
                i.security_group_id,
                3 ob, 
                'REQUIRED'        as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items i,
                apex_200100.wwv_flow_step_validations v
          where v.flow_id           = i.flow_id
            and v.flow_step_id      = i.flow_step_id
            and v.validation_type   = 'ITEM_NOT_NULL'
            and v.validation        = i.name
            and v.validation_condition_type is null
            and v.when_button_pressed       is null
         having count(*) > 0
         group by i.flow_id, i.security_group_id   
          union
         select i.flow_id, 
                i.security_group_id,
                15 ob, 
                'ADVANCED'        as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items i,
                apex_200100.wwv_flow_step_validations v
          where v.flow_id           = i.flow_id
            and v.flow_step_id      = i.flow_step_id
            and ((v.validation_type = 'ITEM_IS_NUMERIC' and 
                  i.display_as in ('TEXT','NATIVE_TEXT_FIELD')) or
                 v.validation_type in ('ITEM_NOT_NULL','ITEM_IS_DATE'))
            and v.validation        = i.name
            and (v.when_button_pressed is not null or
                 v.validation_condition_type is not null)
         having count(*) > 0
         group by i.flow_id, i.security_group_id   
          union
         select flow_id, 
                security_group_id,
                5 ob, 
                'LOV_NULL_VALUE'  as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items
          where lov_null_value    = '%null%'
         having count(*) > 0
         group by flow_id, security_group_id   
          union
         select flow_id, 
                security_group_id,
                6 ob, 
                'DATE_PICKER'     as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items
          where display_as        = 'NATIVE_DATE_PICKER_CLASSIC'
         having count(*) > 0
         group by flow_id, security_group_id   
          union
         select flow_id, 
                security_group_id,
                7 ob, 
                'CKEDITOR'        as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_step_items
          where display_as        = 'NATIVE_RICH_TEXT_EDITOR'
            and attribute_01      = 'FCKEDITOR2'
         having count(*) > 0
         group by flow_id, security_group_id   
          union
         select flow_id, 
                security_group_id,
                11 ob, 
                'IR_GROUP_BY'  as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_worksheets
          where show_group_by     = 'N'
            and show_search_bar   = 'Y'
            and show_actions_menu = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
          union
         select flow_id, 
                security_group_id,
                12 ob, 
                'IR_SAVE_PUBLIC'  as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_worksheets
          where allow_save_rpt_public = 'N'
            and show_search_bar       = 'Y'
            and show_actions_menu     = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
          union
         select flow_id, 
                security_group_id,
                13 ob, 
                'IR_SUBSCRIBE'  as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_worksheets
          where show_notify       = 'N'
            and show_search_bar   = 'Y'
            and show_actions_menu = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
           union
         select flow_id, 
                security_group_id,
                14 ob, 
                'IR_ROWS_PER_PAGE'  as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_worksheets
          where show_display_row_count = 'N'
            and show_search_bar    = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
           union
        select flow_id, 
               security_group_id,
               15 ob, 
                'IR_PIVOT'  as migration_type,
                count(*)    as object_count
           from apex_200100.wwv_flow_worksheets
          where show_pivot         = 'N'
            and show_search_bar    = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
            union
         select flow_id, 
                security_group_id,
                17 ob, 
                'CALENDAR_TO_CSS_CALENDAR'    as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_page_plugs
          where plug_source_type  = 'NATIVE_CALENDAR'
         having count(*) > 0
         group by flow_id, security_group_id   
           union
         select flow_id, 
                security_group_id,
                19 ob, 
                'IR_FIXED_HEADER' as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_worksheets
          where fixed_header      = 'NONE'
         having count(*) > 0
         group by flow_id, security_group_id   
           union
         select flow_id, 
                security_group_id,
                21 ob, 
                'TABULAR_TO_IG' as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_page_plugs
          where plug_source_type  = 'NATIVE_TABFORM'
         having count(*) > 0       
         group by flow_id, security_group_id   
         /*         union
         select flow_id, 
                security_group_id,   
                22 ob, 
                'SWITCH'   as migration_type,
                count(*)   as object_count
           from apex_200100.wwv_flow_step_items
          where display_as        in ( 'NATIVE_SELECT_LIST', 'NATIVE_RADIOGROUP')
            -- and apex_200100.wwv_flow_upgrade_app.can_update_to_switch( flow_id, lov, named_lov, lov_display_extra, lov_display_null, display_as, attribute_01, attribute_02, attribute_03 ) = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   
                  union
         select flow_id, 
                security_group_id,
                23 ob, 
                'FORM_REGION'   as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_steps
          --where apex_200100.wwv_flow_upgrade_app.can_update_to_form_region( flow_id, id ) = 'Y'
         having count(*) > 0
         group by flow_id, security_group_id   */
                  union
         select flow_id, 
                security_group_id,
                24 ob, 
                'DATE_PICKER_JET' as migration_type,
                count(*)          as object_count
           from ( select flow_id, security_group_id
                    from apex_200100.wwv_flow_step_items
                   where display_as        = 'NATIVE_DATE_PICKER'
                union all 
                  select flow_id, security_group_id
                    from apex_200100.wwv_flow_region_columns
                   where item_type         = 'NATIVE_DATE_PICKER' )
         having count(*) > 0
         group by flow_id, security_group_id
                  union
         select flow_id,
                security_group_id,
                 25 ob, 
                'CSS_CALENDAR_V3_TO_V5'    as migration_type,
                count(*)          as object_count
           from apex_200100.wwv_flow_page_plugs
          where plug_source_type            = 'NATIVE_CSS_CALENDAR'
            and attribute_23                = '3'
            and attribute_12                is null
            and attribute_15                is null
            and plugin_init_javascript_code is null
         having count(*) > 0
         group by flow_id, security_group_id
                  union
         select flow_id,
                security_group_id,
                26 ob, 
                'BUTTON_CONFIRM_LINK_TO_NATIVE' as migration_type,
                count(*)                        as object_count
           from apex_200100.wwv_flow_step_buttons
          where button_action       = 'REDIRECT_URL'
            and button_name         = regexp_substr(button_redirect_url, q'{javascript:apex.confirm\(htmldb_delete_message,'(.+)'\);}', 1, 1, null, 1)
         having count(*) > 0
         group by flow_id, security_group_id
       ) z
       inner join apex_application_lov_entries aale on aale.return_value = z.migration_type
                                                    and list_of_values_name = 'UPGRADE_APPLICATION_OPTIONS'
       inner join apex_application_lovs aal on aale.lov_id = aal.lov_id
                                            and aal.application_id = 4000
;

/* No need to :
 * - add application_name
 * - add application status
 * - add application type
 * - join on eba_stds_applications.apex_app_id
 */