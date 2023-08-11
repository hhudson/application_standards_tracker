# Published tests

## [APEX Accessibility](APEX_ACCESSIBILITY/STANDARD-APEX_ACCESSIBILITY.json)
These are standards to maintain Accessibility.

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [C_COL_BAD_HTML](APEX_ACCESSIBILITY/tests/C_COL_BAD_HTML.json) |  Classic Columns have wellformed HTML | V1 | APEX_APPLICATION_PAGE_RPT_COLS |
| [PG_NAME_TITLE](APEX_ACCESSIBILITY/tests/PG_NAME_TITLE.json) |  Pages have name, title and not a blank space | V1 | APEX_APPLICATION_PAGES |

## [APEX Broken Functionality](APEX_BROKEN_FUNCTIONALITY/STANDARD-APEX_BROKEN_FUNCTIONALITY.json)
These tests identify functionality that invalid.

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [VAL_BUTTON_LINKS](APEX_BROKEN_FUNCTIONALITY/tests/VAL_BUTTON_LINKS.json) |  Invalid Button URL | V1.1 | APEX_APPLICATION_PAGE_BUTTONS |

## [APEX Cleanup](APEX_CLEANUP/STANDARD-APEX_CLEANUP.json)
Best practices to keep things tidy

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [VAL_BUILD_LIST_ENTRY](APEX_CLEANUP/tests/VAL_BUILD_LIST_ENTRY.json) |  List entries should have valid build options | V1 | APEX_APPLICATION_LIST_ENTRIES |

## [APEX General](APEX_GENERAL/STANDARD-APEX_GENERAL.json)
These are best practices that probably apply to any given APEX application.

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [BUTTON_DEPRECTD_OR_LEGCY](APEX_GENERAL/tests/BUTTON_DEPRECTD_OR_LEGCY.json) |  Button display positions should not be legacy or deprecated | V1 | APEX_APPLICATION_PAGE_BUTTONS |

## [APEX Idiosyncratic](APEX_IDIOSYNCRATIC/STANDARD-APEX_IDIOSYNCRATIC.json)
Standards that are *not* general standards

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [AST_PAGE_AUTH](APEX_IDIOSYNCRATIC/tests/AST_PAGE_AUTH.json) |  SVT Application Pages should have Authorization Schemes | V1 | APEX_APPLICATION_PAGES |

## [APEX Redwood](APEX_REDWOOD/STANDARD-APEX_REDWOOD.json)
Standards for correctly implementing Redwood patterns

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [RW_BUTTON_PLACEMENT](APEX_REDWOOD/tests/RW_BUTTON_PLACEMENT.json) |  Redwood Buttons should be correctly placed | V1 | APEX_APPLICATION_PAGE_BUTTONS |
| [RW_LIST_ENTRIES_ICONS](APEX_REDWOOD/tests/RW_LIST_ENTRIES_ICONS.json) |  List Entries should use the correct icons | V1 | APEX_APPLICATION_LIST_ENTRIES |
| [RW_PAGE_ITEM_STYLING](APEX_REDWOOD/tests/RW_PAGE_ITEM_STYLING.json) |  Redwood Page Items should use Redwood Icons | V1 | APEX_APPLICATION_PAGE_ITEMS |

## [APEX Security](APEX_SECURITY/STANDARD-APEX_SECURITY.json)
These standards enforce security

| Test Code | Test Name | Version | Component Type |
|-----------|-----------|---------|----------------|
| [IG_HTML_ESCAPING_COLS](APEX_SECURITY/tests/IG_HTML_ESCAPING_COLS.json) |  HTML should be escaped in IG Columns | V1 | APEX_APPL_PAGE_IG_COLUMNS |

    
