SET SERVEROUTPUT ON;

DECLARE 
    l_last_day NUMBER := to_number(to_char(last_day(sysdate), 'dd')); --last day of month 
    l_date DATE; -- store day of month 
    l_week_day  VARCHAR2(20); -- store name of the weekday 
BEGIN 
    /* 
        iterate over day in month 
    */ 
    FOR i IN 1..l_last_day LOOP 
        l_date := to_date(i || '.10.2021', 'dd.mm.yyyy'); 
        l_week_day := to_char(l_date, 'fmday'); 
        IF l_week_day = 'monday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' BAZAR ERTƏSİ'); 
        ELSIF l_week_day = 'tuesday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' ÇƏRŞƏNBƏ AXŞAMI'); 
        ELSIF l_week_day = 'wednesday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' ÇƏRŞƏNBƏ'); 
        ELSIF l_week_day = 'thursday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' CÜMƏ AXŞAMI'); 
        ELSIF l_week_day = 'friday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' CÜMƏ'); 
        ELSIF l_week_day = 'saturday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' ŞƏNBƏ'); 
        ELSIF l_week_day = 'sunday' THEN 
            dbms_output.put_line(TO_CHAR(l_date,'dd.mm.yyyy') || ' BAZAR'); 
        END IF; 
 
    END LOOP; 
END;
