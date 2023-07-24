declare
c_user constant varchar2(31) := 'HAYHUDSO';
begin
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>c_user);   
    
    apex_util.set_preference(        
            p_preference => 'SVT_APPLY_SERT_STANDARDS',
            p_value      => 'N',     
            p_user       => c_user);

    apex_util.set_preference(        
            p_preference => 'SVT_CREATE_APEX_ISSUES',
            p_value      => 'N',      
            p_user       => c_user);
end;
/
