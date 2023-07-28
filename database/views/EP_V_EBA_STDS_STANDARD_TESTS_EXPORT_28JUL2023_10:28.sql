SQL_ID  9wtg3fc1axj5n, child number 0
 
select /*+ gather_plan_statistics */ * from 
V_EBA_STDS_STANDARD_TESTS_EXPORT fetch first 10000 rows only
 
Plan hash value: 3838620486
 
-------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name                      | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
-------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |                           |      1 |        |    165 |00:00:04.15 |     814K|    212 |
|*  1 |  VIEW                                |                           |      1 |  10000 |    165 |00:00:04.15 |     814K|    212 |
|*  2 |   WINDOW NOSORT STOPKEY              |                           |      1 |   8168 |    165 |00:00:04.14 |     814K|    212 |
|*  3 |    HASH JOIN RIGHT OUTER             |                           |      1 |   8168 |    165 |00:00:04.25 |     814K|    212 |
|   4 |     TABLE ACCESS FULL                | EBA_STDS_TESTS_LIB        |      1 |      1 |      1 |00:00:00.01 |      38 |      0 |
|   5 |     COLLECTION ITERATOR PICKLER FETCH| V_EBA_STDS_STANDARD_TESTS |      1 |   8168 |    165 |00:00:04.25 |     814K|    212 |
-------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("from$_subquery$_002"."rowlimit_$$_rownumber"<=10000)
   2 - filter(ROW_NUMBER() OVER ( ORDER BY  NULL )<=10000)
   3 - access("STANDARD_CODE"=VALUE(KOKBF$))
-------------------------------------
