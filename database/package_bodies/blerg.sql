 select unqid,         
                                    'TABLE' issue_category,         
                                    null application_id,         
                                    null page_id,         
                                    pass_yn,         
                                    1 line,         
                                    table_name object_name,         
                                    'TABLE' object_type,         
                                    code,         
                                    null validation_failure_message,         
                                    code issue_title,         
                                    null apex_created_by,         
                                    null apex_created_on,         
                                    null apex_last_updated_by,         
                                    null apex_last_updated_on,         
                                    null test_code,         
                                    object_id component_id,         
                                    null parent_component_id         
                           from (with tblfk as (select 
         
 cons.table_name, 
         
 cons.constraint_name,
         
 cons.cname1 || nvl2(cons.cname2,','||cons.cname2,null) ||
         
 nvl2(cons.cname3,','||cons.cname3,null) || nvl2(cons.cname4,','||cons.cname4,null) ||
         
 nvl2(cons.cname5,','||cons.cname5,null) || nvl2(cons.cname6,','||cons.cname6,null) ||
         
 nvl2(cons.cname7,','||cons.cname7,null) || nvl2(cons.cname8,','||cons.cname8,null) icolumns
         
 from ( select b.table_name,
         
                 b.constraint_name,
         
                 max(decode( position, 1, column_name, null )) cname1,
         
                 max(decode( position, 2, column_name, null )) cname2,
         
                 max(decode( position, 3, column_name, null )) cname3,
         
                 max(decode( position, 4, column_name, null )) cname4,
         
                 max(decode( position, 5, column_name, null )) cname5,
         
                 max(decode( position, 6, column_name, null )) cname6,
         
                 max(decode( position, 7, column_name, null )) cname7,
         
                 max(decode( position, 8, column_name, null )) cname8,
         
                 count(*) col_cnt
         
             from (select substr(table_name,1,30) table_name,
         
                         substr(constraint_name,1,30) constraint_name,
         
                         substr(column_name,1,30) column_name,
         
                         position
         
                     from v_user_cons_columns ) a,
         
                 v_user_constraints b
         
         where a.constraint_name = b.constraint_name
         
             and b.constraint_type = 'R'
         
         group by b.table_name, b.constraint_name
         
         ) cons
         
 where cons.col_cnt > ALL
         
         ( select count(*)
         
             from v_user_ind_columns i
         
             where i.table_name = cons.table_name
         
             and i.column_name in (cname1, cname2, cname3, cname4,
         
                                     cname5, cname6, cname7, cname8 )
         
             and i.column_position <= cons.col_cnt
         
             group by i.index_name
         
         )
         
 )
         
 select 
         
 'N' pass_yn,
         
 'MISSING_FK :'||table_name unqid,
         
 table_name, constraint_name, icolumns,
         
 apex_string.format('Constraint %0 on column(s) %1 is missing an index', constraint_name, icolumns) code,
         
 ao.object_id
         
 from tblfk
         
 inner join all_objects ao on ao.object_name = tblfk.table_name
         
                           and ao.object_type = 'TABLE') mydata 
                           where 1=1  
                           and 'FK_INDEXED:'||unqid = 'FK_INDEXED:MISSING_FK :EBA_STDS_INHERITED_TESTS'          