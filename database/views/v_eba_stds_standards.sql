--liquibase formatted sql
--changeset view_script:v_eba_stds_standards stripComments:false endDelimiter:/ runOnChange:true

create or replace force view v_eba_stds_standards as
select std.id,
    std.standard_name standard,
    std.active_yn,
    count( distinct t.id ) tests
from eba_stds_standards std
left join eba_stds_standard_tests t on t.standard_id = std.id
group by std.id, std.standard_name, std.active_yn
order by 4 asc, upper(std.standard_name) 
/

--rollback drop view v_eba_stds_standards;