CREATE OR REPLACE PACKAGE rest_api IS

    PROCEDURE json_req (l_url VARCHAR2,l_id VARCHAR2,l_customer VARCHAR2,l_quantity VARCHAR2,l_price VARCHAR2);
END rest_api;
/

CREATE OR REPLACE PACKAGE BODY rest_api IS

    PROCEDURE json_req (
       l_url VARCHAR2,
       l_id VARCHAR2,
       l_customer VARCHAR2,
       l_quantity VARCHAR2,
       l_price VARCHAR2
    ) IS

        req     utl_http.req;
        res     utl_http.resp;
        url     VARCHAR2(4000) := l_url;
        name    VARCHAR2(4000);
        buffer  VARCHAR2(4000);
        json_body VARCHAR2(4000) := '{
                                       "Id": "'||l_id||'",
                                       "Customer": "'||l_customer||'",
                                       "Quantity": "'||l_quantity||'",
                                       "Price": "'||l_price||'"
                                     }';
    BEGIN
        req := utl_http.begin_request(url, 'POST', ' HTTP/1.1');
        utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header(req, 'content-type', 'application/json');
        utl_http.write_text(req, json_body);
        res := utl_http.get_response(req);
  -- process the response from the HTTP call
        BEGIN
            LOOP
                utl_http.read_line(res, buffer);
                dbms_output.put_line(buffer);
            END LOOP;

            utl_http.end_response(res);
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
        END;

    END json_req;
END;    
/