--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-pf-plsql.sql

--Student ID: 32837011
--Student Name: Cheah Jit Yung

/* Comments for your marker:


*/


--(a)
--Write your trigger statement,
--finish it with a slash(/) followed by a blank line

CREATE OR REPLACE TRIGGER chk_visit_service_cost
    BEFORE INSERT OR UPDATE OR DELETE
        ON VISIT_SERVICE
FOR EACH ROW
DECLARE
    service_std_cost service.service_std_cost%type;
BEGIN
    IF updating OR inserting THEN
        SELECT service_std_cost INTO service_std_cost
        FROM service
        WHERE service_code = :new.service_code;
        IF NOT (:new.VISIT_SERVICE_LINECOST BETWEEN service_std_cost*0.9 AND service_std_cost*1.1) THEN
            RAISE_APPLICATION_ERROR(-20000, 'Visit service line cost is beyond the set limit of 10% difference than standard cost');
        END IF;
    END IF;
    -- value is within range

    -- now update the cost on visit table
    IF updating THEN
        UPDATE VISIT
        -- replace old cost with new cost
        SET VISIT_TOTAL_COST = VISIT_TOTAL_COST - :old.VISIT_SERVICE_LINECOST + :new.VISIT_SERVICE_LINECOST
        WHERE VISIT_ID = :new.VISIT_ID;
    ELSIF inserting THEN
        UPDATE VISIT
        -- add new cost to total cost
        SET VISIT_TOTAL_COST = VISIT_TOTAL_COST + :new.VISIT_SERVICE_LINECOST
        WHERE VISIT_ID = :new.VISIT_ID;
    ELSIF deleting THEN
        UPDATE VISIT
        -- deduct cost from total cost
        SET VISIT_TOTAL_COST = VISIT_TOTAL_COST - :old.VISIT_SERVICE_LINECOST
        WHERE VISIT_ID = :old.VISIT_ID;
    END IF;
END;
/

commit;


-- Write Test Harness for (a)
-- initial data

-- DISPLAY initial data for update and delete
select SERVICE_CODE, VISIT_SERVICE_LINECOST
from visit_service
where visit_id = 1 AND SERVICE_CODE = 'S001'
;


-- test trigger invalid visit_service_linecost (TEST LIMITS & UPDATE)

BEGIN
    UPDATE VISIT_SERVICE
    SET VISIT_SERVICE_LINECOST = 66.01
    where visit_id = 1 AND SERVICE_CODE = 'S001';
END;
/

-- test trigger - invalid visit_service_linecost (beyond lower limit UPDATE)

BEGIN
    UPDATE VISIT_SERVICE
    SET VISIT_SERVICE_LINECOST = 53.99
    where visit_id = 1 AND SERVICE_CODE = 'S001';
END;
/




-- test trigger - valid visit_service_linecost (within limits upper UPDATE)
BEGIN
    UPDATE VISIT_SERVICE
    SET VISIT_SERVICE_LINECOST = 66
    where visit_id = 1 AND SERVICE_CODE = 'S001';
END;
/

rollback;

-- test trigger -- valid visit_service_linecost (within limits lower UPDATE)
BEGIN
    UPDATE VISIT_SERVICE
    SET VISIT_SERVICE_LINECOST = 54
    where visit_id = 1 AND SERVICE_CODE = 'S001';
END;
/

rollback;




-- TEST TRIGGER DELETE 

-- BEFORE ( see theres two instance of visit_id = 1 and service code = 'S001'  (Assume accidential double charge))
select visit_id, SERVICE_CODE
from visit_service
where visit_id = 1;

select visit_id, visit_total_cost
from VISIT
where visit_id = 1;


BEGIN
    DELETE FROM VISIT_SERVICE
    where visit_id = 1 AND SERVICE_CODE = 'S001'
    ;
END;
/

-- AFTER (1 instance is removed AND visit_total_cost is reduced by the amount of the deleted service line cost)
select visit_id, SERVICE_CODE
from visit_service
where visit_id = 1;

select visit_id, visit_total_cost
from VISIT
where visit_id = 1;


rollback;


-- TEST TRIGGER INSERT

-- BEFORE

select visit_id, SERVICE_CODE
from visit_service
where visit_id = 1;

select visit_id, visit_total_cost
from VISIT
where visit_id = 1;

-- INVALID
BEGIN
    INSERT INTO VISIT_SERVICE (VISIT_ID, SERVICE_CODE, VISIT_SERVICE_LINECOST)
    VALUES (1, 'S002', 100);
END;
/

-- AFTER (NO MODIFICATION)

select visit_id, SERVICE_CODE
from visit_service
where visit_id = 1;

select visit_id, visit_total_cost
from VISIT
where visit_id = 1;




-- VALID
BEGIN
    INSERT INTO VISIT_SERVICE (VISIT_ID, SERVICE_CODE, VISIT_SERVICE_LINECOST)
    VALUES (1, 'S002', 45);
END;
/

-- AFTER  (Recorded an additional service, total visit cost added accordingly)

select visit_id, SERVICE_CODE
from visit_service
where visit_id = 1;

select visit_id, visit_total_cost
from VISIT
where visit_id = 1;

rollback;







--(b)
-- Complete the procedure below
CREATE OR REPLACE PROCEDURE prc_followup_visit (
    p_prevvisit_id IN NUMBER,
    p_newvisit_datetime IN DATE,
    p_newvisit_length IN NUMBER,
    p_output OUT VARCHAR2
) IS
    visit_id  visit.visit_id%TYPE;
    animal_id  visit.animal_id%TYPE;
    vet_id     visit.vet_id%TYPE;
    clinic_id  visit.clinic_id%TYPE;
    var_prevvisit_found   NUMBER;
    service_code service.service_code%TYPE;
BEGIN
    SELECT
        COUNT(*) INTO var_prevvisit_found
    FROM
        visit
    WHERE
        visit_id = p_prevvisit_id;
    p_output := 'Invalid date time or no previous visit found.';
    IF ( (var_prevvisit_found > 0)
        AND
        (p_newvisit_datetime between to_date('01/04/2024', 'dd/mm/yyyy') and to_date('30/06/2024', 'dd/mm/yyyy'))
        )
        THEN
            SELECT animal_id, vet_id, clinic_id
            INTO animal_id, vet_id, clinic_id
            FROM visit
            WHERE visit_id = p_prevvisit_id;

            select service_code
            INTO service_code
            from service
            where upper(service_desc) = upper('General Consultation');

            INSERT INTO VISIT
            VALUES
            (
                visit_pk_seq.NEXTVAL, 
                p_newvisit_datetime, 
                p_newvisit_length,
                NULL,
                NULL,
                NULL,
                animal_id,
                vet_id,
                clinic_id,
                p_prevvisit_id,
                'Y'
            );
            INSERT INTO VISIT_SERVICE (visit_id, service_code, visit_service_linecost)
            VALUES
            (
                visit_pk_seq.CURRVAL,
                service_code,
                NULL
            );
            p_output := 'Follow-up visit successfully created.';
    END IF;
END;
/

commit;



-- Write Test Harness for (b)
-- initial data


-- previous visit (valid existing record)
select *
from visit 
where FROM_VISIT_ID = 9;

-- ATTEMPT INSERT with INVALID prev visit (non-existing id)

DECLARE
    p_output VARCHAR2(200);
BEGIN
    prc_followup_visit(1000, to_date('31/03/2024', 'dd/mm/yyyy'), 30, p_output);
    dbms_output.put_line(p_output);
END;
/

-- ATTEMPT INSERT with INVALID date

DECLARE
    p_output VARCHAR2(200);
BEGIN
    prc_followup_visit(9, to_date('31/03/2024', 'dd/mm/yyyy'), 30, p_output);
    dbms_output.put_line(p_output);
END;
/

-- server output will display the error message.

-- No Added appointment seen (queried by from_visit_id)
select *
from VISIT
where FROM_VISIT_ID = 9;

-- VALID Insert

DECLARE
    p_output VARCHAR2(200);
BEGIN
    prc_followup_visit(9, to_date('01/04/2024', 'dd/mm/yyyy'), 30, p_output);
    dbms_output.put_line(p_output);
END;
/

-- displays 1 record
select *
from VISIT
where FROM_VISIT_ID = 9;

rollback;
