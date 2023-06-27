select st.id,
    st.display_sequence,
    st.name,
    st.quer_view,
    st.app_bind_variable,
    st.failure_help_text,
    st.test_type,
    (   select avg(test_duration) d
        from eba_stds_standard_statuses sss
        where sss.standard_id = st.standard_id
            and sss.test_id = st.id ) avg_duration,
    st.standard_id
from eba_stds_standard_tests st
order by st.display_sequence nulls last
;
/
select * 
from eba_stds_users;
/
insert into eba_stds_users(username, access_level_id) values ('HAYHUDSO', 3);
/
select * 
from EBA_STDS_ACCESS_LEVELS
/
select * 
from eba_stds_preferences
/
select * 
from eba_stds_error_lookup