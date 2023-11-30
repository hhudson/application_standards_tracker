  CREATE TABLE "SVT_AUDIT_ON_AUDIT" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"UNQID" VARCHAR2(1000 CHAR)  NOT NULL ENABLE, 
	"ACTION_NAME" VARCHAR2(100 CHAR)  NOT NULL ENABLE, 
	"TEST_CODE" VARCHAR2(100 CHAR) , 
	"AUDIT_ID" NUMBER, 
	"VALIDATION_FAILURE_MESSAGE" VARCHAR2(4000 CHAR) , 
	"APP_ID" NUMBER, 
	"PAGE_ID" NUMBER, 
	"COMPONENT_ID" NUMBER, 
	"ASSIGNEE" VARCHAR2(255 CHAR) , 
	"LINE" NUMBER, 
	"OBJECT_NAME" VARCHAR2(255 CHAR) , 
	"OBJECT_TYPE" VARCHAR2(31 CHAR) , 
	"CODE" VARCHAR2(255 CHAR) , 
	"DELETE_REASON" VARCHAR2(31 CHAR) , 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_ADT_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_ADT_PK_IDX" ON "SVT_AUDIT_ON_AUDIT" ("ID") 
  )  ENABLE
   );

  CREATE TABLE "SVT_NESTED_TABLE_TYPES" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"NT_NAME" VARCHAR2(255 CHAR) , 
	"EXAMPLE_QUERY" CLOB , 
	"OBJECT_TYPE" VARCHAR2(55 CHAR) , 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_NESTED_TABLE_T_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_NESTED_TABLE_TYPES_UK1" UNIQUE ("NT_NAME")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_PLSQL_APEX_AUDIT" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"ISSUE_CATEGORY" VARCHAR2(10 CHAR) , 
	"APPLICATION_ID" NUMBER, 
	"PAGE_ID" NUMBER, 
	"LINE" NUMBER, 
	"OBJECT_NAME" VARCHAR2(255 CHAR) , 
	"OBJECT_TYPE" VARCHAR2(31 CHAR) , 
	"CODE" VARCHAR2(4000 CHAR) , 
	"VALIDATION_FAILURE_MESSAGE" VARCHAR2(4000 CHAR) , 
	"APEX_CREATED_BY" VARCHAR2(255 CHAR) , 
	"APEX_CREATED_ON" DATE, 
	"APEX_LAST_UPDATED_BY" VARCHAR2(255 CHAR) , 
	"APEX_LAST_UPDATED_ON" DATE, 
	"ASSIGNEE" VARCHAR2(255 CHAR) , 
	"NOTES" VARCHAR2(4000 CHAR) , 
	"ACTION_ID" NUMBER, 
	"APEX_ISSUE_ID" NUMBER, 
	"ISSUE_TITLE" VARCHAR2(1000 CHAR) , 
	"APEX_ISSUE_TITLE_SUFFIX" VARCHAR2(100 CHAR) , 
	"OWNER" VARCHAR2(50 CHAR) , 
	"TEST_CODE" VARCHAR2(100 CHAR) , 
	"UNQID" VARCHAR2(1000 CHAR) , 
	"LEGACY_YN" VARCHAR2(1 CHAR) , 
	"COMPONENT_ID" NUMBER, 
	"PARENT_COMPONENT_ID" NUMBER, 
	"CREATED" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_PLAPAD_UK2" UNIQUE ("UNQID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_PLAPAD_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_PLAPAD_PK_IDX" ON "SVT_PLSQL_APEX_AUDIT" ("ID") 
  )  ENABLE
   ) ENABLE ROW MOVEMENT ;

  CREATE TABLE "SVT_STDS_APPLICATIONS" 
   (	"PK_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"APEX_APP_ID" NUMBER NOT NULL ENABLE, 
	"DEFAULT_DEVELOPER" VARCHAR2(100 CHAR) , 
	"TYPE_ID" NUMBER, 
	"NOTES" VARCHAR2(4000 CHAR) , 
	"ACTIVE_YN" VARCHAR2(1 CHAR)  DEFAULT 'Y', 
	"ESA_CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"ESA_CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"ESA_UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"ESA_UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STDS_APPLICATIONS_PK" PRIMARY KEY ("PK_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_STDAPP_UK1" UNIQUE ("APEX_APP_ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDAPP_UK1_IDX" ON "SVT_STDS_APPLICATIONS" ("APEX_APP_ID") 
  )  ENABLE
   );

  CREATE TABLE "SVT_STDS_ERROR_LOOKUP" 
   (	"CONSTRAINT_NAME" VARCHAR2(30 CHAR)  NOT NULL ENABLE, 
	"MESSAGE" VARCHAR2(4000 CHAR)  NOT NULL ENABLE, 
	"LANGUAGE_CODE" VARCHAR2(30 CHAR)  NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STERLK_PK" PRIMARY KEY ("CONSTRAINT_NAME")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STERLK_PK_IDX" ON "SVT_STDS_ERROR_LOOKUP" ("CONSTRAINT_NAME") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STERLK_UK1" UNIQUE ("CONSTRAINT_NAME", "LANGUAGE_CODE")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STERLK_UK1_IDX" ON "SVT_STDS_ERROR_LOOKUP" ("CONSTRAINT_NAME", "LANGUAGE_CODE") 
  )  ENABLE
   );

  CREATE TABLE "SVT_STDS_NOTIFICATIONS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"NOTIFICATION_NAME" VARCHAR2(255 CHAR)  NOT NULL ENABLE, 
	"NOTIFICATION_DESCRIPTION" VARCHAR2(4000 CHAR) , 
	"NOTIFICATION_TYPE" VARCHAR2(30 CHAR)  NOT NULL ENABLE, 
	"DISPLAY_SEQUENCE" NUMBER, 
	"DISPLAY_FROM" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	"DISPLAY_UNTIL" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	"ROW_VERSION_NUMBER" NUMBER NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STDNTF_CK1" CHECK (notification_type in ('RED','YELLOW')) ENABLE, 
	 CONSTRAINT "SVT_STDNTF_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDNTF_PK_IDX" ON "SVT_STDS_NOTIFICATIONS" ("ID") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STDNTF_UK1" UNIQUE ("NOTIFICATION_NAME")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDNTF_UK1_IDX" ON "SVT_STDS_NOTIFICATIONS" ("NOTIFICATION_NAME") 
  )  ENABLE
   );

  CREATE TABLE "SVT_STDS_STANDARDS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"STANDARD_NAME" VARCHAR2(64 CHAR)  NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000 CHAR) , 
	"PRIMARY_DEVELOPER" VARCHAR2(255 CHAR) , 
	"IMPLEMENTATION" CLOB , 
	"DATE_STARTED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT localtimestamp NOT NULL ENABLE, 
	"STANDARD_GROUP" VARCHAR2(32 CHAR) , 
	"ACTIVE_YN" VARCHAR2(1 CHAR)  DEFAULT 'Y' NOT NULL ENABLE, 
	"COMPATIBILITY_MODE_ID" NUMBER NOT NULL ENABLE, 
	"PARENT_STANDARD_ID" NUMBER, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STDSTN_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDSTN_PK_IDX" ON "SVT_STDS_STANDARDS" ("ID") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STDSTN_UK" UNIQUE ("STANDARD_NAME", "COMPATIBILITY_MODE_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_STDSTN_UK2" UNIQUE ("ID", "PARENT_STANDARD_ID")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_STDS_STANDARD_TESTS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"STANDARD_ID" NUMBER NOT NULL ENABLE, 
	"TEST_NAME" VARCHAR2(64 CHAR)  NOT NULL ENABLE, 
	"DISPLAY_SEQUENCE" NUMBER, 
	"QUERY_CLOB" CLOB , 
	"OWNER" VARCHAR2(128)  DEFAULT sys_context('userenv','current_schema'), 
	"TEST_CODE" VARCHAR2(100 CHAR)  NOT NULL ENABLE, 
	"LEVEL_ID" NUMBER, 
	"EXPLANATION" VARCHAR2(4000 CHAR) , 
	"FIX" CLOB , 
	"ACTIVE_YN" VARCHAR2(1)  DEFAULT 'Y', 
	"VERSION_NUMBER" NUMBER NOT NULL ENABLE, 
	"VERSION_DB" VARCHAR2(55 CHAR)  NOT NULL ENABLE, 
	"MV_DEPENDENCY" VARCHAR2(100) , 
	"SVT_COMPONENT_TYPE_ID" NUMBER NOT NULL ENABLE, 
	"AVG_EXCTN_SCNDS" NUMBER, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STDS_STANDARD_TESTS_UK1" UNIQUE ("TEST_NAME")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_STSTTS_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STSTTS_PK_IDX" ON "SVT_STDS_STANDARD_TESTS" ("ID") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STDS_STANDARD_TESTS_UK2" UNIQUE ("TEST_CODE")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_STDS_STANDARD_TESTS_UK3" UNIQUE ("STANDARD_ID", "ID")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_STDS_TESTS_LIB" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"STANDARD_ID" NUMBER, 
	"TEST_NAME" VARCHAR2(64 CHAR) , 
	"QUERY_CLOB" CLOB , 
	"TEST_CODE" VARCHAR2(100 CHAR)  NOT NULL ENABLE, 
	"ACTIVE_YN" VARCHAR2(1 CHAR) , 
	"MV_DEPENDENCY" VARCHAR2(100 CHAR) , 
	"SVT_COMPONENT_TYPE_ID" NUMBER, 
	"TEST_ID" NUMBER, 
	"EXPLANATION" VARCHAR2(4000 CHAR) , 
	"FIX" CLOB , 
	"LEVEL_ID" NUMBER, 
	"VERSION_NUMBER" NUMBER NOT NULL ENABLE, 
	"VERSION_DB" VARCHAR2(55 CHAR)  NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STSTTS_LIB_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STSTTS_LIB_IDX" ON "SVT_STDS_TESTS_LIB" ("ID") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STSTTS_LIB_UK1" UNIQUE ("TEST_CODE")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_STDS_TYPES" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"DISPLAY_SEQUENCE" NUMBER, 
	"TYPE_NAME" VARCHAR2(32 CHAR)  NOT NULL ENABLE, 
	"TYPE_CODE" VARCHAR2(10 CHAR)  NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(2000 CHAR) , 
	"ACTIVE_YN" VARCHAR2(1 CHAR)  DEFAULT 'Y', 
	 CONSTRAINT "SVT_STDTYP_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDTYP_PK_IDX" ON "SVT_STDS_TYPES" ("ID") 
  )  ENABLE, 
	 CONSTRAINT "SVT_STDTYP_UK2" UNIQUE ("TYPE_CODE")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STDTYP_IDX2" ON "SVT_STDS_TYPES" ("TYPE_CODE") 
  )  ENABLE
   );

  CREATE TABLE "SVT_AUDIT_ACTIONS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"ACTION_NAME" VARCHAR2(255 CHAR) , 
	"INCLUDE_IN_REPORT_YN" VARCHAR2(1 CHAR)  NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_ADTACT_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_ADTACT_PK_IDX" ON "SVT_AUDIT_ACTIONS" ("ID") 
  )  ENABLE
   );

  CREATE TABLE "SVT_COMPATIBILITY" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"DISPLAY_ORDER" NUMBER NOT NULL ENABLE, 
	"COMPATIBILITY_MODE" VARCHAR2(4 CHAR)  NOT NULL ENABLE, 
	"COMPATIBILITY_DESC" VARCHAR2(400 CHAR)  NOT NULL ENABLE, 
	"TYPE_NAME" VARCHAR2(10 CHAR)  NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_COMPATIBILITY_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_COMPONENT_TYPES" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"COMPONENT_NAME" VARCHAR2(50 CHAR)  NOT NULL ENABLE, 
	"AVAILABLE_YN" VARCHAR2(1 CHAR)  NOT NULL ENABLE, 
	"NT_TYPE_ID" NUMBER NOT NULL ENABLE, 
	"PK_VALUE" VARCHAR2(50 CHAR) , 
	"PARENT_PK_VALUE" VARCHAR2(50 CHAR) , 
	"TEMPLATE_URL" VARCHAR2(250 CHAR) , 
	"FRIENDLY_NAME" VARCHAR2(50 CHAR)  NOT NULL ENABLE, 
	"NAME_COLUMN" VARCHAR2(100 CHAR)  NOT NULL ENABLE, 
	"ADDL_COLS" VARCHAR2(1000 CHAR) , 
	"COMPONENT_TYPE_ID" NUMBER, 
	"FDV_ID" NUMBER, 
	"FDV_PARENT_VIEW_ID" NUMBER, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "UK_COMPONENTNAME" UNIQUE ("COMPONENT_NAME")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SVT_COMPONENT_TYPES_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_STANDARDS_URGENCY_LEVEL" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"URGENCY_LEVEL" NUMBER NOT NULL ENABLE, 
	"URGENCY_NAME" VARCHAR2(255 CHAR)  NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STURLV_PK" PRIMARY KEY ("ID")
  USING INDEX (CREATE UNIQUE INDEX "SVT_STURLV_PK_IDX" ON "SVT_STANDARDS_URGENCY_LEVEL" ("ID") 
  )  ENABLE
   );

  CREATE TABLE "SVT_STDS_INHERITED_TESTS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"PARENT_STANDARD_ID" NUMBER NOT NULL ENABLE, 
	"TEST_ID" NUMBER NOT NULL ENABLE, 
	"STANDARD_ID" NUMBER NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255 CHAR)  DEFAULT user NOT NULL ENABLE, 
	 CONSTRAINT "SVT_STDS_INHERITED_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "EB_STD_INH_C1" CHECK (parent_standard_id != standard_id) ENABLE, 
	 CONSTRAINT "EB_STD_INH_UK1" UNIQUE ("STANDARD_ID", "TEST_ID")
  USING INDEX  ENABLE
   );

  CREATE TABLE "SVT_TEST_TIMING" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"TEST_CODE" VARCHAR2(100 CHAR) , 
	"ELAPSED_SECONDS" NUMBER, 
	"CREATED" DATE DEFAULT sysdate NOT NULL ENABLE, 
	 CONSTRAINT "SVT_TEST_TIMING_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   );

  ALTER TABLE "SVT_COMPONENT_TYPES" ADD CONSTRAINT "SVT_COMPONENT_TYPES_FK1" FOREIGN KEY ("NT_TYPE_ID")
	  REFERENCES "SVT_NESTED_TABLE_TYPES" ("ID") ENABLE;

  CREATE INDEX "SVT_COMPONENT_TYPES_IDX1" ON "SVT_COMPONENT_TYPES" ("NT_TYPE_ID") 
  ;

  ALTER TABLE "SVT_PLSQL_APEX_AUDIT" ADD CONSTRAINT "SVT_PLAPAD_SVT_ADTACT_FK1" FOREIGN KEY ("ACTION_ID")
	  REFERENCES "SVT_AUDIT_ACTIONS" ("ID") ENABLE;

  CREATE INDEX "SVT_PLAPAD_IDX1" ON "SVT_PLSQL_APEX_AUDIT" ("ACTION_ID") 
  ;

  CREATE INDEX "SVT_PLAPAD_IDX2" ON "SVT_PLSQL_APEX_AUDIT" ("TEST_CODE") 
  ;

  CREATE INDEX "SVT_PLAPAD_IDX3" ON "SVT_PLSQL_APEX_AUDIT" ("APPLICATION_ID") 
  ;

  CREATE INDEX "SVT_STURLV_IDX2" ON "SVT_STANDARDS_URGENCY_LEVEL" ("URGENCY_LEVEL") 
  ;

  ALTER TABLE "SVT_STDS_APPLICATIONS" ADD CONSTRAINT "SVT_STDS_APPLICATIONS_FK" FOREIGN KEY ("TYPE_ID")
	  REFERENCES "SVT_STDS_TYPES" ("ID") ENABLE;

  CREATE INDEX "SVT_STDAPP_IDX1" ON "SVT_STDS_APPLICATIONS" ("TYPE_ID") 
  ;

  ALTER TABLE "SVT_STDS_INHERITED_TESTS" ADD CONSTRAINT "SVT_STDS_INHERITED_TESTS_FK" FOREIGN KEY ("STANDARD_ID")
	  REFERENCES "SVT_STDS_STANDARDS" ("ID") ENABLE;

  CREATE INDEX "EB_STD_INH_IDX1" ON "SVT_STDS_INHERITED_TESTS" ("PARENT_STANDARD_ID", "TEST_ID") 
  ;

  ALTER TABLE "SVT_STDS_STANDARDS" ADD CONSTRAINT "SVT_STDS_STANDARDS_FK" FOREIGN KEY ("COMPATIBILITY_MODE_ID")
	  REFERENCES "SVT_COMPATIBILITY" ("ID") ENABLE;

  CREATE INDEX "SVT_STDSTN_IDX1" ON "SVT_STDS_STANDARDS" ("COMPATIBILITY_MODE_ID") 
  ;

  CREATE INDEX "SVT_STDSTN_IDX2" ON "SVT_STDS_STANDARDS" ("PARENT_STANDARD_ID") 
  ;

  ALTER TABLE "SVT_STDS_STANDARD_TESTS" ADD CONSTRAINT "SVT_STSTTS_SVT_STDSTN_FK5" FOREIGN KEY ("LEVEL_ID")
	  REFERENCES "SVT_STANDARDS_URGENCY_LEVEL" ("ID") ENABLE;
  ALTER TABLE "SVT_STDS_STANDARD_TESTS" ADD CONSTRAINT "SVT_STSTTS_SVT_STDSTN_FK1" FOREIGN KEY ("STANDARD_ID")
	  REFERENCES "SVT_STDS_STANDARDS" ("ID") ENABLE;
  ALTER TABLE "SVT_STDS_STANDARD_TESTS" ADD CONSTRAINT "SVT_STSTTS_SVT_STDSTN_FK2" FOREIGN KEY ("SVT_COMPONENT_TYPE_ID")
	  REFERENCES "SVT_COMPONENT_TYPES" ("ID") ENABLE;

  CREATE INDEX "SVT_STDS_STANDARD_TESTS_IDX1" ON "SVT_STDS_STANDARD_TESTS" ("SVT_COMPONENT_TYPE_ID") 
  ;

  CREATE INDEX "SVT_STSTTS_IDX1" ON "SVT_STDS_STANDARD_TESTS" ("STANDARD_ID") 
  ;

  CREATE INDEX "SVT_STSTTS_IDX4" ON "SVT_STDS_STANDARD_TESTS" ("LEVEL_ID") 
  ;

  CREATE UNIQUE INDEX "SVT_STDTYP_IDX1" ON "SVT_STDS_TYPES" ("TYPE_NAME") 
  ; 