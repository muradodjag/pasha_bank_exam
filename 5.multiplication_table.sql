SET SERVEROUTPUT ON;
BEGIN
    /*
        Use nested loop for multiplication table.
        The main difficulty of this task is nicely formatted of table.
        I use dbms_output.put() because this function doesn't start from new line
        like dbms_output.put_line(). After apply RPAD to each output, it helps me
        leave a gap between output of 'inner loop'. In outer loop 
        after inner loop i wrote dbms_output.new_line to start on a new line.
    */
    FOR i IN 1..9 
    LOOP
        FOR j IN 1..9
        LOOP
            dbms_output.put(RPAD(j||'x'||i||'='||i*j,10,' '));
        END LOOP;
       dbms_output.new_line; 
    END LOOP;
END;