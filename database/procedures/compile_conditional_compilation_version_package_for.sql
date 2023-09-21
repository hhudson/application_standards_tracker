--liquibase formatted sql
--changeset procedure_script:COMPILE_CONDITIONAL_COMPILATION_VERSION_PACKAGE_FOR stripComments:false endDelimiter:/ runOnChange:true

-- https://livesql.oracle.com/apex/livesql/file/content_MYKQ2SIS76LD5JDBJGKKEXK6V.html

-- begin
--    compile_conditional_compilation_version_package_for(
--       p_product_name             => 'oracle_apex',
--       p_product_version_function => 'orclapex_version',
--       p_min_version_number       => 18,
--       p_max_release_number       => 2,
--       p_send_to_screen           => true
--    );
-- end;

create or replace procedure COMPILE_CONDITIONAL_COMPILATION_VERSION_PACKAGE_FOR (
   p_product_name             in varchar2,
   p_product_version_function in varchar2,
   p_min_version_number       in integer,
   p_max_release_number       in integer,
   p_send_to_screen           in boolean default false
) 
authid definer 
is
   vr  number;
   v   number;
   r   number;
   blk varchar(4000);

   procedure get_version_and_release is
      l_first_period integer;
   begin
      execute immediate 'begin :vr := '
                        || p_product_version_function
                        || '; end;'
         using out vr;
      l_first_period := instr(vr, '.', 1, 1);
      v              := to_number(substr(vr, 1, l_first_period - 1));
      r              := to_number(substr(vr, l_first_period + 1, l_first_period - 2));
   end;

   procedure add_line (
      p_line in varchar2
   ) is
   begin
      blk := blk
             ||
         case
            when blk is not null then
               chr(10)
         end
             || p_line;
   end;

   function add_bool (
      p_current_version in number,
      p_a_version       in number
   ) return varchar2 is
   begin
      return
         case
            when p_current_version <= p_a_version then
               'true'
            else 'false'
         end;
   end;
begin
   get_version_and_release;
   add_line(
      'create or replace package '
      || p_product_name
      || '_version authid definer is 
   version constant pls_integer := '
      || v
      || '; release constant pls_integer := '
      || r
      || '; '
   );
   for vn in p_min_version_number..v loop
      add_line('ver_le_'
               || vn
               || ' constant boolean := '
               || add_bool(trunc(vr), vn)
               || ';');
      for rn in 1..p_max_release_number loop
         add_line('ver_le_'
                  || vn
                  || '_'
                  || rn
                  || ' constant boolean := '
                  || add_bool(vr, vn +(rn / 10))
                  || ';');
      end loop;
   end loop;
   
   <<sert_yn>>
   declare
   l_access_to_sert_yn varchar2(1) := 'N';
   begin

      begin <<subsert>>
         select preference_value
         into l_access_to_sert_yn
         from apex_workspace_preferences
         where preference_name = 'SVT_SERT_YN'
         order by user_name
         fetch first 1 rows only;
      exception when no_data_found then
         l_access_to_sert_yn := 'N';
      end subsert;

      add_line(apex_string.format(q'[c_sert_access constant boolean := %s;]', 
                                    case when l_access_to_sert_yn = 'Y'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
   end sert_yn;

   <<apex_i_yn>>
   declare 
   l_access_to_apex_issues_yn varchar2(1) := 'N';
   begin

      begin <<subapexi>>
         select preference_value
         into l_access_to_apex_issues_yn
         from apex_workspace_preferences
         where preference_name = 'SVT_APEX_ISSUES_YN'
         order by user_name
         fetch first 1 rows only;
      exception when no_data_found then
         l_access_to_apex_issues_yn := 'N';
      end subapexi;

      add_line(apex_string.format(q'[c_apex_issue_access constant boolean := %s;]', 
                                    case when l_access_to_apex_issues_yn = 'Y'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
   end apex_i_yn;

   <<scm_yn>>
   declare 
   l_scm_utility_yn varchar2(1) := 'N';
   begin

      begin <<subscm>>
         select preference_value
         into l_scm_utility_yn
         from apex_workspace_preferences
         where preference_name = 'SVT_SCM_YN'
         order by user_name
         fetch first 1 rows only;
      exception when no_data_found then
         l_scm_utility_yn := 'N';
      end subscm;

      add_line(apex_string.format(q'[c_scm_access constant boolean := %s;]', 
                                    case when l_scm_utility_yn = 'Y'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
               
   end scm_yn;

   <<loki_yn>>
   declare 
   l_loki_yn_yn varchar2(1) := 'N';
   begin

      begin <<subscm>>
         select preference_value
         into l_loki_yn_yn
         from apex_workspace_preferences
         where preference_name = 'SVT_LOKI_YN'
         order by user_name
         fetch first 1 rows only;
      exception when no_data_found then
         l_loki_yn_yn := 'N';
      end subscm;

      add_line(apex_string.format(q'[c_loki_access constant boolean := %s;]', 
                                    case when l_loki_yn_yn = 'Y'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
               
   end loki_yn;
   
   <<email_soln>>
   declare 
   l_email_api varchar2(31) := 'NA';
   begin

      begin <<subemail>>
         select preference_value
         into l_email_api
         from apex_workspace_preferences
         where preference_name = 'SVT_EMAIL_API'
         order by user_name
         fetch first 1 rows only;
      exception when no_data_found then
         l_email_api := 'NA';
      end subemail;

      add_line(apex_string.format(q'[c_email_afw constant boolean := %s;]', 
                                    case when l_email_api = 'AFW'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
      add_line(apex_string.format(q'[c_email_apex constant boolean := %s;]', 
                                    case when l_email_api = 'APEX'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
      add_line(apex_string.format(q'[c_email_na constant boolean := %s;]', 
                                    case when l_email_api = 'NA'
                                       then 'true'
                                       else 'false'
                                       end
                                 )
               );
   end email_soln;

   add_line(' end;');
   if p_send_to_screen then
      dbms_output.put_line(blk);
   end if;
   execute immediate blk;
end;
/

--rollback drop procedure COMPILE_CONDITIONAL_COMPILATION_VERSION_PACKAGE_FOR;