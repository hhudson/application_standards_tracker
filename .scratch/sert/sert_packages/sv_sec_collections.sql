create or replace PACKAGE sv_sec_collections as

procedure create_collection (
    p_collection_id            in number
   ,p_collection_name          in varchar2
   ,p_app_session              in number
   ,p_query                    in varchar2
   ,p_attribute_set_id         in number
   ,p_application_id           in number );

procedure parse_collection_sql (
   --
   -- Parses Score Collection SQL for active attributes to verify the collection_sql is syntactically valid.
   -- Code is validated but not executed.
   --
   -- Results collection returns:
   --      c001      : collection_name
   --      c002      : PASS/FAIL result
   --      c003      : compilation error for fails
   --      n001      : score_collection_id
   --      clob001   : parsed code with substitutions applied
   --
   -- Arguments:
   --     p_results_collection_name  =  Name of APEX collection containing the PASS/FAIL results.
   --     p_collection_id            =  Parse all collections (Default), or specified collection_id only.
   --
    p_results_collection_name  in varchar2 default 'SERT_PARSE_COLLECTIONS'
   ,p_collection_id            in number default null );

function get_parse_error (
   -- Returns error text or null after parsing the collection.
    p_collection_id            in number
   ,p_results_collection_name  in varchar2 default 'SERT_PARSE_COLLECTIONS' )
   return varchar2;


procedure delete_score_collections;

procedure create_score_collections (
    p_collection_id            in number
   ,p_application_id           in number
   ,p_attribute_set_id         in number
   ,p_app_session              in number default nv('APP_SESSION')
   ,p_app_user                 in varchar2 default v('APP_USER')
);

end sv_sec_collections;
/