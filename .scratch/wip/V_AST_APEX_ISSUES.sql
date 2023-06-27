--------------------------------------------------------
--  DDL for View v_ast_apex_issues
--------------------------------------------------------

create or replace force editionable view v_ast_apex_issues as
swith agg_stakeholders as (
    select issue_id,
           listagg(case when seqnum <=5 then apex_200100.wwv_flow_issue_int.get_user_name(stakeholder) end, ', ') 
            within group(order by apex_200100.wwv_flow_issue_int.get_user_name(stakeholder) ) assignees, 
           listagg(case when seqnum <=5 then apex_200100.wwv_flow_issue_int.get_avatar(stakeholder, p_image_size => 24, p_include_link => 'Y') end, ' ') 
            within group(order by stakeholder ) assignees_html, 
           count(*) assignee_count
      from (select ss.*, 
                   row_number() over (partition by ISSUE_ID order by stakeholder ) as seqnum 
              from apex_200100.wwv_flow_issue_stakeholders ss
             where ss.stakeholder_type = 'ASSIGNEE'
               and ss.security_group_id = 1626702108601364)
     group by issue_id
), agg_subscribers as (
    select issue_id,
           listagg(apex_200100.wwv_flow_issue_int.get_user_name(stakeholder), ':') 
            within group(order by apex_200100.wwv_flow_issue_int.get_user_name(stakeholder) ) subcribers,
           listagg(apex_200100.wwv_flow_issue_int.get_avatar(stakeholder, p_image_size => 24, p_include_link => 'Y'), ' ') 
            within group( order by stakeholder ) subscribers_html, 
           count(*) subscriber_count
      from apex_200100.wwv_flow_issue_stakeholders
     where stakeholder_type = 'SUBSCRIBER'
       and security_group_id = 1626702108601364
     group by issue_id
), 
agg_labels as (
    select issue_id,
           listagg(apex_200100.wwv_flow_escape.html(label_name), ', ') within group(
                order by label_name
           ) labels, 
           listagg('<span class="a-IssueLabel '||g.group_color||'" > '||apex_200100.wwv_flow_escape.html(label_name)||'</span>', '') within group(
                order by g.group_name, l.label_name
           ) labels_html
      from apex_200100.wwv_flow_issue_labels il,
           apex_200100.wwv_flow_labels l, 
           apex_200100.wwv_flow_label_groups g
     where il.label_id = l.id
       and l.label_group_id = g.id
       and il.security_group_id = 1626702108601364
       and l.security_group_id = 1626702108601364
       and g.security_group_id = 1626702108601364
     group by issue_id
), 
agg_milestones as (
  select issue_id,
           listagg(apex_200100.wwv_flow_escape.html(milestone_name), ':') within group(
                order by milestone_name
           ) milestones,
           listagg('<a class="a-IssueMilestone" href="'||apex_util.prepare_url('f?p='||700||':205:'||123||'::::P205_ID:'||m.id )||'"><span class="fa fa-map-signs" aria-hidden="true"></span>'||apex_200100.wwv_flow_escape.html(milestone_name)||'</a> ', ' ') within group(
                order by milestone_name
           ) milestones_html
      from apex_200100.wwv_flow_issue_milestones im,
           apex_200100.wwv_flow_milestones m
     where im.milestone_id = m.id
       and im.security_group_id = 1626702108601364
       and m.security_group_id = 1626702108601364
     group by issue_id
)
select *
  from apex_200100.wwv_flow_issues               i,
       apex_200100.wwv_flow_current_workspaces   w,
       agg_stakeholders              h,
       agg_subscribers               ss,
       agg_labels                    l,
       apex_200100.wwv_flow_issues               i2,
       agg_milestones                  m
 where i.deleted = 'N' 
   and i.security_group_id = w.workspace_id
   and i.security_group_id = 1626702108601364
   and w.workspace_id = 1626702108601364
   and h.issue_id (+) = i.id
   and ss.issue_id (+) = i.id
   and l.issue_id (+) = i.id
   and m.issue_id (+) = i.id
   and i.duplicate_of = i2.id (+)
/