set define off;
set serveroutput on

declare
  type rec_t_data is varray(9) of varchar2(4000);
  type tab_t_data is table of rec_t_data index by pls_integer;
  l_st_data             tab_t_data;
  l_st_row              eba_stds_standard_tests%rowtype;
  l_general_standard    eba_stds_standard_tests.standard_id%type := 1;
  l_accessible_standard eba_stds_standard_tests.standard_id%type := 2;
  l_db_object_standard  eba_stds_standard_tests.standard_id%type := 3;
  l_broken_standard     eba_stds_standard_tests.standard_id%type := 4;
begin
-- Column order:
-- 9_eba_stds_standard_tests
-- 0: id
-- 1: query_view
-- 2: name
-- 3: display_sequence
-- 4: test_type
-- 5: standard_id
-- 6: link_type
-- 7: failure_help_text
/*
select
apex_string.format(
p_message => q'[l_st_data(l_st_data.count + 1) := rec_t_data('%0','%1', '%2', '%3', '%4', '%5', '%6','%7');]',
p0 => sst.id,
p1 => sst.query_view,
p2 => sst.name,
p3 => sst.display_sequence,
p4 => sst.test_type,
p5 => sst.standard_id,
p6 => sst.link_type,
p7 => failure_help_text
) stmt
from eba_stds_standard_tests sst
order by id 
*/

l_st_data(l_st_data.count + 1) := rec_t_data('290934672085980425626077628758317791546','V_SVT_APEX_120_VALID_LIST_LINKS', 'Invalid List URL', '300', 'FAIL_REPORT', '4', 'LISTENTRY','List Entries should not link to invalid destinations. For eg, applications that have been made unavailable');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810138535748024902016765152078','V_SVT_APEX_1_APP_AUTH', 'Application has Authorization Scheme', '10', 'FAIL_REPORT', '297008886111499643989624756707235911314', 'APPLICATION','Application authorization schemes are defined for an application for the purpose of controlling access. Setting a required authorization scheme here at the application level will require all pages of the application to pass the defined authorization check.');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810139744673844516645939858254','V_SVT_APEX_40_PAGE_AUTH', 'Application Pages have Authorization Schemes', '15', 'FAIL_REPORT', '297008886111499643989624756707235911314', 'PAGE','All Application Pages should have an Authorization Schemes.');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810140953599664131275114564430','V_SVT_APEX_3_APP_ITEM_NAMING', 'Application Item correctly prefixed', '20', 'FAIL_REPORT', '1', 'APP_ITEM','All Application Item should be prefixed with G_ or A_.');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810142162525483745904289270606','V_SVT_APEX_20_HTML_ESCAPING_COLS', 'Report Columns escape HTML', '30', 'FAIL_REPORT', '297008886111499643989624756707235911314', 'REPORT_COL','Interactive Reports and Grids should escape HTML to protect against XSS attacks.');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810145789302942589791813389134','V_SVT_APEX_50_PAGE_ITEM_NAMING', 'Page Items correctly prefixed', '60', 'FAIL_REPORT', '1', 'PAGE_ITEM','Page Items should be prefixed P and the [page id], e.g. P1_ITEM.');
l_st_data(l_st_data.count + 1) := rec_t_data('290954809810150625006221048308512213838','V_SVT_DB_PLSQL__0', 'PL/SQL code standards', '200', 'FAIL_REPORT', '3', 'DB_SUPPORTING_OBJECT','Enforcing the following PL/SQL code standards: https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL');
l_st_data(l_st_data.count + 1) := rec_t_data('291716553215644274634379898138449814780','V_SVT_APEX_100_VALID_COL_LINKS', 'Invalid Column Link', '320', 'FAIL_REPORT', '4', 'REGION','Columns links should lead to valid destinations');
l_st_data(l_st_data.count + 1) := rec_t_data('291722916888588813458425836146204012298','V_SVT_APEX_110_VALID_LINK_BUTTONS', 'Invalid Button URL', '310', 'FAIL_REPORT', '4', 'BUTTON','Buttons should not link to applications that are missing or unavailable');
l_st_data(l_st_data.count + 1) := rec_t_data('292302818419702751897719419630883846433','V_SVT_APEX_70_VAL_COL_AUTHORIZATION', 'Columns have valid authorization scheme', '330', 'FAIL_REPORT', '4', 'REGION','Columns should have valid authorization schemes');
l_st_data(l_st_data.count + 1) := rec_t_data('292407724756887247473643654613687773229','V_SVT_APEX_90_VALID_BUILD_PAGES', 'Pages have valid build options', '340', 'FAIL_REPORT', '292427565561508440301674749281201445673', 'PAGE','Page builds must (1) exist and (2) not be "NEVER"');
l_st_data(l_st_data.count + 1) := rec_t_data('292407724756888456399463269242862479405','V_SVT_APEX_2_APP_AVAILABLE', 'Applications are available', '360', 'FAIL_REPORT', '292427565561508440301674749281201445673', 'APPLICATION','Applications that are "Unavailable" or "TO BE ARCHIVED" should be deleted');
l_st_data(l_st_data.count + 1) := rec_t_data('292427565561507231375855134652026739497','V_SVT_APEX_80_VALID_BUILD_LIST_ENTRY', 'List entries have valid build options', '350', 'FAIL_REPORT', '292427565561508440301674749281201445673', 'LISTENTRY','List entries should have build options that (1) exist and (2) are not "NEVER"');
l_st_data(l_st_data.count + 1) := rec_t_data('293042031711024343743217219378644412213','V_SVT_APEX_30_PAGE_ACCESS_PROTECTION', 'Form pages require authentication and have access protection', '70', 'FAIL_REPORT', '297008886111499643989624756707235911314', 'PAGE','Pages should require authentication and should not have access protection set to "Unrestricted" if they have page items that have an "unrestricted" protection level');
l_st_data(l_st_data.count + 1) := rec_t_data('294591489438560344494721046159842530021','V_SVT_APEX_60_PUBLIC_PAGES_PUBLIC_AUTH', 'Public pages should not require authentication', '340', 'FAIL_REPORT', '4', 'PAGE','Public pages should be public but they can be victims of an over-zealous attempt to give all pages an authorization scheme');
l_st_data(l_st_data.count + 1) := rec_t_data('298261660297559066749993614614253461489','V_SVT_APEX_10_ACCESSIBILITY_COL_ALT_TEXT', 'Column links have alt text', '130', 'FAIL_REPORT', '2', 'REPORT_COL','');
l_st_data(l_st_data.count + 1) := rec_t_data('298903245150734763698321716532373764592','V_SVT_DB_FK_MISSING_INDEX', 'All Foreign Keys Should have an Index', '230', 'FAIL_REPORT', '3', 'DB_SUPPORTING_OBJECT','');
l_st_data(l_st_data.count + 1) := rec_t_data('312153571812426193655816434380775773898','V_SVT_APEX_11_ACCESSIBILITY_ROW_HEADER', 'Region has Row Header', '140', 'FAIL_REPORT', '2', 'REGION','');
l_st_data(l_st_data.count + 1) := rec_t_data('317486358396587155369675160537113730181','V_SVT_SERT__ALL', 'Apply APEX SERT standards', '80', 'PASS_FAIL', '297008886111499643989624756707235911314', 'APPLICATION','');
l_st_data(l_st_data.count + 1) := rec_t_data('320961415779841372215128723658776381311','V_SVT_DB_VIEW_ALL', 'DB Objects are correctly named', '240', 'FAIL_REPORT', '3', 'DB_SUPPORTING_OBJECT','');
l_st_data(l_st_data.count + 1) := rec_t_data('320961415779842581140948338287951087487','V_SVT_DB_VIEW_INVALID', 'Invalid object', '250', 'FAIL_REPORT', '3', 'DB_SUPPORTING_OBJECT','');

    for i in 1..l_st_data.count loop
        l_st_row.id                := l_st_data(i)(1);
        l_st_row.query_view        := l_st_data(i)(2);
        l_st_row.name              := l_st_data(i)(3);
        l_st_row.display_sequence  := l_st_data(i)(4);
        l_st_row.test_type         := l_st_data(i)(5);
        l_st_row.standard_id       := l_st_data(i)(6);
        l_st_row.link_type         := l_st_data(i)(7);
        l_st_row.failure_help_text := l_st_data(i)(8);
        dbms_output.put_line('l_st_row.query_view :'||l_st_row.query_view);
        
        merge into eba_stds_standard_tests dest
          using (
            select
            l_st_row.id id,
            l_st_row.query_view query_view,
            l_st_row.name name,
            l_st_row.display_sequence display_sequence,
            l_st_row.test_type test_type,
            l_st_row.standard_id standard_id,
            l_st_row.link_type link_type,
            l_st_row.failure_help_text failure_help_text
            from dual
          ) src
          on (1=1
            and dest.id = src.id
          )
        when matched then
          update
            set
              -- Don't update the value as it's probably a key/secure value
              -- Deletions are handled above
              dest.query_view = l_st_row.query_view,
              dest.name = l_st_row.name,
              dest.display_sequence = l_st_row.display_sequence,
              dest.test_type = l_st_row.test_type,
              dest.standard_id = l_st_row.standard_id,
              dest.link_type = l_st_row.link_type,
              dest.failure_help_text = l_st_row.failure_help_text
        when not matched then
          insert (
            id,
            query_view,
            name,
            display_sequence,
            test_type,
            standard_id,
            link_type,
            failure_help_text
            )
          values(
            l_st_row.id,
            l_st_row.query_view,
            l_st_row.name,
            l_st_row.display_sequence,
            l_st_row.test_type,
            l_st_row.standard_id,
            l_st_row.link_type,
            l_st_row.failure_help_text
            );
    end loop;
end;
/
