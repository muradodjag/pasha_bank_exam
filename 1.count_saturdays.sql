CREATE OR REPLACE FUNCTION count_saturdays(start_date_in IN DATE, 
                                           end_date_in IN DATE)
   RETURN NUMBER
IS 
    l_cnt NUMBER := 0;
    start_date_copy DATE := start_date_in; 
BEGIN
    /* 
       We set our start_date_copy as 'Saturday'. 
       We substract 1 from start_date_copy, because if weekday of start_date_copy
       equals 'Saturday', NEXT_DAY return next 'Saturday' not 'today's Saturday'.  
    */

    start_date_copy := NEXT_DAY(start_date_copy - 1, 'SATURDAY');
    
    /*
        After in while loop we count number of 'Saturday' and 
        add 7 to start_date_copy , because in every week there is 1 'Saturday'.
        And we do this until start_date_copy exceeds end_date_in.
    */
    WHILE start_date_copy <= end_date_in 
    LOOP
        start_date_copy := start_date_copy + 7;
        l_cnt := l_cnt + 1;
    END LOOP;
    
    RETURN l_cnt;
END;    