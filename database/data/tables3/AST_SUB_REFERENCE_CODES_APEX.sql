--liquibase formatted sql
--changeset data_script:AST_SUB_REFERENCE_CODES_APEX.sql stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from AST_SUB_REFERENCE_CODES asrc inner join EBA_STDS_STANDARD_TESTS esst on asrc.test_id = esst.id and esst.nt_type_id = 41;
--REM INSERTING into AST_SUB_REFERENCE_CODES
-- SET DEFINE OFF;  
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('APP_AUTH','Applications should have application-level authorization schemes as a matter of best-practice','Specify an authorization scheme for your application. Application authorization schemes are defined for an application for the purpose of controlling access. Setting a required authorization scheme here at the application level will require all pages of the application to pass the defined authorization check.',290954809810138535748024902016765152078);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('APP_AVAILABLE','Workspaces should be populated by active applications','Either make the application available or archive it (delete it)',292407724756888456399463269242862479405);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('APP_ITEM_NAMING','Global Scope Application Items with should be prefixed with "G_"
. App Scope Application Items should be prefixed with "A_".','Correct the item name',290954809810140953599664131275114564430);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('HTML_ESCAPING_COLS','Avoid turning the "Escape special characters" setting off on report columns','To prevent Cross-Site Scripting (XSS) attacks, always set this attribute to **On**. If you need to render HTML tags stored in the page item or in the entries of a list of values, you can set this flag to **Off**. In such cases, you should take additional precautions to ensure any user input to such fields are properly escaped when entered and before saving.',290954809810142162525483745904289270606);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('LIST_ENTRY_BUILD_ABUSE','List Entry Excluded by Build Option for too long','Remove the build or eliminate the page',292427565561507231375855134652026739497);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('NA','Link columns in reports that do not feature text (eg, they have the pencil symbol) should include “Alt” text. This alt-text will be displayed by a screen-reader in the web-elements rotor, “links” section.','Add some descriptive text to your alt text. You are encouraged to use substitution variables.

For eg:

`<img src="#APEX_FILES#apex-edit-pencil.png" alt="edit #NAMES">`',298261660297559066749993614614253461489);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('NO_CSS_IN_PAGE','Applications should consolidate CSS and not have CSS locally','Remove page level CSS',330470167757302707196724192153988423042);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PAGE_ACCESS_PROTECTION',null,'Require Authentication and set access protection to something other than ‘Unrestricted’',293042031711024343743217219378644412213);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PAGE_AUTH','Application pages should have authorization schemes',TO_CLOB(q'[Select an authorization scheme applied to the page. Authorization schemes are defined at the application-level and can be applied to many elements within the application.

An authorization scheme is evaluated either once for each application session (at session creation), or once for each page view. If the selected authorization scheme evaluates to **TRUE**, then the page displays and is subject to other defined conditions. If it evaluates to **FALSE**, then the page does not display and an er]')
|| TO_CLOB(q'[ror message displays.]'),290954809810139744673844516645939858254);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PAGE_BUILD_ABUSE','Page Excluded by Build Option for too long','Remove the build or eliminate the page',292407724756887247473643654613687773229);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PAGE_ITEM_NAMING','Page Items should be prefixed "P" and the [page id], e.g. "P1_ITEM".','Correct the item name',290954809810145789302942589791813389134);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PUBLIC_PAGE_PUBLIC_AUTH',null,'Remove the authorization scheme',294591489438560344494721046159842530021);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('ROW_HEADER','One or more columns must have "Value Identifies Row" switched on so that screen readers can better describe individual records of a table.','At the column level of your report, toggle on “Value Identifies Row” for as many columns is appropriate to uniquely describe the record in human-friendly terms.',312153571812426193655816434380775773898);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_BUILD_LIST_ENTRY','The build option on this list entry is in an invalid state','Remove or replace the build option',292427565561507231375855134652026739497);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_BUTTON_LINKS','The button URL is invalid','Fix the URL or eliminate the button',291722916888588813458425836146204012298);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_COL_AUTH','The authorization on your column is in an invalid state','Remove the authorization scheme or replace it.',292302818419702751897719419630883846433);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_COL_LINKS','The URL in the column link is invalid','Fix the link or remove it.',291716553215644274634379898138449814780);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_LIST_LINKS','The URL in the list link is invalid','Fix the URL or eliminate the list item',290934672085980425626077628758317791546);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VAL_PAGE_BUILD','The build on this page is in an invalid state','Remove the build option.',292407724756887247473643654613687773229);
