SELECT *
FROM apex_200100.apex_debug_messages
WHERE application_id = 261
    AND page_id = 15
    AND message LIKE '%eba_stds_parser.build_link%'
    --and id > 22657771050
    and session_id = 116220574941527
ORDER BY message_timestamp DESC
/
select "STATUS","FALSE_NEG_DATE","LEGACY_DATE","C003","C004","C005","C006","EDIT_LINK","BUTTON_STYLE",APEX$TOTAL_ROW_COUNT from (select i.*, count(*) over () as APEX$TOTAL_ROW_COUNT
 from (select "STATUS","FALSE_NEG_DATE","LEGACY_DATE","C003","C004","C005","C006","EDIT_LINK","BUTTON_STYLE","C002","C011","C012","C013","C014","C015","C016","C017","C018","C019","C020","C021","C022","C023","C024","C025","C026","C027","C028","C029","C030","C031","C032","C033","C034","C035","C036","C037","C038","C039","C040","C041","C042","C043","C044","C045","C046","C047","C048","C049","C050","SEQ_ID"
from ((select /*+ qb_name(apex$inner) */d."STATUS",d."FALSE_NEG_DATE",d."LEGACY_DATE",d."C003",d."C004",d."C005",d."C006",d."EDIT_LINK",d."BUTTON_STYLE",d."C002",d."C011",d."C012",d."C013",d."C014",d."C015",d."C016",d."C017",d."C018",d."C019",d."C020",d."C021",d."C022",d."C023",d."C024",d."C025",d."C026",d."C027",d."C028",d."C029",d."C030",d."C031",d."C032",d."C033",d."C034",d."C035",d."C036",d."C037",d."C038",d."C039",d."C040",d."C041",d."C042",d."C043",d."C044",d."C045",d."C046",d."C047",d."C048",d."C049",d."C050",d."SEQ_ID" from (select case when ac.c001 = 'Y' then
                    'Pass'
                when tv.false_positive_yn = 'Y' then
                    'False Negative'
                when tv.legacy_yn = 'Y' then
                    'Legacy'
                else 'Fail'
            end as status,
            case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' 
                 then   '<a href="javascript:$s(''P15_VALIDATE'',''-290019771628015543158582811403521528177:'||ac.c002||''');" 
                        class="t-Button t-Button--success t-Button--stretch">
                        Marked as Valid</a>
                        <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then    '<a href="javascript:$s(''P15_VALIDATE'',''+290019771628015543158582811403521528177:'||ac.c002||''');"
                        class="t-Button t-Button--stretch"> Mark as Valid</a>'
                else ' ' end as false_neg_date,
            case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
                 then '<a href="javascript:$s(''P15_LEGACY'',''-290019771628015543158582811403521528177:'||ac.c002||''');" 
                       class="t-Button t-Button--success t-Button--stretch">
                       Marked as Legacy</a>
                       <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then '<a href="javascript:$s(''P15_LEGACY'',''+290019771628015543158582811403521528177:'||ac.c002||''');"
                      class="t-Button t-Button--stretch"> Mark as Legacy</a>'
                else ' ' end as legacy_date,
            'javascript:openInBuilder('''||eba_stds_parser.build_link(   p_test_id => 290019771628015543158582811403521528177,
                                                                                            p_application_id => null,
                                                                                            p_param => ac.c002)||''');' as edit_link,
            ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
            ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
            ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
            ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
            ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
            ac.seq_id,
            case when 'eba_stds_parser.build_link(   p_test_id => 290019771628015543158582811403521528177,
                                                                                            p_application_id => null,
                                                                                            p_param => ac.c002)' != 'null'
                 then case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                           then 'success'
                           when tv.legacy_yn = 'Y'
                           then 'primary'
                           else 'warning' 
                           end 
                 else 'disabled'
                 end as button_style
            from apex_collections ac
            inner join eba_stds_applications sa on sa.apex_app_id = ac.c003
            left join eba_stds_test_validations tv on tv.test_id = 290019771628015543158582811403521528177
                                                   and 1=1
                                                   and tv.result_identifier = 290019771628015543158582811403521528177||':'||ac.c002
                                                   and 1=1
            where ac.collection_name = 'EBA_STDS_P15_TEST_RESULTS'
) d
 )) i 
) i where 1=1  and rownum<=1000001

)i
/
select eba_stds_parser.test_results_sql (
                p_test_id          => :P15_TEST_ID,
                p_origin_app_id    => null,
                p_ast_app_id       => :APP_ID,
                p_page_id          => :APP_PAGE_ID,
                p_showonly         => null,
                p_apx_bldr_session => :APX_BLDR_SESSION,
                p_link_type        => :P15_LINK_TYPE
            )
    from dual;
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
                 then   '<a href="javascript:$s(''P0_VALIDATE'',''-0:'||ac.c002||''');" 
                        class="t-Button t-Button--success t-Button--stretch">
                        Marked as Valid</a>
                        <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then    '<a href="javascript:$s(''P0_VALIDATE'',''+0:'||ac.c002||''');"
                        class="t-Button t-Button--stretch"> Mark as Valid</a>'
                else ' ' end as false_neg_date,
            case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
                 then '<a href="javascript:$s(''P0_LEGACY'',''-0:'||ac.c002||''');" 
                       class="t-Button t-Button--success t-Button--stretch">
                       Marked as Legacy</a>
                       <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
                when ac.c001 = 'N' 
                then '<a href="javascript:$s(''P0_LEGACY'',''+0:'||ac.c002||''');"
                      class="t-Button t-Button--stretch"> Mark as Legacy</a>'
                else ' ' end as legacy_date,
            'javascript:openInBuilder('''||null||''');' as edit_link,
            ac.c002, ac.c003, ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
            ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
            ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
            ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
            ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
            ac.seq_id,
            case when ''''||null||'''' is not null
                 then case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                           then 'success'
                           when tv.legacy_yn = 'Y'
                           then 'primary'
                           else 'warning' 
                           end 
                 else 'btn-disable'
                 end as button_style
            from apex_collections ac
            inner join eba_stds_applications sa on sa.apex_app_id = ac.c003
            left join eba_stds_test_validations tv on tv.test_id = 0
                                                   and 1=1
                                                   and tv.result_identifier = 0||':'||ac.c002
                                                   and 1=1
            where ac.collection_name = 'EBA_STDS_P0_TEST_RESULTS'
/
/*
eba_stds_parser.build_link START p_test_id 290019771628014334232763196774346822001 p_application_id  p_param 109:2566197788483088208 l_param  l_builder_session 117020380113566
l_origin_app 109
p_test_id 290019771628015543158582811403521528177 p_application_id  p_param 102:210 l_builder_session 107303366447197
*/
select eba_stds_parser.build_link(  p_test_id        => '290019771628015543158582811403521528177', 
                                    p_application_id => null, 
                                    p_param          => '102:210') thgelink
from dual;
/
select case when ''''||null||'''' != ''
            then 'not null'
            else 'null'
            end regrsg, ''''||null||'''' sdfsdfs
            from dual;
/
select * 
from apex_applications
where application_id = 109
/
select 1
--            into l_dummy
            from apex_applications aa 
            where aa.application_id = :p_app_id
            and aa.workspace = (select workspace
                                from apex_applications
                                where application_id =  261);
/
select application_id,
    apex_app_id,
    application_name,
    application_type,
    last_updated_on,
    status,
    null link_col2
from (  select na.id application_id,
            na.apex_app_id,
            na.apex_app_id||'. '||aa.application_name application_name,
            nt.name application_type,
            aa.last_updated_on,
            ( select floor(avg(ss.pass_fail_pct))
                  from eba_stds_standard_statuses ss
                  where ss.application_id = na.id
                      and ss.standard_id = nf.id
                      and ss.test_id = nvl(:P5_TEST_ID,ss.test_id) ) status
        from eba_stds_standards nf
        inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
        inner join eba_stds_applications na on nftr.type_id = na.type_id
        inner join eba_stds_types nt on nt.id = na.type_id 
                                     and nt.id = nvl(:P5_APPLICATION_TYPE,nt.id)
        inner join apex_applications aa on aa.application_id = na.apex_app_id
        where nf.id = :P5_ID
    )
where ( :P5_COMPLETION is null
        or (:P5_COMPLETION = 'I' and status = 100 )
        or (:P5_COMPLETION = 'O' and status < 100 )
    )
order by apex_app_id
/
select *
from eba_stds_standards nf
inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
--inner join eba_stds_applications na on nftr.type_id = na.type_id
--inner join eba_stds_types nt on nt.id = na.type_id 
--inner join apex_applications aa on aa.application_id = na.apex_app_id
where nf.id = 2 --:P5_ID
/
select *
from eba_stds_standards
/
commit;
/
select id 
--            into l_default_id
            from eba_stds_types
            where lower(name) = 'default';
/
select * 
from eba_stds_standard_type_ref
/
select * 
from user_constraints
where constraint_name = 'EBA_STDS_APPLICATIONS_FK2'
/
select * 
from EBA_STDS_TYPES
/
select * 
from eba_stds_standard_tests
/
select * 
from eba_stds_standards
/
select * 
from eba_stds_standard_type_ref
/
begin
    eba_stds_data.load_sample_data;
end;
/
--insert into eba_stds_applications( apex_app_id, type_id )
   select aa.application_id, 1 type_id, wrk.workspace
   from apex_applications aa, apex_workspaces wrk
   where not exists (
           select null
           from eba_stds_applications esa
           where esa.apex_app_id = aa.application_id )
       and aa.workspace = wrk.workspace
       --and wrk.workspace_id = v('WORKSPACE_ID')
       ;
       /
begin
eba_stds_data.load_initial_data;
end;
/
select * 
from apex_workspaces
/
select * 
from eba_stds_types
/
select * 
from eba_stds_app_statuses
/
delete from eba_stds_types
/
delete from EBA_STDS_APPLICATIONS
/
delete from eba_stds_app_statuses;
/
commit;

select * --display_sequence, name, query_view, test_type, standard_id
from EBA_STDS_STANDARD_TESTS
/
desc V_EBA_STDS_STANDARD_TESTS
/
select * 
from EBA_STDS_STANDARDs
/
delete from EBA_STDS_STANDARD_TESTS
/
delete from EBA_STDS_STANDARDs
/
