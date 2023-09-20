# Published standards & tests
- [Export of all standards](ALL_STANDARDS.json)- [Export of all tests](ALL_TESTS.json)*

## Accessibility (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are standards to maintain Accessibility.

 - [Standard export](APEX_ACCESSIBILITY_212/STANDARD-APEX_ACCESSIBILITY_212.json)
 - [Consolidated tests export](APEX_ACCESSIBILITY_212/ALL_TESTS-APEX_ACCESSIBILITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [ACC_AUTOCOMPLETE](APEX_ACCESSIBILITY_212/tests/ACC_AUTOCOMPLETE.json) |  Some fields benefit from an autocomplete attribute | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [ACC_BTN_UNQ](APEX_ACCESSIBILITY_212/tests/ACC_BTN_UNQ.json) |  Button labels should be unique per page | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [ACC_CARD_LINK](APEX_ACCESSIBILITY_212/tests/ACC_CARD_LINK.json) |  Card link require titles and arias | v1.1 | APEX_APPL_PAGE_CARD_ACTIONS |
| [ACC_DA_FOCUS](APEX_ACCESSIBILITY_212/tests/ACC_DA_FOCUS.json) |  DA should avoid "get focus" events | v1 | APEX_APPLICATION_PAGE_DA |
| [ACC_DA_MOUSE_EVNT](APEX_ACCESSIBILITY_212/tests/ACC_DA_MOUSE_EVNT.json) |  DA should avoid mouse events | v1.1 | APEX_APPLICATION_PAGE_DA |
| [ACC_IG_COL_AUTOCOMPLETE](APEX_ACCESSIBILITY_212/tests/ACC_IG_COL_AUTOCOMPLETE.json) |  IG Columns may need autocomplete | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [ACC_IG_COL_LINK](APEX_ACCESSIBILITY_212/tests/ACC_IG_COL_LINK.json) |  IG Column Links should have title + aria | v1.1 | APEX_APPL_PAGE_IG_COLUMNS |
| [ACC_IG_IV_LINK](APEX_ACCESSIBILITY_212/tests/ACC_IG_IV_LINK.json) |  IG Icon View Links need title + aria | v1.1 | APEX_APPL_PAGE_IGS |
| [ACC_IG_JS_SHORTCUT](APEX_ACCESSIBILITY_212/tests/ACC_IG_JS_SHORTCUT.json) |  IG should avoid custom shortcuts | v1 | APEX_APPL_PAGE_IGS |
| [ACC_LST_TMP_CSS_ANMTN](APEX_ACCESSIBILITY_212/tests/ACC_LST_TMP_CSS_ANMTN.json) |  List templates should avoid inline CSS w blinking or animation  | v1 | APEX_APPLICATION_TEMP_LIST |
| [ACC_PAGE_MOUSE_EVNT](APEX_ACCESSIBILITY_212/tests/ACC_PAGE_MOUSE_EVNT.json) |  Page JS must avoid mouse events | v1 | APEX_APPLICATION_PAGES |
| [ACC_PG_ITM_LINK](APEX_ACCESSIBILITY_212/tests/ACC_PG_ITM_LINK.json) |  Page Item Quick Pick Links need aria & title | v1.1 | APEX_APPLICATION_PAGE_ITEMS |
| [ACC_PG_JS_FOCUS](APEX_ACCESSIBILITY_212/tests/ACC_PG_JS_FOCUS.json) |  Page JS should avoid focus events | v1 | APEX_APPLICATION_PAGES |
| [ACC_PG_TMP_CSS_ANMTN](APEX_ACCESSIBILITY_212/tests/ACC_PG_TMP_CSS_ANMTN.json) |  Page Templates should avoid CSS animations | v1 | APEX_APPLICATION_TEMP_PAGE |
| [ACC_TAB_TABINDEX](APEX_ACCESSIBILITY_212/tests/ACC_TAB_TABINDEX.json) |  Application Tabs should avoid tabindex | v1 | APEX_APPLICATION_TABS |
| [ACC_VAL_DSPLY_LOCN](APEX_ACCESSIBILITY_212/tests/ACC_VAL_DSPLY_LOCN.json) |  Inline with field error notification is insufficient | v1.1 | APEX_APPLICATION_PAGE_VAL |
| [BTN_TABINDX](APEX_ACCESSIBILITY_212/tests/BTN_TABINDX.json) |  Buttons should avoid hardcoded tab indexes | v1.1 | APEX_APPLICATION_PAGE_BUTTONS |
| [COL_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/COL_ALT_TEXT.json) |  Column image links should have alt text | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [CRD_ACTNS_TAB_INDX](APEX_ACCESSIBILITY_212/tests/CRD_ACTNS_TAB_INDX.json) |  Card Actions should avoid hard coded tab indexes | v1 | APEX_APPL_PAGE_CARD_ACTIONS |
| [C_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/C_COL_BAD_HTML.json) |  Classic Columns have wellformed HTML | v1.2 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/C_COL_IMG_ALT_TEXT.json) |  Classic Columns with images have alt text | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_INACC_CSS](APEX_ACCESSIBILITY_212/tests/C_COL_INACC_CSS.json) |  Classic columns should avoid animations | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_LINK](APEX_ACCESSIBILITY_212/tests/C_COL_LINK.json) |  Classic Columns links must have aria and title | v1.2 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_UNQ_HEADNG](APEX_ACCESSIBILITY_212/tests/C_COL_UNQ_HEADNG.json) |  Classic Report column headings are unique per region | v1.1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_UNQ_LBL](APEX_ACCESSIBILITY_212/tests/C_COL_UNQ_LBL.json) |  Classic Report column aliases are unique per page | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [C_COL_VLD_HEADNG](APEX_ACCESSIBILITY_212/tests/C_COL_VLD_HEADNG.json) |  Classic Report- all columns have a header defined | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [DA_BLUR](APEX_ACCESSIBILITY_212/tests/DA_BLUR.json) |  Check page JS for on blur events | v1 | APEX_APPLICATION_PAGES |
| [DA_FOCUS](APEX_ACCESSIBILITY_212/tests/DA_FOCUS.json) |  DAs should avoid Lose Focus or Get Focus triggering events | v1 | APEX_APPLICATION_PAGE_DA |
| [DA_JS_INTRVL_TIMT](APEX_ACCESSIBILITY_212/tests/DA_JS_INTRVL_TIMT.json) |  DA should avoid js that is setting intervals or timeouts | v1.1 | APEX_APPLICATION_PAGE_DA_ACTS |
| [IG_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/IG_COL_BAD_HTML.json) |  HTML should be correctly configured in IG Cols | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/IG_COL_IMG_ALT_TEXT.json) |  IG Columns with images have alt text | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/IG_COL_TABINDX.json) |  IG Columns should avoid hard coded tab indexes | v1.1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_UNQ_ALIAS](APEX_ACCESSIBILITY_212/tests/IG_COL_UNQ_ALIAS.json) |  Interactive Grid Columns aliases are unique | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_UNQ_HEADNG](APEX_ACCESSIBILITY_212/tests/IG_COL_UNQ_HEADNG.json) |  Interactive Grid Columns headings are unique | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_COL_VLD](APEX_ACCESSIBILITY_212/tests/IG_COL_VLD.json) |  Interactive Grid Columns are not null | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IG_TABINDX](APEX_ACCESSIBILITY_212/tests/IG_TABINDX.json) |  Interactive Grids should avoid hardcorded tab indexes | v1 | APEX_APPL_PAGE_IGS |
| [IR_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/IR_COL_BAD_HTML.json) |  IR Cols have wellformed HTML | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/IR_COL_IMG_ALT_TEXT.json) |  IR Columns with images have alt text | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_LINK](APEX_ACCESSIBILITY_212/tests/IR_COL_LINK.json) |  IR Column links should have aria and title | v1.1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/IR_COL_TABINDX.json) |  IR Columns should avoid harded tab indexes | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_UNQ](APEX_ACCESSIBILITY_212/tests/IR_COL_UNQ.json) |  IR column aliases should be unique | v1.1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_UNQ_LBL](APEX_ACCESSIBILITY_212/tests/IR_COL_UNQ_LBL.json) |  IR columns need unique labels | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_COL_VLD_HEADNG](APEX_ACCESSIBILITY_212/tests/IR_COL_VLD_HEADNG.json) |  IR columns are not null | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [IR_DETL_LINK](APEX_ACCESSIBILITY_212/tests/IR_DETL_LINK.json) |  IR detail link must contain aria and title | v1.1 | APEX_APPLICATION_PAGE_IR |
| [IR_TABINDX](APEX_ACCESSIBILITY_212/tests/IR_TABINDX.json) |  IR reports should avoid hard coded indexes | v1 | APEX_APPLICATION_PAGE_IR |
| [LE_TABINDX](APEX_ACCESSIBILITY_212/tests/LE_TABINDX.json) |  List entries should avoid hardcoding tab indexes | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [PAGE_HELP_BAD_HTML](APEX_ACCESSIBILITY_212/tests/PAGE_HELP_BAD_HTML.json) |  Page Help HTML is well formed | v1 | APEX_APPLICATION_PAGES |
| [PAGE_INACC_CSS](APEX_ACCESSIBILITY_212/tests/PAGE_INACC_CSS.json) |  Pages should avoid inline CSS for blinking or animation logic | v1 | APEX_APPLICATION_PAGES |
| [PAGE_JS_INTRVL_TIMT](APEX_ACCESSIBILITY_212/tests/PAGE_JS_INTRVL_TIMT.json) |  Page JS should avoid intervals and timeouts | v1 | APEX_APPLICATION_PAGES |
| [PAGE_TABINDX](APEX_ACCESSIBILITY_212/tests/PAGE_TABINDX.json) |  Pages should avoid hardcoding tab indexes | v1 | APEX_APPLICATION_PAGES |
| [PG_NAME_TITLE](APEX_ACCESSIBILITY_212/tests/PG_NAME_TITLE.json) |  Pages have name, title and not a blank space | v1 | APEX_APPLICATION_PAGES |
| [PG_NAME_UNQ](APEX_ACCESSIBILITY_212/tests/PG_NAME_UNQ.json) |  Page names should be unique | v1 | APEX_APPLICATION_PAGES |
| [PG_RGN_COL_TABINDX](APEX_ACCESSIBILITY_212/tests/PG_RGN_COL_TABINDX.json) |  Page region columns should avoid tab indexes | v1 | APEX_APPLICATION_PAGE_REG_COLS |
| [PG_RGN_TABINDX](APEX_ACCESSIBILITY_212/tests/PG_RGN_TABINDX.json) |  Page regions should avoid hardcoded tab indexes | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [PG_RPT_COL_INDX](APEX_ACCESSIBILITY_212/tests/PG_RPT_COL_INDX.json) |  Page report columns should avoid tab indexes | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [PI_HLP_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/PI_HLP_COL_BAD_HTML.json) |  Item Help HTML is well formed | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PI_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/PI_IMG_ALT_TEXT.json) |  Page items with html images have alt text | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PI_LBL_UNQ](APEX_ACCESSIBILITY_212/tests/PI_LBL_UNQ.json) |  Page item labels must be unique | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PI_TABINDX](APEX_ACCESSIBILITY_212/tests/PI_TABINDX.json) |  Page items should avoid hardcoded indexes | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PI_VLD_LBL](APEX_ACCESSIBILITY_212/tests/PI_VLD_LBL.json) |  Page Items have valid label and no blank spaces | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PRNT_TAB_INDX](APEX_ACCESSIBILITY_212/tests/PRNT_TAB_INDX.json) |  Parent tab should avoid hard coded tab indexes | v1 | APEX_APPLICATION_PARENT_TABS |
| [RGN_IMG_ALT_TEXT](APEX_ACCESSIBILITY_212/tests/RGN_IMG_ALT_TEXT.json) |  Regions with HTML images should have alt text | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RGN_UNQ](APEX_ACCESSIBILITY_212/tests/RGN_UNQ.json) |  Regions on a page must be unique | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [ROW_HEADER](APEX_ACCESSIBILITY_212/tests/ROW_HEADER.json) |  Region should have Row Header | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [STTC_CNTNT_BAD_HTML](APEX_ACCESSIBILITY_212/tests/STTC_CNTNT_BAD_HTML.json) |  Static Content HTML is well formed | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [THEME_STL_INACC](APEX_ACCESSIBILITY_212/tests/THEME_STL_INACC.json) |  Theme styles should avoid animations | v1 | APEX_APPLICATION_THEME_STYLES |

## Broken Functionality (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These tests identify functionality that invalid.

 - [Standard export](APEX_BROKEN_FUNCTIONALITY_212/STANDARD-APEX_BROKEN_FUNCTIONALITY_212.json)
 - [Consolidated tests export](APEX_BROKEN_FUNCTIONALITY_212/ALL_TESTS-APEX_BROKEN_FUNCTIONALITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [BC_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/BC_AUTHR_MATCH_DEST.json) |  Breadcrumb Authorization Matches Destination | v1 | APEX_APPLICATION_BC_ENTRIES |
| [BUTTON_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/BUTTON_AUTHR_MATCH_DEST.json) |  Button Authorization Matches Destination | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [BUTTON_DEPRECTD_OR_LEGCY](APEX_BROKEN_FUNCTIONALITY_212/tests/BUTTON_DEPRECTD_OR_LEGCY.json) |  Button display positions should not be legacy or deprecated | v1.1 | APEX_APPLICATION_PAGE_BUTTONS |
| [C_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/C_COL_AUTHR_MATCH_DEST.json) |  Classic Column Link Authorization Matches Destination | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [IG_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/IG_COL_AUTHR_MATCH_DEST.json) |  IG Column Link Authorization Matches Destination  | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IR_COL_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/IR_COL_AUTHR_MATCH_DEST.json) |  IR Column Link Authorization Matches Destination  | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [NLE_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/NLE_AUTHR_MATCH_DEST.json) |  Navigation List Entry Authorization Matches Destination | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [PAGES_CURRENT_IN_MENU](APEX_BROKEN_FUNCTIONALITY_212/tests/PAGES_CURRENT_IN_MENU.json) |  Regular Pages should be Current in Navigation | v1 | APEX_APPLICATION_PAGES |
| [PAGE_ERROR](APEX_BROKEN_FUNCTIONALITY_212/tests/PAGE_ERROR.json) |  Pages should not have unresolved critical issues | v1 | APEX_APPLICATION_PAGES |
| [PB_AUTHR_MATCH_DEST](APEX_BROKEN_FUNCTIONALITY_212/tests/PB_AUTHR_MATCH_DEST.json) |  Page Branch Authorization Matches Destination | v1 | APEX_APPLICATION_PAGES |
| [PUBLIC_PAGE_PUBLIC_AUTH](APEX_BROKEN_FUNCTIONALITY_212/tests/PUBLIC_PAGE_PUBLIC_AUTH.json) |  Public pages should not require authentication | v1 | APEX_APPLICATION_PAGES |
| [UNREACHABLE_PAGE](APEX_BROKEN_FUNCTIONALITY_212/tests/UNREACHABLE_PAGE.json) |  Pages should be reachable | v1 | APEX_APPLICATION_PAGES |
| [VAL_BUTTON_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_BUTTON_LINKS.json) |  Button URLs should be valid | v1.2 | APEX_APPLICATION_PAGE_BUTTONS |
| [VAL_COL_AUTH](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_COL_AUTH.json) |  Columns should have a valid authorization scheme | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [VAL_COL_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_COL_LINKS.json) |  Column Link should be valid | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [VAL_LIST_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_LIST_LINKS.json) |  List URLs should be valid | v1 | APEX_APPLICATION_LIST_ENTRIES |

## Cleanup (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Best practices to keep things tidy

 - [Standard export](APEX_CLEANUP_212/STANDARD-APEX_CLEANUP_212.json)
 - [Consolidated tests export](APEX_CLEANUP_212/ALL_TESTS-APEX_CLEANUP_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AVAILABLE](APEX_CLEANUP_212/tests/APP_AVAILABLE.json) |  Applications are available | v1 | APEX_APPLICATIONS |
| [AVAILABLE_REGION](APEX_CLEANUP_212/tests/AVAILABLE_REGION.json) |  Regions should be available | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [BUTTON_AVAILABLE](APEX_CLEANUP_212/tests/BUTTON_AVAILABLE.json) |  Buttons should be available | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [CARD_ACTIONS_AVAILABLE](APEX_CLEANUP_212/tests/CARD_ACTIONS_AVAILABLE.json) |  Card Actions should be available | v1 | APEX_APPL_PAGE_CARD_ACTIONS |
| [CHARTS_AVAILABLE](APEX_CLEANUP_212/tests/CHARTS_AVAILABLE.json) |  Charts should be available | v1 | APEX_APPLICATION_PAGE_CHART_S |
| [MAP_LAYERS_AVAILABLE](APEX_CLEANUP_212/tests/MAP_LAYERS_AVAILABLE.json) |  Map Layers should be available  | v1 | APEX_APPL_PAGE_MAP_LAYERS |
| [PAGE_BRANCH_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_BRANCH_AVAILABLE.json) |  Page branches should be available | v1 | APEX_APPLICATION_PAGE_BRANCHES |
| [PAGE_COMP_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_COMP_AVAILABLE.json) |  Page computations should be available | v1 | APEX_APPLICATION_PAGE_COMP |
| [PAGE_DA_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_DA_AVAILABLE.json) |  Page dynamic actions should be available | v1 | APEX_APPLICATION_PAGE_DA |
| [PAGE_ITEM_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_ITEM_AVAILABLE.json) |  Page Items should be available | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [PAGE_PROC_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_PROC_AVAILABLE.json) |  Page procedures should be available | v1 | APEX_APPLICATION_PAGE_PROC |
| [PAGE_VAL_AVAILABLE](APEX_CLEANUP_212/tests/PAGE_VAL_AVAILABLE.json) |  Page Validations should be available | v1 | APEX_APPLICATION_PAGE_VAL |
| [SEARCH_SOURCES_AVAILABLE](APEX_CLEANUP_212/tests/SEARCH_SOURCES_AVAILABLE.json) |  Search Sources should be available | v1 | APEX_APPL_PAGE_SEARCH_SOURCES |
| [THEME_SUBSCRIPTION](APEX_CLEANUP_212/tests/THEME_SUBSCRIPTION.json) |  Themes should be specific numbers and subscribed | v1 | APEX_APPLICATION_THEME_STYLES |
| [TOO_MANY_REGIONS](APEX_CLEANUP_212/tests/TOO_MANY_REGIONS.json) |  Pages should limit their content | v1 | APEX_APPLICATION_PAGES |
| [VAL_BUILD_LIST_ENTRY](APEX_CLEANUP_212/tests/VAL_BUILD_LIST_ENTRY.json) |  List entries should have valid build options | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [VAL_PAGE_BUILD](APEX_CLEANUP_212/tests/VAL_PAGE_BUILD.json) |  Pages should have valid build options | v1 | APEX_APPLICATION_PAGES |

## Idiosyncratic (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Standards that are *not* general standards

 - [Standard export](APEX_IDIOSYNCRATIC_212/STANDARD-APEX_IDIOSYNCRATIC_212.json)
 - [Consolidated tests export](APEX_IDIOSYNCRATIC_212/ALL_TESTS-APEX_IDIOSYNCRATIC_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_BUILDS](APEX_IDIOSYNCRATIC_212/tests/APP_BUILDS.json) |  Apps should have particular set of builds | v1 | APEX_APPLICATIONS |
| [APP_ITEM_NAMING](APEX_IDIOSYNCRATIC_212/tests/APP_ITEM_NAMING.json) |  Application Item incorrectly prefixed | v1 | APEX_APPLICATION_ITEMS |
| [AST_BREADCRUMB_STYLING](APEX_IDIOSYNCRATIC_212/tests/AST_BREADCRUMB_STYLING.json) |  AST Breadcrumbs are correctly styled | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [AST_BUTTONS_HAVE_ICONS](APEX_IDIOSYNCRATIC_212/tests/AST_BUTTONS_HAVE_ICONS.json) |  All AST Standard Buttons have left-sided icons | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_BUTTON_SIMPLE](APEX_IDIOSYNCRATIC_212/tests/AST_BUTTON_SIMPLE.json) |  AST buttons should be simple | v1.2 | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_CANCEL_BUTTON](APEX_IDIOSYNCRATIC_212/tests/AST_CANCEL_BUTTON.json) |  All Cancel buttons should be default | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_DELETE_BUTTON](APEX_IDIOSYNCRATIC_212/tests/AST_DELETE_BUTTON.json) |  Delete buttons should be correctly styled | v1.1 | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_MERGE_SAMPLE_DATA](APEX_IDIOSYNCRATIC_212/tests/AST_MERGE_SAMPLE_DATA.json) |  "Merge sample data" are consistently styled | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [AST_PAGE_AUTH](APEX_IDIOSYNCRATIC_212/tests/AST_PAGE_AUTH.json) |  SVT Application Pages should have Authorization Schemes | v1 | APEX_APPLICATION_PAGES |
| [BC_MATCHES_NAV_LIST](APEX_IDIOSYNCRATIC_212/tests/BC_MATCHES_NAV_LIST.json) |  Breadcrumb hierarchy should match nav menu | v1.1 | APEX_APPLICATION_BC_ENTRIES |
| [CREATE_BUTTON_STYLE](APEX_IDIOSYNCRATIC_212/tests/CREATE_BUTTON_STYLE.json) |  Create buttons should be styled in a consistent way | v1.2 | APEX_APPLICATION_PAGE_BUTTONS |
| [DRAWERS_NOT_MODALS](APEX_IDIOSYNCRATIC_212/tests/DRAWERS_NOT_MODALS.json) |  User Drawers instead of Modals | v1 | APEX_APPLICATION_PAGES |
| [FRIENDLY_PAGE_NAMES](APEX_IDIOSYNCRATIC_212/tests/FRIENDLY_PAGE_NAMES.json) |  Page names should be human friendly | v1 | APEX_APPLICATION_PAGES |
| [LIST_MENU_ENTRY_DESC](APEX_IDIOSYNCRATIC_212/tests/LIST_MENU_ENTRY_DESC.json) |  List Menu Entries have Descriptions | v1.1 | APEX_APPLICATION_LIST_ENTRIES |
| [NAVIGATION_MENU_ICONS](APEX_IDIOSYNCRATIC_212/tests/NAVIGATION_MENU_ICONS.json) |  Navigation menu list entries should have icons | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [PAGE_ACCESS_PROTECTION](APEX_IDIOSYNCRATIC_212/tests/PAGE_ACCESS_PROTECTION.json) |  Form pages require authentication and have access protection | v1 | APEX_APPLICATION_PAGES |
| [RDS_TABS_CONTAINER](APEX_IDIOSYNCRATIC_212/tests/RDS_TABS_CONTAINER.json) |  RDS regions should have a template of Tabs Container | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RESET_BUTTON_STYLE](APEX_IDIOSYNCRATIC_212/tests/RESET_BUTTON_STYLE.json) |  Reset buttons should be styled in a consistent way | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [SVT_BUTTON_CAPS](APEX_IDIOSYNCRATIC_212/tests/SVT_BUTTON_CAPS.json) |  Button names and labels should be correctly capitalized | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [SVT_SAVE_BUTTONS](APEX_IDIOSYNCRATIC_212/tests/SVT_SAVE_BUTTONS.json) |  Update buttons must be labelled "Save" | v1 | APEX_APPLICATION_PAGE_BUTTONS |

## Object (Database Version 19C)
These tests run against the DB objects and therefore may be hard to associate with a given application. They can be associated with the Application Standards Tracker app.

 - [Standard export](DB_OBJECT_19C/STANDARD-DB_OBJECT_19C.json)
 - [Consolidated tests export](DB_OBJECT_19C/ALL_TESTS-DB_OBJECT_19C.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [DBMS_ASSERT](DB_OBJECT_19C/tests/DBMS_ASSERT.json) |  Missing DBMS_ASSERT | v1.4 | DATABASE SUPPORTING OBJECT |
| [DISCOURAGED_CODE](DB_OBJECT_19C/tests/DISCOURAGED_CODE.json) |  Discouraged code | v1.3 | DATABASE SUPPORTING OBJECT |
| [DUPLICATE_STATEMENTS](DB_OBJECT_19C/tests/DUPLICATE_STATEMENTS.json) |  Duplicate Statements | v1.3 | DATABASE SUPPORTING OBJECT |
| [FK_INDEXED](DB_OBJECT_19C/tests/FK_INDEXED.json) |  Foreign keys must be indexed | v1.1 | DATABASE TABLE |
| [IDENTIFIER_NAMING](DB_OBJECT_19C/tests/IDENTIFIER_NAMING.json) |  Naming Convention violation | v1.3 | DATABASE SUPPORTING OBJECT |
| [MISSING_COMMENT](DB_OBJECT_19C/tests/MISSING_COMMENT.json) |  Missing Comments | v1.1 | DATABASE SUPPORTING OBJECT |
| [UNUSED_IDENTIFIERS](DB_OBJECT_19C/tests/UNUSED_IDENTIFIERS.json) |  Unused identifers | v1.1 | DATABASE SUPPORTING OBJECT |
| [URGENT_PLSQL_WARNINGS](DB_OBJECT_19C/tests/URGENT_PLSQL_WARNINGS.json) |  Urgent PLSQL Warning | v1.1 | DATABASE SUPPORTING OBJECT |
| [VALID_OBJECTS](DB_OBJECT_19C/tests/VALID_OBJECTS.json) |  Invalid Object | v1.2 | DATABASE SUPPORTING OBJECT |
| [VALID_VIEW](DB_OBJECT_19C/tests/VALID_VIEW.json) |  Fix Invalid View | v1 | DATABASE VIEW |

## Redwood (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Standards for correctly implementing Redwood patterns

 - [Standard export](APEX_REDWOOD_212/STANDARD-APEX_REDWOOD_212.json)
 - [Consolidated tests export](APEX_REDWOOD_212/ALL_TESTS-APEX_REDWOOD_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [RW_ADDL_INFO](APEX_REDWOOD_212/tests/RW_ADDL_INFO.json) |  Additional Info regions are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_BNNR_MSG_LNKS](APEX_REDWOOD_212/tests/RW_BNNR_MSG_LNKS.json) |  Banner Message region should only have Links | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_BUTTON_PLACEMENT](APEX_REDWOOD_212/tests/RW_BUTTON_PLACEMENT.json) |  Redwood Buttons should be correctly placed | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [RW_CTXT_INFO](APEX_REDWOOD_212/tests/RW_CTXT_INFO.json) |  Contextual Info regions should be configured correctly | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_FOLDOUTPANEL](APEX_REDWOOD_212/tests/RW_FOLDOUTPANEL.json) |  Use Foldout panels in the Panels positions | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_IO_CONTENT](APEX_REDWOOD_212/tests/RW_IO_CONTENT.json) |  Item Overview Content is correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_ITEM_OVVW_ICN](APEX_REDWOOD_212/tests/RW_ITEM_OVVW_ICN.json) |  Item Overview Regions should have an Icon or Initials | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_ITM_OVRVW_POS](APEX_REDWOOD_212/tests/RW_ITM_OVRVW_POS.json) |  Region in "Item Overview" position is correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_LIST_ENTRIES_ICONS](APEX_REDWOOD_212/tests/RW_LIST_ENTRIES_ICONS.json) |  List Entries should use the correct icons | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [RW_LOGIN](APEX_REDWOOD_212/tests/RW_LOGIN.json) |  Login regions are configured correctly | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_PAGE_HEADER](APEX_REDWOOD_212/tests/RW_PAGE_HEADER.json) |  Regions in the "Page Header" position are correctly config | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_PAGE_ITEM_STYLING](APEX_REDWOOD_212/tests/RW_PAGE_ITEM_STYLING.json) |  Redwood Page Items should use Redwood Icons | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [RW_PG_NAV_POS](APEX_REDWOOD_212/tests/RW_PG_NAV_POS.json) |  Region in "Page Navigation" is correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_RGN_BREADCRUMB](APEX_REDWOOD_212/tests/RW_RGN_BREADCRUMB.json) |  Breadcrumbs have a template and position of "Page Header" | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_SCRBRD_POS](APEX_REDWOOD_212/tests/RW_SCRBRD_POS.json) |  Region in "Scoreboard" position is correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_SMT_FILTR](APEX_REDWOOD_212/tests/RW_SMT_FILTR.json) |  Smart filter regions are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TMSTMP_ACTIONS_POS](APEX_REDWOOD_212/tests/RW_TMSTMP_ACTIONS_POS.json) |  Regions in "Timestamp & Actions" are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOAST_ICON](APEX_REDWOOD_212/tests/RW_TOAST_ICON.json) |  Toast regions with the custom icon setting should have an icon | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOAST_LNKS](APEX_REDWOOD_212/tests/RW_TOAST_LNKS.json) |  Toast regions should only have links | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_TOC_POS](APEX_REDWOOD_212/tests/RW_TOC_POS.json) |  Regions in "Table of Contents" are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_VISUALZTNS](APEX_REDWOOD_212/tests/RW_VISUALZTNS.json) |  Visualization regions are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [RW_WLCM_BNNR_TMPL](APEX_REDWOOD_212/tests/RW_WLCM_BNNR_TMPL.json) |  Banner regions are correctly configured | v1 | APEX_APPLICATION_PAGE_REGIONS |

## Security (APEX Version 19.1)
These standards enforce security

 - [Standard export](APEX_SECURITY_191/STANDARD-APEX_SECURITY_191.json)
 - [Consolidated tests export](APEX_SECURITY_191/ALL_TESTS-APEX_SECURITY_191.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_191/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_191/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |

## Security (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These standards enforce security

 - [Standard export](APEX_SECURITY_212/STANDARD-APEX_SECURITY_212.json)
 - [Consolidated tests export](APEX_SECURITY_212/ALL_TESTS-APEX_SECURITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_212/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_212/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IR_HTML_ESCAPING_COLS](APEX_SECURITY_212/tests/IR_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IR Columns | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [PAGE_AUTH](APEX_SECURITY_212/tests/PAGE_AUTH.json) |  Application Pages should have Authorization Schemes | v1 | APEX_APPLICATION_PAGES |

## Security (APEX Version 23.2 +)
These standards enforce security

 - [Standard export](APEX_SECURITY_232/STANDARD-APEX_SECURITY_232.json)
 - [Consolidated tests export](APEX_SECURITY_232/ALL_TESTS-APEX_SECURITY_232.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_232/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_232/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [IR_HTML_ESCAPING_COLS](APEX_SECURITY_232/tests/IR_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IR Columns | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [PAGE_AUTH](APEX_SECURITY_232/tests/PAGE_AUTH.json) |  Application Pages should have Authorization Schemes | v1 | APEX_APPLICATION_PAGES |

## Universal Theme (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are best practices that apply to Universal Theme applications.

 - [Standard export](APEX_UNIVERSAL_THEME_212/STANDARD-APEX_UNIVERSAL_THEME_212.json)
 - [Consolidated tests export](APEX_UNIVERSAL_THEME_212/ALL_TESTS-APEX_UNIVERSAL_THEME_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_CSS_FILE](APEX_UNIVERSAL_THEME_212/tests/APP_CSS_FILE.json) |  Apps should have a centralized css file | v1 | APEX_APPLICATIONS |
| [BUTTON_DEFAULT_SIZE](APEX_UNIVERSAL_THEME_212/tests/BUTTON_DEFAULT_SIZE.json) |  Button size should be default | v1.1 | APEX_APPLICATION_PAGE_BUTTONS |
| [BUTTON_STYLING](APEX_UNIVERSAL_THEME_212/tests/BUTTON_STYLING.json) |  Buttons should be styled correctly | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [CLASSIC_REPORT_STYLE](APEX_UNIVERSAL_THEME_212/tests/CLASSIC_REPORT_STYLE.json) |  Classic Report should be correctly styled | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [COL_ALIGNMENT_CLASSIC](APEX_UNIVERSAL_THEME_212/tests/COL_ALIGNMENT_CLASSIC.json) |  Classic Columns are correctly aligned | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [COL_ALIGNMENT_IG](APEX_UNIVERSAL_THEME_212/tests/COL_ALIGNMENT_IG.json) |  IG Columns are correctly aligned | v1 | APEX_APPL_PAGE_IG_COLUMNS |
| [COL_ALIGNMENT_IR](APEX_UNIVERSAL_THEME_212/tests/COL_ALIGNMENT_IR.json) |  IR Columns are correctly aligned | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [COL_HEADERS_C](APEX_UNIVERSAL_THEME_212/tests/COL_HEADERS_C.json) |  Classic Column header is appropriate | v1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [COL_HEADERS_IR](APEX_UNIVERSAL_THEME_212/tests/COL_HEADERS_IR.json) |  IR Column header is appropriate | v1 | APEX_APPLICATION_PAGE_IR_COL |
| [COL_HEADER_RF_TG](APEX_UNIVERSAL_THEME_212/tests/COL_HEADER_RF_TG.json) |  Reflow / Toggle Column header is appropriate | v1 | APEX_APPLICATION_PAGE_REG_COLS |
| [FIELD_NAMES](APEX_UNIVERSAL_THEME_212/tests/FIELD_NAMES.json) |  Form field label is appropriate | v1.1 | APEX_APPLICATION_PAGE_ITEMS |
| [FILTER_RGN_TMPLT](APEX_UNIVERSAL_THEME_212/tests/FILTER_RGN_TMPLT.json) |  Filtered Regions has Card Container template | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [FORM_ITEM_HELP](APEX_UNIVERSAL_THEME_212/tests/FORM_ITEM_HELP.json) |  Form Elements should have help text | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [MODAL_FLOATING_LABEL](APEX_UNIVERSAL_THEME_212/tests/MODAL_FLOATING_LABEL.json) |  Use Floating Labels | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [NO_CSS_IN_PAGE](APEX_UNIVERSAL_THEME_212/tests/NO_CSS_IN_PAGE.json) |  Pages should not have local CSS | v1 | APEX_APPLICATION_PAGES |
| [PAGES_HAVE_PADDING](APEX_UNIVERSAL_THEME_212/tests/PAGES_HAVE_PADDING.json) |  Pages should not remove padding | v1 | APEX_APPLICATION_PAGES |
| [PAGE_ITEM_NAMING](APEX_UNIVERSAL_THEME_212/tests/PAGE_ITEM_NAMING.json) |  Page Items incorrectly prefixed | v1 | APEX_APPLICATION_PAGE_ITEMS |
| [RESET_BUTTON_REPORT](APEX_UNIVERSAL_THEME_212/tests/RESET_BUTTON_REPORT.json) |  Reports should have a reset button | v1 | APEX_APPLICATION_PAGE_REGIONS |
| [TOO_MANY_DAS](APEX_UNIVERSAL_THEME_212/tests/TOO_MANY_DAS.json) |  Pages should limit the amount of Dynamic Actions | v1 | APEX_APPLICATION_PAGES |


* This consolidated tests export does not include inherited relationships. You will need to install the individual standards / tests for that purpose.    
