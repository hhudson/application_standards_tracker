--liquibase formatted sql
--changeset view_script:V_USER_MVIEWS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_MVIEWS
--------------------------------------------------------

create or replace force editionable view v_user_mviews as
select owner, mview_name
from all_mviews
where owner = svt_ctx_util.get_default_user
/

--rollback drop view V_USER_MVIEWS;