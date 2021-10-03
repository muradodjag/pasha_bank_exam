/*
Explanation: 
Level generate sequence of number. The Level returns 1 for root,2 for child of 
root now and so on. 'Connect by' set hierarchical relationship between the 
parent rows and the child rows of the hierarchy.. In query, condition will be 
checked and relationship created using Connect By between Level having value 1 
and the specified condition. In our case condition is CONNECT BY level <= 31.

We add level(day) to date and iterate until 31 october inclusive.
*/

SELECT CASE TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'fmday')
       WHEN 'monday'    THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' BAZAR ERTƏSİ'
       WHEN 'tuesday'   THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' ÇƏRŞƏNBƏ AXŞAMI'
       WHEN 'wednesday' THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' ÇƏRŞƏNBƏ'
       WHEN 'thursday'  THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' CÜMƏ AXŞAMI'
       WHEN 'friday'    THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' CÜMƏ'
       WHEN 'saturday'  THEN TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' ŞƏNBƏ'
       ELSE 
            TO_CHAR(TO_DATE('30.09.21','dd.mm.yy') + level,'dd.mm.yyyy') || ' BAZAR'
       END     
FROM DUAL
CONNECT BY level <= 31
