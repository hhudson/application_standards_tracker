create or replace package body sv_sec as
---------------------------------------------------------------------
--
-- Copyright(C) 2020, Oracle Corporation
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec.pkb
-- Purpose              : generic functions
--
-- HAS COMMITS          : NO
-- HAS ROLLBACKS        : NO
-- RUNTIME DEPLOYMENT   : NO
--
-- Comments :
--
--    MyComments
--
-- History :
--
--    MODIFIED (DD-Mon-YYYY)
--    mipotter  15-Oct-2021 - updated with use of constants for icon classes
--    mzimon    21-DEC-2021 - Post PL_FPDF removal refactoring.
--                            Removed dashboard and dashboard_cards.
--    mlancast  24-Feb-2022 - Modify get_result to log attributes without attribute values.
--    mlancast  14-Mar-2022 - Modify calc_attribute_column to only replace #COLUMN_NAME# token.
---------------------------------------------------------------------

--===================================================================
--< PRIVATE PROCEDURES AND FUNCTIONS >--
--===================================================================
---------------------------------------------------------------------
--< G E T _ G U I D >--
---------------------------------------------------------------------
-- Purpose         : briefly
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : Returns the product GUID
-- Comments  :
--
-- Call Example :
--
---------------------------------------------------------------------
   function get_guid return varchar2 is
   begin
      return c_guid;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_guid;

--===================================================================
--< PROCEDURES AND FUNCTIONS >--
--===================================================================

--------------------------------------------------------------------------------
-- PROCEURE: C A L C _ A T T R I B U T E _ C O L U M N
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
   procedure calc_attribute_column (
       p_collection_id    in number
      ,p_attribute_set_id in number
      ,p_application_id   in number
      ,p_attribute_id     in number
      ,p_app_user         in varchar2
      ,p_app_session      in number
   ) is
      l_sql              varchar2 (32767);
      x                  sv_sec_attributes%rowtype;
      l_col_template     varchar2 (4000);
      l_params logger.tab_param;
      -- PACKAGE procs
      l_scope logger_logs.scope%type := utl_call_stack.concatenate_subprogram (utl_call_stack.subprogram (1 ));
   begin
      logger.append_param(l_params, 'p_collection_id'    , p_collection_id ) ;
      logger.append_param(l_params, 'p_attribute_set_id' , p_attribute_set_id ) ;
      logger.append_param(l_params, 'p_application_id'   , p_application_id ) ;
      logger.append_param(l_params, 'p_attribute_id'     , p_attribute_id ) ;
      logger.append_param(l_params, 'p_app_user'         , p_app_user ) ;
      logger.append_param(l_params, 'p_app_session'      , p_app_session ) ;
      logger.log('START', l_scope, null, l_params);

      -- Fetch the attribute row
      select *
        into x
        from sv_sec_attributes
       where attribute_id = p_attribute_id;

      -- Fetch the SQL Template
      select col_template
        into l_col_template
        from sv_sec_col_templates
       where col_template_id = x.col_template_id;

      l_sql := replace(l_col_template, '#COLUMN_NAME#', x.column_name);

      sv_sec_collections.create_collection (
          p_collection_id     => p_collection_id
         ,p_collection_name   => x.attribute_key
         ,p_application_id    => p_application_id
         ,p_app_session       => p_app_session
         ,p_query             => l_sql
         ,p_attribute_set_id  => p_attribute_set_id );

   exception
      when others then
         logger.log_error;
         raise_application_error ( -20000 , dbms_utility.format_error_backtrace );
   end calc_attribute_column;

---------------------------------------------------------------------
-- PROCEDURE: C A L C _ S C O R E
---------------------------------------------------------------------
-- Purpose         : Determines the overall score and prints the corresponding region
-- HAS COMMITS     : NO
-- HAS ROLLBACKS   : NO
--
-- Purpose   : <brief description>
--
-- Comments  : <general comments>
-- This function gets executed in the SERT application through an application
-- computation!.
-- Applications > 105 - APEX-SERT
--    > Application Computations > G_SCORE BEFORE_HEADER
-- Attribute	Computation (Identifies the computation logic that corresponds
-- to the computation type) Value
--
-- Call Example :
--
---------------------------------------------------------------------
   function calc_score (
       p_attribute_set_id      in number
      ,p_application_id        in number
      ,p_page_id               in number default null
      ,p_request               in varchar2 default v ('REQUEST')
      ,p_app_user              in varchar2 default v ('APP_USER')
      ,p_workspace_id          in number default nv ('G_WORKSPACE_ID')
      ,p_sert_app_id           in number default nv ('APP_ID')
      ,p_app_session           in number default nv ('APP_SESSION')
      ,p_owner                 in varchar2
      ,p_app_eval_id           in number default null
      ,p_user_workspace_id     in number default nv ('G_WORKSPACE_ID')
      ,p_scheduled_eval        in varchar2 default 'N'
   ) return varchar2 is

      l_application_name      apex_applications.application_name%type;
      l_build_status          apex_applications.build_status%type;
      l_collection_id         sv_sec_collection.collection_id%type;

      l_attributes_a          htmldb_application_global.vc_arr2;
      l_collection_a          htmldb_application_global.vc_arr2;

      l_count                 number := 1;
      l_pct_score             number;
      l_possible_score        number := 0;
      l_score                 number := 0;
      l_total_cat             number;
      l_total_possible_score  number := 0;
      l_total_score           number := 0;

      l_attributes            varchar2 (1000);
      l_collection            varchar2 (4000);
      l_color                 varchar2 (100);
      l_dummy                 varchar2 (100);
      l_html                  varchar2 (4000);
      l_page_alias            varchar2 (255);
      l_parse_as              varchar2 (100);
      l_params logger.tab_param;
      -- PACKAGE procs
      l_scope logger_logs.scope%type := utl_call_stack.concatenate_subprogram (utl_call_stack.subprogram (1 ));

   begin
      logger.append_param(l_params, 'p_attribute_set_id'  , p_attribute_set_id );
      logger.append_param(l_params, 'p_application_id'    , p_application_id );
      logger.append_param(l_params, 'p_page_id'           , p_page_id );
      logger.append_param(l_params, 'p_request'           , p_request );
      logger.append_param(l_params, 'p_app_user'          , p_app_user );
      logger.append_param(l_params, 'p_workspace_id'      , p_workspace_id );
      logger.append_param(l_params, 'p_sert_app_id'       , p_sert_app_id );
      logger.append_param(l_params, 'p_app_session'       , p_app_session );
      logger.append_param(l_params, 'p_owner'             , p_owner );
      logger.append_param(l_params, 'p_app_eval_id'       , p_app_eval_id );
      logger.append_param(l_params, 'p_user_workspace_id' , p_user_workspace_id );
      logger.append_param(l_params, 'p_scheduled_eval'    , p_scheduled_eval );
      logger.log('START', l_scope, null, l_params);

-- Get the Parse As schemas
      select snippet
        into l_parse_as
        from sv_sec_snippets
       where snippet_key = 'PARSE_AS';

-- Check to see that the APP is Run Only or the user is a member of SV_SERT_SU
      select build_status
        into l_build_status
        from apex_applications
       where application_id = p_sert_app_id;

      -- remove this if clause since it's always true
      if 1 = 1 then
         --IF l_build_status = 'Run Only' OR sv_sec_util.user_has_role(p_workspace_id => p_user_workspace_id, p_user_name => p_app_user, p_role_name => 'SV_SERT_SU')
         -- Check to see if the user has access to evaluate the application
         -- Use the core of the sv_sec_apex_applications_v here
         select count (*)
           into l_count
           from apex_applications                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      a
               ,sv_sec_user_roles_v                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ur
          where a.application_id not between 3000 and 8999
            and a.workspace_id = ur.workspace_id
            and a.application_id = p_application_id
            and ur.user_name = p_app_user
            and ur.user_workspace_id = p_user_workspace_id;

         if l_count > 0 then
            if p_request = 'SCORE' then
               if p_app_session > 0 then
                  -- Reset the Progress bar
                  apex_util.set_session_state (
                        'G_PROGRESS'
                     , '"title": "Starting Evaluation...", "value": ""'
                  );
               end if;

               if p_app_session > 0 then
                  -- Log the event
                  sv_sec_log_events.log_exception_event (
                      p_event_key        => 'MANUAL_EVAL'
                     ,p_application_id   => p_application_id
                     ,p_number_affected  => 1
                     ,p_sert_app_id      => p_sert_app_id
                     ,p_app_user         => p_app_user
                     ,p_app_session      => p_app_session
                     ,p_attribute_set_id => p_attribute_set_id
                  );

               else
                  sv_sec_log_events.log_exception_event (
                      p_event_key        => 'AUTO_EVAL'
                     ,p_application_id   => p_application_id
                     ,p_number_affected  => 1
                     ,p_sert_app_id      => p_sert_app_id
                     ,p_app_user         => 'Scheduler'
                     ,p_app_session      => p_app_session
                     ,p_attribute_set_id => p_attribute_set_id
                  );
               end if;

               -- Clear out the Collection Data
               logger.log('Clear out the Collection Data');
               delete from sv_sec_collection
                where app_user = p_app_user
                  and app_session = p_app_session
                  and app_id = p_application_id;
               -- Clear out Old Collections
               delete from sv_sec_collection
                where app_user = p_app_user
                  and created_on < (sysdate - 7);

               logger.log('Create the collection');
               -- Create the Collection
               insert into sv_sec_collection (
                  app_id
                  , app_user
                  , app_session
                  , created_on
               ) values (
                  p_application_id
                , p_app_user
                , p_app_session
                , sysdate
               )
               returning collection_id into l_collection_id;

               -- Set the Context
               sv_sec_util.set_ctx (
                     p_application_id  => p_application_id
                  , p_app_session      => p_app_session
                  , p_app_user         => p_app_user
                  , p_collection_id    => l_collection_id
                  , p_attribute_set_id => p_attribute_set_id
               );

               -- Pre-populate the collection-based attributes
               logger.log('Pre-populate the collection-based attributes');
               sv_sec_collections.create_score_collections (
                     p_collection_id   => l_collection_id
                  , p_application_id   => p_application_id
                  , p_attribute_set_id => p_attribute_set_id
                  , p_app_session      => p_app_session
                  , p_app_user         => p_app_user
               );

               -- Next, calculate the column-based attributes
               -- Get the total number of categories for the Progress Bar
               select count (*)
                 into l_total_cat
                 from (
                  select distinct c.category_key
                    from sv_sec_categories c
                        ,sv_sec_attribute_sets aset
                        ,sv_sec_attribute_set_attrs asa
                        ,sv_sec_attributes a
                   where aset.attribute_set_id  = asa.attribute_set_id
                     and aset.attribute_set_id  = p_attribute_set_id
                     and a.attribute_id         = asa.attribute_id
                     and a.category_id          = c.category_id
                     and a.active_flag          = 'Y'
                     and a.rule_source          = 'COLUMN'
                     and asa.active_flag        = 'Y'
                     and c.category_id          > 0
               );

               -- Loop through all attributes in the specified attribute set that are not mapped to collections
               for x in (
                  select a.attribute_key
                        ,a.attribute_id
                        ,a.rule_source
                    from sv_sec_attribute_sets                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   aset
                        ,sv_sec_attribute_set_attrs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              asa
                        ,sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       a
                   where aset.attribute_set_id = asa.attribute_set_id
                     and aset.attribute_set_id = p_attribute_set_id
                     and a.attribute_id = asa.attribute_id
                     and a.active_flag    = 'Y'
                     and asa.active_flag  = 'Y'
                     and a.rule_source    != 'COLLECTION'
               ) loop
                  if x.rule_source = 'COLUMN' then

                     -- Evalute a specific attribute
                     logger.log( 'SCORE: COLUMN Attribute: '||x.attribute_id);
                     calc_attribute_column (
                         p_collection_id    => l_collection_id
                        ,p_attribute_set_id => p_attribute_set_id
                        ,p_application_id   => p_application_id
                        ,p_attribute_id     => x.attribute_id
                        ,p_app_user         => p_app_user
                        ,p_app_session      => p_app_session
                     );

                  elsif x.rule_source = 'PLSQL' then
                     null;
                  end if;
               end loop;

               if p_app_session > 0 then

                  apex_util.set_session_state (
                        'G_PROGRESS'
                     , '"title": "Processing Exceptions...", "value": ""'
                  );
               end if;

               -- Apply exceptions for all collection data
               sv_sec_exception.apply_exceptions (
                   p_collection_id    => l_collection_id
                  ,p_application_id   => p_application_id
                  ,p_attribute_set_id => p_attribute_set_id
                  ,p_app_user         => p_app_user
                  ,p_app_session      => p_app_session
                  ,p_sert_app_id      => p_sert_app_id
               );

            elsif p_request = 'PAGE_SCORE' then
               ------------------------------------------------------------------------------
               -- Recalculate the score only for a specific PAGE
               ------------------------------------------------------------------------------
               -- Log the event
               sv_sec_log_events.log_exception_event (
                   p_event_key        => 'RECALC_PAGE'
                  ,p_application_id   => p_application_id
                  ,p_page_id          => p_page_id
                  ,p_number_affected  => 1
                  ,p_sert_app_id      => p_sert_app_id
                  ,p_app_user         => p_app_user
                  ,p_app_session      => p_app_session
                  ,p_attribute_set_id => p_attribute_set_id
               );

               -- Get the Collection ID
               l_collection_id := sv_sec_util.get_collection_id (
                   p_app_user         => p_app_user
                  ,p_app_session      => p_app_session
                  ,p_application_id   => p_application_id
               );
               -- Determine if the page is a summary page or a single attribute page
               select count (*)
                 into l_count
                 from sv_sec_attributes
                where summary_page_id = p_page_id;

               if l_count = 0 then
                  -- Page is not summary page; get the attribute that matches the DISPLAY_PAGE_ID
                  for q in (
                     select a.attribute_id
                       from sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      a
                           ,sv_sec_attribute_set_attrs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             asa
                      where a.display_page_id      = p_page_id
                        and a.attribute_id         = asa.attribute_id
                        and asa.attribute_set_id   = p_attribute_set_id
                        and a.active_flag          = 'Y'
                        and asa.active_flag        = 'Y'
                  )
                  loop
                     l_attributes := l_attributes || q.attribute_id || ':';
                  end loop;
               else
                  -- Page is a summary page; get the corresponding attributes that map to this page
                  for q in (
                     select a.attribute_id
                       from sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        a
                           ,sv_sec_attribute_set_attrs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               asa
                      where a.summary_page_id      = p_page_id
                        and a.attribute_id         = asa.attribute_id
                        and asa.attribute_set_id   = p_attribute_set_id
                        and a.active_flag          = 'Y'
                        and asa.active_flag        = 'Y'
                  )
                  loop
                     l_attributes := l_attributes || q.attribute_id || ':';
                  end loop;
               end if;

               -- Convert the string to an array
               l_attributes_a := htmldb_util.string_to_table (l_attributes);

               -- Loop through all pages that need to be recalculated
               for z in 1..l_attributes_a.count loop
                  -- Loop through each attribute mapped to the page
                  for x in (
                     select *
                       from sv_sec_attributes
                      where attribute_id = l_attributes_a (z)
                  )
                  loop
                     -- Remove the collection data for a specific attribute
                     delete from sv_sec_collection_data
                      where collection_id = l_collection_id
                        and attribute_id = l_attributes_a (z);

                     -- Recreate each collection
                     if x.rule_source = 'COLLECTION' then
                        for y in (
                           select *
                             from sv_sec_score_collections
                            where collection_name = x.attribute_key
                        )
                        loop
                           -- Calculate collection-based attributes
                           sv_sec_collections.create_collection (
                               p_collection_id    => l_collection_id
                              ,p_collection_name  => x.attribute_key
                              ,p_application_id   => p_application_id
                              ,p_app_session      => p_app_session
                              ,p_query            => y.collection_sql
                              ,p_attribute_set_id => p_attribute_set_id
                           );
                        end loop;

                        -- Calculate non-collection based attributes
                     elsif x.rule_source = 'COLUMN' then
                        -- Evalute a specific attribute
                        logger.log( 'PAGE SCORE: COLUMN Attribute: '||x.attribute_id);
                        calc_attribute_column (
                            p_collection_id    => l_collection_id
                           ,p_attribute_set_id => p_attribute_set_id
                           ,p_application_id   => p_application_id
                           ,p_attribute_id     => x.attribute_id
                           ,p_app_user         => p_app_user
                           ,p_app_session      => p_app_session
                        );
                     end if;
                     -- Apply exceptions for each attribute
                     sv_sec_exception.apply_exceptions (
                         p_collection_id    => l_collection_id
                        , p_application_id   => p_application_id
                        , p_attribute_set_id => p_attribute_set_id
                        , p_app_user         => p_app_user
                        , p_attribute_id     => l_attributes_a (z)
                        , p_app_session      => p_app_session
                        , p_sert_app_id      => p_sert_app_id
                     );
                  end loop;

               end loop;

            end if;

            -- Add the HTML for FAILed attributes
            -- c_failed_exception
            update sv_sec_collection_data
               set exception = '<i class="'||sv_sec_exception.c_failed_exception ||'" title="Add Exception"></i>'
                  , exception_url = 'f?p='
                     || p_sert_app_id || ':10:' || p_app_session
                     || ':::10:P10_EXCEPTION_PK:'
                     || 'IND|' || attribute_id || '|' || page_id
                     || '|' || component_id || '|' || column_id
             where result        = 'FAIL'
               and collection_id = l_collection_id;

            -- Add the Notation icons, based on existing data
            sv_sec_util.apply_notations (
                  p_collection_id   => l_collection_id
               , p_application_id   => p_application_id
               , p_attribute_set_id => p_attribute_set_id
               , p_sert_app_id      => p_sert_app_id
               , p_app_session      => p_app_session
            );

            if p_app_session > 0 then
               -- Set the P1 Items
               apex_util.set_session_state (
                     'P1_APPLICATION_ID'
                  , p_application_id
               );
               apex_util.set_session_state (
                     'P1_EVAL_ATTRIBUTE_SET_ID'
                  , p_attribute_set_id
               );
            end if;

            if p_app_session < 0 then
               -- Record the Evaluation if run as a scheduled job
               l_dummy := sv_sec_util.print_name (
                     p_application_id  => p_application_id
                  , p_attribute_set_id => p_attribute_set_id
                  , p_record_score     => true
                  , p_app_user         => p_app_user
                  , p_app_session      => p_app_session
                  , p_app_eval_id      => p_app_eval_id
                  , p_scheduled_eval   => p_scheduled_eval
                  , p_evaluated_ws     => p_user_workspace_id
               );
            end if;

         else -- Application is not accessible by the user
            logger.log ('Application ' || p_application_id || ' is not accessible by this user');
            owa_util.redirect_url (
               apex_util.prepare_url (
                  'f?p=' || to_char (p_sert_app_id || ':4:' || p_app_session) )
            );

         end if;

      else -- Application is Run and Build
         logger.log ('The SERT Application Status needs to be set to Run Only');
         owa_util.redirect_url(apex_util.prepare_url('f?p=' || p_sert_app_id || ':3:' || p_app_session) );

      end if;

      -- Return the Score Banner to G_SCORE
      return l_html;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end calc_score;
/*
--------------------------------------------------------------------------------
-- PROCEDURE: D A S H B O A R D
--------------------------------------------------------------------------------
-- Prints a dashboard for a specific page
--------------------------------------------------------------------------------
   function dashboard (
      p_attribute_set_id   in number
    , p_application_id     in number
    , p_page_id            in number default nv ('APP_PAGE_ID')
    , p_format             in varchar2 default 'HTML'
    , p_app_user           in varchar2 default v ('APP_USER')
    , p_app_session        in number default nv ('APP_SESSION')
    , p_sert_app_id        in number default nv ('APP_ID')
   ) return varchar2 as

      type l_score_t is
         table of number index by binary_integer;
      type l_score_label_t is
         table of varchar2 (255) index by binary_integer;

      l_score_arr          l_score_t;
      l_score_label_arr    l_score_label_t;
      l_classification_key sv_sec_classifications.classification_key%type;
      l_collection_id      sv_sec_collection.collection_id%type;
      l_color_rgb          apex_application_global.vc_arr2;

      l_approved_score     number := 0;
      l_component_id       number;
      l_count              number := 0;
      l_page_id            number;
      l_pending_score      number := 0;
      l_pct_score          number;
      l_possible_score     number := 0;
      l_raw_score          number := 0;
      l_total_score        number := 0;
      y                    number := 1;

      l_color              varchar2 (255);
      l_html               varchar2 (32767);
      l_severity           varchar2 (1000);
      l_severity_level     number;
      l_time_to_fix        number;
   begin

      -- Get the current collection ID
      l_collection_id := sv_sec_util.get_collection_id (
                                    p_app_user => p_app_user
                                 , p_app_session => p_app_session
                                 , p_application_id => p_application_id
      );

      -- Set the score labels
      l_score_label_arr (1) := 'Approved';
      l_score_label_arr (2) := 'Pending';
      l_score_label_arr (3) := 'Raw';

      -- Produce the dashboard region for the specific page
      for x in (
         select *
           from sv_sec_attributes
          where display_page_id = p_page_id
      ) loop

         -- Get the classification key
         select cl.classification_key
           into l_classification_key
           from sv_sec_classifications                                                                                                                                                                                                                                                                                                                                                                                                     cl
              , sv_sec_categories                                                                                                                                                                                                                                                                                                                                                                                                          c
              , sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                          a
          where cl.classification_id   = c.classification_id
            and c.category_id          = a.category_id
            and a.attribute_id         = x.attribute_id;

        -- Calculate the total time to fix
         select nvl ( round ( (sum (s.time_to_fix)) / 60 , 2 ) , 0 )
           into l_time_to_fix
           from sv_sec_attribute_set_attrs                                                                                                                                                                                                                                                                                                                                                                                                              s
              , sv_sec_collection_data                                                                                                                                                                                                                                                                                                                                                                                                                  c
              , sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                       a
              , sv_sec_categories                                                                                                                                                                                                                                                                                                                                                                                                                       cat
          where s.attribute_set_id  = p_attribute_set_id
            and s.attribute_id      = c.attribute_id
            and c.attribute_id      = a.attribute_id
            and a.category_id       = cat.category_id
            and c.collection_id     = l_collection_id
            and a.attribute_id      = x.attribute_id
            and c.result not in ('PASS'
                               , 'APPROVED'
                               , 'PENDING');

         if p_format = 'HTML' then
            l_html := '<div>Approximate Time to Fix: '
               || l_time_to_fix
               || ' hours</div><ul class="t-Cards t-Cards--compact t-Cards--displayInitials t-Cards--3cols t-Cards--desc-2ln">';
         else
            if l_classification_key != 'SETTINGS' then
               pl_fpdf.setxy ( 10 , 15 );
               sv_sec_rpt_util.set_font ( p_family => 'Arial' , p_size => 10 , p_style => null );

               pl_fpdf.cell (   pw => 100
                  , ph => 20
                  , ptxt => 'Approximate Time to Fix: ' || l_time_to_fix || ' hours'
                  , palign => 'L'
                  , pborder => '0' );

            end if;
         end if;

         -- Determine if the attribute is in the current attribute set
         select count (*)
           into l_count
           from sv_sec_attribute_set_attrs
          where attribute_id     = x.attribute_id
            and attribute_set_id = p_attribute_set_id;

         if l_count < 1 then
            if p_format = 'HTML' then -- Attribute is not part of the current set
               l_html := l_html
                         || 'This Attribute is not part of the current Attribute Set.  '
                         || 'No information will be displayed.';
            else -- PRINT PLACEHOLDER
               null;
            end if;
         else -- Determine if there are any values for this attribute
            select count (*)
              into l_count
              from sv_sec_collection_data
             where attribute_id = x.attribute_id
               and collection_id = l_collection_id;

            if l_count = 0 then
               if p_format = 'HTML' then
                  l_html := l_html || 'There are no matching components for this attribute.';
               end if;
            else -- Print the scores for the current attribute
               -- APPROVED Score
               select count (*)
                 into
                  l_score_arr (1)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'APPROVED')
                  and case
                        when l_page_id is not null
                         and l_component_id is null
                         and page_id = l_page_id then
                           1
                        when l_page_id is not null
                         and l_component_id is not null
                         and cd.page_id = l_page_id
                         and cd.component_id = l_component_id then
                           1
                        when l_page_id is null and l_component_id is null then
                           1
                        else
                           0
                     end = 1;

               -- PENDING Score
               select count (*)
                 into
                  l_score_arr (2)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'PENDING'
                                  , 'APPROVED')
                  and case
                        when l_page_id is not null
                         and l_component_id is null
                         and page_id = l_page_id then
                           1
                        when l_page_id is not null
                         and l_component_id is not null
                         and cd.page_id = l_page_id
                         and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                         and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- RAW Score
               select count (*)
                 into
                  l_score_arr (3)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result = 'PASS'
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- POSSIBLE Score
               select count (*)
                 into l_possible_score
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- Loop through all three scores and print the progress bar for each
               for x in 1..3 loop

                  -- Calculate the percentage
                  l_pct_score := round ( (l_score_arr (x) / l_possible_score) * 100 , 1 );

                  if p_format = 'HTML' then -- Print the row
                     l_html := l_html
                        || '<li class="t-Cards-item">
                           <div class="t-Card t-Card-wrap">
                              <div class="t-Card-icon">
                                 <span class="t-Icon fa-laptop" style="width:48px; height:48px;background-color:'
                        || sv_sec_util.get_color (
                              p_pct_score => round (l_pct_score)
                           , p_possible_score => l_possible_score
                           )
                        || ';"><span class="t-Card-initials" role="presentation" style="line-height:4.5rem;">'
                        || l_pct_score
                        || '%</span></span></div>
                            <div class="t-Card-titleWrap"><h3 class="t-Card-title">'
                        || l_score_label_arr (x)
                        || '</h3></div>
                              <div class="t-Card-body">
                                 <div class="t-Card-desc">'
                        || l_score_arr (x)
                        || ' out of '
                        || l_possible_score
                        || ' possible points</div>
                              <div class="t-Card-info">
                                 <div class="a-Report-percentChart" style="background-color:#DBDBDB;">
                                 <div class="a-Report-percentChart-fill" style="width:'
                        || l_pct_score
                        || '%; background-color:#999;"></div>
                                 </div>
                              </div>
                              </div>
                              </div>
                           </li>'
                     ;

                  else -- Only print if NOT settings
                     if l_classification_key != 'SETTINGS' then
                        -- Move the cursor
                        pl_fpdf.setxy ( 135 + (x * 35) , 17 );
                        -- Set the header font
                        sv_sec_rpt_util.set_font (
                              p_family => 'Arial'
                           , p_size => 10
                           , p_style => 'B'
                           , p_r => 0
                           , p_g => 0
                           , p_b => 0
                        );

                        -- Print the header
                        pl_fpdf.cell (
                              pw => 20
                           , ph => 5
                           , ptxt => l_score_label_arr (x)
                           , palign => 'R'
                           , pborder => '0'
                        );

                        -- Drop the cursor
                        pl_fpdf.setxy (
                              132 + (x * 35)
                           , 21
                        );

                        -- Set the detail font
                        sv_sec_rpt_util.set_font (
                              p_family => 'Arial'
                           , p_size => 9
                           , p_style => null
                        );

                        -- Print the details
                        pl_fpdf.cell (
                              pw => 23
                           , ph => 5
                           , ptxt => l_score_arr (x)
                                    || ' out of '
                                    || l_possible_score
                           , palign => 'R'
                           , pborder => '0'
                        );

                        --Set the percentage font color
                        sv_sec_rpt_class_summary.set_color (
                              p_pct_score => (l_score_arr (x) / l_possible_score) * 100
                           , p_possible_score => l_possible_score
                        );

                        -- Move the cursor
                        pl_fpdf.setxy (
                              135 + (x * 35) + 20
                           , 15
                        );

                        -- Set the detail font
                        sv_sec_rpt_util.set_font (
                              p_family => 'Arial'
                           , p_size => 12
                           , p_style => 'B'
                           , p_r => 255
                           , p_g => 255
                           , p_b => 255
                        );

                        -- Print the percentage
                        pl_fpdf.cell (
                              pw => 12
                           , ph => 10
                           , ptxt => round ( ((l_score_arr (x) / l_possible_score) * 100) , 0 )
                                    || '%'
                           , palign => 'C'
                           , pfill => 1
                        );

                     end if;
                  end if;

                  -- Reset the alternating row color
                  pl_fpdf.setfillcolor (
                     230
                     , 230
                     , 230
                  );
               end loop;

            end if;

         end if;

      end loop;

      if p_format = 'HTML' then
         -- Close the region
         l_html := l_html || '</ul>';
         return l_html;
      else
         return 'x';
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end dashboard;
*/
--------------------------------------------------------------------------------
-- FUNCTION: G E T _ R E S U L T
--------------------------------------------------------------------------------
-- Returns the result for a specific attribute
--------------------------------------------------------------------------------
   function get_result (
       p_attribute_key      in varchar2
      ,p_attribute_set_id   in number
      ,p_value              in varchar2
      ,p_recommended_value  in varchar2 default null  -- Not used
      ,p_show_value         in varchar2 default 'N'   -- Not used
      ,p_image              in varchar2 default 'Y'   -- Not used
      ,p_exception_key      in varchar2 default null  -- Not used
      ,p_inline             in varchar2 default 'N' ) -- Not used
      return varchar2
   is
      l_values  apex_application_global.vc_arr2;
      l_results apex_application_global.vc_arr2;

      procedure load_attribute_values is
      begin
         -- Populate the array with all potential PASS values for the attribute
         select av.value
               ,av.result
           bulk collect
           into l_values
               ,l_results
           from sv_sec_attribute_values av
               ,sv_sec_attributes       a
          where a.attribute_id = av.attribute_id
            and a.attribute_key = p_attribute_key
            and av.attribute_set_id = p_attribute_set_id;

         if l_values.count = 0 then
            logger.log_error(logger.sprintf('Attribute key %s in attribute set %s does not have any attribute values assigned.', p_attribute_key, p_attribute_set_id));
         end if;
      end;
   begin
      --
      -- DEPRECATED FUNCTION: code left here in case any existing collection_sql or collection template sql is still calling it.
      --

      -- Loop through a single attribute and determine whether it passed or failed
      for x in (
         select a.attribute_id
               ,a.attribute_key
               ,a.rule_type
               ,a.rule_source
               ,a.when_not_found
           from sv_sec_attribute_set_attrs asa
               ,sv_sec_attributes          a
               ,sv_sec_attribute_sets      s
          where asa.attribute_id = a.attribute_id
            and a.attribute_key = p_attribute_key
            and s.attribute_set_id = asa.attribute_set_id
            and s.attribute_set_id = p_attribute_set_id )
      loop
         if x.rule_source in ('COLUMN' , 'COLLECTION') then
            if x.rule_type = 'NONE' then
               -- Unconditionally Pass, as no rule needs to be applied
               return 'PASS';

            elsif x.rule_type = 'NOT_NULL' then
               if p_value is null then
                  return 'FAIL';
               else
                  return 'PASS';
               end if;

            elsif x.rule_type = 'LESS_THAN' then
               load_attribute_values;
               return case  when l_values.count = 0               then null
                            when to_number(p_value) < l_values(1) then 'PASS'
                            else 'FAIL'
                            end;

            elsif x.rule_type = 'GREATER_THAN' then
               load_attribute_values;
               return case  when l_values.count = 0               then null
                            when to_number(p_value) > l_values(1) then 'PASS'
                            else 'FAIL'
                            end;

            elsif x.rule_type = 'COMPARISON' then
               load_attribute_values;
               for z in 1..l_values.count loop
                  if l_values(z) = p_value then
                     return l_results(z);
                  end if;
               end loop;

               return x.when_not_found;

            else -- Unhandled issue
               return 'FAIL';
            end if;

         elsif x.rule_source = 'PLSQL' then
            -- Not yet implemented
            return 'FAIL';
         end if;
      end loop;

      return null;
   exception
      when others then
         logger.log(logger.sprintf('Attribute %s - Value: %s', p_attribute_key, p_value));
         sv_sec_error.raise_unanticipated;
   end get_result;

--------------------------------------------------------------------------------
-- FUNCTION: C H E C K _ A T T R I B U T E _ R U L E
--------------------------------------------------------------------------------
-- Returns the result for a specific attribute
--------------------------------------------------------------------------------
   function check_attribute_rule(
       p_value             in varchar2
      ,p_rule_source       in varchar2
      ,p_rule_type         in varchar2
      ,p_when_not_found    in varchar2
      ,p_attribute_values  in varchar2
      ,p_attribute_results in varchar2 )
      return varchar2
   is
      l_values  apex_application_global.vc_arr2;
      l_results apex_application_global.vc_arr2;

      procedure load_attribute_values is
         c_separator constant varchar2(1) := ':';
      begin
         l_values  := apex_string.string_to_table(p_attribute_values, c_separator);
         l_results := apex_string.string_to_table(p_attribute_results, c_separator);
      end;

   begin
      if p_rule_source in ('COLUMN' , 'COLLECTION') then
         if p_rule_type = 'NONE' then
            -- Unconditionally Pass, as no rule needs to be applied
            return 'PASS';

         elsif p_rule_type = 'NOT_NULL' then
            return case when p_value is not null then 'PASS' else 'FAIL' end;

         elsif p_rule_type = 'LESS_THAN' then
            load_attribute_values;
            return case when l_values.count = 0                          then null
                        when to_number(p_value) < to_number(l_values(1)) then 'PASS'
                        else 'FAIL'
                        end;

         elsif p_rule_type = 'GREATER_THAN' then
            load_attribute_values;
            return case when l_values.count = 0                          then null
                        when to_number(p_value) > to_number(l_values(1)) then 'PASS'
                        else 'FAIL'
                        end;

         elsif p_rule_type = 'COMPARISON' then
            load_attribute_values;
            for z in 1..l_values.count loop
               if l_values(z) = p_value then
                  return l_results(z);
               end if;
            end loop;

            return p_when_not_found;

         else -- Unhandled issue
            return 'FAIL';
         end if;

      elsif p_rule_source = 'PLSQL' then
         -- Not yet implemented
         return 'FAIL';
      end if;

      return null;
   exception
      when others then
         logger.log_error(logger.sprintf('Rule %s-%s failed for value: %s', p_rule_source, p_rule_type, p_value));
         sv_sec_error.raise_unanticipated;
   end check_attribute_rule;


--------------------------------------------------------------------------------
-- FUNCTION: G E T _ R E C O M M E N D E D _ V A L U E
--------------------------------------------------------------------------------
-- Retrns recommended value(s) for an attribute
--------------------------------------------------------------------------------
   function get_recommended_value (
       p_attribute_set_id   in number
      ,p_attribute_key      in varchar2
   ) return varchar2 is

      l_recommended_value      varchar2 (4000);
      l_recommended_value_list varchar2 (32767);
      l_counter                number := 0;
      l_rule_type              sv_sec_attributes.rule_type%type;
   begin

      -- Get the rule type
      select rule_type
        into l_rule_type
        from sv_sec_attributes
       where attribute_key = p_attribute_key;

      -- Determine what to return based on the rule type
      if l_rule_type = 'NONE' then
         return null;
      elsif l_rule_type = 'NOT_NULL' then
         return 'NOT NULL';
      else

         -- Loop through and return all recommended values for an attribute
         for x in (
            select sav.value
                  ,sav.result
              from sv_sec_attributes          sa
                  ,sv_sec_attribute_set_attrs sasa
                  ,sv_sec_attribute_values    sav
             where sa.attribute_id = sasa.attribute_id
               and sasa.attribute_set_id = p_attribute_set_id
               and sav.attribute_set_id = sasa.attribute_set_id
               and sasa.attribute_id = sav.attribute_id (+)
               and sa.attribute_key = p_attribute_key
               and sav.result = 'PASS'
               and sa.active_flag = 'Y'
         )
         loop
            l_recommended_value := x.value;
            l_recommended_value_list := l_recommended_value_list
                                        || '<li style="font-size:1.2rem; margin-left:10px;">'
                                        || x.value
                                        || '</li>';
            l_counter := l_counter + 1;
         end loop;

         if l_counter > 1 then
            return nvl (l_recommended_value_list, 'n/a');
         else
            if l_rule_type = 'LESS_THAN' then
               return 'Less Than ' || nvl (l_recommended_value, 'n/a');
            elsif l_rule_type = 'GREATER_THAN' then
               return 'Greater Than ' || nvl (l_recommended_value, 'n/a');
            else
               return nvl (l_recommended_value, 'n/a');
            end if;
         end if;

      end if;

   end get_recommended_value;

---------------------------------------------------------------------
--< summary_cards >--
---------------------------------------------------------------------
-- Purpose         : briefly
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : <brief description>
--
-- Comments  : <general comments>
--    Car Title is the Category or Attribute
--    Card Initials hold the percent passed/pending
--    Color is based on pct of successful tests
--    card text is the english language version of the count X passed out of Y total
--
-- Call Example :
--

---------------------------------------------------------------------
   function category_summary_card (
       p_attribute_set_id   in number
      ,p_application_id     in number
      ,p_page_id            in number default nv ('APP_PAGE_ID')
      ,p_format             in varchar2 default 'HTML'
      ,p_app_user           in varchar2 default v ('APP_USER')
      ,p_app_session        in number default nv ('APP_SESSION')
      ,p_sert_app_id        in number default nv ('APP_ID')
      ,p_banner_yn          in varchar2 default 'N'
   ) return t_basic_card_tab
      pipelined
   as

      type l_score_t is
         table of number index by binary_integer;
      type l_score_label_t is
         table of varchar2 (255) index by binary_integer;
      type card_array is
         table of t_basic_card index by pls_integer;

      l_basic_card         card_array;
      l_card               t_basic_card;
      l_score_arr          l_score_t;
      l_score_label_arr    l_score_label_t;
      l_classification_key sv_sec_classifications.classification_key%type;
      l_collection_id      sv_sec_collection.collection_id%type;
      l_title              apex_application_pages.page_title%type;
      l_color_rgb          apex_application_global.vc_arr2;

      l_banner             boolean := upper (p_banner_yn) = 'Y';

      l_pct_score          number;
      l_total_score        number := 0;
      l_raw_score          number := 0;
      l_pending_score      number := 0;
      l_possible_score     number := 0;
      l_approved_score     number := 0;
      l_count              number := 0;
      l_component_id       number;
      l_page_id            number;
      l_severity_level     number;
      l_time_to_fix        number;
      l_total_pct          number := 0;
      y                    number := 1;

      l_color              varchar2 (255);
      l_html               varchar2 (32767);
      l_result             varchar2 (100);
      l_severity           varchar2 (1000);


      ---------------------------------------------------------------------
      -- select counts for each attribute in the category
      ---------------------------------------------------------------------
      cursor c_attribute_counts is
      select            ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id )   total_count
                      , ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'PASS' )                pass_count
                      , ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'PENDING' )             pending_count
                      , ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'STALE' )               stale_count
                      , ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'APPROVED' )            approved_count
                      , ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'FAIL' )    fail_count
                      , atr.attribute_name
                      , atr.summary_page_id
                      , atr.display_page_id
                 from  sv_sec_attributes atr
                where  summary_page_id = p_page_id
                  and active_flag like 'Y';
      ---------------------------------------------------------------------
      -- Take the same query and wrap it to make a simple cursor showing summary
      -- page totals
      ---------------------------------------------------------------------
      cursor c_counts is
      select sum (total_count)    as total_count
            ,sum (pass_count)     as pass_count
            ,sum (pending_count)  as pending_count
            ,sum (stale_count)    as stale_count
            ,sum (approved_count) as approved_count
            ,sum (fail_count)     as fail_count
            ,category_id          as category_id
        from ( select   ( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id )   total_count
                       ,( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'PASS' )                pass_count
                       ,( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'PENDING' )             pending_count
                       ,( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'STALE' )               stale_count
                       ,( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'APPROVED' )            approved_count
                       ,( select count (*)
                            from sv_sec_collection_data cd
                           where cd.application_id = p_application_id
                             and attribute_id = atr.attribute_id
                             and collection_id = l_collection_id
                             and result like 'FAIL' )    fail_count
                       ,atr.category_id
                 from  sv_sec_attributes atr
                where  summary_page_id = p_page_id
                  and active_flag like 'Y'
                order by attribute_key
      )
       group by category_id;


   begin
      -- Get the name based on the page name
      select page_title
        into l_title
        from apex_application_pages
       where page_id = p_page_id
         and application_id = p_sert_app_id;

      -- Get the current collection ID
      l_collection_id := sv_sec_util.get_collection_id (
            p_app_user => p_app_user
         , p_app_session => p_app_session
         , p_application_id => p_application_id
      );

      -- Get the value of Result
      l_result := nvl ( v ('P0_RESULT') , 'Raw' );

      if( p_banner_yn = 'Y') then
         -- Produce the dashboard region for the specific summary page
         for rec in c_counts loop
            l_card.card_title := l_title;
            l_card.card_subtext := null;

            if (rec.total_count = 0) then
               -- setup "empty" result
               l_total_pct := 0;
               l_card.card_color    := null;
               l_card.card_initials := null;
               l_card.card_text     := 'No matching components for this attribute';
               l_card.card_subtext  := null;
            else
               l_total_pct := round (
                  (rec.total_count - rec.fail_count - rec.stale_count) / rec.total_count * 100
                  , 1
               );
               l_card.card_initials := floor (l_total_pct);
               l_card.card_color    := sv_sec_util.get_color_class (
                  p_pct_score          => round (l_total_pct)
                  , p_possible_score   => rec.total_count
               );

               l_card.card_text := (rec.total_count - rec.fail_count - rec.stale_count)
                                 || ' out of '
                                 || rec.total_count
                                 || ' possible points';
            end if;
            pipe row (l_card);
         end loop;
      else
         -- doing the details
         for rec in c_attribute_counts loop

            case
               when (instr ( rec.attribute_name , 'Contains' ) > 0) then
                  l_card.card_title := substr ( rec.attribute_name
                              , instr ( rec.attribute_name , 'Contains' ) + 9 );
               when (instr ( rec.attribute_name , 'Inconsistencies' ) > 0) then
                  l_card.card_title := replace ( rec.attribute_name
                              , 'Inconsistencies' , null );
               else
                  l_card.card_title := rec.attribute_name;
            end case;

            l_card.card_link := apex_util.prepare_url ('f?p=' || p_sert_app_id
               || ':' || rec.display_page_id
               || ':' || p_app_session);

           if ( rec.total_count = 0 ) then
               l_total_pct          := null; --100;
               l_card.card_color    := null; --'u-success';
               l_card.card_initials := null; --100;
               l_card.card_text     := 'No matching components for this attribute';
               l_card.card_subtext  := null;
            else
               l_total_pct := round (
                  (rec.total_count - rec.fail_count - rec.stale_count) / rec.total_count * 100
                  , 1
               );

               l_card.card_color    := sv_sec_util.get_color_class (
                  p_pct_score          => round (l_total_pct)
                  , p_possible_score   => rec.total_count
               );

               l_card.card_initials := floor (l_total_pct);
               l_card.card_text := (rec.total_count - rec.fail_count - rec.stale_count)
                                 || ' out of ' || rec.total_count || ' possible points';

               l_card.card_subtext := null;

           end if;

            pipe row (l_card);

         end loop;
      end if;
   exception
      when others then
         logger.log_error;
         raise;
   end category_summary_card;

---------------------------------------------------------------------
--  attribute_cards
---------------------------------------------------------------------

--------------------------------------------------------------------------------
-- PROCEDURE: S U M M A R Y _ D A S H B O A R D
--------------------------------------------------------------------------------
-- Prints a dashboard for a Summary Page
--------------------------------------------------------------------------------
   procedure summary_dashboard (
      p_attribute_set_id in   number
    , p_application_id   in   number
    , p_page_id          in   number
    , p_app_user         in   varchar2 default v ('APP_USER')
    , p_app_session      in   number default nv ('APP_SESSION')
    , p_sert_app_id      in   number default nv ('APP_ID')
   ) as

      type l_score_t is
         table of number index by binary_integer;

      l_collection_id         sv_sec_collection.collection_id%type;
      l_title                 apex_application_pages.page_title%type;
      l_result                varchar2 (100);
      l_pct_score             number;
      l_score_arr             l_score_t;
      l_possible_score        number := 0;
      y                       number := 1;
      z                       number;
      l_pending_count         number;
      l_count                 number;
      l_total                 number := 0;
      l_total_pct             number := 0;
      l_attribute_name        varchar2 (255);
      l_total_possible_score  number := 0;
      l_not_found_html        varchar2 (10000);
      l_html                  varchar2 (10000);
   begin

-- Get the name based on the page name
      select page_title
        into l_title
        from apex_application_pages
       where page_id = p_page_id
         and application_id = p_sert_app_id;

-- Get the current collection ID
      l_collection_id := sv_sec_util.get_collection_id (
            p_app_user => p_app_user
         , p_app_session => p_app_session
         , p_application_id => p_application_id
      );

-- Get the value of Result
      l_result := nvl ( v ('P0_RESULT') , 'Raw' );

-- Produce the dashboard region for the specific summary page
      for x in (
         select *
           from sv_sec_attributes
          where summary_page_id = p_page_id
            and active_flag = 'Y'
          order by attribute_key
      ) loop
  -- Determine if any components exist
         select count (*)
           into l_count
           from sv_sec_collection_data
          where attribute_id = x.attribute_id
            and collection_id = l_collection_id;

  -- If there is no data found, then record the card
         if l_count = 0 then

    -- Get the attribute name
            if instr ( x.attribute_name , 'Contains' ) > 0 then
               l_attribute_name := substr (
                                          x.attribute_name
                                        , instr (
                                                x.attribute_name
                                              , 'Contains'
                                          ) + 9
                                   );
            else
               l_attribute_name := x.attribute_name;
            end if;

            l_not_found_html := l_not_found_html
               || '<li class="t-Cards-item">'
               || '<div class="t-Card t-Card-wrap"><a href="'
               || apex_util.prepare_url ('f?p='
                                          || p_sert_app_id
                                          || ':'
                                          || x.display_page_id
                                          || ':'
                                          || p_app_session)
               || '">'
               || '  <div class="t-Card-titleWrap"><h3 class="t-Card-title">'
               || case
                  when (instr ( x.attribute_name , 'Contains' ) > 0) then
                     substr (
                            x.attribute_name
                          , instr (
                                  x.attribute_name
                                , 'Contains'
                            ) + 9
                     )
                  when (instr ( x.attribute_name , 'Inconsistencies' ) > 0) then
                     replace (
                             x.attribute_name
                           , 'Inconsistencies'
                           , null
                     )
                  else x.attribute_name
                  end
               || '</h3></div>'
               || '<div class="t-Card-body">'
               || '  <div class="t-Card-desc" style="height:60px;">No matching components for this attribute</div>'
               || '  </div>'
               || '</a></div>'
               || '</li>';

         else
            if l_result = 'Approved' then
               select count (*)
                 into
                  l_score_arr (y)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'APPROVED');

            elsif l_result = 'Pending' then
               -- PENDING Score
               select count (*)
                 into
                  l_score_arr (y)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'PENDING'
                                  , 'APPROVED');

            elsif l_result = 'Raw' then
               -- RAW Score
               select count (*)
                 into
                  l_score_arr (y)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result = 'PASS';

            end if;

            -- POSSIBLE Score
            select count (*)
              into l_possible_score
              from sv_sec_collection_data cd
             where cd.attribute_id = x.attribute_id
               and cd.collection_id = l_collection_id;

            if l_possible_score != 0 then
               l_pct_score := round (
                  (l_score_arr (y) / l_possible_score) * 100
                  , nvl ( apex_util.get_preference ( p_preference => 'SCORE_PRECISION'
                                                   , p_user => v ( 'G_WORKSPACE_ID' )
                                                     || '.'
                                                     || v ( 'APP_USER' )
                                                   )
                        , 2
                        )
               );

               l_total_possible_score := l_total_possible_score + l_possible_score;
            end if;

    -- Determine how many pending attributes exist
    -- this is used in the 2nd displayed section of the dashboard
            select count (*) cnt
              into l_pending_count
              from sv_sec_collection_data cd
             where cd.attribute_id = x.attribute_id
               and cd.collection_id = l_collection_id
               and result = 'PENDING';

            l_html := l_html
               || '<li class="t-Cards-item">'
               || '<div class="t-Card t-Card-wrap"><a href="'
               || apex_util.prepare_url ('f?p='
                                       || p_sert_app_id
                                       || ':'
                                       || x.display_page_id
                                       || ':'
                                       || p_app_session)
               || '">'
               || '  <div class="t-Card-icon"><span class="t-Icon fa-laptop" style="width:48px; height:48px;background-color:'
               || sv_sec_util.get_color (
                                       p_pct_score => l_pct_score
                                    , p_possible_score => l_possible_score
                  )
               || ';"><span class="t-Card-initials" role="presentation" style="line-height:4.5rem;">'
               || l_pct_score
               || '%</span></span></div>'
               || '  <div class="t-Card-titleWrap"><h3 class="t-Card-title">'
               || case
                     when (instr (
                                 x.attribute_name
                              , 'Contains'
                           ) > 0) then
                        substr (
                              x.attribute_name
                           , instr (
                                    x.attribute_name
                                 , 'Contains'
                              ) + 9
                        )
                     when (instr (
                                 x.attribute_name
                              , 'Inconsistencies'
                           ) > 0) then
                        replace (
                              x.attribute_name
                              , 'Inconsistencies'
                              , null
                        )
                     else x.attribute_name
                  end
               || '</h3></div>'
               || '  <div class="t-Card-body">'
               || '    <div class="t-Card-desc">'
               || l_score_arr (y)
               || ' out of '
               || l_possible_score
               || ' possible points</div>'
               || '    <div class="t-Card-info">'
               || '      <div class="a-Report-percentChart" style="background-color:#DBDBDB;">'
               || '        <div class="a-Report-percentChart-fill" style="width:'
               || l_pct_score
               || '%; background-color:#999;"></div>'
               || '      </div>'
               || '    </div>'
               || '  </div>'
               || '</a></div>'
               || '</li>';

            -- Increment the score
            l_total  := l_total + l_score_arr (y);

            -- Increment the counter
            y        := y + 1;
         end if;

      end loop;

      -- Remove the last value from y
      y := y - 1;

      -- Print the Totals
      if l_possible_score = 0 then
         l_total_pct := 0;
         l_total     := 0;
      else
         l_total_pct := round ( (l_total / (l_total_possible_score)) * 100 , 1 );
      end if;

      htp.prn ('<ul class="t-Cards t-Cards--compact t-Cards--displayInitials t-Cards--cols">'
         || '<li class="t-Cards-item" style="width:100%;">'
         || '  <div class="t-Card t-Card-wrap">'
         || '    <div class="t-Card-icon"'
         || case
               when l_total_possible_score = 0 then
                  'style="display:none;"'
            end
         || '><span class="t-Icon fa-laptop" style="width:48px; height:48px;background-color:'
         || sv_sec_util.get_color (
                                    p_pct_score => round (l_total_pct)
                                 , p_possible_score => l_total_possible_score
            )
         || ';">'
         || '      <span class="t-Card-initials" role="presentation" style="line-height:4.5rem;">'
         || case
               when l_total_pct > 100 then
                  100
               else l_total_pct
            end
         || '%</span></span></div>'
         || '    <div class="t-Card-titleWrap"><h3 class="t-Card-title">'
         || l_title
         || '</h3></div>'
         || '    <div class="t-Card-body">'
         || '      <div class="t-Card-desc">'
         || case
               when l_total_possible_score = 0 then
                  'No Attributes in this application'
               else to_char (
                           l_total
                        , '999G999'
                  )
                  || ' out of '
                  || to_char (
                              l_total_possible_score
                           , '999G999'
                     )
                  || ' Possible Points ( topline'
            end
         || '</div>'
         || '    </div>'
         || '  </div>'
         || '</li>'
         || '</ul>'
      );

      -- Open the UL
      htp.prn ('<ul class="t-Cards t-Cards--compact t-Cards--displayInitials t-Cards--3cols t-Cards--desc-2ln">');

      -- Print the HTML for found attributes
      htp.
      prn (l_html);

      -- Print the HTML for not found attributes
      htp.prn (l_not_found_html);

      -- Close the UL
      htp.prn ('</ul>');
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end summary_dashboard;

/*
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
   function dashboard_cards (
      p_attribute_set_id   in number
    , p_application_id     in number
    , p_page_id            in number   default nv ('APP_PAGE_ID')
    , p_format             in varchar2 default 'HTML'
    , p_app_user           in varchar2 default v ('APP_USER')
    , p_app_session        in number   default nv ('APP_SESSION')
    , p_sert_app_id        in number   default nv ('APP_ID')
   ) return t_basic_card_tab
      pipelined
   as

      type card_array is
         table of t_basic_card index by pls_integer;
      type l_score_t is
         table of number index by binary_integer;
      type l_score_label_t is
         table of varchar2 (255) index by binary_integer;
      l_basic_card         card_array;
      l_card               t_basic_card;
      l_collection_id      sv_sec_collection.collection_id%type;
      l_classification_key sv_sec_classifications.classification_key%type;

      l_approved_score     number := 0;
      l_component_id       number;
      l_count              number := 0;
      l_page_id            number;
      l_pct_score          number;
      l_pending_score      number := 0;
      l_possible_score     number := 0;
      l_raw_score          number := 0;
      l_score_arr          l_score_t;
      l_score_label_arr    l_score_label_t;
      l_severity_level     number;
      l_time_to_fix        number;
      l_total_score        number := 0;
      y                    number := 1;

      l_color_rgb          apex_application_global.vc_arr2;
      l_color              varchar2 (255);
      l_html               varchar2 (32767);
      l_severity           varchar2 (1000);
   begin

      -- Get the current collection ID
      l_collection_id := sv_sec_util.get_collection_id (
            p_app_user => p_app_user
         , p_app_session => p_app_session
         , p_application_id => p_application_id
      );

      -- Set the score labels
      l_score_label_arr (1) := 'Approved';
      l_score_label_arr (2) := 'Pending';
      l_score_label_arr (3) := 'Raw';

      -- Produce the dashboard region for the specific page
      for x in (
         select *
           from sv_sec_attributes
          where display_page_id = p_page_id
      ) loop
         -- Get the classification key
         select cl.classification_key
           into l_classification_key
           from sv_sec_classifications                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               cl
              , sv_sec_categories                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    c
              , sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    a
          where cl.classification_id = c.classification_id
            and c.category_id = a.category_id
            and a.attribute_id = x.attribute_id;

         -- Calculate the total time to fix
         select nvl ( round ( (sum (s.time_to_fix)) / 60 , 2 ) , 0 )
           into l_time_to_fix
           from sv_sec_attribute_set_attrs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        s
              , sv_sec_collection_data                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            c
              , sv_sec_attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 a
              , sv_sec_categories                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 cat
          where s.attribute_set_id  = p_attribute_set_id
            and s.attribute_id      = c.attribute_id
            and c.attribute_id      = a.attribute_id
            and a.category_id       = cat.category_id
            and c.collection_id     = l_collection_id
            and a.attribute_id      = x.attribute_id
            and c.result not in ('PASS'
                               , 'APPROVED'
                               , 'PENDING');

         if ( l_classification_key != 'SETTINGS'
            and p_format not like 'HTML' )
         then
            pl_fpdf.setxy ( 10 , 15 );
            sv_sec_rpt_util.set_font (
                  p_family => 'Arial'
               , p_size => 10
               , p_style => null
            );

            pl_fpdf.cell (
                  pw => 100
               , ph => 20
               , ptxt => 'Approximate Time to Fix: '
                        || l_time_to_fix
                        || ' hours'
               , palign => 'L'
               , pborder => '0'
            );
         end if;

         -- Determine if the attribute is in the current attribute set
         select count (*)
           into l_count
           from sv_sec_attribute_set_attrs
          where attribute_id = x.attribute_id
            and attribute_set_id = p_attribute_set_id;

         if l_count > 0 then
            -- Determine if there are any values for this attribute

            select count (*)
              into l_count
              from sv_sec_collection_data
             where attribute_id = x.attribute_id
               and collection_id = l_collection_id;

            if l_count > 0 then
               -- Print the scores for the current attribute
               -- APPROVED Score
               select count (*)
                 into
                  l_score_arr (1)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'APPROVED')
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- PENDING Score
               select count (*)
                 into
                  l_score_arr (2)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in ('PASS'
                                  , 'PENDING'
                                  , 'APPROVED')
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- RAW Score
               select count (*)
                 into
                  l_score_arr (3)
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result = 'PASS'
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- POSSIBLE Score
               select count (*)
                 into l_possible_score
                 from sv_sec_collection_data cd
                where cd.attribute_id = x.attribute_id
                  and cd.collection_id = l_collection_id
                  and case
                        when l_page_id is not null
                           and l_component_id is null
                           and page_id = l_page_id then
                           1
                        when l_page_id is not null
                           and l_component_id is not null
                           and cd.page_id = l_page_id
                           and cd.component_id = l_component_id then
                           1
                        when l_page_id is null
                           and l_component_id is null then
                           1
                        else
                           0
                      end = 1;

               -- Loop through all three scores and print the progress bar for each
               for x in 1..3 loop
                  if p_format = 'HTML' then
                     -- Calculate the percentage
                     l_pct_score := round ( (l_score_arr (x) / l_possible_score) * 100 , 1 );

                     l_basic_card (x).card_color := sv_sec_util.get_color_class (
                        p_pct_score          => round (l_pct_score)
                        , p_possible_score   => l_possible_score
                     );

                     l_basic_card (x).card_title      := l_score_label_arr (x);
                     l_basic_card (x).card_initials   := round (l_pct_score) || '%';
                     l_basic_card (x).card_text       := l_score_arr (x)
                                                      || ' out of '
                                                      || l_possible_score
                                                      || ' possible points';

                     l_basic_card (x).card_subtext := '<div class="a-Report-percentChart" style="background-color:#DBDBDB;"> <div class="a-Report-percentChart-fill" style="width:'
                                                      || l_pct_score
                                                      || '%; background-color:#999;"></div> </div>';
                     pipe row (l_basic_card (x));
                  else
                     -- Only print if NOT settings
                     if l_classification_key != 'SETTINGS' then
                        -- Move the cursor
                        pl_fpdf.setxy ( 135 + (x * 35) , 17 );

                        -- Set the header font
                        sv_sec_rpt_util.set_font (
                              p_family => 'Arial'
                           , p_size => 10
                           , p_style => 'B'
                           , p_r => 0
                           , p_g => 0
                           , p_b => 0
                        );

                        -- Print the header
                        pl_fpdf.cell ( pw => 20 , ph => 5 , ptxt => l_score_label_arr (x) , palign => 'R' , pborder => '0' );

                        -- Drop the cursor
                        pl_fpdf.setxy ( 132 + (x * 35) , 21 );

                        -- Set the detail font
                        sv_sec_rpt_util.set_font (
                              p_family => 'Arial'
                           , p_size => 9
                           , p_style => null
                        );

                        -- Print the details
                        pl_fpdf.cell ( pw => 23 , ph => 5 , ptxt => l_score_arr (x) || ' out of ' || l_possible_score , palign => 'R' , pborder => '0' );

                        --Set the percentage font color
                        sv_sec_rpt_class_summary.set_color (
                              p_pct_score => (l_score_arr (x) / l_possible_score) * 100
                           , p_possible_score => l_possible_score
                        );

                        -- Move the cursor
                        pl_fpdf.setxy ( 135 + (x * 35) + 20 , 15 );

                        -- Set the detail font
                        sv_sec_rpt_util.set_font (
                             p_family => 'Arial'
                           , p_size    => 12
                           , p_style   => 'B'
                           , p_r       => 255
                           , p_g       => 255
                           , p_b       => 255
                        );

                        -- Print the percentage
                        pl_fpdf.cell ( pw    => 12 , ph     => 10 , ptxt   => round ( ((l_score_arr (x) / l_possible_score) * 100) , 0 ) || '%' , palign => 'C' , pfill  => 1 );

                     end if;
                  end if;
               end loop;

            end if;

         end if;

      end loop;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end dashboard_cards;
*/
end sv_sec;
/