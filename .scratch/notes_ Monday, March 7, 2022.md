## Theme Style tested for accessibility
Is your app using a Theme Style that has been tested for accessibility? Theme Styles that have not been accessibility tested may contain more issues, such as insufficient color contrast.

## Page has page title
Does the page have a title? Meaningful page titles are important for accessibility, to help users understand the content and purpose of the current page. Note: Global pages, and pages with no regions are excluded from this check.


## Region has Row Header
Regions that support row headers should have a column with the "Use as Row Header" attribute set to Yes.

## Chart type supports accessibility
Are you using any older Chart Types that have limited accessibility support? These should instead be switched to using our new charts based on Oracle JET.

## Page item has label
Does the item have a label defined? For example just defining the 'Value Placeholder' text is not sufficient in labelling an item for accessibility.

## Page item does not cause an unexpected context change
Some page item settings can cause an unexpected change of context for the user, such as select lists that submit the page after a value is selected. Unless the user has prior warning that this will happen, this represents an accessibility issue.

## Display Image item has image ALT text defined
Display Image page items must provide text, or a column (depending on the Based On setting), that will be used as the image's alternative text. This is important for accessibility, as without it some user's may have no way of perceiving the content of the image.

```
wwv_flow_advisor_dev.check_application (
        p_application_id => :FB_FLOW_ID,
        p_page_id_list   => l_page_id_list,
        p_check_list     => wwv_flow_utilities.string_to_table(:P8101_ALL_CHECKS) );
```
```
-- verify result
select count(*)
    into l_count
    from wwv_flow_advisor_result_dev;
```

# Actions
 - investigate accessibility
 - zero out current status
 