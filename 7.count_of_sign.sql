--1st solution
/*
Explanation:
Replace '!' with empty string,  found length of new string after replacing.
Substract length of new string from old string.
*/
SELECT LENGTH('Hello World! It is a good day!!!') - LENGTH(REPLACE('Hello World! It is a good day!!!', '!')) FROM DUAL;

--2nd solution
/*
Explanation:
Pass a string and a pattern to function 'REGEXP_COUNT'.
Function count number of times a pattern occurs in string
*/
SELECT REGEXP_COUNT('Hello World! It is a good day!!!', '!') FROM DUAL;

--3rd solution
/*
Explanation:
Replace everything that is match to pattern with empty string 
*/
SELECT LENGTH(REGEXP_REPLACE('Hello World! It is a good day!!!','[^!]','')) FROM DUAL;

--4th solution 
/*
Explanation: 
Level generate sequence of number. The Level returns 1 for root,2 for child of 
root now and so on. 'Connect by' set hierarchical relationship between the 
parent rows and the child rows of the hierarchy.. In query, condition will be 
checked and relationship created using Connect By between Level having value 1 
and the specified condition. In our case condition is CONNECT BY level <= LENGTH(str).

Function 'Substr' helps get each character of string and 'WHERE' clause query only '!'.
And finally count rows

*/
SELECT COUNT(*) "Number of '!' "FROM
(
    SELECT SUBSTR('Hello World! It is a good day!!!',level,1) sign
    FROM DUAL
    CONNECT BY level <= LENGTH('Hello World! It is a good day!!!')
)
WHERE sign = '!';