create or replace package body sv_sec_collections as
---------------------------------------------------------------------
--
-- Copyright(C) 2020, Oracle Corporation
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec_collections.pkb
-- Purpose              : Perform token substitutions before parsing/executing collection SQL statements.
--
-- HAS COMMITS          : NO
-- HAS ROLLBACKS        : NO
-- RUNTIME DEPLOYMENT   : NO
--
-- Comments :
--
--    -
--
-- History :
--
--    MODIFIED (DD-Mon-YYYY)
--    ???                   - Created
--    mlancast  07-Mar-2022 - Add procedure parse_collection_sql.
--    mlancast  14-Mar-2022 - Refactored token handling to support collection sql refactoring.
---------------------------------------------------------------------


function replace_tokens (
    p_code              in varchar2
   ,p_collection_id     in number
   ,p_collection_name   in varchar2
   ,p_app_session       in number
   ,p_attribute_set_id  in number
   ,p_application_id    in number )
   return varchar2
is
   l_code            varchar2(32767) := p_code;
   l_sec_attributes  sv_sec_attributes%rowtype;
   l_category_key    sv_sec_categories.category_key%type;

   l_values  apex_application_global.vc_arr2;
   l_results apex_application_global.vc_arr2;

   procedure load_attribute_values is
   begin
      -- Populate the array with all potential PASS/FAIL values for the attribute
      select av.value
            ,av.result
        bulk collect
        into l_values
            ,l_results
        from sv_sec_attribute_values av
       where av.attribute_id = l_sec_attributes.attribute_id
         and av.attribute_set_id = p_attribute_set_id;

      if l_values.count = 0 then
         logger.log_error(logger.sprintf('Attribute key %s in attribute set %s does not have any attribute values assigned.', l_sec_attributes.attribute_key, p_attribute_set_id));
      end if;
   end;
begin
   -- Replace all parameter tokens
   wwv_flow_utilities.fast_replace(l_code, '#COLLECTION_ID#',    p_collection_id);
   wwv_flow_utilities.fast_replace(l_code, '#COLLECTION_NAME#',  p_collection_name);
   wwv_flow_utilities.fast_replace(l_code, '#APP_ID#',           p_application_id);
   wwv_flow_utilities.fast_replace(l_code, '#APPLICATION_ID#',   p_application_id);
   wwv_flow_utilities.fast_replace(l_code, '#APP_SESSION#',      p_app_session);
   wwv_flow_utilities.fast_replace(l_code, '#ATTRIBUTE_SET_ID#', p_attribute_set_id);

   -- SV_SEC_ATTRIBUTES tokens
   select *
     into l_sec_attributes
     from sv_sec_attributes
    where attribute_key = p_collection_name;

   wwv_flow_utilities.fast_replace(l_code, '#ATTRIBUTE_ID#',   l_sec_attributes.attribute_id);
   wwv_flow_utilities.fast_replace(l_code, '#ATTRIBUTE_KEY#',  l_sec_attributes.attribute_key);
   wwv_flow_utilities.fast_replace(l_code, '#ATTRIBUTE_NAME#', l_sec_attributes.attribute_name);
   wwv_flow_utilities.fast_replace(l_code, '#RULE_SOURCE#',    l_sec_attributes.rule_source);
   wwv_flow_utilities.fast_replace(l_code, '#RULE_TYPE#',      l_sec_attributes.rule_type);
   wwv_flow_utilities.fast_replace(l_code, '#WHEN_NOT_FOUND#', l_sec_attributes.when_not_found);

   -- Check for any: '#RULE_VALUES#','#RULE_RESULTS#'
   if l_sec_attributes.rule_source in ('COLUMN' , 'COLLECTION') and
      l_sec_attributes.rule_type in ('LESS_THAN','GREATER_THAN','COMPARISON')
   then
      load_attribute_values;
      wwv_flow_utilities.fast_replace(l_code, '#RULE_VALUES#',  apex_string.table_to_string(l_values));
      wwv_flow_utilities.fast_replace(l_code, '#RULE_RESULTS#', apex_string.table_to_string(l_results));
   else
      wwv_flow_utilities.fast_replace(l_code, '#RULE_VALUES#',  null);
      wwv_flow_utilities.fast_replace(l_code, '#RULE_RESULTS#', null);
   end if;

   -- Recommended value rarely used now, may increase in the future.
   if instr(l_code, '#RECOMMENDED_VALUE#') > 0 then
      wwv_flow_utilities.fast_replace(
          l_code
         ,'#RECOMMENDED_VALUE#'
         ,sv_sec.get_recommended_value(p_attribute_set_id => p_attribute_set_id, p_attribute_key => l_sec_attributes.attribute_key) );
   end if;

   -- Deprecated tokens
   if instr(l_code, '#CATEGORY_KEY#') > 0 then
      select category_key
        into l_category_key
        from sv_sec_categories
       where category_id = l_sec_attributes.category_id;

      wwv_flow_utilities.fast_replace(l_code, '#CATEGORY_KEY#', l_category_key);
   end if;

   -- Remove trailing spaces, standardize line-feeds, remove trailing line-feeds, remove trailing semi-colons.
   l_code := rtrim(rtrim(replace(replace(rtrim(l_code,' '),chr(13)||chr(10),chr(10)),chr(13), chr(10)),chr(10)),';');

   return l_code;
end replace_tokens;


---------------------------------------------------------------------
--< PUBLIC METHODS >-------------------------------------------------
---------------------------------------------------------------------

---------------------------------------------------------------------
--< create_collection >--
---------------------------------------------------------------------

procedure create_collection (
    p_collection_id    in number
   ,p_collection_name  in varchar2
   ,p_app_session      in number
   ,p_query            in varchar2
   ,p_attribute_set_id in number
   ,p_application_id   in number )
is
   l_code   varchar2(32767);
   l_params logger.tab_param;
   -- PACKAGE procs
   l_scope logger_logs.scope%type := utl_call_stack.concatenate_subprogram (utl_call_stack.subprogram (1 ));
begin
   logger.append_param(l_params, 'p_collection_name'  , p_collection_name );
   logger.log('START - ' || p_collection_name, l_scope, null, l_params);

   -- Replace all tokens
   l_code := replace_tokens (
       p_code             => p_query
      ,p_collection_id    => p_collection_id
      ,p_collection_name  => p_collection_name
      ,p_app_session      => p_app_session
      ,p_attribute_set_id => p_attribute_set_id
      ,p_application_id   => p_application_id );

   l_code := apex_string.join(apex_t_varchar2('BEGIN', l_code||';', 'END;'));

   logger.log('Code for '||p_collection_name, l_scope, l_code);

   -- Execute the statement to populate the Collection Data
   execute immediate (l_code);
   commit;

exception
   when others then
      logger.log_error(p_collection_name||' : '||sqlerrm, l_scope, l_code);
      raise;
end create_collection;

---------------------------------------------------------------------
--< parse_collection_sql >--
---------------------------------------------------------------------
procedure parse_collection_sql (
    p_results_collection_name  in varchar2 default 'SERT_PARSE_COLLECTIONS'
   ,p_collection_id            in number default null )
is
   l_code   varchar2(32767);
   l_result varchar2(5);
   l_error  varchar2(4000);
begin
   -- Create APEX collection for results
   if p_collection_id is null then
      apex_collection.create_or_truncate_collection(p_collection_name => p_results_collection_name);
   else
      if apex_collection.collection_exists(p_collection_name => p_results_collection_name) then
         -- delete member if exists
         for c in (
            select seq_id
              from apex_collections
             where collection_name = p_results_collection_name
               and n001 = p_collection_id )
         loop
            apex_collection.delete_member(p_collection_name => p_results_collection_name, p_seq => c.seq_id);
         end loop;
      else
         apex_collection.create_collection(p_collection_name => p_results_collection_name);
      end if;
   end if;

   -- Loop through the collections processing each one
   for c in (
      select sc.*
        from sv_sec_score_collections sc
            ,sv_sec_attribute_set_attrs asa
            ,sv_sec_attributes a
       where asa.attribute_id = a.attribute_id
         and a.score_collection_id = sc.score_collection_id
         and a.rule_source = 'COLLECTION'
         and (p_collection_id is null or (p_collection_id is not null and sc.score_collection_id = p_collection_id))
         and a.active_flag = 'Y' )
   loop
      -- Replace all tokens
      l_code := replace_tokens (
          p_code              => c.collection_sql
         ,p_collection_id     => c.score_collection_id
         ,p_collection_name   => c.collection_name
         ,p_app_session       => 0
         ,p_attribute_set_id  => 0
         ,p_application_id    => 0 );

      -- Join using a space character so error reports correct line and column reference (in most cases).
      l_code := apex_string.join(
         apex_t_varchar2(
            'declare'
            ,'   procedure dummy is'
            ,'   begin'
            ,'      '||l_code||';'
            ,'   end;'
            ,'begin'
            ,'   null;'
            ,'end;' )
         ,' ');

      -- Parse the code without executing it
      -- Invalid code will cause an exception to be raised, how to handle it is determined by the calling procedure.
      begin
         execute immediate (l_code);
         l_result := 'PASS';
      exception
         when others then
            l_result := 'FAIL';
            l_error  := sqlerrm; -- use sqlerrm, not dbms_utility.format_error_backtrace
      end;

      -- Record the result
      apex_collection.add_member(
          p_collection_name => p_results_collection_name
         ,p_c001            => c.collection_name
         ,p_c002            => l_result
         ,p_c003            => case when l_result = 'FAIL' then l_error else null end
         ,p_n001            => c.score_collection_id
         ,p_clob001         => l_code );

   end loop;
end parse_collection_sql;


function get_parse_error (
   -- Returns error text or null after parsing the collection.
    p_collection_id            in number
   ,p_results_collection_name  in varchar2 default 'SERT_PARSE_COLLECTIONS' )
   return varchar2
is
begin
   -- Parse the collection_id so results are live
   parse_collection_sql(p_results_collection_name => p_results_collection_name, p_collection_id => p_collection_id);

   for c in (
      select c003 error_text
        from apex_collections
       where collection_name = p_results_collection_name
         and n001 = p_collection_id
       order by seq_id )
   loop
      return c.error_text;
   end loop;

   return null;
end get_parse_error;


---------------------------------------------------------------------
--< delete_score_collections >--
---------------------------------------------------------------------
procedure delete_score_collections
is
begin

   -- Loop through all score collections and delete them
   for x in (select * from sv_sec_score_collections where collection_name is not null)
   loop
      if apex_collection.collection_exists(p_collection_name => x.collection_name) then
         apex_collection.delete_collection(p_collection_name => x.collection_name);
      end if;
   end loop;

exception
   when others then
      logger.log_error;
      raise;
end delete_score_collections;


---------------------------------------------------------------------
--< create_score_collections >--
---------------------------------------------------------------------
procedure create_score_collections (
    p_collection_id     in number
   ,p_application_id    in number
   ,p_attribute_set_id  in number
   ,p_app_session       in number   default nv('APP_SESSION')
   ,p_app_user          in varchar2 default v('APP_USER') )
is
   l_timer_text varchar2(255);
begin
   l_timer_text := logger.sprintf('SERT timing APP_ID %s using attribute set %s', p_application_id, p_attribute_set_id);
   logger.time_reset;
   logger.time_start(l_timer_text);

   -- Set the initial progress bar
   if sys_context('APEX$SESSION','APP_SESSION') is not null then
      apex_util.set_session_state('G_PROGRESS','"title" : "Processing - ", "value":"0% Complete"');
   end if;

   -- Loop through all of the collections in an attribute set and process each one
   -- Many attributes in attribute set, each attribute has 1 score_collection.
   for x in (
      select trunc(100*row_number() over (order by sc.score_collection_id)/sum(1) over ()) progress
            ,sc.collection_name
            ,sc.collection_sql
        from sv_sec_score_collections sc,
             sv_sec_attribute_set_attrs asa,
             sv_sec_attributes a
       where asa.attribute_id = a.attribute_id
         and a.score_collection_id = sc.score_collection_id
         and a.rule_source = 'COLLECTION'
         and asa.attribute_set_id = p_attribute_set_id
         and a.active_flag = 'Y'
       order by sc.score_collection_id )
   loop
      create_collection(
          p_collection_id    => p_collection_id
         ,p_collection_name  => x.collection_name
         ,p_app_session      => p_app_session
         ,p_application_id   => p_application_id
         ,p_query            => x.collection_sql
         ,p_attribute_set_id => p_attribute_set_id );

      if sys_context('APEX$SESSION','APP_SESSION') is not null then
         -- Set the Progress Bar
         apex_util.set_session_state('G_PROGRESS','"title" : "Processing - ", "value":"' ||  x.progress || '% Complete"');
      end if;
   end loop;

   logger.time_stop(l_timer_text);
exception
   when others then
      logger.log_error;
      raise;
end create_score_collections;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end sv_sec_collections;
/