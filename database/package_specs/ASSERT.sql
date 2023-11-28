--liquibase formatted sql
--changeset package_script:ASSERT stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE assert authid definer
IS  
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2011 - 2020. All Rights Reserved.
--
--    NAME
--      assert
--
--    DESCRIPTION
--    Source  : https://livesql.oracle.com/apex/livesql/file/content_CFLUGC2RAJKP3RAF5XYUMTXE8.html
--    Assertion Package  
--    Provides a set of procedures you can use to *assert*  
--    that a required condition is met. If not, an   
--    error is raised, stopping execution of the block.  

--    Author: Steven Feuerstein, steven.feuerstein@oracle.com   

--    Example:  

-- instead of this:  

-- PROCEDURE calc_totals (  
--    dept_in   IN   INTEGER,  
--    date_in   IN   DATE  
-- )  
-- IS   
--    bad_date   EXCEPTION;  
-- BEGIN  
--    IF dept_in IS NULL  
--    THEN  
--       RAISE_APPLICATION_ERROR (-20000, 'Department ID cannot be null.');  
--    END IF;  

--    IF date_in NOT BETWEEN ADD_MONTHS (SYSDATE, -60) AND SYSDATE  
--    THEN  
--       RAISE_APPLICATION_ERROR (-20000, 'Date is out of range.');  
--    END IF; 

--    /* Program logic  */
-- END; 

-- Do this:  

-- PROCEDURE calc_totals (  
--    dept_in   IN   INTEGER,  
--    date_in   IN   DATE  
-- )  
-- IS   
--    bad_date   EXCEPTION;  

--    PROCEDURE validate_assumptions 
--    IS 
--    BEGIN 
--       assert.is_null (dept_in, 'Department ID');  

--       assert.is_in_range (  
--          date_in,  
--          ADD_MONTHS (SYSDATE, -60),  
--          SYSDATE  
--       );  
--    END;   
-- BEGIN  

--    validate_assumptions; 

--    /* Everything's fine. Code in confidence...  
--     * Program logic  */
-- END;    
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--    hayhudso   07/25/2022 - created
--------------------------------------------------------------------------------

   PROCEDURE this_condition (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
    , p_null_means_failure_in IN BOOLEAN DEFAULT TRUE  
   );   

   PROCEDURE is_null (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure, used to assert email address 
--
/*
begin
   assert.is_email (  
      p_val_in => p_assignee
    , p_msg_in => 'Assignee must be an email address');
end;
*/
------------------------------------------------------------------------------
   PROCEDURE is_email (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );  

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to assert a value is not null
--
/*
begin
   assert.is_not_null (  
      p_val_in => p_app_id
    , p_msg_in => 'App id cannot be null');
end;
*/
------------------------------------------------------------------------------
   PROCEDURE is_not_null (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );  

   PROCEDURE is_true (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );  

   PROCEDURE is_false (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );  

   PROCEDURE is_in_range (  
      p_date_in IN DATE  
    , p_low_date_in IN DATE  
    , p_high_date_in IN DATE  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   );  
END assert; 
/
--rollback drop package ASSERT;
