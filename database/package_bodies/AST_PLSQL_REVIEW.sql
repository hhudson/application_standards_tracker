--liquibase formatted sql
--changeset package_body_script:AST_PLSQL_REVIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package body ast_plsql_review as

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_userenv_current_user constant varchar2(100) :=  sys_context('userenv', 'current_user');
  gc_package constant varchar2(20) := 'PACKAGE';
  gc_view    constant varchar2(20) := 'VIEW';
  gc_table   constant varchar2(20) := 'TABLE';
  gc_y       constant varchar2(1) := 'Y';
  gc_n       constant varchar2(1) := 'N';
  gc_ast     constant varchar2(3) := 'AST';


  ------------------------------------------------------------------------------
  -- Procedure to check for contradiction between the current schema and the review schema
  ------------------------------------------------------------------------------
  procedure error_for_incorrect_schema (p_object_name in all_objects.object_name%type) is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'error_for_incorrect_schema';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  l_object_exists_yn varchar2(1);
  c_review_schema constant varchar2(32) 
                  := case when sys_context('userenv', 'current_user') = gc_ast
                          then ast_ctx_util.get_default_user
                          else sys_context('userenv', 'current_user')
                          end;
  begin
    apex_debug.message(c_debug_template,'START', 'p_object_name', p_object_name);

    if p_object_name is not null then
      select case when count(*) = 1
                  then gc_y
                  else gc_n
                  end into l_object_exists_yn
              from sys.dual where exists (
                  select 1
                  from v_user_objects
                  where object_name = p_object_name
              );

      if l_object_exists_yn = gc_n 
      and sys_context('userenv', 'current_user') = gc_ast 
      and ast_ctx_util.get_default_user != gc_ast /* we need to be able to run scripts that aren't ddl scripts */
      then 
        ast_ctx_util.set_review_schema (p_schema => sys_context('userenv', 'current_user'));
        -- raise_application_error(-20124, apex_string.format(
        --                                   p_message => q'[%0.%1 does not exist:
        -- • The review schema is currently set to : %2
        -- • You can change this by running the release/set_review_schema.sql script]',
        --                                   p0 => c_review_schema,
        --                                   p1 => p_object_name,
        --                                   p2 => ast_ctx_util.get_default_user,
        --                                   p3 => sys_context('userenv', 'current_user')
        --                                   )
        --                       );
      end if;
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end error_for_incorrect_schema;

  ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 4, 2023
-- Synopsis:
--
-- Function to query the db for an object_type for a object_name 
--
------------------------------------------------------------------------------
  function get_object_type (p_object_name in user_objects.object_name%type) 
  return user_objects.object_type%type
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_object_type'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_object_name constant user_objects.object_name%type := upper(p_object_name);
  l_object_type user_objects.object_type%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_object_name', p_object_name);

    select object_type
    into l_object_type
    from v_user_objects
    where object_name = c_object_name
    order by object_type
    fetch first 1 rows only;

    apex_debug.message(c_debug_template, 'l_object_type', l_object_type);
    return l_object_type;

  exception 
    when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'No data found', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_object_type;


  function issues (p_object_name             in user_plsql_object_settings.name%type default null,
                   p_object_type             in user_plsql_object_settings.type%type default null,
                   p_max_standard_code_count in number default null,
                   p_max_issue_count         in number default null,
                   p_file_dirname            in varchar2 default null
                   )
  return ast_db_plsql_issue_nt pipelined
  is 
  pragma autonomous_transaction;

  c_scope constant varchar2(128) := gc_scope_prefix || 'issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';


  c_object_name  constant all_procedures.object_name%type 
                 := case when p_object_name is not null 
                         then sys.dbms_assert.noop(upper(p_object_name)) --todo: figure out what dbms_assert function would work here
                         end;
  c_object_type  constant all_plsql_object_settings.type%type
                := case when p_object_type is not null 
                        then sys.dbms_assert.simple_sql_name(upper(p_object_type))
                        else case when p_file_dirname is not null
                                  then case upper(p_file_dirname)
                                        when 'PACKAGE_BODIES' then gc_package
                                        when 'PACKAGE_SPECS'  then gc_package
                                        else get_object_type(c_object_name)
                                        end
                                  else get_object_type(c_object_name)
                                  end
                        end;

  c_plsql_stmt      constant varchar2(512) := q'[ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL, STATEMENTS:ALL']';
  l_standard_code   eba_stds_standard_tests.standard_code%type := 'blank';
  c_max_standard_code_count   constant pls_integer := coalesce(p_max_standard_code_count, 50);
  c_max_issue_count constant pls_integer := coalesce(p_max_issue_count, 999999);
  l_standard_code_count    pls_integer   := 0;
  l_issue_count            pls_integer   := 0;
  l_issue_shown_count      pls_integer   := 0;
  l_not_shown_count_msg    varchar2(500) := '';

  cursor cur_pkg_issues
   is
      select  
        substr(esst.explanation,1,500) issue_desc,
        dp.object_name,
        dp.object_type,
        dp.line,
        dp.code,
        esst.urgency,
        esst.urgency_level,
        esst.standard_code
      from ast.v_eba_stds_standard_tests esst
      join ast.ast_standard_view.v_ast_db_plsql(p_standard_code => esst.standard_code, 
                                            p_failures_only => gc_y,
                                            p_object_name => c_object_name) dp
        on  esst.nt_name = 'V_AST_DB_PLSQL_NT'
        and esst.query_clob is not null
        and esst.active_yn = gc_y
      order by urgency_level, esst.explanation, object_name, line, code;

  type r_v_ast_db_plsql is record (
    issue_desc              varchar2(511   char),
    object_name             varchar2(128   char),  
    object_type             varchar2(23    char),   
    line                    number,
    code                    varchar2(1000 char),
    urgency                 varchar2(255   char),
    urgency_level           number,
    standard_code           varchar2(100 char)
  );
  type t_ast_db_plsql_issue is table of r_v_ast_db_plsql index by pls_integer;
  l_pkg_issue_t t_ast_db_plsql_issue;

  cursor cur_vw_issues
   is
      select *
      from ast.v_ast_db_view_all
      where (view_name = c_object_name or c_object_name is null)
      order by urgency_level, issue_desc, view_name;

  type t_ast_db_view_issue is table of ast.v_ast_db_view_all%rowtype index by pls_integer;
  l_vw_issue_t t_ast_db_view_issue;

  cursor cur_tbl_issues
   is
      select *
      from ast.v_ast_db_tbl_all
      where (table_name = c_object_name or c_object_name is null)
      order by urgency_level, issue_desc, table_name;

  type t_ast_db_tbl_issue is table of ast.v_ast_db_tbl_all%rowtype index by pls_integer;
  l_tbl_issue_t t_ast_db_tbl_issue;

  e_incorrect_plscope_settings exception;
  pragma exception_init(e_incorrect_plscope_settings, -20123);

    ------------------------------------------------------------------------------
    -- Local Procedure to check that data has been deployed
    ------------------------------------------------------------------------------
    procedure verify_standards_exist_in_general is 
    l_count number := 0;
    begin

      select count(*) 
      into l_count
      from sys.dual where exists (
          select 1
          from ast.v_eba_stds_standard_tests
      );

      if l_count = 0 then
        raise_application_error(-20123, 'Standards have not been defined in this environment');
      end if;

    end verify_standards_exist_in_general;

    ------------------------------------------------------------------------------
    -- Local Procedure to check that plscope can be used
    ------------------------------------------------------------------------------
    procedure verify_plscope_setting(p_object_name in all_objects.object_name%type) is 
    c_req_plscope_settings constant all_plsql_object_settings.plscope_settings%type := 'IDENTIFIERS:ALL, STATEMENTS:ALL';
    l_incorrect_plscope_yn varchar2(1) := gc_n;
    l_compile_stmt varchar2(512);
    begin
      if p_object_name is not null then 
        select case when count(*) > 0
                    then gc_y
                    else gc_n
                    end 
                    into l_incorrect_plscope_yn
        from v_user_plsql_object_settings
        where plscope_settings != c_req_plscope_settings
        and name = p_object_name
        and (type = c_object_type or c_object_type is null);

        if l_incorrect_plscope_yn = gc_y then 
          l_compile_stmt := apex_string.format(p_message => 'ALTER %2 %0.%1 COMPILE',
                                               p0 => gc_userenv_current_user,
                                               p1 => p_object_name,
                                               p2 => coalesce(c_object_type, gc_package)
                                              );
          raise_application_error(-20123, 
                                  apex_string.format(p_message =>
                                                        'This DB object has not been compiled with the required PL/Scope Settings.
                                                          • Step 1 : %0
                                                          • Step 2 : %1',
                                                      p0 => c_plsql_stmt,
                                                      p1 => l_compile_stmt)
                                  );
        end if;
      end if;
    end verify_plscope_setting;


  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_object_name', p_object_name,
                                        'p_object_type', p_object_type,
                                        'review_schema' , ast_ctx_util.get_default_user,
                                        'current_schema', gc_userenv_current_user,
                                        'p_file_dirname', p_file_dirname
                                        );


    verify_standards_exist_in_general;

    if c_object_name is not null then
      error_for_incorrect_schema(c_object_name);
      verify_plscope_setting(c_object_name);
    end if;

    case 
    when c_object_type = gc_package 
    then open cur_pkg_issues;

      loop
        fetch cur_pkg_issues bulk collect into l_pkg_issue_t limit 100;
        exit when l_pkg_issue_t.count = 0;

        for rec in 1 .. l_pkg_issue_t.count
        loop

        l_issue_count := l_issue_count + 1;
        case when l_issue_count <= c_max_issue_count then 

          case  when l_standard_code = l_pkg_issue_t (rec).standard_code then
            l_standard_code_count := l_standard_code_count + 1;
          else 
            l_standard_code_count := 1;
          end case;

          l_standard_code := l_pkg_issue_t (rec).standard_code;

          case when l_standard_code_count <= c_max_standard_code_count then

            l_issue_shown_count := l_issue_shown_count + 1;

            pipe row (ast_db_plsql_issue_ot (
                          l_pkg_issue_t (rec).issue_desc,
                          l_pkg_issue_t (rec).object_name,
                          l_pkg_issue_t (rec).object_type,
                          l_pkg_issue_t (rec).line,
                          l_pkg_issue_t (rec).code,
                          l_pkg_issue_t (rec).urgency,
                          l_pkg_issue_t (rec).urgency_level,
                          l_pkg_issue_t (rec).standard_code
                        )
                    );
          else 
            apex_debug.message(c_debug_template, 'max standard_code count / standard_code has been exceeded');
          end case;

        else 
          apex_debug.message(c_debug_template, 'issue limit exceeded');       
        end case;

        end loop;
      end loop;  

      case when l_issue_count > l_issue_shown_count then 

        l_not_shown_count_msg := apex_string.format('Summary : %0 issue(s) total, %1 not shown.', 
                                                              l_issue_count, 
                                                              l_issue_count - l_issue_shown_count );

        pipe row (ast_db_plsql_issue_ot (
                            null,
                            null,
                            null,
                            null,
                            l_not_shown_count_msg,
                            null,
                            null,
                            null
                          )
                      );

      else 
        apex_debug.message(c_debug_template, 'Not unshown issues');
      end case;

    when c_object_type = gc_view
    then open cur_vw_issues;

      loop
        fetch cur_vw_issues bulk collect into l_vw_issue_t limit 100;
        exit when l_vw_issue_t.count = 0;

        for rec in 1 .. l_vw_issue_t.count
        loop

            pipe row (ast_db_plsql_issue_ot (
                          l_vw_issue_t (rec).issue_desc,
                          l_vw_issue_t (rec).view_name,
                          gc_view,
                          null,
                          null,
                          l_vw_issue_t (rec).urgency,
                          l_vw_issue_t (rec).urgency_level,
                          l_vw_issue_t (rec).standard_code
                        )
                    );

        end loop;
      end loop;  

    when c_object_type = gc_table
    then open cur_tbl_issues;

      loop
        fetch cur_tbl_issues bulk collect into l_tbl_issue_t limit 100;
        exit when l_tbl_issue_t.count = 0;

        for rec in 1 .. l_tbl_issue_t.count
        loop

            pipe row (ast_db_plsql_issue_ot (
                          l_tbl_issue_t (rec).issue_desc,
                          l_tbl_issue_t (rec).table_name,
                          gc_table,
                          null,
                          l_tbl_issue_t (rec).code,
                          l_tbl_issue_t (rec).urgency,
                          l_tbl_issue_t (rec).urgency_level,
                          l_tbl_issue_t (rec).standard_code
                        )
                    );

        end loop;
      end loop;  

    else 

      pipe row (ast_db_plsql_issue_ot (
                          null,
                          null,
                          null,
                          null,
                          apex_string.format('No standards defined for script type %s', 
                                              case when c_object_type is not null
                                                   then '('||c_object_type||')'
                                                   end),
                          null,
                          null,
                          null
                        )
                    );
    end case;

    return;

  exception 
    when e_incorrect_plscope_settings then
      apex_debug.error(p_message => c_debug_template, p0 =>'Incorrect PL/Scope Settings', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
    when others then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end issues;

  procedure assert_exception (p_unqid in ast_plsql_exceptions.unqid%type)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assert_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_unqid constant varchar2(500) := upper(trim(p_unqid));
  begin
    apex_debug.message(c_debug_template,'START', 'p_unqid', p_unqid);

    insert into ast_plsql_exceptions (unqid)
    values (c_unqid);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
    raise;
  end assert_exception;

  procedure clear_invalid_exceptions
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'clear_invalid_exceptions';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    delete from ast_plsql_exceptions
    where unqid not in (
      select unqid 
      from ast.v_ast_db_plsql__0
      where unqid is not null
    );

    apex_debug.message(c_debug_template, 'deleted', sql%rowcount);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
    raise;
  end clear_invalid_exceptions;

end ast_plsql_review;
/

--rollback drop package AST_PLSQL_REVIEW;
