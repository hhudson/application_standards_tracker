--liquibase formatted sql
--changeset package_body_script:ast_plsql_apex_audit_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body ast_plsql_apex_audit_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_plsql_apex_audit_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-29 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure mark_as_exception (p_audit_id in ast_plsql_apex_audit.id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_ignore_legacy  constant ast_audit_actions.id%type := 2;
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

    update ast_plsql_apex_audit
    set action_id = c_ignore_legacy
    where id = p_audit_id;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end mark_as_exception;

  procedure null_out_apex_issue (p_audit_id in ast_plsql_apex_audit.id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'null_out_apex_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_ignore_legacy  constant ast_audit_actions.id%type := 2;
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

    update ast_plsql_apex_audit
    set apex_issue_id = null, apex_issue_title_suffix = null
    where id = p_audit_id;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end null_out_apex_issue;

  procedure assign_violation (p_audit_id in ast_plsql_apex_audit.id%type,
                              p_assignee in ast_plsql_apex_audit.assignee%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'assign_violation';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_assignee constant ast_plsql_apex_audit.assignee%type := coalesce(lower(p_assignee),ast_preferences.get_preference ('AST_DEFAULT_ASSIGNEE'));
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_audit_id', p_audit_id,
                                        'p_assignee', p_assignee,
                                        'c_assignee', c_assignee);
    
    update ast_plsql_apex_audit
    set assignee = c_assignee
    where id = p_audit_id;
    apex_debug.message(c_debug_template, 'updated', sql%rowcount);
    
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end assign_violation;

  procedure bulk_reassign (p_audit_ids in varchar2,
                           p_assignee  in ast_plsql_apex_audit.assignee%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_reassign';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_ids', p_audit_ids);

    for rec in (select column_value audit_id
                  from table(apex_string.split(p_audit_ids, ':'))
                )
    loop
      assign_violation (p_audit_id => rec.audit_id,
                        p_assignee => p_assignee);
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end bulk_reassign;

  function get_audit_record (p_audit_id in ast_plsql_apex_audit.id%type) 
    return ast_plsql_apex_audit%rowtype
    is 
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'get_audit_record';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_ast_plsql_apex_audit_rec ast_plsql_apex_audit%rowtype;
    begin
      apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

      select *
      into l_ast_plsql_apex_audit_rec
      from ast_plsql_apex_audit
      where id = p_audit_id;

      return l_ast_plsql_apex_audit_rec;

    exception 
      when no_data_found then 
        return l_ast_plsql_apex_audit_rec;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
  end get_audit_record;

  function get_unqid(p_audit_id in ast_plsql_apex_audit.id%type) 
    return ast_plsql_apex_audit.unqid%type
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_unqid';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_unqid ast_plsql_apex_audit.unqid%type;
    begin
      apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

      select unqid
      into l_unqid
      from ast_plsql_apex_audit
      where id = p_audit_id;

      return l_unqid;

    exception 
      when no_data_found then
        apex_debug.error(c_debug_template, 'Unknown p_audit_id: ',p_audit_id);
        raise;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
  end get_unqid;


end ast_plsql_apex_audit_api;
/
--rollback drop package body ast_plsql_apex_audit_api;