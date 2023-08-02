--liquibase formatted sql
--changeset package_body_script:SVT_MV_UTIL_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_MV_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MV_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jul-5 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  function mv_svt_query return clob
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'mv_svt_query';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_index          pls_integer := 0;
    l_query_clob     clob;
  begin
    apex_debug.message(c_debug_template,'START');

    for rec in (select table_name
                from user_tables
                where table_name like 'MV_SVT%'
                order by 1)
    loop
      <<sqlfrgmt>>
      declare
      l_sql_frgmt varchar2(1000);
      l_sql_wu varchar2(1000);
      begin
        with thecols as (select column_name, column_id
                          from all_tab_cols
                          where table_name = 'MV_SVT_BUTTONS'
                          union all
                          select 'OPT_PARENT_ELEMENT_ID', 100
                          from dual
                          union all
                          select 'CREATED_BY', 101
                          from dual
                          union all
                          select 'CREATED_ON', 102
                          from dual)
        select listagg(lower(case when atc.column_name is null 
                                  then 'null as '||thecols.column_name
                                  else thecols.column_name
                                  end), ', ') within group (order by thecols.column_id) stmt
              into l_sql_frgmt
        from thecols
        left outer join all_tab_cols atc on atc.column_name = thecols.column_name
                                        and atc.table_name = rec.table_name;
        
        l_query_clob := l_query_clob ||
                        apex_string.format ('%3select %0%1from %2',
                        p0 => l_sql_frgmt,
                        p1 => chr(10),
                        p2 => rec.table_name||chr(10),
                        p3 => case when l_index > 0
                                   then 'union all'||chr(10)
                                   end
                        );
        l_index := l_index + 1;
      end sqlfrgmt;
    end loop;

    return l_query_clob;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end mv_svt_query;

  procedure refresh_mv(p_mv_list in eba_stds_standard_tests.mv_dependency%type default null)
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_mv';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START', 'p_mv_list', p_mv_list);

      SVT_audit_util.set_workspace;

      if p_mv_list like '%V_MV_SVT%' then
        for rec in (select object_name mview
                      from user_objects
                      where object_type = 'MATERIALIZED VIEW'
                      and object_name like 'MV_SVT%'
                      order by 1)
        loop
          dbms_mview.refresh (rec.mview);
        end loop;
      elsif p_mv_list is not null then
        for rec in (select asp.column_value mview
                    from table(apex_string.split(p_mv_list, ':')) asp
                    inner join user_objects uo on uo.object_name = asp.column_value
                                               and uo.object_type = 'MATERIALIZED VIEW'
                    where asp.column_value is not null
                    order by 1)
        loop
          dbms_mview.refresh (rec.mview);
        end loop;
      else 
        for rec in (select object_name mview
                      from user_objects
                      where object_type = 'MATERIALIZED VIEW'
                      order by 1)
        loop
          dbms_mview.refresh (rec.mview);
        end loop;
      end if;

  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end refresh_mv;


end SVT_MV_UTIL;
/
--rollback drop package body SVT_MV_UTIL;