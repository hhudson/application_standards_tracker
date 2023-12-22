# Standards and Tests available for download and import

## Summary and instructions
This page lists 189 published tests distributed across 12 standards (*Accessibility, Broken Functionality, Cleanup, General, Idiosyncratic, Millenium Gen2, Redwood, Security, Universal Theme*) and 6 issue categories (*APEX, General DB Object, Materialized view, Table, Trigger, View*). Download either the "consolidated test exports" or the individual tests for import into your Standard Violation Tracker instance.

## Accessibility (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These tests help support Accessibility standards. They are not substitutes for screen reader tests and other manual tests.

 - [Consolidated tests export for Accessibility](APEX_ACCESSIBILITY_212/ALL_TESTS-APEX_ACCESSIBILITY_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [ACC_AUTOCOMPLETE](APEX_ACCESSIBILITY_212/tests/ACC_AUTOCOMPLETE-REDWOOD.json) |  Some fields benefit from an autocomplete attribute | v1.3 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [ACC_BTN_UNQ](APEX_ACCESSIBILITY_212/tests/ACC_BTN_UNQ-REDWOOD.json) |  Combo of button labels + region names should be unique / page | v1.6 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [ACC_DA_FOCUS](APEX_ACCESSIBILITY_212/tests/ACC_DA_FOCUS-REDWOOD.json) |  DA should avoid "get focus" events | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_DA |
| [ACC_DA_MOUSE_EVNT](APEX_ACCESSIBILITY_212/tests/ACC_DA_MOUSE_EVNT-REDWOOD.json) |  DA should avoid mouse events | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_DA |
| [ACC_IG_COL_AUTOCOMPLETE](APEX_ACCESSIBILITY_212/tests/ACC_IG_COL_AUTOCOMPLETE-REDWOOD.json) |  IG Columns may need autocomplete | v1.4 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [ACC_IG_JS_SHORTCUT](APEX_ACCESSIBILITY_212/tests/ACC_IG_JS_SHORTCUT-REDWOOD.json) |  IG should avoid custom shortcuts | v1.4 [REDWOOD] | APEX_APPL_PAGE_IGS |
| [ACC_LST_TMP_CSS_ANMTN](APEX_ACCESSIBILITY_212/tests/ACC_LST_TMP_CSS_ANMTN-REDWOOD.json) |  List templates should avoid inline CSS w blinking or animation  | v1.4 [REDWOOD] | APEX_APPLICATION_TEMP_LIST |
| [ACC_PAGE_MOUSE_EVNT](APEX_ACCESSIBILITY_212/tests/ACC_PAGE_MOUSE_EVNT-REDWOOD.json) |  Page JS must avoid mouse events | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [ACC_PG_JS_FOCUS](APEX_ACCESSIBILITY_212/tests/ACC_PG_JS_FOCUS-REDWOOD.json) |  Page JS should avoid focus events | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [ACC_PG_TMP_CSS_ANMTN](APEX_ACCESSIBILITY_212/tests/ACC_PG_TMP_CSS_ANMTN-REDWOOD.json) |  Page Templates should avoid CSS animations | v1.4 [REDWOOD] | APEX_APPLICATION_TEMP_PAGE |
| [ACC_REGION_NAMES](APEX_ACCESSIBILITY_212/tests/ACC_REGION_NAMES-REDWOOD.json) |  Region names should be descriptive | v1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [ACC_TAB_TABINDEX](APEX_ACCESSIBILITY_212/tests/ACC_TAB_TABINDEX-REDWOOD.json) |  Application Tabs should avoid tabindex | v1.4 [REDWOOD] | APEX_APPLICATION_TABS |
| [ACC_VAL_DSPLY_LOCN](APEX_ACCESSIBILITY_212/tests/ACC_VAL_DSPLY_LOCN-REDWOOD.json) |  Inline with field error notification is insufficient | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_VAL |
| [BTN_TABINDX](APEX_ACCESSIBILITY_212/tests/BTN_TABINDX-REDWOOD.json) |  Buttons should avoid hardcoded tab indexes | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [CRD_ACTNS_TAB_INDX](APEX_ACCESSIBILITY_212/tests/CRD_ACTNS_TAB_INDX-REDWOOD.json) |  Card Actions should avoid hard coded tab indexes | v1.4 [REDWOOD] | APEX_APPL_PAGE_CARD_ACTIONS |
| [C_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/C_COL_BAD_HTML-REDWOOD.json) |  Classic Columns have wellformed HTML | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/C_COL_IMG_ALT_TEXT-REDWOOD.json) |  Classic Columns with images have alt text | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_INACC_CSS](APEX_ACCESSIBILITY_212/tests/C_COL_INACC_CSS-REDWOOD.json) |  Classic columns should avoid animations | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_UNQ_HEADNG](APEX_ACCESSIBILITY_212/tests/C_COL_UNQ_HEADNG-REDWOOD.json) |  Classic Report column headings are unique per region | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_VLD_HEADNG](APEX_ACCESSIBILITY_212/tests/C_COL_VLD_HEADNG-REDWOOD.json) |  Classic Report- all columns have a header defined | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [DA_BLUR](APEX_ACCESSIBILITY_212/tests/DA_BLUR-REDWOOD.json) |  Check page JS for on blur events | v1.2 [REDWOOD] | APEX_APPLICATION_PAGES |
| [DA_FOCUS](APEX_ACCESSIBILITY_212/tests/DA_FOCUS-REDWOOD.json) |  DAs should avoid Lose Focus or Get Focus triggering events | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_DA |
| [DA_JS_INTRVL_TIMT](APEX_ACCESSIBILITY_212/tests/DA_JS_INTRVL_TIMT-REDWOOD.json) |  DA should avoid js that is setting intervals or timeouts | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_DA_ACTS |
| [IG_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/IG_COL_BAD_HTML-REDWOOD.json) |  HTML should be correctly configured in IG Cols | v1.2 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/IG_COL_IMG_ALT_TEXT-REDWOOD.json) |  IG Columns with images have alt text | v1.4 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/IG_COL_TABINDX-REDWOOD.json) |  IG Columns should avoid hard coded tab indexes | v1.5 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_UNQ_HEADNG](APEX_ACCESSIBILITY_212/tests/IG_COL_UNQ_HEADNG-REDWOOD.json) |  Interactive Grid Columns headings are unique | v1.4 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_VLD](APEX_ACCESSIBILITY_212/tests/IG_COL_VLD-REDWOOD.json) |  Interactive Grid Columns are not null | v1.4 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_TABINDX](APEX_ACCESSIBILITY_212/tests/IG_TABINDX-REDWOOD.json) |  Interactive Grids should avoid hardcorded tab indexes | v1.4 [REDWOOD] | APEX_APPL_PAGE_IGS |
| [IR_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/IR_COL_BAD_HTML-REDWOOD.json) |  IR Cols have wellformed HTML | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/IR_COL_IMG_ALT_TEXT-REDWOOD.json) |  IR Columns with images have alt text | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/IR_COL_TABINDX-REDWOOD.json) |  IR Columns should avoid harded tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_UNQ_LBL](APEX_ACCESSIBILITY_212/tests/IR_COL_UNQ_LBL-REDWOOD.json) |  IR columns need unique labels | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_VLD_HEADNG](APEX_ACCESSIBILITY_212/tests/IR_COL_VLD_HEADNG-REDWOOD.json) |  IR columns are not null | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [IR_TABINDX](APEX_ACCESSIBILITY_212/tests/IR_TABINDX-REDWOOD.json) |  IR reports should avoid hard coded indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_IR |
| [LE_TABINDX](APEX_ACCESSIBILITY_212/tests/LE_TABINDX-REDWOOD.json) |  List entries should avoid hardcoding tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_LIST_ENTRIES |
| [PAGE_HELP_BAD_HTML](APEX_ACCESSIBILITY_212/tests/PAGE_HELP_BAD_HTML-REDWOOD.json) |  Page Help HTML is well formed | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PAGE_INACC_CSS](APEX_ACCESSIBILITY_212/tests/PAGE_INACC_CSS-REDWOOD.json) |  Pages should avoid inline CSS for blinking or animation logic | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PAGE_JS_INTRVL_TIMT](APEX_ACCESSIBILITY_212/tests/PAGE_JS_INTRVL_TIMT-REDWOOD.json) |  Page JS should avoid intervals and timeouts | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PAGE_TABINDX](APEX_ACCESSIBILITY_212/tests/PAGE_TABINDX-REDWOOD.json) |  Pages should avoid hardcoding tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PG_NAME_TITLE](APEX_ACCESSIBILITY_212/tests/PG_NAME_TITLE-REDWOOD.json) |  Pages have name, title and not a blank space | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PG_NAME_UNQ](APEX_ACCESSIBILITY_212/tests/PG_NAME_UNQ-REDWOOD.json) |  Page names should be unique | v1.4 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PG_RGN_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/PG_RGN_COL_TABINDX-REDWOOD.json) |  Page region columns should avoid tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_REG_COLS |
| [PG_RGN_TABINDX](APEX_ACCESSIBILITY_212/tests/PG_RGN_TABINDX-REDWOOD.json) |  Page regions should avoid hardcoded tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [PG_RPT_COL_INDX](APEX_ACCESSIBILITY_212/tests/PG_RPT_COL_INDX-REDWOOD.json) |  Page report columns should avoid tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [PI_HLP_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/PI_HLP_COL_BAD_HTML-REDWOOD.json) |  Item Help HTML is well formed | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PI_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/PI_IMG_ALT_TEXT-REDWOOD.json) |  Page items with html images have alt text | v1.3 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PI_LBL_UNQ](APEX_ACCESSIBILITY_212/tests/PI_LBL_UNQ-REDWOOD.json) |  Page item labels  + region names must be unique | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PI_TABINDX](APEX_ACCESSIBILITY_212/tests/PI_TABINDX-REDWOOD.json) |  Page items should avoid hardcoded indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PI_VLD_LBL](APEX_ACCESSIBILITY_212/tests/PI_VLD_LBL-REDWOOD.json) |  Page Items have valid label and no blank spaces | v1.6 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PRNT_TAB_INDX](APEX_ACCESSIBILITY_212/tests/PRNT_TAB_INDX-REDWOOD.json) |  Parent tab should avoid hard coded tab indexes | v1.4 [REDWOOD] | APEX_APPLICATION_PARENT_TABS |
| [RGN_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/RGN_IMG_ALT_TEXT-REDWOOD.json) |  Regions with HTML images should have alt text | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RGN_UNQ](APEX_ACCESSIBILITY_212/tests/RGN_UNQ-REDWOOD.json) |  Regions on a page must be unique | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [ROW_HEADER](APEX_ACCESSIBILITY_212/tests/ROW_HEADER-REDWOOD.json) |  Reports should have Row Headers | v1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [STTC_CNTNT_BAD_HTML](APEX_ACCESSIBILITY_212/tests/STTC_CNTNT_BAD_HTML-REDWOOD.json) |  Static Content HTML is well formed | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [THEME_STL_INACC](APEX_ACCESSIBILITY_212/tests/THEME_STL_INACC-REDWOOD.json) |  Theme styles should avoid animations | v1.1 [REDWOOD] | APEX_APPLICATION_THEME_STYLES |

## Broken Functionality (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These tests identify functionality that appears unintentional and could cause problems.

 - [Consolidated tests export for Broken Functionality](APEX_BROKEN_FUNCTIONALITY_212/ALL_TESTS-APEX_BROKEN_FUNCTIONALITY_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [BC_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/BC_AUTHR_MATCH_DEST-REDWOOD.json) |  Breadcrumb Authorization Matches Destination | v1.1 [REDWOOD] | APEX_APPLICATION_BC_ENTRIES |
| [BUTTON_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/BUTTON_AUTHR_MATCH_DEST-REDWOOD.json) |  Button Authorization Matches Destination | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [BUTTON_DEPRECTD_OR_LEGCY](APEX_BROKEN_FUNCTIONALITY_212/tests/BUTTON_DEPRECTD_OR_LEGCY-REDWOOD.json) |  Button display positions should not be legacy or deprecated | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [C_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/C_COL_AUTHR_MATCH_DEST-REDWOOD.json) |  Classic Column Link Authorization Matches Destination | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [IG_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/IG_COL_AUTHR_MATCH_DEST-REDWOOD.json) |  IG Column Link Authorization Matches Destination  | v1.1 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [IR_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/IR_COL_AUTHR_MATCH_DEST-REDWOOD.json) |  IR Column Link Authorization Matches Destination  | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [NLE_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/NLE_AUTHR_MATCH_DEST-REDWOOD.json) |  Navigation List Entry Authorization Matches Destination | v1.1 [REDWOOD] | APEX_APPLICATION_LIST_ENTRIES |
| [PAGES_CURRENT_IN_MENU](APEX_BROKEN_FUNCTIONALITY_212/tests/PAGES_CURRENT_IN_MENU-REDWOOD.json) |  Regular Pages should be Current in Navigation | v1.2 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PAGE_ERROR](APEX_BROKEN_FUNCTIONALITY_212/tests/PAGE_ERROR-REDWOOD.json) |  Pages should not have unresolved critical issues | v1.7 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PB_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/PB_AUTHR_MATCH_DEST-REDWOOD.json) |  Page Branch Authorization Matches Destination | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [PUBLIC_PAGE_PUBLIC_AUTH](APEX_BROKEN_FUNCTIONALITY_212/tests/PUBLIC_PAGE_PUBLIC_AUTH-ILA.json) |  Public pages should not require authentication | v1 [ILA] | APEX_APPLICATION_PAGES |
| [UNREACHABLE_PAGE](APEX_BROKEN_FUNCTIONALITY_212/tests/UNREACHABLE_PAGE-REDWOOD.json) |  Pages should be reachable | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [VAL_BUTTON_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_BUTTON_LINKS-ILA.json) |  Button URLs should be valid | v1 [ILA] | APEX_APPLICATION_PAGE_BUTTONS |
| [VAL_COL_AUTH](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_COL_AUTH-ILA.json) |  Columns should have a valid authorization scheme | v1 [ILA] | APEX_APPLICATION_PAGE_REGIONS |
| [VAL_COL_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_COL_LINKS-ILA.json) |  Column Link should be valid | v1 [ILA] | APEX_APPLICATION_PAGE_REGIONS |
| [VAL_LIST_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_LIST_LINKS-ILA.json) |  List URLs should be valid | v1 [ILA] | APEX_APPLICATION_LIST_ENTRIES |

## Cleanup (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These tests describe general best practices to keep things tidy (housekeeping)

 - [Consolidated tests export for Cleanup](APEX_CLEANUP_212/ALL_TESTS-APEX_CLEANUP_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AVAILABLE](APEX_CLEANUP_212/tests/APP_AVAILABLE-ILA.json) |  Applications are available | v1 [ILA] | APEX_APPLICATIONS |
| [AVAILABLE_REGION](APEX_CLEANUP_212/tests/AVAILABLE_REGION-REDWOOD.json) |  Regions should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [BUTTON_AVAILABLE](APEX_CLEANUP_212/tests/BUTTON_AVAILABLE-REDWOOD.json) |  Buttons should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [CARD_ACTIONS_AVAILABLE](APEX_CLEANUP_212/tests/CARD_ACTIONS_AVAILABLE-REDWOOD.json) |  Card Actions should be available | v1.2 [REDWOOD] | APEX_APPL_PAGE_CARD_ACTIONS |
| [CHARTS_AVAILABLE](APEX_CLEANUP_212/tests/CHARTS_AVAILABLE-REDWOOD.json) |  Charts should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_CHART_S |
| [MAP_LAYERS_AVAILABLE](APEX_CLEANUP_212/tests/MAP_LAYERS_AVAILABLE-REDWOOD.json) |  Map Layers should be available  | v1.2 [REDWOOD] | APEX_APPL_PAGE_MAP_LAYERS |
| [PAGE_BRANCH_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_BRANCH_AVAILABLE-REDWOOD.json) |  Page branches should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BRANCHES |
| [PAGE_COMP_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_COMP_AVAILABLE-REDWOOD.json) |  Page computations should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_COMP |
| [PAGE_DA_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_DA_AVAILABLE-REDWOOD.json) |  Page dynamic actions should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_DA |
| [PAGE_ITEM_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_ITEM_AVAILABLE-REDWOOD.json) |  Page Items should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PAGE_PROC_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_PROC_AVAILABLE-REDWOOD.json) |  Page procedures should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_PROC |
| [PAGE_VAL_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_VAL_AVAILABLE-REDWOOD.json) |  Page Validations should be available | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_VAL |
| [SEARCH_SOURCES_AVAILABLE](APEX_CLEANUP_212/tests/SEARCH_SOURCES_AVAILABLE-REDWOOD.json) |  Search Sources should be available | v1.2 [REDWOOD] | APEX_APPL_PAGE_SEARCH_SOURCES |
| [THEME_SUBSCRIPTION](APEX_CLEANUP_212/tests/THEME_SUBSCRIPTION-REDWOOD.json) |  Themes should be specific numbers and subscribed | v1 [REDWOOD] | APEX_APPLICATION_THEME_STYLES |
| [TOO_MANY_REGIONS](APEX_CLEANUP_212/tests/TOO_MANY_REGIONS-REDWOOD.json) |  Pages should limit their content | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [VAL_BUILD_LIST_ENTRY](APEX_CLEANUP_212/tests/VAL_BUILD_LIST_ENTRY-ILA.json) |  List entries should have valid build options | v1 [ILA] | APEX_APPLICATION_LIST_ENTRIES |
| [VAL_PAGE_BUILD](APEX_CLEANUP_212/tests/VAL_PAGE_BUILD-ILA.json) |  Pages should have valid build options | v1 [ILA] | APEX_APPLICATION_PAGES |

## General (Database Version 19C)
These tests describe general tests to run against DB objects

 - [Consolidated tests export for General](DB_GENERAL_19C/ALL_TESTS-DB_GENERAL_19C.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [DBMS_ASSERT](DB_GENERAL_19C/tests/DBMS_ASSERT-REDWOOD.json) |  Missing DBMS_ASSERT | v1.5 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [DISCOURAGED_CODE](DB_GENERAL_19C/tests/DISCOURAGED_CODE-REDWOOD.json) |  Discouraged code | v1.6 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [DUPLICATE_STATEMENTS](DB_GENERAL_19C/tests/DUPLICATE_STATEMENTS-REDWOOD.json) |  Duplicate Statements | v1.5 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [FK_INDEXED](DB_GENERAL_19C/tests/FK_INDEXED-REDWOOD.json) |  Foreign keys must be indexed | v1.3 [REDWOOD] | DATABASE TABLE |
| [IDENTIFIER_NAMING](DB_GENERAL_19C/tests/IDENTIFIER_NAMING-REDWOOD.json) |  Naming Convention violation | v1.6 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [MISSING_COMMENT](DB_GENERAL_19C/tests/MISSING_COMMENT-REDWOOD.json) |  Missing Comments | v1 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [UNUSED_IDENTIFIERS](DB_GENERAL_19C/tests/UNUSED_IDENTIFIERS-REDWOOD.json) |  Unused identifers | v1.3 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [URGENT_PLSQL_WARNINGS](DB_GENERAL_19C/tests/URGENT_PLSQL_WARNINGS-REDWOOD.json) |  Urgent PLSQL Warning | v1.2 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [VALID_OBJECTS](DB_GENERAL_19C/tests/VALID_OBJECTS-REDWOOD.json) |  Invalid Object | v1.3 [REDWOOD] | DATABASE SUPPORTING OBJECT |
| [VALID_VIEW](DB_GENERAL_19C/tests/VALID_VIEW-REDWOOD.json) |  Fix Invalid View | v1.2 [REDWOOD] | DATABASE VIEW |
| [VIEW_NAME](DB_GENERAL_19C/tests/VIEW_NAME-REDWOOD.json) |  Views must be correctly named | v1.1 [REDWOOD] | DATABASE VIEW |

## General (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are general tests with no theme-specific angle

 - [Consolidated tests export for General](APEX_GENERAL_212/ALL_TESTS-APEX_GENERAL_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [APT_PAGE_ITEM_SUBTYPE](APEX_GENERAL_212/tests/APT_PAGE_ITEM_SUBTYPE-REDWOOD.json) |  Use the appropriate page item subtype | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [FORM_ITEM_HELP](APEX_GENERAL_212/tests/FORM_ITEM_HELP-REDWOOD.json) |  Form Elements may benefit from help text | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [JVSCRIPT_CONSOLE_LOG](APEX_GENERAL_212/tests/JVSCRIPT_CONSOLE_LOG-REDWOOD.json) |  Do not use console.log | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_DA_ACTS |
| [NO_HARDCDD_DT_FRMTS](APEX_GENERAL_212/tests/NO_HARDCDD_DT_FRMTS-REDWOOD.json) |  Avoid hardcoded date formats | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RGN_STTC_NODASH](APEX_GENERAL_212/tests/RGN_STTC_NODASH-REDWOOD.json) |  Region Static IDs can have underscores not dashes | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |

## Idiosyncratic (Database Version 19C)
Tests that are *not* general standards. You are welcome to disagree with them.

 - [Consolidated tests export for Idiosyncratic](DB_IDIOSYNCRATIC_19C/ALL_TESTS-DB_IDIOSYNCRATIC_19C.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [NO_TRIGGERS](DB_IDIOSYNCRATIC_19C/tests/NO_TRIGGERS-REDWOOD.json) |  This schema should not have triggers | v1 [REDWOOD] | DATABASE TRIGGER |

## Idiosyncratic (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Tests that are *not* general standards. You are welcome to disagree with them.

 - [Consolidated tests export for Idiosyncratic](APEX_IDIOSYNCRATIC_212/ALL_TESTS-APEX_IDIOSYNCRATIC_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [APP_BUILDS](APEX_IDIOSYNCRATIC_212/tests/APP_BUILDS-REDWOOD.json) |  Apps should have particular set of builds | v1.1 [REDWOOD] | APEX_APPLICATIONS |
| [APP_ITEM_NAMING](APEX_IDIOSYNCRATIC_212/tests/APP_ITEM_NAMING-ILA.json) |  Application Item incorrectly prefixed | v1 [ILA] | APEX_APPLICATION_ITEMS |
| [AST_BREADCRUMB_STYLING](APEX_IDIOSYNCRATIC_212/tests/AST_BREADCRUMB_STYLING-REDWOOD.json) |  AST Breadcrumbs are correctly styled | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [AST_BUTTONS_HAVE_ICONS](APEX_IDIOSYNCRATIC_212/tests/AST_BUTTONS_HAVE_ICONS-REDWOOD.json) |  All AST Standard Buttons have left-sided icons | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_BUTTON_SIMPLE](APEX_IDIOSYNCRATIC_212/tests/AST_BUTTON_SIMPLE-REDWOOD.json) |  AST buttons should be simple | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_CANCEL_BUTTON](APEX_IDIOSYNCRATIC_212/tests/AST_CANCEL_BUTTON-REDWOOD.json) |  All Cancel buttons should be default | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_DELETE_BUTTON](APEX_IDIOSYNCRATIC_212/tests/AST_DELETE_BUTTON-REDWOOD.json) |  Delete buttons should be correctly styled | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_PAGE_AUTH](APEX_IDIOSYNCRATIC_212/tests/AST_PAGE_AUTH-REDWOOD.json) |  SVT Application Pages should have Authorization Schemes | v1.2 [REDWOOD] | APEX_APPLICATION_PAGES |
| [BC_MATCHES_NAV_LIST](APEX_IDIOSYNCRATIC_212/tests/BC_MATCHES_NAV_LIST-REDWOOD.json) |  Breadcrumb hierarchy should match nav menu | v1.2 [REDWOOD] | APEX_APPLICATION_BC_ENTRIES |
| [CREATE_BUTTON_STYLE](APEX_IDIOSYNCRATIC_212/tests/CREATE_BUTTON_STYLE-REDWOOD.json) |  Create buttons should be styled in a consistent way | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [DEV_PAGES_HAVE_BUILDS](APEX_IDIOSYNCRATIC_212/tests/DEV_PAGES_HAVE_BUILDS-AHA_APEX.json) |  Scratch Pages have 'dev_only' builds on them | v1.1 [AHA_APEX] | APEX_APPLICATION_PAGES |
| [DRAWERS_NOT_MODALS](APEX_IDIOSYNCRATIC_212/tests/DRAWERS_NOT_MODALS-REDWOOD.json) |  User Drawers instead of Modals | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [FRIENDLY_PAGE_NAMES](APEX_IDIOSYNCRATIC_212/tests/FRIENDLY_PAGE_NAMES-REDWOOD.json) |  Page names should be human friendly | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [LIST_MENU_ENTRY_DESC](APEX_IDIOSYNCRATIC_212/tests/LIST_MENU_ENTRY_DESC-REDWOOD.json) |  List Menu Entries have Descriptions (for searchability) | v1.4 [REDWOOD] | APEX_APPLICATION_LIST_ENTRIES |
| [NAVIGATION_MENU_ICONS](APEX_IDIOSYNCRATIC_212/tests/NAVIGATION_MENU_ICONS-REDWOOD.json) |  Navigation menu list entries should have icons | v1.1 [REDWOOD] | APEX_APPLICATION_LIST_ENTRIES |
| [NEVER_REGIONS_HAVE_BUILDS](APEX_IDIOSYNCRATIC_212/tests/NEVER_REGIONS_HAVE_BUILDS-AHA_APEX.json) |  Regions with a 'never' condition have 'to_delete' build | v1.1 [AHA_APEX] | APEX_APPLICATION_PAGE_REGIONS |
| [RDS_TABS_CONTAINER](APEX_IDIOSYNCRATIC_212/tests/RDS_TABS_CONTAINER-REDWOOD.json) |  RDS regions should have a template of Tabs Container | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RESET_BUTTON_STYLE](APEX_IDIOSYNCRATIC_212/tests/RESET_BUTTON_STYLE-REDWOOD.json) |  Reset buttons should be styled in a consistent way | v1.3 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [SVT_BUTTON_CAPS](APEX_IDIOSYNCRATIC_212/tests/SVT_BUTTON_CAPS-REDWOOD.json) |  Button names and labels should be correctly capitalized | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [SVT_P0SUCCESS_PROC](APEX_IDIOSYNCRATIC_212/tests/SVT_P0SUCCESS_PROC-REDWOOD.json) |  Modal Dialogs should set P0_SUCCESS | v1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [SVT_SAVE_BUTTONS](APEX_IDIOSYNCRATIC_212/tests/SVT_SAVE_BUTTONS-REDWOOD.json) |  Update buttons must be labelled "Save" | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |

## Millenium Gen2 (Database Version 19C)
Tests that are specific to the Millenium Gen2 project

 - [Consolidated tests export for Millenium Gen2](DB_MILLENIUM_GEN2_19C/ALL_TESTS-DB_MILLENIUM_GEN2_19C.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [ALPH_COL_DATATYPE](DB_MILLENIUM_GEN2_19C/tests/ALPH_COL_DATATYPE-REDWOOD.json) |  These column datatypes are discouraged | v1 [REDWOOD] | DATABASE TABLE |
| [ALPH_MV_NAME](DB_MILLENIUM_GEN2_19C/tests/ALPH_MV_NAME-REDWOOD.json) |  Materialized Views should be named correctly | v1.3 [REDWOOD] | DATABASE MATERIALIZED VIEW |
| [ALPH_VIEW_NAME](DB_MILLENIUM_GEN2_19C/tests/ALPH_VIEW_NAME-REDWOOD.json) |  Alphawave Views must be correctly named | v1.3 [REDWOOD] | DATABASE VIEW |
| [TBL_AUDIT_COLS](DB_MILLENIUM_GEN2_19C/tests/TBL_AUDIT_COLS-REDWOOD.json) |  Tables should have audit columns | v1.2 [REDWOOD] | DATABASE TABLE |
| [TRIGGER_SCHEMA_PRFX_TBL](DB_MILLENIUM_GEN2_19C/tests/TRIGGER_SCHEMA_PRFX_TBL-REDWOOD.json) |  DML Triggers must have schema prefix for table | v1 [REDWOOD] | DATABASE TRIGGER |
| [USE_CHAR_NOT_BYTE](DB_MILLENIUM_GEN2_19C/tests/USE_CHAR_NOT_BYTE-REDWOOD.json) |  Use Char not Bytes | v1 [REDWOOD] | DATABASE TABLE |
| [USE_TS_W_TZ](DB_MILLENIUM_GEN2_19C/tests/USE_TS_W_TZ-REDWOOD.json) |  Use TIMESTAMP WITH TIME ZONE where appropriate | v1.1 [REDWOOD] | DATABASE TABLE |

## Millenium Gen2 (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Tests that are specific to the Millenium Gen2 project

 - [Consolidated tests export for Millenium Gen2](APEX_MILLENIUM_GEN2_212/ALL_TESTS-APEX_MILLENIUM_GEN2_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [ALPH_AI_NAMING](APEX_MILLENIUM_GEN2_212/tests/ALPH_AI_NAMING-REDWOOD.json) |  Application Items should be correctly named | v1.3 [REDWOOD] | APEX_APPLICATION_ITEMS |
| [ALPH_AP_NAMING](APEX_MILLENIUM_GEN2_212/tests/ALPH_AP_NAMING-REDWOOD.json) |  Application Processes should be correctly named | v1.2 [REDWOOD] | APEX_APPLICATION_PROCESSES |
| [ALPH_BTN_STC_ID_NM](APEX_MILLENIUM_GEN2_212/tests/ALPH_BTN_STC_ID_NM-REDWOOD.json) |  Button Static IDs should be correctly named | v1.3 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [ALPH_ERROR_HANDLING](APEX_MILLENIUM_GEN2_212/tests/ALPH_ERROR_HANDLING-REDWOOD.json) |  Applications should have the correct error handling function set | v1.1 [REDWOOD] | APEX_APPLICATIONS |
| [ALPH_RGN_NAMING](APEX_MILLENIUM_GEN2_212/tests/ALPH_RGN_NAMING-REDWOOD.json) |  Region Static IDs should be correctly named | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [GEN2_INIT_CLEANUP](APEX_MILLENIUM_GEN2_212/tests/GEN2_INIT_CLEANUP-AHA_APEX_EOD1.json) |  Applications should have the correct initialization and cleanup | v1.1 [AHA_APEX_EOD1] | APEX_APPLICATIONS |
| [GLOBAL_TIME_FORMATS](APEX_MILLENIUM_GEN2_212/tests/GLOBAL_TIME_FORMATS-REDWOOD.json) |  Time formats should be set in Globalization Attributes | v1.1 [REDWOOD] | APEX_APPLICATIONS |
| [INVLD_END_POINTS](APEX_MILLENIUM_GEN2_212/tests/INVLD_END_POINTS-REDWOOD.json) |  These URL endpoints are deprecated | v1 [REDWOOD] | APEX_APPLICATIONS |
| [MISSING_ROW_PROCESSING](APEX_MILLENIUM_GEN2_212/tests/MISSING_ROW_PROCESSING-AHA_APEX_EOD1.json) |  Forms need corresponding Automatic Row Processing | v1 [AHA_APEX_EOD1] | APEX_APPLICATION_PAGE_REGIONS |

## Redwood (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Standards for correctly implementing Redwood patterns

 - [Consolidated tests export for Redwood](APEX_REDWOOD_212/ALL_TESTS-APEX_REDWOOD_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [APP_CSS_FILE](APEX_REDWOOD_212/tests/APP_CSS_FILE-REDWOOD.json) |  Apps should have a centralized css file | v1.1 [REDWOOD] | APEX_APPLICATIONS |
| [COL_ALIGNMENT_CLASSIC](APEX_REDWOOD_212/tests/COL_ALIGNMENT_CLASSIC-REDWOOD.json) |  Classic Columns are correctly aligned | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [COL_ALIGNMENT_IG](APEX_REDWOOD_212/tests/COL_ALIGNMENT_IG-REDWOOD.json) |  IG Columns are correctly aligned | v1.2 [REDWOOD] | APEX_APPL_PAGE_IG_COLUMNS |
| [COL_ALIGNMENT_IR](APEX_REDWOOD_212/tests/COL_ALIGNMENT_IR-REDWOOD.json) |  IR Columns are correctly aligned | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [COL_HEADERS_C](APEX_REDWOOD_212/tests/COL_HEADERS_C-REDWOOD.json) |  Classic Column header is appropriate | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_RPT_COLS |
| [COL_HEADERS_IR](APEX_REDWOOD_212/tests/COL_HEADERS_IR-REDWOOD.json) |  IR Column header is appropriate | v1.5 [REDWOOD] | APEX_APPLICATION_PAGE_IR_COL |
| [FIELD_NAMES](APEX_REDWOOD_212/tests/FIELD_NAMES-REDWOOD.json) |  Form field label is appropriate | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [NO_CSS_IN_PAGE](APEX_REDWOOD_212/tests/NO_CSS_IN_PAGE-ILA.json) |  Pages should not have local CSS | v1 [ILA] | APEX_APPLICATION_PAGES |
| [PAGE_ITEM_NAMING](APEX_REDWOOD_212/tests/PAGE_ITEM_NAMING-ILA.json) |  Page Items incorrectly prefixed | v1 [ILA] | APEX_APPLICATION_PAGE_ITEMS |
| [RW_ADDL_INFO](APEX_REDWOOD_212/tests/RW_ADDL_INFO-REDWOOD.json) |  Additional Info regions are correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_BNNR_MSG_LNKS](APEX_REDWOOD_212/tests/RW_BNNR_MSG_LNKS-REDWOOD.json) |  Banner Message region should only have Links | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_BUTTON_ICON](APEX_REDWOOD_212/tests/RW_BUTTON_ICON-REDWOOD.json) |  Buttons should the correct icons | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [RW_BUTTON_PLACEMENT](APEX_REDWOOD_212/tests/RW_BUTTON_PLACEMENT-REDWOOD.json) |  Redwood Buttons should be correctly placed | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [RW_CTXT_INFO](APEX_REDWOOD_212/tests/RW_CTXT_INFO-REDWOOD.json) |  Contextual Info regions should be configured correctly | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_FOLDOUTPANEL](APEX_REDWOOD_212/tests/RW_FOLDOUTPANEL-REDWOOD.json) |  Use Foldout panels in the Panels positions | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_IO_CONTENT](APEX_REDWOOD_212/tests/RW_IO_CONTENT-REDWOOD.json) |  Item Overview Content is correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_ITEM_OVVW_ICN](APEX_REDWOOD_212/tests/RW_ITEM_OVVW_ICN-REDWOOD.json) |  Item Overview Regions should have an Icon or Initials | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_ITM_OVRVW_POS](APEX_REDWOOD_212/tests/RW_ITM_OVRVW_POS-REDWOOD.json) |  Region in "Item Overview" position is correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_JVSCRIPT_DOM_MANPLTN](APEX_REDWOOD_212/tests/RW_JVSCRIPT_DOM_MANPLTN-REDWOOD.json) |  Do not manipulates classes, text and attributes in Redwood | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_DA_ACTS |
| [RW_LIST_ENTRIES_ICONS](APEX_REDWOOD_212/tests/RW_LIST_ENTRIES_ICONS-REDWOOD.json) |  List Entries should use the correct icons | v1.2 [REDWOOD] | APEX_APPLICATION_LIST_ENTRIES |
| [RW_LOGIN](APEX_REDWOOD_212/tests/RW_LOGIN-REDWOOD.json) |  Login regions are configured correctly | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_PAGE_HEADER](APEX_REDWOOD_212/tests/RW_PAGE_HEADER-REDWOOD.json) |  Regions in the "Page Header" position are correctly config | v1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_PAGE_ITEM_STYLING](APEX_REDWOOD_212/tests/RW_PAGE_ITEM_STYLING-REDWOOD.json) |  Redwood Page Items should use Redwood Icons | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [RW_PG_NAV_POS](APEX_REDWOOD_212/tests/RW_PG_NAV_POS-REDWOOD.json) |  Region in "Page Navigation" is correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_PILLAR_VERIFY](APEX_REDWOOD_212/tests/RW_PILLAR_VERIFY-REDWOOD.json) |  Health apps should have Sky Pillar set | v1 [REDWOOD] | APEX_APPLICATIONS |
| [RW_RGN_BREADCRUMB](APEX_REDWOOD_212/tests/RW_RGN_BREADCRUMB-REDWOOD.json) |  Breadcrumbs have a template and position of "Page Header" | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_SCRBRD_POS](APEX_REDWOOD_212/tests/RW_SCRBRD_POS-REDWOOD.json) |  Region in "Scoreboard" position is correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_SMT_FILTR](APEX_REDWOOD_212/tests/RW_SMT_FILTR-REDWOOD.json) |  Smart filter regions are correctly configured | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TMSTMP_ACTIONS_POS](APEX_REDWOOD_212/tests/RW_TMSTMP_ACTIONS_POS-REDWOOD.json) |  Regions in "Timestamp & Actions" are correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOAST_ICON](APEX_REDWOOD_212/tests/RW_TOAST_ICON-REDWOOD.json) |  Toast regions with the custom icon setting should have an icon | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOAST_LNKS](APEX_REDWOOD_212/tests/RW_TOAST_LNKS-REDWOOD.json) |  Toast regions should only have links | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOC_POS](APEX_REDWOOD_212/tests/RW_TOC_POS-REDWOOD.json) |  Regions in "Table of Contents" are correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_VISUALZTNS](APEX_REDWOOD_212/tests/RW_VISUALZTNS-REDWOOD.json) |  Visualization regions are correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [RW_WLCM_BNNR_TMPL](APEX_REDWOOD_212/tests/RW_WLCM_BNNR_TMPL-REDWOOD.json) |  Banner regions are correctly configured | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [TOO_MANY_DAS](APEX_REDWOOD_212/tests/TOO_MANY_DAS-REDWOOD.json) |  Pages should limit the amount of Dynamic Actions | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |

## Security (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These standards enforce security

 - [Consolidated tests export for Security](APEX_SECURITY_212/ALL_TESTS-APEX_SECURITY_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_212/tests/APP_AUTH-ILA.json) |  Application has Authorization Scheme | v1 [ILA] | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_212/tests/IG_HTML_ESCAPING_COLS-ILA.json) |  HTML should be escaped in IG Columns | v1 [ILA] | APEX_APPL_PAGE_IG_COLUMNS |
| [IR_HTML_ESCAPING_COLS](APEX_SECURITY_212/tests/IR_HTML_ESCAPING_COLS-ILA.json) |  HTML should be escaped in IR Columns | v1 [ILA] | APEX_APPLICATION_PAGE_IR_COL |
| [PAGE_AUTH](APEX_SECURITY_212/tests/PAGE_AUTH-ILA.json) |  Application Pages should have Authorization Schemes | v1 [ILA] | APEX_APPLICATION_PAGES |

## Universal Theme (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are best practices that apply to Universal Theme applications.

 - [Consolidated tests export for Universal Theme](APEX_UNIVERSAL_THEME_212/ALL_TESTS-APEX_UNIVERSAL_THEME_212.json)

| Test Code | Test Name | Version* | Component Type |
|-----------|-----------|---------|----------------|
| [BUTTON_DEFAULT_SIZE](APEX_UNIVERSAL_THEME_212/tests/BUTTON_DEFAULT_SIZE-REDWOOD.json) |  Button size should be default | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [BUTTON_STYLING](APEX_UNIVERSAL_THEME_212/tests/BUTTON_STYLING-REDWOOD.json) |  Buttons should be styled correctly | v1 [REDWOOD] | APEX_APPLICATION_PAGE_BUTTONS |
| [COL_HEADER_RF_TG](APEX_UNIVERSAL_THEME_212/tests/COL_HEADER_RF_TG-REDWOOD.json) |  Reflow / Toggle Column header is appropriate | v1.4 [REDWOOD] | APEX_APPLICATION_PAGE_REG_COLS |
| [FILTER_RGN_TMPLT](APEX_UNIVERSAL_THEME_212/tests/FILTER_RGN_TMPLT-REDWOOD.json) |  Filtered Regions has Card Container template | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |
| [MODAL_FLOATING_LABEL](APEX_UNIVERSAL_THEME_212/tests/MODAL_FLOATING_LABEL-REDWOOD.json) |  Use Floating Labels | v1.1 [REDWOOD] | APEX_APPLICATION_PAGE_ITEMS |
| [PAGES_HAVE_PADDING](APEX_UNIVERSAL_THEME_212/tests/PAGES_HAVE_PADDING-REDWOOD.json) |  Pages should not remove padding | v1.1 [REDWOOD] | APEX_APPLICATION_PAGES |
| [RESET_BUTTON_REPORT](APEX_UNIVERSAL_THEME_212/tests/RESET_BUTTON_REPORT-REDWOOD.json) |  Reports should have a reset button | v1.2 [REDWOOD] | APEX_APPLICATION_PAGE_REGIONS |

## Download All Tests
 - [Consolidated export of all 189 tests and 12 standards](ALL_TESTS.json)


* Test versions are idenfied by an incrementing number and the name of the database on which they were developed. The addition of the database name allows us to distinguish between tests that have been imported and untouched and ones that have been modified locally after import.    
