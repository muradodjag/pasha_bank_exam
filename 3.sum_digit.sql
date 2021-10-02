CREATE OR REPLACE FUNCTION sum_digit(num_in IN NUMBER)
RETURN NUMBER
IS
    l_num_copy NUMBER := num_in;
    l_sum NUMBER := 0;
BEGIN
    /*
        Each iteration we sum remainder of the number divided by 10
        and decrease the number by dividing by 10. 
        Continue it until the number is zero 
    */
    WHILE l_num_copy != 0
    LOOP
        l_sum := l_sum + MOD(l_num_copy,10);
        l_num_copy := FLOOR(l_num_copy/10);
    END LOOP;
    
    RETURN l_sum;
END;    
    