select * 
from user_identifiers ui
where 1=1
--and object_name = 'AFW_DATA_LOAD_UTIL'
--and name = 'R_ROW_OBJECT'
and usage = 'DECLARATION'
--and type = 'RECORD'
and object_type = 'TYPE BODY'
/
select * 
from all_objects
where object_name = 'PIVOTIMPL'
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
    AND application_id = 261
    AND page_id = 19
    AND message LIKE '%eba_stds_parser.assert_exception%'
    and session_id = 109811745212232
ORDER BY message_timestamp DESC
/
set serveroutput on
begin
  apex_session.attach (
        p_app_id     => 261,
        p_page_id    => 19,
        p_session_id => 993245871739 );

end;
/
select ac.c002
from apex_collections ac
inner join eba_stds_test_validations tv on tv.result_identifier = :P15_TEST_ID||':'||ac.c002
                                       and tv.test_id = :P15_TEST_ID
where ac.collection_name = 'EBA_STDS_P15_TEST_RESULTS'
--and ac.c002 = '261:REL_RELEASE_UTILS:PACKAGE BODY:1149'
/
select * 
from eba_stds_test_validations tv
where tv.test_id = :P15_TEST_ID
/
delete from eba_stds_test_validations
/
commit;
/
set serveroutput on
declare
l_Sql varchar2(4000);
begin
l_sql := eba_stds_parser.test_results_sql (
                p_test_id          => :P19_TEST_ID,
                p_origin_app_id    => :P19_APPLICATION_ID,
                p_ast_app_id       => :APP_ID,
                p_page_id          => :APP_PAGE_ID,
                p_showonly         => :pshownly,
                p_apx_bldr_session => :bldr,
                p_link_type        => :ltyp
            );
dbms_output.put_line(l_sql);
end;
/
select case when ac.c001 = 'Y' then
            'Pass'
        when tv.false_positive_yn = 'Y' then
            'False Negative'
        else 'Fail'
    end as status,
    case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' then
        apex_string.format(p_message => '<a href="javascript:$s(''P15_VALIDATE'',''-%0:%1'');"
                                         class="t-Button t-Button--success t-Button--stretch">
                                         Marked as Valid</a>
                                         <div style="text-align:center">%2 by %3</div>',
                           p0 => :P15_TEST_ID,
                           p1 => ac.c002,
                           p2 => apex_util.get_since(tv.updated),
                           p3 => apex_escape.html(tv.updated_by))
        when ac.c001 = 'N' then
            apex_string.format(p_message => '<a href="javascript:$s(''P15_VALIDATE'',''+%0:%1'');" 
                                             class="t-Button t-Button--stretch">
                                             Mark as Valid</a>',
                               p0 => :P15_TEST_ID,
                               p1 => ac.c002)
        else '&nbsp;' end as false_neg_date,
    case when :APX_BLDR_SESSION is not null
            and apex_util.get_build_option_status(p_application_id => :APP_ID,
                                                  p_build_option_name => 'Link to Builder') = 'INCLUDE' then
        'javascript:openInBuilder('''
            ||eba_stds_parser.build_link( p_test_id => :P15_TEST_ID, 
                                          p_application_id => null,
                                          p_param => ac.c002 )
            ||''');'
        else 'javascript:null;'
    end as edit_link,
    ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
    ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
    ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
    ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
    ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
    ac.seq_id,
    case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' then 'success'
        else 'warning' end as button_style
from apex_collections ac,
    eba_stds_test_validations tv
where ac.collection_name = 'EBA_STDS_P15_TEST_RESULTS'
    and tv.test_id(+) = :P15_TEST_ID
    and tv.result_identifier(+) = :P15_TEST_ID||':'||ac.c002
/
select case when ac.c001 = 'Y' then
                    'Pass'
                when tv.false_positive_yn = 'Y' then
                    'False Negative'
                when tv.legacy_yn = 'Y' then
                    'Legacy'
                else 'Fail'
            end as status,
            case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' 
                 then   '<a href="javascript:$s(''P0_VALIDATE'',''-0:'''||ac.c002||');" 
                        class="t-Button t-Button--success t-Button--stretch">
                        Marked as Valid</a>
                        <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then    '<a href="javascript:$s(''P0_VALIDATE'',''+0:'');"
                        class="t-Button t-Button--stretch"> Mark as Valid</a>'
                else ' ' end as false_neg_date,
            case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
                 then '<a href="javascript:$s(''P0_LEGACY'',''-0:'''||ac.c002||');" 
                       class="t-Button t-Button--success t-Button--stretch">
                       Marked as Legacy</a>
                       <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then '<a href="javascript:$s(''P0_LEGACY'',''+0:'''||ac.c002||');"
                      class="t-Button t-Button--stretch"> Mark as Legacy</a>'
                else ' ' end as legacy_date,
            'javascript:null;' as edit_link,
            ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
            ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
            ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
            ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
            ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
            ac.seq_id,
            case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                then 'success'
                when tv.legacy_yn = 'Y'
                then 'primary'
                else 'warning' end as button_style
            from apex_collections ac,
                eba_stds_test_validations tv
            where ac.collection_name = 'EBA_STDS_P0_TEST_RESULTS'
                and tv.test_id(+) = 0
                and tv.application_id(+) = 0
                and tv.result_identifier(+) = 0||':'||ac.c002
                and 1=1
/
select case when ac.c001 = 'Y' then
                    'Pass'
                when tv.false_positive_yn = 'Y' then
                    'False Negative'
                when tv.legacy_yn = 'Y' then
                    'Legacy'
                else 'Fail'
            end as status,
            case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' 
                 then   '<a href="javascript:$s(''P19_VALIDATE'',''-:'''||ac.c002||');" 
                        class="t-Button t-Button--success t-Button--stretch">
                        Marked as Valid</a>
                        <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then    '<a href="javascript:$s(''P19_VALIDATE'',''+:'');"
                        class="t-Button t-Button--stretch"> Mark as Valid</a>'
                else ' ' end as false_neg_date,
            case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
                 then '<a href="javascript:$s(''P19_LEGACY'',''-:'''||ac.c002||');" 
                       class="t-Button t-Button--success t-Button--stretch">
                       Marked as Legacy</a>
                       <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then '<a href="javascript:$s(''P19_LEGACY'',''+:'''||ac.c002||');"
                      class="t-Button t-Button--stretch"> Mark as Legacy</a>'
                else ' ' end as legacy_date,
            'javascript:null;' as edit_link,
            ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
            ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
            ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
            ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
            ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
            ac.seq_id,
            case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                then 'success'
                when tv.legacy_yn = 'Y'
                then 'primary'
                else 'warning' end as button_style
            from apex_collections ac,
                eba_stds_test_validations tv
            where ac.collection_name = 'EBA_STDS_P19_TEST_RESULTS'
                and tv.test_id(+) = 
                and tv.application_id(+) = 
                and tv.result_identifier(+) = ||':'||ac.c002
                and 1=1
/
select case when ac.c001 = 'Y' then
            'Pass'
        when tv.false_positive_yn = 'Y' then
            'False Negative'
        when tv.legacy_yn = 'Y' then
            'Legacy'
        else 'Fail'
    end as status,
    case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' then
        apex_string.format(p_message => '<a href="javascript:$s(''P19_VALIDATE'',''-%0:%1'');" 
                                         class="t-Button t-Button--success t-Button--stretch">
                                         Marked as Valid</a>
                                         <div style="text-align:center">%2 by %3</div>',
                           p0 => :P19_TEST_ID,
                           p1 => ac.c002,
                           p2 => apex_util.get_since(tv.updated),
                           p3 => apex_escape.html(tv.updated_by))
        when ac.c001 = 'N' then
           apex_string.format(p_message => '<a href="javascript:$s(''P19_VALIDATE'',''+%0:%1'');"
                                            class="t-Button t-Button--stretch"> Mark as Valid</a>',
                              p0 => :P19_TEST_ID,
                              p1 => ac.c002)
        else '&nbsp;' end as false_neg_date,
    case when ac.c001 = 'N' and tv.legacy_yn = 'Y' then
        apex_string.format(p_message => '<a href="javascript:$s(''P19_LEGACY'',''-%0:%1'');" 
                                         class="t-Button t-Button--success t-Button--stretch">
                                         Marked as Legacy</a>
                                         <div style="text-align:center">%2 by %3</div>',
                           p0 => :P19_TEST_ID,
                           p1 => ac.c002,
                           p2 => apex_util.get_since(tv.updated),
                           p3 => apex_escape.html(tv.updated_by))
        when ac.c001 = 'N' then
           apex_string.format(p_message => '<a href="javascript:$s(''P19_LEGACY'',''+%0:%1'');"
                                            class="t-Button t-Button--stretch"> Mark as Legacy</a>',
                              p0 => :P19_TEST_ID,
                              p1 => ac.c002)
        else '&nbsp;' end as legacy_date,
    case when :APX_BLDR_SESSION is not null
            and apex_util.get_build_option_status(p_application_id => :APP_ID,
                                                  p_build_option_name => 'Link to Builder') = 'INCLUDE' then
        'javascript:openInBuilder('''
            ||eba_stds_parser.build_link( :P19_TEST_ID, :P19_APPLICATION_ID, ac.c002 )
            ||''');'
        else 'javascript:null;'
    end as edit_link,
    ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
    ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
    ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
    ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
    ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
    ac.seq_id,
    case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
         then 'success'
         when tv.legacy_yn = 'Y'
         then 'primary'
         else 'warning' end as button_style
from apex_collections ac,
    eba_stds_test_validations tv
where ac.collection_name = 'EBA_STDS_P19_TEST_RESULTS'
    and tv.test_id(+) = :P19_TEST_ID
    and tv.application_id(+) = :P19_APPLICATION_ID
    and tv.result_identifier(+) = :P19_TEST_ID||':'||ac.c002
    and (:P19_SHOWONLY is null
        or (:P19_SHOWONLY = 'F' and (ac.c001 = 'N' and nvl(tv.false_positive_yn,'N') != 'Y'))
        or (:P19_SHOWONLY = 'P' and (ac.c001 = 'Y' or  nvl(tv.false_positive_yn,'N')  = 'Y'))
        or (:P19_SHOWONLY = 'N' and (ac.c001 = 'N' and nvl(tv.false_positive_yn,'N')  = 'Y'))
        or (:P19_SHOWONLY = 'L' and (ac.c001 = 'N' and nvl(tv.legacy_yn,'N')  = 'Y'))
    )
/
select case when ac.c001 = 'Y' then
                    'Pass'
                when tv.false_positive_yn = 'Y' then
                    'False Negative'
                when tv.legacy_yn = 'Y' then
                    'Legacy'
                else 'Fail'
            end as status,
            case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' 
                 then   '<a href="javascript:$s(''P19_VALIDATE'',''-123:'''||ac.c002||');" 
                        class="t-Button t-Button--success t-Button--stretch">
                        Marked as Valid</a>
                        <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then    '<a href="javascript:$s(''P19_VALIDATE'',''+123:'');"
                        class="t-Button t-Button--stretch"> Mark as Valid</a>'
                else ' ' end as false_neg_date,
            case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
                 then '<a href="javascript:$s(''P19_LEGACY'',''-123:'''||ac.c002||');" 
                       class="t-Button t-Button--success t-Button--stretch">
                       Marked as Legacy</a>
                       <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then '<a href="javascript:$s(''P19_LEGACY'',''+123:'''||ac.c002||');"
                      class="t-Button t-Button--stretch"> Mark as Legacy</a>'
                else ' ' end as legacy_date,
            'javascript:null;' as edit_link,
            ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
            ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
            ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
            ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
            ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
            ac.seq_id,
            case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                then 'success'
                when tv.legacy_yn = 'Y'
                then 'primary'
                else 'warning' end as button_style
            from apex_collections ac,
                eba_stds_test_validations tv
            where ac.collection_name = 'EBA_STDS_P19_TEST_RESULTS'
                and tv.test_id(+) = 123
                and tv.application_id(+) = 123
                and tv.result_identifier(+) = 123||':'||ac.c002
                and (ac.c001 = 'N' and nvl(tv.legacy_yn,'N')  = 'Y')
/
select * 
from eba_stds_test_validations

/
set serveroutput on
begin
  apex_session.attach (
        p_app_id     => 261,
        p_page_id    => 19,
        p_session_id => 993245871739 );

end;
/
begin
--eba_stds_parser.assert_exception START p_result_identifier +289002266828385404649548380751352491367:261:REL_RELEASE_UTILS:PACKAGE BODY:1149 p_test_id 289002266828385404649548380751352491367 p_app_id 261 p_exception_type LEGACY  
    eba_stds_parser.assert_exception (
                p_result_identifier => '-289002266828385404649548380751352491367:261:REL_RELEASE_UTILS:PACKAGE BODY:1149',
                p_test_id           => '289002266828385404649548380751352491367',
                p_app_id            => '261',
                p_exception_type    => 'LEGACY'
                );
end;
/
select st.test_type, st.name, st.link_type, tv.false_positive_yn, tv.legacy_yn
from eba_stds_test_validations tv
left join eba_stds_standard_tests st on tv.test_id = st.id
/
delete from eba_stds_test_validations
/
commit;
/
declare 
l_scope varchar2(50) := 'hauyden assert_exception';
l_debug_template varchar2(4000) := l_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
begin
apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace); 
 apex_debug.message(l_debug_template, 'parse_result_identifier', 'hayden');
 --apex_debug.log('hello');
 apex_debug.message(p_message => l_debug_template, p0 => 'fef', p1 => 123, p_level => apex_debug.c_log_level_warn, p_force => true);
end;