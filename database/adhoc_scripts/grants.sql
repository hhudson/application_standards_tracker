--liquibase formatted sql
--changeset adhoc_script:GRANTS stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_users where upper(username) = upper('${grant_to_schema}');

grant execute on ast_plsql_review to ${grant_to_schema}
/
grant execute on ast_preferences to ${grant_to_schema}
/
grant execute on ast_ctx_util to ${grant_to_schema}
/