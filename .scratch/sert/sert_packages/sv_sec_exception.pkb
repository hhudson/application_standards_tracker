create or replace package body sv_sec_exception as
---------------------------------------------------------------------
--
-- Copyright(C) 2020, Oracle Corporation 
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec_exception.pkb
-- Purpose              : MyPurpose
--
-- HAS COMMITS          : NO
-- HAS ROLLBACKS        : NO
-- RUNTIME DEPLOYMENT   : YES
--
-- Comments :
--
--    MyComments
-- 
-- History :
-- 
--    MODIFIED (DD-Mon-YYYY)  
--    mipotter  15-Oct-2021 - modified to use constants to display icons
--    mzimon    20-OCT-2021 GAT-52. Added page_id to save_exception, 
--                          save_approval, save_rejection.
--                          
--    
---------------------------------------------------------------------

--------------------------------------------------------------------------------
-- P R O C E D U R E :   S E N D _ N O T I F I C A T I O N
--------------------------------------------------------------------------------
-- Sends Notifications when exceptions are created, approved and/or rejected
--------------------------------------------------------------------------------
   procedure send_notification (
      p_type               in  varchar2,
      p_application_id     in  number,
      p_attribute_id       in  number,
      p_page_id            in  number,
      p_number_affected    in  number,
      p_app_user           in  varchar2,
      p_attribute_set_id   in  number,
      p_user_workspace_id  in  number,
      p_justification      in  varchar2
   ) is
   begin

-- Future Feature
      null;
   end send_notification;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ E X C E P T I O N _ I D
--------------------------------------------------------------------------------
-- Gets the surrogate PK for an Exception
--------------------------------------------------------------------------------
   function get_exception_id (
      p_exception_pk      in  varchar2,
      p_application_id    in  number,
      p_attribute_set_id  in  number
   ) return number is
      l_exception_id  number;
      l_pk            apex_application_global.vc_arr2;
      l_attribute_id  number;
      l_page_id       number;
      l_component_id  varchar2(1000);
      l_column_id     number;
   begin

-- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk, '|');

-- Loop through the table and assign each component
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               null;
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      select exception_id
        into l_exception_id
        from sv_sec_exceptions
       where attribute_id = l_attribute_id
         and application_id = p_application_id
         and attribute_set_id = p_attribute_set_id
         and case
             when l_page_id is not null
                and l_component_id is null
                and l_column_id is null
                and page_id = l_page_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is null
                and page_id = l_page_id
                and component_id = l_component_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is not null
                and page_id = l_page_id
                and component_id = l_component_id
                and column_id = l_column_id then
                1
             else
                0
          end = 1;

      return l_exception_id;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_exception_id;

--------------------------------------------------------------------------------
-- PROCEDURE: S A V E _ E X C E P T I O N
--------------------------------------------------------------------------------
-- Saves an exception
--------------------------------------------------------------------------------
   procedure save_exception (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_justification      in  varchar2,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   ) is
      l_scope           varchar2(100);
      l_attribute_id    number;
      l_page_id         number;
      l_component_id    varchar2(1000);
      l_column_id       number;
      l_count           number := 0;
      l_pk              apex_application_global.vc_arr2;
      l_checksum        raw(16);
      l_val             clob;
      l_exception_id    number;
      l_attribute_name  varchar2(255);
      l_exception_api   varchar2(255) := 'N';
   begin

-- Determine if the exception needs to be created in an external system
      for x in (
         select *
           from sv_sec_snippets
          where snippet_key = 'EXCEPTION_API'
      ) loop
         if UPPER(x.snippet) = 'Y' or UPPER(x.snippet) = 'YES' then
            l_exception_api := 'Y';
         end if;
      end loop;

-- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk, '|');

-- Loop through the table and assign each component
-- String should conform to this: SCOPE:ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_scope := l_pk(x);
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      if l_scope = 'BAT' then
-- Loop though the collection for all FAIL components that match
         for x in (
            select *
              from sv_sec_collection_data
             where collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
               and case
                   when l_attribute_id is not null
                      and l_page_id is null
                      and l_component_id is null
                      and l_column_id is null
                      and attribute_id = l_attribute_id then
                      1
                   when l_attribute_id is not null
                      and l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and attribute_id = l_attribute_id
                      and page_id = l_page_id then
                      1
                   when l_attribute_id is not null
                      and l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and attribute_id = l_attribute_id
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_attribute_id is not null
                      and l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and attribute_id = l_attribute_id
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   --MZ added
                   when l_attribute_id is null
                      and page_id = l_page_id then 
                      1
                   else
                      0
                end = 1
               and result = 'FAIL'
         ) loop

    -- Insert the Exception
            insert into sv_sec_exceptions (
               attribute_set_id,
               application_id,
               attribute_id,
               page_id,
               component_id,
               column_id,
               justification,
               checksum,
               val
            ) values (
               p_attribute_set_id,
               p_application_id,
               x.attribute_id,
               x.page_id,
               x.component_id,
               x.column_id,
               p_justification,
               x.checksum,
               x.val
            );

    -- Increment the counter
            l_count := l_count + 1;
         end loop;

  -- Update the Collection
         update sv_sec_collection_data
            set result = 'PENDING'
          where collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
            and case
                when l_attribute_id is not null
                   and l_page_id is null
                   and l_component_id is null
                   and l_column_id is null
                   and attribute_id = l_attribute_id then
                   1
                when l_attribute_id is not null
                   and l_page_id is not null
                   and l_component_id is null
                   and l_column_id is null
                   and attribute_id = l_attribute_id
                   and page_id = l_page_id then
                   1
                when l_attribute_id is not null
                   and l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is null
                   and attribute_id = l_attribute_id
                   and page_id = l_page_id
                   and component_id = l_component_id then
                   1
                when l_attribute_id is not null
                   and l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is not null
                   and attribute_id = l_attribute_id
                   and page_id = l_page_id
                   and component_id = l_component_id
                   and column_id = l_column_id then
                   1
                else
                   0
             end = 1
            and result = 'FAIL';

  -- Send Notifications
         send_notification(
            p_type               => 'CREATE',
            p_application_id     => p_application_id,
            p_attribute_id       => l_attribute_id,
            p_page_id            => l_page_id,
            p_number_affected    => l_count,
            p_app_user           => p_app_user,
            p_attribute_set_id   => p_attribute_set_id,
            p_user_workspace_id  => p_user_workspace_id,
            p_justification      => p_justification
         );

  -- Log the event
         sv_sec_log_events.log_exception_event(
            p_event_key          => 'SUBMITTED',
            p_application_id     => p_application_id,
            p_attribute_id       => l_attribute_id,
            p_page_id            => l_page_id,
            p_component_id       => l_component_id,
            p_column_id          => l_column_id,
            p_number_affected    => l_count,
            p_sert_app_id        => p_sert_app_id,
            p_app_user           => p_app_user,
            p_app_session        => p_app_session,
            p_attribute_set_id   => p_attribute_set_id,
            p_user_workspace_id  => p_user_workspace_id,
            p_justification      => p_justification
         );

  -- Apply the exceptions
         apply_exceptions(
            p_collection_id     => SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID'),
            p_application_id    => p_application_id,
            p_attribute_set_id  => p_attribute_set_id,
            p_app_user          => p_app_user,
            p_attribute_id      => l_attribute_id
         );

      elsif l_scope = 'IND' then
  -- Process for an individual exception

  -- Determine if the exception should be INSERTED or UPDATED
         select count(*)
           into l_count
           from sv_sec_exceptions
          where application_id = v('G_APPLICATION_ID')
            and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
            and attribute_id = l_attribute_id
            and case
                when l_page_id is not null
                   and l_component_id is null
                   and l_column_id is null
                   and page_id = l_page_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is null
                   and page_id = l_page_id
                   and component_id = l_component_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is not null
                   and page_id = l_page_id
                   and component_id = l_component_id
                   and column_id = l_column_id then
                   1
                else
                   0
             end = 1;

         if l_count = 0 then

    -- Get the checksum from the collection
            select checksum,
                   val
              into l_checksum,
                   l_val
              from sv_sec_collection_data
             where application_id = v('G_APPLICATION_ID')
      --AND attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;

    -- Insert the Exception
            insert into sv_sec_exceptions (
               attribute_set_id,
               application_id,
               attribute_id,
               page_id,
               component_id,
               column_id,
               justification,
               checksum,
               val
            ) values (
               p_attribute_set_id,
               p_application_id,
               l_attribute_id,
               l_page_id,
               l_component_id,
               l_column_id,
               p_justification,
               l_checksum,
               l_val
            ) returning exception_id into l_exception_id;

    -- Update the Collection
            update sv_sec_collection_data
               set result = 'PENDING'
             where collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
               and application_id = p_application_id
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;

    -- Apply the exceptions
            apply_exceptions(
               p_collection_id     => SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID'),
               p_application_id    => p_application_id,
               p_attribute_set_id  => p_attribute_set_id,
               p_app_user          => p_app_user,
               p_attribute_id      => l_attribute_id
            );

    -- Create the exception in the External API
            if l_exception_api = 'Y' then
               select attribute_name
                 into l_attribute_name
                 from sv_sec_attributes
                where attribute_id = l_attribute_id;

               for x in (
                  select *
                    from sv_sec_collection_data
                   where exception_id = l_exception_id
               ) loop

        -- Call the API to log the exception to an external system
                  sv_sec_log_exception_api(
                     p_app_user        => v('APP_USER'),
                     p_justification   => p_justification,
                     p_application_id  => p_application_id,
                     p_page_id         => l_page_id,
                     p_attribute_name  => l_attribute_name,
                     p_component_name  => x.component_name,
                     p_column_name     => x.column_name,
                     p_exception_id    => l_exception_id
                  );
               end loop;
            end if;

         else

    -- Update the Exception
            update sv_sec_exceptions
               set justification = p_justification
             where application_id = v('G_APPLICATION_ID')
               and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;

         end if;

  -- Send Notifications

  -- Log the event
         SV_SEC_LOG_EVENTS.LOG_EXCEPTION_EVENT(
            p_event_key         => 'SUBMITTED',
            p_application_id    => p_application_id,
            p_attribute_id      => l_attribute_id,
            p_page_id           => l_page_id,
            p_component_id      => l_component_id,
            p_column_id         => l_column_id,
            p_number_affected   => 1,
            p_sert_app_id       => p_sert_app_id,
            p_app_user          => p_app_user,
            p_app_session       => p_app_session,
            p_attribute_set_id  => p_attribute_set_id,
            p_justification     => p_justification
         );

      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end save_exception;

--------------------------------------------------------------------------------
-- PROCEDURE: S A V E _ A P P R O V A L
--------------------------------------------------------------------------------
-- Saves an approval
--------------------------------------------------------------------------------
   procedure save_approval (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_val                in  clob default null,
      p_checksum           in  varchar2 default null,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   ) is
      l_scope           varchar2(100);
      l_attribute_id    number;
      l_page_id         number;
      l_component_id    varchar2(1000);
      l_column_id       number;
      l_count           number := 0;
      l_pk              apex_application_global.vc_arr2;
      l_exception_id    sv_sec_exceptions.exception_id%type;
      l_justification   sv_sec_exceptions.justification%type;
      l_exception_guid  sv_sec_exceptions.exception_guid%type;
   begin

      -- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk, '|');

      -- Loop through the table and assign each component
      -- String should conform to this: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      -- cursor :C1:
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_scope := l_pk(x);
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      -- Get the Exception ID - any of them i it is batch
      -- THERE COULD BE MANY EXCEPTIONS WITH THIS ATTRIBUTE ID 
      -- so grab the last one, and grab the count while we are at it.  
      select max(EXCEPTION_GUID),
             count(*)
        into l_exception_guid,
             l_count
        from sv_sec_exceptions
       where application_id = p_application_id
         and attribute_set_id = p_attribute_set_id
         and attribute_id = coalesce(l_attribute_id,attribute_id)
           and page_id = coalesce(l_page_id, page_id)
         and created_by != p_app_user
         and approved_flag = 'P';

      if ( l_exception_guid is not null ) then
         select exception_id,
                justification
           into l_exception_id,
                l_justification
           from sv_sec_exceptions
          where exception_guid = l_exception_guid;
      end if;

      -- cursor :C2:
      if l_scope = 'BAT' then
         -- Update all records that are pending and not created by the current user
         update sv_sec_exceptions
            set rejected_justification = justification,
                approved_flag = 'Y',
                approved_on = SYSDATE,
                approved_by = p_app_user,
                approved_ws = p_user_workspace_id
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
            and attribute_id = coalesce(l_attribute_id,attribute_id)
            and page_id = coalesce(l_page_id, page_id)
            and created_by != p_app_user
            and approved_flag = 'P';

         -- Log the event
         if l_count > 0 then
            SV_SEC_LOG_EVENTS.LOG_EXCEPTION_EVENT(
               p_event_key          => 'APPROVED',
               p_application_id     => p_application_id,
               p_attribute_id       => l_attribute_id,
               p_page_id            => l_page_id,
               p_component_id       => l_component_id,
               p_column_id          => l_column_id,
               p_number_affected    => l_count,
               p_sert_app_id        => p_sert_app_id,
               p_app_user           => p_app_user,
               p_app_session        => p_app_session,
               p_attribute_set_id   => p_attribute_set_id,
               p_user_workspace_id  => p_user_workspace_id,
               p_justification      => l_justification,
               p_exception_id       => l_exception_id
            );
         end if;

      elsif l_scope = 'IND' then
         -- Process for an individual exception

         -- Update the Collection
         update sv_sec_collection_data
            set result = 'APPROVED'
          where collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
            and application_id = p_application_id
            and attribute_id = l_attribute_id
            and case
                when l_page_id is not null
                   and l_component_id is null
                   and l_column_id is null
                   and page_id = l_page_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is null
                   and page_id = l_page_id
                   and component_id = l_component_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is not null
                   and page_id = l_page_id
                   and component_id = l_component_id
                   and column_id = l_column_id then
                   1
                else
                   0
             end = 1;

         -- Update the Exception
         if p_val is null then
            update sv_sec_exceptions
               set approved_flag = 'Y',
                   approved_by = v('APP_USER'),
                   approved_on = SYSDATE,
                   approved_ws = p_user_workspace_id
             where application_id = v('G_APPLICATION_ID')
               and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;

         else
            update sv_sec_exceptions
               set approved_flag = 'Y',
                   approved_by = v('APP_USER'),
                   approved_on = SYSDATE,
                   val = p_val,
                   checksum = p_checksum
             where application_id = v('G_APPLICATION_ID')
               and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;
         end if;

         -- Log the event
         SV_SEC_LOG_EVENTS.LOG_EXCEPTION_EVENT(
            p_event_key          => 'APPROVED',
            p_application_id     => p_application_id,
            p_attribute_id       => l_attribute_id,
            p_page_id            => l_page_id,
            p_component_id       => l_component_id,
            p_column_id          => l_column_id,
            p_number_affected    => 1,
            p_sert_app_id        => p_sert_app_id,
            p_app_user           => p_app_user,
            p_app_session        => p_app_session,
            p_attribute_set_id   => p_attribute_set_id,
            p_user_workspace_id  => p_user_workspace_id,
            p_justification      => l_justification,
            p_exception_id       => l_exception_id
         );

      end if;

      -- Apply the exceptions
      apply_exceptions(
         p_collection_id     => SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID'),
         p_application_id    => p_application_id,
         p_attribute_set_id  => p_attribute_set_id,
         p_app_user          => p_app_user,
         p_attribute_id      => l_attribute_id
      );

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end save_approval;

--------------------------------------------------------------------------------
-- PROCEDURE: S A V E _ R E J E C T I O N
--------------------------------------------------------------------------------
-- Saves a rejection
--------------------------------------------------------------------------------
   procedure save_rejection (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_rejection          in  varchar2,
      p_val                in  clob default null,
      p_checksum           in  varchar2 default null,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   ) is
      l_scope         varchar2(10);
      l_attribute_id  number;
      l_page_id       number;
      l_component_id  varchar2(1000);
      l_column_id     number;
      l_count         number := 0;
      l_pk            apex_application_global.vc_arr2;
      l_exception_id  number;
   begin

      -- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk, '|');

      -- Loop through the table and assign each component
      -- String should conform to : ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_scope := l_pk(x);
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

-- Get the Exception ID - any of them if it is batch
      for x in (
         select *
           from sv_sec_exceptions
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
            and attribute_id = coalesce(l_attribute_id,attribute_id)
            and page_id = coalesce(l_page_id, page_id)
            and created_by != p_app_user
            and approved_flag = 'P'
      ) loop
         l_exception_id := x.exception_id;
      end loop;

      if l_scope = 'BAT' then
      -- Count the number to be processed
         select count(*)
           into l_count
           from sv_sec_exceptions
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
            and attribute_id = coalesce(l_attribute_id,attribute_id)
            and page_id = coalesce(l_page_id, page_id)
            and created_by != p_app_user
            and approved_flag = 'P';

         -- Update all records that are pending and not created by the current user
         update sv_sec_exceptions
            set rejected_justification = justification,
                approved_flag = 'R',
                rejection = p_rejection,
                rejected_on = SYSDATE,
                rejected_by = p_app_user,
                rejected_ws = p_user_workspace_id
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
            and attribute_id = coalesce(l_attribute_id,attribute_id)
            and page_id = coalesce(l_page_id, page_id)
            and created_by != p_app_user
            and approved_flag = 'P';

         -- Log the event
         if l_count > 0 then
            SV_SEC_LOG_EVENTS.LOG_EXCEPTION_EVENT(
               p_event_key          => 'REJECTED',
               p_application_id     => p_application_id,
               p_attribute_id       => l_attribute_id,
               p_page_id            => l_page_id,
               p_component_id       => l_component_id,
               p_column_id          => l_column_id,
               p_number_affected    => l_count,
               p_sert_app_id        => p_sert_app_id,
               p_app_user           => p_app_user,
               p_app_session        => p_app_session,
               p_attribute_set_id   => p_attribute_set_id,
               p_user_workspace_id  => p_user_workspace_id,
               p_justification      => p_rejection,
               p_exception_id       => l_exception_id
            );
         end if;

      elsif l_scope = 'IND' then
      -- Update the Collection

         update sv_sec_collection_data
            set result = 'REJECTED'
          where collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
            and attribute_id = l_attribute_id
            and application_id = p_application_id
            and case
                when l_page_id is not null
                   and l_component_id is null
                   and l_column_id is null
                   and page_id = l_page_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is null
                   and page_id = l_page_id
                   and component_id = l_component_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is not null
                   and page_id = l_page_id
                   and component_id = l_component_id
                   and column_id = l_column_id then
                   1
                else
                   0
             end = 1;

         -- Update the Exception
         if p_val is null then
            update sv_sec_exceptions
               set rejected_justification = justification,
                   approved_flag = 'R',
                   rejection = p_rejection,
                   rejected_on = SYSDATE,
                   rejected_by = v('APP_USER'),
                   rejected_ws = p_user_workspace_id
             where application_id = v('G_APPLICATION_ID')
               and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;

         else
            update sv_sec_exceptions
               set rejected_justification = justification,
                   approved_flag = 'R',
                   rejection = p_rejection,
                   rejected_on = SYSDATE,
                   rejected_by = v('APP_USER'),
                   rejected_ws = p_user_workspace_id,
                   val = p_val,
                   checksum = p_checksum
             where application_id = v('G_APPLICATION_ID')
               and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
               and attribute_id = l_attribute_id
               and case
                   when l_page_id is not null
                      and l_component_id is null
                      and l_column_id is null
                      and page_id = l_page_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is null
                      and page_id = l_page_id
                      and component_id = l_component_id then
                      1
                   when l_page_id is not null
                      and l_component_id is not null
                      and l_column_id is not null
                      and page_id = l_page_id
                      and component_id = l_component_id
                      and column_id = l_column_id then
                      1
                   else
                      0
                end = 1;
         end if;

         -- Log the event
         SV_SEC_LOG_EVENTS.LOG_EXCEPTION_EVENT(
            p_event_key          => 'REJECTED',
            p_application_id     => p_application_id,
            p_attribute_id       => l_attribute_id,
            p_page_id            => l_page_id,
            p_component_id       => l_component_id,
            p_column_id          => l_column_id,
            p_number_affected    => 1,
            p_sert_app_id        => p_sert_app_id,
            p_app_user           => p_app_user,
            p_app_session        => p_app_session,
            p_attribute_set_id   => p_attribute_set_id,
            p_user_workspace_id  => p_user_workspace_id,
            p_justification      => p_rejection,
            p_exception_id       => l_exception_id
         );

      end if;

      -- Apply the exceptions
      apply_exceptions(
         p_collection_id     => SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID'),
         p_application_id    => p_application_id,
         p_attribute_set_id  => p_attribute_set_id,
         p_app_user          => p_app_user,
         p_attribute_id      => l_attribute_id
      );

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end save_rejection;

--------------------------------------------------------------------------------
-- PROCEDURE: S A V E _ N O T A T I O N 
--------------------------------------------------------------------------------
-- Saves a Notation
--------------------------------------------------------------------------------
   procedure save_notation (
      p_app_user           in  varchar2 default v('APP_USER'),
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_notation_pk        in  varchar2,
      p_notation_msg       in  varchar2,
      p_workspace_id       in  varchar2,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   ) is
      l_attribute_id           number;
      l_page_id                number;
      l_component_id           varchar2(1000);
      l_column_id              number;
      l_count                  number;
      l_pk                     apex_application_global.vc_arr2;
      l_generic_event_type_id  number;
      l_dummy                  varchar2(1000);
      l_owner                  varchar2(255);
   begin

      -- Get the SERT Owner
      select owner
        into l_owner
        from apex_applications
       where application_id = p_sert_app_id;

      -- Parse through the p_notation_pk and decompose into individual items
      l_pk     := apex_util.string_to_table(p_notation_pk, '|');

      -- Loop through the table and assign each component
      -- String should conform to this: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_attribute_id := l_pk(x);
            when x = 2 then
               l_page_id := l_pk(x);
            when x = 3 then
               l_component_id := l_pk(x);
            when x = 4 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      -- Log the Event
      sv_sec_log_events.log_exception_event(
         p_event_key          => 'NOTATION',
         p_application_id     => p_application_id,
         p_attribute_id       => l_attribute_id,
         p_page_id            => l_page_id,
         p_component_id       => l_component_id,
         p_column_id          => l_column_id,
         p_message            => p_notation_msg,
         p_sert_app_id        => p_sert_app_id,
         p_app_user           => p_app_user,
         p_app_session        => p_app_session,
         p_attribute_set_id   => p_attribute_set_id,
         p_user_workspace_id  => p_user_workspace_id
      );

      -- Add the notation
      insert into sv_sec_notations (
         attribute_set_id,
         application_id,
         attribute_id,
         page_id,
         component_id,
         column_id,
         notation,
         created_by,
         created_on,
         created_ws
      ) values (
         p_attribute_set_id,
         p_application_id,
         l_attribute_id,
         l_page_id,
         l_component_id,
         l_column_id,
         p_notation_msg,
         p_app_user,
         SYSDATE,
         p_user_workspace_id
      );

      l_dummy  :=
         sv_sec.calc_score(
            p_attribute_set_id   => p_attribute_set_id,
            p_application_id     => p_application_id,
            p_page_id            => l_page_id,
            p_request            => 'PAGE_SCORE',
            p_app_user           => p_app_user,
            p_workspace_id       => p_workspace_id,
            p_owner              => l_owner,
            p_user_workspace_id  => p_user_workspace_id
         );

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end save_notation;

--------------------------------------------------------------------------------
-- PROCEDURE: D E L E T E _ N O T A T I O N
--------------------------------------------------------------------------------
-- Deletes a specific Notation
--------------------------------------------------------------------------------
   procedure delete_notation (
      p_notation_id in number
   ) is
   begin
      delete from sv_sec_notations
       where notation_id = p_notation_id;

   end delete_notation;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ E X C E P T I O N
--------------------------------------------------------------------------------
-- Gets an exception
--------------------------------------------------------------------------------
   function get_exception (
      p_exception_pk in varchar2
   ) return varchar2 is
      l_attribute_id   number;
      l_page_id        number;
      l_component_id   varchar2(1000);
      l_column_id      number;
      l_justification  varchar2(4000);
      l_rejection      varchar2(4000);
      l_scope          varchar2(100);
      l_pk             apex_application_global.vc_arr2;
   begin

      -- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk);

      -- Loop through the table and assign each component
      -- String should conform to: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_scope := l_pk(x);
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      -- Fetch the Justification for the attribute
      select justification
             || '|'
             || 'Added by '
             || created_by
             || ' on '
             || TO_CHAR(created_on, 'DD-MON-YYYY HH:MIPM')
             || DECODE(
                  rejected_by,
                  null,
                  null,
                  '<br />Rejected by '
                  || rejected_by
                  || ' on '
                  || TO_CHAR(rejected_on, 'DD-MON-YYYY HH:MIPM')
                )
             || DECODE(
                  approved_by,
                  null,
                  null,
                  '<br />Approved by '
                  || approved_by
                  || ' on '
                  || TO_CHAR(approved_on, 'DD-MON-YYYY HH:MIPM')
               )
             || '|'
             || rejection
        into l_justification
        from sv_sec_exceptions
       where application_id = v('G_APPLICATION_ID')
         and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
         and attribute_id = l_attribute_id
         and case
             when l_page_id is not null
                and l_component_id is null
                and l_column_id is null
                and page_id = l_page_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is null
                and page_id = l_page_id
                and component_id = l_component_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is not null
                and page_id = l_page_id
                and component_id = l_component_id
                and column_id = l_column_id then
                1
             else
                0
          end = 1;

-- Return the Justification
      return l_justification;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_exception;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ A P P R O V A L
--------------------------------------------------------------------------------
-- Gets an approval, if one exists
--------------------------------------------------------------------------------
   function get_approval (
      p_exception_pk in varchar2
   ) return varchar2 is
      l_attribute_id  number;
      l_page_id       number;
      l_component_id  varchar2(1000);
      l_column_id     number;
      l_approval      varchar2(4000);
      l_rejection     varchar2(4000);
      l_pk            apex_application_global.vc_arr2;
   begin

      -- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk);

      -- Loop through the table and assign each component
      -- String should conform to: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_attribute_id := l_pk(x);
            when x = 2 then
               l_page_id := l_pk(x);
            when x = 3 then
               l_component_id := l_pk(x);
            when x = 4 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      -- Fetch the Justification for the attribute
      for x in (
         select 'Approved by '
                || approved_by
                || ' on '
                || TO_CHAR(approved_on, 'DD-MON-YYYY HH:MIPM') approval
           from sv_sec_exceptions
          where application_id = v('G_APPLICATION_ID')
            and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
            and attribute_id = l_attribute_id
            and approved_flag = 'Y'
            and case
                when l_page_id is not null
                   and l_component_id is null
                   and l_column_id is null
                   and page_id = l_page_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is null
                   and page_id = l_page_id
                   and component_id = l_component_id then
                   1
                when l_page_id is not null
                   and l_component_id is not null
                   and l_column_id is not null
                   and page_id = l_page_id
                   and component_id = l_component_id
                   and column_id = l_column_id then
                   1
                else
                   0
             end = 1
      ) loop
         l_approval := x.approval;
      end loop;

-- Return the Approval
      return l_approval;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_approval;

--------------------------------------------------------------------------------
-- PROCEDURE: D E L E T E _ E X C E P T I O N
--------------------------------------------------------------------------------
-- Deletes an exception
--------------------------------------------------------------------------------
   procedure delete_exception (
      p_exception_pk in varchar2
   ) is
      l_scope          varchar2(100);
      l_attribute_id   number;
      l_page_id        number;
      l_component_id   varchar2(1000);
      l_column_id      number;
      l_justification  varchar2(4000);
      l_pk             apex_application_global.vc_arr2;
   begin

      -- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_exception_pk, '|');

      -- Loop through the table and assign each component
      -- String should conform to: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.COUNT loop
         case
            when x = 1 then
               l_scope := l_pk(x);
            when x = 2 then
               l_attribute_id := l_pk(x);
            when x = 3 then
               l_page_id := l_pk(x);
            when x = 4 then
               l_component_id := l_pk(x);
            when x = 5 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      -- Delete the exception
      delete from sv_sec_exceptions
       where application_id = v('G_APPLICATION_ID')
         and attribute_set_id = v('P0_ATTRIBUTE_SET_ID')
         and attribute_id = l_attribute_id
         and case
             when l_page_id is not null
                and l_component_id is null
                and l_column_id is null
                and page_id = l_page_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is null
                and page_id = l_page_id
                and component_id = l_component_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is not null
                and page_id = l_page_id
                and component_id = l_component_id
                and column_id = l_column_id then
                1
             else
                0
          end = 1;

      -- Update the Collection
      update sv_sec_collection_data
         set exception = '<i class="'
               || c_failed_exception
               || '" ></i>',
             exception_url = 'f?p='
               || v('APP_ID')
               || ':10:'
               || v('APP_SESSION')
               || ':::10:P10_EXCEPTION_PK:'
               || 'IND|'
               || attribute_id
               || '|'
               || page_id
               || '|'
               || component_id
               || '|'
               || column_id,
             result = 'FAIL'
       where attribute_id = l_attribute_id
         and collection_id = SYS_CONTEXT('SV_SERT_CTX', 'COLLECTION_ID')
         and case
             when l_page_id is not null
                and l_component_id is null
                and l_column_id is null
                and page_id = l_page_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is null
                and page_id = l_page_id
                and component_id = l_component_id then
                1
             when l_page_id is not null
                and l_component_id is not null
                and l_column_id is not null
                and page_id = l_page_id
                and component_id = l_component_id
                and column_id = l_column_id then
                1
             else
                0
          end = 1;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end delete_exception;

--------------------------------------------------------------------------------
-- PROCEDURE: A P P L Y _ E X C E P T I O N S
--------------------------------------------------------------------------------
-- Applies all exceptions
--------------------------------------------------------------------------------
   procedure apply_exceptions (
      p_collection_id      in  number,
      p_application_id     in  number,
      p_attribute_set_id   in  number,
      p_app_user           in  varchar2,
      p_attribute_id       in  number default null,
      p_app_session        in  number default nv('APP_SESSION'),
      p_sert_app_id        in  varchar2 default v('APP_ID'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   ) is
      l_is_approver varchar2(1) := 'N';
   begin

      -- Determine if the user is an approver
      if sv_sec_util.user_has_role(
         p_application_id  => p_application_id,
         p_workspace_id    => p_user_workspace_id,
         p_user_name       => p_app_user,
         p_role_name       => 'SV_SERT_APPROVER:SV_SERT_APPROVER_ALL'
      ) = TRUE then
         l_is_approver := 'Y';
      end if;

      -- Set the status to S in the Exceptions table for those that are stale
      merge into sv_sec_exceptions e
      using (
            select *
               from sv_sec_collection_data
               where result != 'PASS'
               and case
                     when p_attribute_id is not null
                        and attribute_id = p_attribute_id then
                        1
                     when p_attribute_id is null then
                        1
                     else
                        0
                  end = 1
               and collection_id = p_collection_id
               and application_id = p_application_id
            ) cd
         on ( 
            cd.application_id = e.application_id
            and cd.attribute_id = e.attribute_id
            and case
                     when cd.page_id is not null
                        and cd.component_id is null
                        and cd.column_id is null
                        and cd.page_id = e.page_id then
                        1
                     when cd.page_id is not null
                        and cd.component_id is not null
                        and cd.column_id is null
                        and cd.page_id = e.page_id
                        and cd.component_id = e.component_id then
                        1
                     when cd.page_id is not null
                        and cd.component_id is not null
                        and cd.column_id is not null
                        and cd.page_id = e.page_id
                        and cd.component_id = e.component_id
                        and cd.column_id = e.column_id then
                        1
                     else
                        0
                  end = 1
            and e.checksum != cd.checksum
            and case
                  when p_attribute_id is not null
                     and e.attribute_id = p_attribute_id then
                     1
                  when p_attribute_id is null then
                     1
                  else
                     0
                  end = 1
            and e.attribute_set_id = p_attribute_set_id 
         )
       when matched then
         update
            set e.approved_flag = 'S',
                e.prev_approved_flag = DECODE(e.prev_approved_flag, null, 
                                       e.approved_flag, 
                                       e.prev_approved_flag)
      ;

      -- Delete all types of exceptions that now resolve to PASS by default
      for x in (
         select *
           from sv_sec_collection_data
          where collection_id = p_collection_id
            and result = 'PASS'
      ) loop
         delete from sv_sec_exceptions e
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
            and attribute_id = x.attribute_id
            and case
                  when x.page_id is not null
                     and x.component_id is null
                     and x.column_id is null
                     and x.page_id = e.page_id then
                     1
                  when x.page_id is not null
                     and x.component_id is not null
                     and x.column_id is null
                     and x.page_id = e.page_id
                     and x.component_id = e.component_id then
                     1
                  when x.page_id is not null
                     and x.component_id is not null
                     and x.column_id is not null
                     and x.page_id = e.page_id
                     and x.component_id = e.component_id
                     and x.column_id = e.column_id then
                     1
                  else
                     0
               end = 1;
      end loop;

      -- Reapply all exceptions via MERGE call
      merge into sv_sec_collection_data cd
      using (
         select *
            from sv_sec_exceptions
            where attribute_set_id = p_attribute_set_id
            and application_id = p_application_id
            and case 
                  when p_attribute_id is not null
                     and attribute_id = p_attribute_id then
                     1
                  when p_attribute_id is null then
                     1
                  else
                     0
                end = 1
      ) e
         on ( 
                e.application_id = cd.application_id
            and e.attribute_id = cd.attribute_id
            and case
                  when e.page_id is not null
                  and e.component_id is null
                  and e.column_id is null
                  and e.page_id = cd.page_id then
                  1
                  when e.page_id is not null
                     and e.component_id is not null
                     and e.column_id is null
                     and e.page_id = cd.page_id
                     and e.component_id = cd.component_id then
                     1
                  when e.page_id is not null
                     and e.component_id is not null
                     and e.column_id is not null
                     and e.page_id = cd.page_id
                     and e.component_id = cd.component_id
                     and e.column_id = cd.column_id then
                     1
                  else
                     0
                end = 1
            and case
                  when p_attribute_id is not null
                     and cd.attribute_id = p_attribute_id then
                     1
                  when p_attribute_id is null then
                     1
                  else
                     0
                end = 1
            and cd.collection_id = p_collection_id
            and cd.application_id = p_application_id )
       when matched then
         update
            set cd.exception_id = e.exception_id,
                cd.result = DECODE( 
                  cd.result, 
                  'PASS', 
                  'PASS',
                  DECODE( e.approved_flag,
                        'P', 
                        case 
                           when l_is_approver ='Y'
                              and e.created_by || e.created_ws != p_app_user || p_user_workspace_id then
                              'PENDING'
                           else
                              'REQUESTED'
                           end,
                        'R',
                        'REJECTED',
                        'S',
                        'STALE',
                        'APPROVED'
                  )
                ),
                cd.exception = DECODE(
                  cd.result,
                  'PASS',
                  null,
                  DECODE(
                     e.approved_flag,
                     'P', -- PENDING approver, owner, viewer
                     case
                        when l_is_approver = 'Y' 
                           and e.created_by || e.created_ws != p_app_user || p_user_workspace_id then
                           '<i class="' || c_pending_approver || '"></i>'
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           '<i class="' || c_pending_owner || '"></i>'
                        else 
                           '<i class="' || c_pending_viewer || '"></i>'
                     end,
                     'R', -- REJECTED
                     case -- owner, other
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           '<i class="' || c_rejected_owner 
                           || '" title="Rejected by ' || e.rejected_by
                           || ' on ' 
                           || TO_CHAR(e.rejected_on, 'DD-MON-YYYY HH:MIPM')
                           || '"></i>'
                        else
                           '<i class="' || c_rejected_other 
                           || '" title="Rejected by ' || e.rejected_by
                           || ' on '
                           || TO_CHAR(e.rejected_on, 'DD-MON-YYYY HH:MIPM')
                           || '"></i>'
                     end,
                     'S', -- STALE
                     case -- Owner, other
                        when e.created_by = p_app_user then
                           '<i class="' || c_stale_owner || '"></i>'
                        else
                           '<i class="' || c_stale_other || '"></i>'
                     end,
                     'Y', -- Approved
                     case -- Owner, other
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           '<i class="' || c_approved_owner 
                           || '" title="Approved by ' || e.approved_by
                           || ' on '
                           || TO_CHAR(e.approved_on, 'DD-MON-YYYY HH:MIPM')
                           || '"></i>'
                        else
                           '<i class="' || c_approved_other
                           || '" title="Approved by ' || e.approved_by
                           || ' on '
                           || TO_CHAR(e.approved_on, 'DD-MON-YYYY HH:MIPM')
                           || '"></i>'
                     end,
                     null
                  )
                ),
                cd.exception_url = DECODE(
                  cd.result,
                  'PASS',
                  null,
                  DECODE(
                     e.approved_flag,
                     'P', -- Pending
                     case -- Approver,Owner,Viewer
                        when l_is_approver = 'Y' 
                        and e.created_by || e.created_ws != p_app_user || p_user_workspace_id then
                           'f?p=' || p_sert_app_id || ':10:' || p_app_session
                           || ':VIEW:' || v('DEBUG') || ':10:P10_EXCEPTION_PK:'
                           || 'IND|' || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           'f?p=' || p_sert_app_id || ':10:' || p_app_session
                           || ':VIEW:' || v('DEBUG') || ':10:P10_EXCEPTION_PK:'
                           || 'IND|' || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                        else 
                           'f?p=' || p_sert_app_id || ':10:' || p_app_session
                           || ':VIEW::10:P10_EXCEPTION_PK:' || 'IND|'
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                     end,
                     'R', -- REJECTED
                     case -- Owner / Other
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           'f?p=' || p_sert_app_id || ':14:' || p_app_session
                           || ':::14:P14_EXCEPTION_PK:' || 'IND|' 
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                        else
                           'f?p=' || p_sert_app_id || ':14:' || p_app_session
                           || ':::14:P14_EXCEPTION_PK:' || 'IND|' 
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                     end,
                     'S',
                     case -- Failed and Owner
                        when e.created_by = p_app_user then
                           'f?p=' || p_sert_app_id || ':16:' || p_app_session
                           || ':::16:P16_EXCEPTION_PK:' || 'IND|'
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                        else
                           'f?p='
                           || p_sert_app_id || ':16:' || p_app_session
                           || ':::16:P16_EXCEPTION_PK:' || 'IND|'
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                     end,
                     'Y',
                     case -- Owner, other
                        when e.created_by || e.created_ws = p_app_user || p_user_workspace_id then
                           'f?p=' || p_sert_app_id || ':12:' || p_app_session
                           || ':::12:P12_EXCEPTION_PK:' || 'IND|'
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                        else
                           'f?p=' || p_sert_app_id || ':12:' || p_app_session
                           || ':::12:P12_EXCEPTION_PK:' || 'IND|'
                           || attribute_id || '|' || page_id || '|'
                           || component_id || '|' || column_id
                     end,
                     null
                  )
                );

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end apply_exceptions;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end sv_sec_exception;
/