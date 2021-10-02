CREATE OR REPLACE FUNCTION is_palindrome(str_in IN VARCHAR2)
   RETURN VARCHAR2
IS 
    l_tail VARCHAR2(500); -- it is substring. String which start with 'FLOOR(LENGTH(str_in)/2)' index
    l_is_palindrome VARCHAR2(500) := 'False';
    l_end_loop NUMBER := FLOOR(LENGTH(str_in)/2); -- decrease iteration by 2 times
BEGIN
    
    /*I add nested block, because function can only return at the end of the code execution 
    (or naturally if any other exception is raised as we don't handle those).
    In the main I do it to avoid 'Return' statement in exception
    */
    
    BEGIN <<inner_block>>
    
    /*  Concatenate l_tail with char from END to FLOOR(LENGTH(str_in)/2)
        minus in prior of i means that we start from end of string
    */
    FOR i IN  1..l_end_loop
    LOOP
       
        l_tail := l_tail || SUBSTR(str_in,-i,1);
    END LOOP;
    
    /*  Compare tail of string with substring, which start 
        from the beginning to  FLOOR(LENGTH(str_in)/2)
     */
    IF SUBSTR(str_in,1,FLOOR(LENGTH(str_in)/2)) = l_tail 
    THEN
        l_is_palindrome := 'True';
    END IF;
    --If user input empty string
    EXCEPTION
    WHEN value_error THEN
        l_is_palindrome := 'You input empty string';
    END;   
    
    RETURN l_is_palindrome;
END;    
