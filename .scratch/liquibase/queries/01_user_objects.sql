select apex_string.format('drop %0 %1;', object_type, object_name) stmt
from user_objects
where 1=1
--and object_type in ('PACKAGE', 'PACKAGE BODY', 'TABLE', 'VIEW', 'TRIGGER')
and object_name not like '%DATABASECHANGELOG%'
and object_name not like '%$%'
order by 1
/