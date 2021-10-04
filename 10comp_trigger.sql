/*
At first i wanted to use flashback for code_before, but after i decided to 
use additional table (log_code_before). Structure of this table:
USERNAME          VARCHAR2(50)   
OBJECT_NAME       VARCHAR2(50)   
CODE_BEFORE       VARCHAR2(4000)

And our main table(log_sys_comp) where we store log of compilation.
Structure of this table:
COMPILE_TIME       DATE           
USERNAME           VARCHAR2(50)   
MACHINE_NAME       VARCHAR2(50)   
OBJECT_NAME        VARCHAR2(50)   
OBJECT_TYPE        VARCHAR2(50)   
CODE_BEFORE        VARCHAR2(4000) 
CODE_AFTER         VARCHAR2(4000) 

*/

CREATE OR REPLACE TRIGGER log_sys_trg
AFTER CREATE ON system.schema
DECLARE
    l_compile_time DATE;
    l_username VARCHAR2(50);
    l_machine_name VARCHAR2(50);
    l_object_name VARCHAR2(50);
    l_object_type VARCHAR2(50);
    l_code_before VARCHAR2(4000);
    l_code_after VARCHAR2(4000);
BEGIN
    /*
    Query ordered rows by timestamp and fetch first row. It is important for
    catching created object
    */
    SELECT UPPER(owner),UPPER(object_type),UPPER(object_name),last_ddl_time INTO 
    l_username,l_object_type,l_object_name,l_compile_time FROM all_objects
    ORDER BY timestamp DESC
    FETCH FIRST 1 ROWS ONLY;
    
    /*
    From table dba_source we query text of object and concatenate all rows of
    particular owner and object_name. If you execute this query without LISTAGG
    you understand that it return entire code in several rows.
    */
    SELECT LISTAGG(text,' ') INTO l_code_after FROM dba_source
    WHERE owner = l_username AND name = l_object_name;

    
    
    /*
    Get machine_name 
    */
    SELECT SYS_CONTEXT('USERENV','HOST') INTO l_machine_name FROM DUAL; 

    
    /*
    From our additional table we query code_before and store in local variable.
    This is necessary in order to update our code_before column in main table
    (log_sys_comp). When we create object in first time, this query raise
    exception no_data_found. For this I write exception, which handle no_data_found
    and execption equates l_code_before to NULL.
    
    */
    SELECT code_before INTO l_code_before FROM log_code_before
    WHERE username = l_username AND object_name = l_object_name;

    
    /*
    The very important thing is happening here. I store l_code_after in code_before
    for the next updating of object.I use merge for inserting and updating. 
    If in log_code_before we have rows with the same username and 
    object name we update column code_before. Otherwise , we insert row.
    */
    MERGE INTO log_code_before a
    USING (SELECT l_username own_name, l_object_name obj_name FROM dual) b
    ON (a.username = b.own_name AND a.object_name = b.obj_name)
    WHEN NOT MATCHED THEN
    INSERT (username,object_name,code_before)
    VALUES (l_username,l_object_name,l_code_before)
     WHEN MATCHED THEN
     UPDATE SET
        a.code_before = l_code_after;


    /*
    Manipulation with main table(log_sys_comp). Insert if we dont have row with 
    the same username and object_name. Update l_code_after and l_code_before
    if username and object name are matching
    */
    MERGE INTO log_sys_comp a
    USING (SELECT l_compile_time cmp_time,l_username own_name, l_machine_name mach_name, 
           l_object_name obj_name, l_object_type obj_type, l_code_before cd_before, l_code_after cd_after from dual) b
    ON (a.username = b.own_name AND a.object_name = b.obj_name)
    WHEN NOT MATCHED THEN
    INSERT (compile_time ,username,machine_name ,object_name ,object_type,code_before,code_after)
    VALUES (cmp_time ,   own_name ,   mach_name,  obj_name,    obj_type,   cd_before,   cd_after)
     WHEN MATCHED THEN
     UPDATE SET
        a.code_after = l_code_after,
        a.code_before = l_code_before;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_code_before := NULL;    

END;
