--------------------------------------------------------
--  DDL for Materialized View CHANGEME
--------------------------------------------------------

create materialized view CHANGEME
refresh complete
start   with sysdate
next  (trunc(sysdate) + 1 + 2/24)
as
select 1
from dual
;