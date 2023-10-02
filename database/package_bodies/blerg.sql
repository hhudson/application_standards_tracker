BEGIN
svt_ctx_util.set_review_schema (p_schema => 'AST');
end;
/
select * 
from v_user_objects
/
select unqid,         
                                    'VIEW' issue_category,         
                                    null application_id,         
                                    null page_id,         
                                    pass_yn,         
                                    1 line,         
                                    view_name object_name,         
                                    'VIEW' object_type,         
                                    code,         
                                    code validation_failure_message,         
                                    view_name issue_title,         
                                    null apex_created_by,         
                                    null apex_created_on,         
                                    null apex_last_updated_by,         
                                    null apex_last_updated_on,         
                                    null test_code,         
                                    null component_id,         
                                    null parent_component_id         
                           from (select 'N' pass_yn, 
         
        ao.object_name view_name, 
         
        apex_string.format('View `%0` is invalid',
         
               p0 => ao.object_name) code,
         
        ao.object_id unqid
         
 from v_user_objects ao
         
 where ao.status != 'VALID'
         
 and ao.object_type = 'VIEW') mydata 
 where 1=1  
 and pass_yn = 'N' 
 --and 'VALID_VIEW:'||unqid = 'VALID_VIEW:116093'          