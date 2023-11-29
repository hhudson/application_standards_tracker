--liquibase formatted sql
--changeset package_body_script:ASSERT stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE BODY assert  
IS  
   PROCEDURE this_condition (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
    , p_null_means_failure_in IN BOOLEAN DEFAULT TRUE  
   )  
   IS  
   BEGIN  
      IF NOT p_condition_in  
         OR (p_null_means_failure_in AND p_condition_in IS NULL)  
      THEN  
         IF p_display_call_stack_in  
         THEN  
            DBMS_OUTPUT.put_line ('ASSERTION VIOLATION! ' || p_msg_in);  
            DBMS_OUTPUT.put_line ('Path taken to assertion violation:');  

            /* Uncomment when you install in your own environment;  
               DBMS_UTILITY currently unavailable in LiveSQL  
              DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack); */ 
         END IF;  

         raise_application_error (-20000, 'ASSERTION VIOLATION! ' || p_msg_in);  
      END IF;  
   END;  

   PROCEDURE is_null (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )  
   IS  
   BEGIN  
      this_condition (p_val_in IS NULL  
               , p_msg_in  
               , p_display_call_stack_in  
               , p_null_means_failure_in      => FALSE  
                );  
   END is_null;  

   PROCEDURE is_email (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )
   IS  
   l_instr pls_integer := 0;
   BEGIN  
      l_instr := regexp_instr(p_val_in,
               '[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*', 1);
      this_condition (l_instr > 0, p_msg_in, p_display_call_stack_in);  
   END is_email;  

   PROCEDURE is_not_null (  
      p_val_in IN VARCHAR2  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )  
   IS  
   BEGIN  
      this_condition (p_val_in IS NOT NULL, p_msg_in, p_display_call_stack_in);  
   END is_not_null;  

   PROCEDURE is_true (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )  
   IS  
   BEGIN  
      this_condition (p_condition_in, p_msg_in, p_display_call_stack_in);  
   END is_true;  

   PROCEDURE is_false (  
      p_condition_in IN BOOLEAN  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )  
   IS  
   BEGIN  
      this_condition (NOT p_condition_in, p_msg_in, p_display_call_stack_in);  
   END is_false;  

   PROCEDURE is_in_range (  
      p_date_in IN DATE  
    , p_low_date_in IN DATE  
    , p_high_date_in IN DATE  
    , p_msg_in IN VARCHAR2  
    , p_display_call_stack_in IN BOOLEAN DEFAULT FALSE  
   )
   IS  
   BEGIN  
      this_condition (TRUNC (p_date_in) BETWEEN TRUNC (p_low_date_in)  
                                     AND TRUNC (p_high_date_in)  
               , p_msg_in  
               , p_display_call_stack_in  
                );  
   END is_in_range;  
END assert; 
/
--rollback drop package ASSERT;
