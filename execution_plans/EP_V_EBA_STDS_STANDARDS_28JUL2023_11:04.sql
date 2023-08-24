SQL_ID  g3j88k2bd0tf2, child number 0
 
select /*+ gather_plan_statistics */ * from V_EBA_STDS_STANDARDS fetch 
first 10000 rows only
 
Plan hash value: 3680281148
 
----------------------------------------------------------------------------------------------------------------
| Id  | Operation              | Name               | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |                    |      1 |        |      9 |00:00:09.15 |     214K|   3816 |
|*  1 |  VIEW                  |                    |      1 |  10000 |      9 |00:00:09.15 |     214K|   3816 |
|*  2 |   WINDOW NOSORT STOPKEY|                    |      1 |      9 |      9 |00:00:00.01 |       7 |      0 |
|   3 |    TABLE ACCESS FULL   | EBA_STDS_STANDARDS |      1 |      9 |      9 |00:00:00.01 |       7 |      0 |
----------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("from$_subquery$_002"."rowlimit_$$_rownumber"<=10000)
   2 - filter(ROW_NUMBER() OVER ( ORDER BY  NULL )<=10000)
-------------------------------------
