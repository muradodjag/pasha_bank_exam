CREATE OR REPLACE PROCEDURE sync_table AS
    CURSOR table_b_cur IS
        SELECT *
        FROM TABLE_B;
    TYPE   recs_type IS TABLE OF table_b_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    recs recs_type;
BEGIN
--All records from cursor Insert into associative array 
-- BULK COLLECT helps to collect many rows at once into associative array
    OPEN table_b_cur;
    FETCH table_b_cur BULK COLLECT INTO recs;
    CLOSE table_b_cur;
    
 -- Update attributes, which matching with primary key,
 -- but atributes from 'table_a' not equal attributes from 'table_b'   
    FOR i IN 1..recs.COUNT 
    LOOP
        UPDATE TABLE_A
        SET book_name = recs(i).book_name,
        author = recs(i).author
        WHERE book_id = recs(i).book_id
        AND (book_name <> recs(i).book_name
        OR author <> recs(i).author);
END LOOP;
-- Find new rows in Table_b and insert into Table_a 
    INSERT INTO TABLE_A
        SELECT *
        FROM TABLE_B
        WHERE book_id NOT IN (
        SELECT book_id
        FROM TABLE_A);
END sync_table;   
    
