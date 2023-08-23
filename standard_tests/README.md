# Published standards & tests
- [Export of all standards](ALL_STANDARDS.json)- [Export of all tests](ALL_TESTS.json)*

## Accessibility (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are standards to maintain Accessibility.

 - [Standard export](APEX_ACCESSIBILITY_212/STANDARD-APEX_ACCESSIBILITY_212.json)
 - [Consolidated tests export](APEX_ACCESSIBILITY_212/ALL_TESTS-APEX_ACCESSIBILITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [C_COL_BAD_HTML](APEX_ACCESSIBILITY_212/tests/C_COL_BAD_HTML.json) |  Classic Columns have wellformed HTML | v1.2 | APEX_APPLICATION_PAGE_RPT_COLS |
| [PG_NAME_TITLE](APEX_ACCESSIBILITY_212/tests/PG_NAME_TITLE.json) |  Pages have name, title and not a blank space | v1 | APEX_APPLICATION_PAGES |

## Broken Functionality (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These tests identify functionality that invalid.

 - [Standard export](APEX_BROKEN_FUNCTIONALITY_212/STANDARD-APEX_BROKEN_FUNCTIONALITY_212.json)
 - [Consolidated tests export](APEX_BROKEN_FUNCTIONALITY_212/ALL_TESTS-APEX_BROKEN_FUNCTIONALITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [VAL_BUTTON_LINKS](APEX_BROKEN_FUNCTIONALITY_212/tests/VAL_BUTTON_LINKS.json) |  Button URLs should be valid | v1.2 | APEX_APPLICATION_PAGE_BUTTONS |

## Cleanup (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Best practices to keep things tidy

 - [Standard export](APEX_CLEANUP_212/STANDARD-APEX_CLEANUP_212.json)
 - [Consolidated tests export](APEX_CLEANUP_212/ALL_TESTS-APEX_CLEANUP_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [VAL_BUILD_LIST_ENTRY](APEX_CLEANUP_212/tests/VAL_BUILD_LIST_ENTRY.json) |  List entries should have valid build options | v1 | APEX_APPLICATION_LIST_ENTRIES |

## Idiosyncratic (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Standards that are *not* general standards

 - [Standard export](APEX_IDIOSYNCRATIC_212/STANDARD-APEX_IDIOSYNCRATIC_212.json)
 - [Consolidated tests export](APEX_IDIOSYNCRATIC_212/ALL_TESTS-APEX_IDIOSYNCRATIC_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [AST_PAGE_AUTH](APEX_IDIOSYNCRATIC_212/tests/AST_PAGE_AUTH.json) |  SVT Application Pages should have Authorization Schemes | v1 | APEX_APPLICATION_PAGES |

## Redwood (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
Standards for correctly implementing Redwood patterns

 - [Standard export](APEX_REDWOOD_212/STANDARD-APEX_REDWOOD_212.json)
 - [Consolidated tests export](APEX_REDWOOD_212/ALL_TESTS-APEX_REDWOOD_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [RW_BUTTON_PLACEMENT](APEX_REDWOOD_212/tests/RW_BUTTON_PLACEMENT.json) |  Redwood Buttons should be correctly placed | v1 | APEX_APPLICATION_PAGE_BUTTONS |
| [RW_LIST_ENTRIES_ICONS](APEX_REDWOOD_212/tests/RW_LIST_ENTRIES_ICONS.json) |  List Entries should use the correct icons | v1 | APEX_APPLICATION_LIST_ENTRIES |
| [RW_PAGE_ITEM_STYLING](APEX_REDWOOD_212/tests/RW_PAGE_ITEM_STYLING.json) |  Redwood Page Items should use Redwood Icons | v1 | APEX_APPLICATION_PAGE_ITEMS |

## Security (APEX Version 19.1)
These standards enforce security

 - [Standard export](APEX_SECURITY_191/STANDARD-APEX_SECURITY_191.json)
 - [Consolidated tests export](APEX_SECURITY_191/ALL_TESTS-APEX_SECURITY_191.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_191/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [BLERG](APEX_SECURITY_191/tests/BLERG.json) |  blerg | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_191/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |

## Security (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These standards enforce security

 - [Standard export](APEX_SECURITY_212/STANDARD-APEX_SECURITY_212.json)
 - [Consolidated tests export](APEX_SECURITY_212/ALL_TESTS-APEX_SECURITY_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_212/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [BLERG](APEX_SECURITY_212/tests/BLERG.json) |  blerg | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_212/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |

## Security (APEX Version 23.2 +)
These standards enforce security

 - [Standard export](APEX_SECURITY_232/STANDARD-APEX_SECURITY_232.json)
 - [Consolidated tests export](APEX_SECURITY_232/ALL_TESTS-APEX_SECURITY_232.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [APP_AUTH](APEX_SECURITY_232/tests/APP_AUTH.json) |  Application has Authorization Scheme | v1 | APEX_APPLICATIONS |
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY_232/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | v1 | APEX_APPL_PAGE_IG_COLUMNS |

## Universal Theme (APEX Version 21.2 / 22.1 / 22.2 / 23.1)
These are best practices that apply to Universal Theme applications.

 - [Standard export](APEX_UNIVERSAL_THEME_212/STANDARD-APEX_UNIVERSAL_THEME_212.json)
 - [Consolidated tests export](APEX_UNIVERSAL_THEME_212/ALL_TESTS-APEX_UNIVERSAL_THEME_212.json)

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [BUTTON_DEFAULT_SIZE](APEX_UNIVERSAL_THEME_212/tests/BUTTON_DEFAULT_SIZE.json) |  Button size should be default | v1 | APEX_APPLICATION_PAGE_BUTTONS |


* This consolidated tests export does not include inherited relationships. You will need to install the individual standards / tests for that purpose.    
