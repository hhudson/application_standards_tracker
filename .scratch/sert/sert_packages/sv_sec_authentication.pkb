create or replace package body sv_sec_authentication as
--------------------------------------------------------------------------------
--
--  Copyright(C) 2021, Oracle Corporation
--  All Rights Reserved
--
--------------------------------------------------------------------------------
--  Application         : SERT
--  Sub-module          : Application API
--  Source file name    : sv_sec_authentication.pks
--  Purpose             : Handle all parts of authentication for SERT
--
--  HAS COMMITS         : NO
--  HAS ROLLBACKS       : NO
--
--  Comments:
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--< PRIVATE TYPES AND GLOBALS >-------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--< PRIVATE METHODS >-----------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--< PUBLIC METHODS >------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--< apex_builder_session >
--------------------------------------------------------------------------------
   function apex_builder_session(
      p_username  in  varchar2,
      p_password  in  varchar2
   )
   return boolean
   as
      c_apex_workspace_id_item        constant    varchar2(255)                   := 'G_WORKSPACE_ID';
      c_apex_workspace_name_item      constant    varchar2(255)                   := 'G_WORKSPACE_NAME';
      c_apex_builder_session_id_item  constant    varchar2(255)                   := 'G_APEX_BUILDER_SESSION_ID';
      c_username                      constant    varchar2(255)                   := upper(p_username);
      l_scope                                     logger_logs.scope%type          := sys.utl_call_stack.concatenate_subprogram(sys.utl_call_stack.subprogram(1));
      l_params                                    logger.tab_param;
      l_session                                   number;
      l_workspace_session                         apex_workspace_sessions%rowtype;
      l_count                                     number;
      l_remote_addr                               varchar2(255);
      l_x_forwarded_for                           varchar2(32767);
      l_workspace_remote_addr                     varchar2(4000);
      l_ip_addresses                              varchar2(255);
   begin
      logger.append_param(l_params, 'p_username', p_username);
      logger.append_param(l_params, 'p_password', p_password);
      logger.log('START', l_scope, null, l_params);
      -- Make sure the username is an actual user
      if c_username in ('NOBODY', 'APEX_PUBLIC_USER') then
         logger.log('Invalid username', l_scope, null, l_params);
         logger.log('FINISH', l_scope, null, l_params);
         return false;
      end if;
      -- Make sure the password is a number (since it should be a session)
      begin
         l_session := to_number(p_password);
      exception when value_error then
         logger.log('Invalid session ID', l_scope, null, l_params);
         logger.log('FINISH', l_scope, null, l_params);
         return false;
      end;
      -- Make sure a session exists for the given username and session
      begin
         select *
         into l_workspace_session
         from apex_workspace_sessions
         where upper(user_name) = c_username
               and apex_session_id = l_session;
      exception when no_data_found then
         logger.log('Invalid username and session ID combination', l_scope, null, l_params);
         logger.log('FINISH', l_scope, null, l_params);
         return false;
      end;
      -- Ensure the identified session is for an APEX builder session
      select count(1)
      into l_count
      from apex_workspace_activity_log
      where apex_session_id = l_session
         and workspace != 'INTERNAL' -- Activity logged under INTERNAL workspace for unauthenticated requests, ignore these
         and application_id in (
               select application_id
               from apex_applications
               where workspace = 'INTERNAL'
         );
      if l_count = 0 then
         logger.log('Session does not belong to APEX builder', l_scope, null, l_params);
         logger.log('FINISH', l_scope, null, l_params);
         return false;
      end if;
      -- Get current user's connection's IP addresses
      -- Get IP address possibilities
      l_remote_addr := owa_util.get_cgi_env('REMOTE_ADDR');
      l_x_forwarded_for := owa_util.get_cgi_env('X-FORWARDED-FOR');
      l_workspace_remote_addr := l_workspace_session.remote_addr;
      -- Remove any white spaces from IP addresses
      l_remote_addr := regexp_replace(owa_util.get_cgi_env('REMOTE_ADDR'), '\s+', null);
      l_x_forwarded_for := regexp_replace(owa_util.get_cgi_env('X-FORWARDED-FOR'), '\s+', null);
      l_workspace_remote_addr := regexp_replace(l_workspace_session.remote_addr, '\s+', null);
      -- Remove any consecutive commas from any possible IP address lists
      l_x_forwarded_for := regexp_replace(owa_util.get_cgi_env('X-FORWARDED-FOR'), ',+', ',');
      l_workspace_remote_addr := regexp_replace(l_workspace_session.remote_addr, ',+', ',');
      -- Make sure the username and session belong to the user attempting to
      -- log in by verifying their IP address
      if instr(l_workspace_remote_addr, ',') = 0 then
         -- Remote address from APEX is singular IP address
         -- Check the remote address from APEX against the following:
               -- CGI REMOTE_ADDR address (exact match)
               -- CGI X-FORWARDED-FOR address (exact match, no list)
               -- Contained within CGI X-FORWARED-FOR address list
         if
               l_workspace_remote_addr != l_remote_addr and
               l_workspace_remote_addr != nvl(l_x_forwarded_for, '-1') and
               ',' || l_x_forwarded_for || ',' not like '%,' || l_workspace_remote_addr || ',%'
         then
               logger.log('Failed IP Validation', l_scope, null, l_params);
               logger.log('==> l_remote_addr:            "' || l_remote_addr || '"' , l_scope, null, l_params);
               logger.log('==> l_x_forwarded_for:        "' || l_x_forwarded_for || '"' , l_scope, null, l_params);
               logger.log('==> l_workspace_remote_addr:  "' || l_workspace_remote_addr || '"' , l_scope, null, l_params);
               logger.log('FINISH', l_scope, null, l_params);
               return false;
         end if;
      else
         -- Remote address from APEX is list of 2 or more addresses
         -- Check the remote address list from APEX is fully contained within
         -- a combiniation of the CGI REMOTE_ADDR and the CGI X-FORWARDED_FOR adresses
         l_ip_addresses := ',' || l_remote_addr || ',' || l_x_forwarded_for || ',' || l_remote_addr || ',';
         if l_ip_addresses not like '%' || l_workspace_remote_addr || '%' then
               logger.log('Failed IP Validation', l_scope, null, l_params);
               logger.log('==> l_remote_addr:            "' || l_remote_addr || '"' , l_scope, null, l_params);
               logger.log('==> l_x_forwarded_for:        "' || l_x_forwarded_for || '"' , l_scope, null, l_params);
               logger.log('==> l_workspace_remote_addr:  "' || l_workspace_remote_addr || '"' , l_scope, null, l_params);
               logger.log('FINISH', l_scope, null, l_params);
               return false;
         end if;
      end if;
      logger.log('SERT authentication successful', l_scope, null, l_params);
      -- Set the session state for the workspace ID and builder session ID for
      -- other applications that may need them
      apex_util.set_session_state(
         p_name  => c_apex_workspace_id_item,
         p_value => l_workspace_session.workspace_id
      );
      apex_util.set_session_state(
         p_name  => c_apex_workspace_name_item,
         p_value => l_workspace_session.workspace_name
      );
      apex_util.set_session_state(
         p_name  => c_apex_builder_session_id_item,
         p_value => l_session
      );
      logger.log('FINISH', l_scope, null, l_params);
      -- All checks passed, user can be authenticated
      return true;
   end apex_builder_session;
end sv_sec_authentication;
/