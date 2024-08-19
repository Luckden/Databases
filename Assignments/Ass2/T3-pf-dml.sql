/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T3-pf-dml.sql

--Student ID: 32837011
--Student Name: Cheah Jit Yung

/* Comments for your marker:

The visit total cost is calculated by summing the visit service line cost and visit drug line cost.
(IDK if this would be an overkill since this case only 1 drug involved and 1 service involved both quantity 1)
Anyways, this makes the query more comprehensive.

*/

/*(a)*/
DROP SEQUENCE visit_pk_seq;

CREATE SEQUENCE visit_pk_seq
START WITH 100
INCREMENT BY 10;



/*(b)*/

-- Visit
INSERT INTO VISIT (visit_id, 
                visit_date_time, 
                visit_length, 
                visit_notes, 
                visit_weight, 
                visit_total_cost, 
                animal_id, 
                vet_id,
                clinic_id, 
                from_visit_id) 
VALUES (
visit_pk_seq.NEXTVAL,
TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI'),
30,
NULL,
NULL,
NULL,
(
    SELECT ANIMAL_ID FROM ANIMAL 
    WHERE upper(ANIMAL_NAME) = upper('Oreo') AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
    AND ATYPE_ID = (
        SELECT ATYPE_ID 
        FROM ANIMAL_TYPE 
        WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
        )
    AND OWNER_ID = 
        (
            SELECT OWNER_ID 
            FROM OWNER 
            WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
            AND upper(OWNER_FAMILYNAME) = 'JONES')
),
(
    SELECT VET_ID 
    FROM VET 
    WHERE upper(VET_GIVENNAME) = upper('Anna') 
    AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
),
3,
NULL
);

-- Visit Service
INSERT INTO VISIT_SERVICE (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST)
VALUES
(visit_pk_seq.CURRVAL, 'S001', NULL);  -- NUll set as price because pricing not yet finalized

commit;






/*(c)*/

UPDATE VISIT_SERVICE
SET SERVICE_CODE = 
(
    SELECT SERVICE_CODE 
    FROM SERVICE 
    WHERE upper(SERVICE_DESC) = upper('ear infection treatment')
)
, 
VISIT_SERVICE_LINECOST = 
(
    
    SELECT SERVICE_STD_COST
    FROM SERVICE 
    WHERE upper(SERVICE_DESC) = upper('ear infection treatment')

)
WHERE visit_id = (
    SELECT VISIT_ID 
    FROM VISIT 
    WHERE VET_ID = (
        SELECT VET_ID 
        FROM VET 
        WHERE upper(VET_GIVENNAME) = upper('Anna') 
        AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
    )
    AND ANIMAL_ID = (
        SELECT ANIMAL_ID FROM ANIMAL 
        WHERE upper(ANIMAL_NAME) = upper('Oreo') 
            AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
            AND ATYPE_ID = (
                SELECT ATYPE_ID 
                FROM ANIMAL_TYPE 
                WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
                )
            AND OWNER_ID = 
                (
                    SELECT OWNER_ID 
                    FROM OWNER 
                    WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
                    AND upper(OWNER_FAMILYNAME) = 'JONES')
    )
    AND 
    VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
);

INSERT INTO VISIT_DRUG (VISIT_ID, DRUG_ID, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST)
VALUES
(
    (
        SELECT VISIT_ID 
        FROM VISIT 
        WHERE VET_ID = (
            SELECT VET_ID 
            FROM VET 
            WHERE upper(VET_GIVENNAME) = upper('Anna') 
            AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
        )
        AND ANIMAL_ID = (
            SELECT ANIMAL_ID FROM ANIMAL 
            WHERE upper(ANIMAL_NAME) = upper('Oreo') 
                AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND ATYPE_ID = (
                    SELECT ATYPE_ID 
                    FROM ANIMAL_TYPE 
                    WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
                    )
                AND OWNER_ID = 
                    (
                        SELECT OWNER_ID 
                        FROM OWNER 
                        WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
                        AND upper(OWNER_FAMILYNAME) = 'JONES')
        )
        AND 
        VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
    ),
    (
        SELECT DRUG_ID 
        FROM DRUG 
        WHERE upper(DRUG_NAME) = upper('Clotrimazole')
    ),
    1,
    1,
    1,
    (
        SELECT DRUG_STD_COST 
        FROM DRUG 
        WHERE upper(DRUG_NAME) = upper('Clotrimazole')
    )
);


UPDATE VISIT
SET VISIT_TOTAL_COST = 
(
    (
    SELECT SUM(VISIT_SERVICE_LINECOST)
    FROM VISIT_SERVICE
    WHERE VISIT_ID = (
        SELECT VISIT_ID 
        FROM VISIT 
        WHERE VET_ID = (
            SELECT VET_ID 
            FROM VET 
            WHERE upper(VET_GIVENNAME) = upper('Anna') 
            AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
        )
        AND ANIMAL_ID = (
            SELECT ANIMAL_ID FROM ANIMAL 
            WHERE upper(ANIMAL_NAME) = upper('Oreo') 
                AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND ATYPE_ID = (
                    SELECT ATYPE_ID 
                    FROM ANIMAL_TYPE 
                    WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
                    )
                AND OWNER_ID = 
                    (
                        SELECT OWNER_ID 
                        FROM OWNER 
                        WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
                        AND upper(OWNER_FAMILYNAME) = 'JONES')
        )
        AND 
        VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
    )
    group by VISIT_ID
    )
    +
    (
    SELECT SUM(VISIT_DRUG_LINECOST)
    FROM VISIT_DRUG
    WHERE VISIT_ID = (
        SELECT VISIT_ID 
        FROM VISIT 
        WHERE VET_ID = (
            SELECT VET_ID 
            FROM VET 
            WHERE upper(VET_GIVENNAME) = upper('Anna') 
            AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
        )
        AND ANIMAL_ID = (
            SELECT ANIMAL_ID FROM ANIMAL 
            WHERE upper(ANIMAL_NAME) = upper('Oreo') 
                AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
                AND ATYPE_ID = (
                    SELECT ATYPE_ID 
                    FROM ANIMAL_TYPE 
                    WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
                    )
                AND OWNER_ID = 
                    (
                        SELECT OWNER_ID 
                        FROM OWNER 
                        WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
                        AND upper(OWNER_FAMILYNAME) = 'JONES')
        )
        AND 
        
        VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
    )
    group by VISIT_ID
    )
)
WHERE VISIT_ID = (
    SELECT VISIT_ID 
    FROM VISIT 
    WHERE VET_ID = (
        SELECT VET_ID 
        FROM VET 
        WHERE upper(VET_GIVENNAME) = upper('Anna') 
        AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
    )
    AND ANIMAL_ID = (
        SELECT ANIMAL_ID FROM ANIMAL 
        WHERE upper(ANIMAL_NAME) = upper('Oreo') 
            AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
            AND ATYPE_ID = (
                SELECT ATYPE_ID 
                FROM ANIMAL_TYPE 
                WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
                )
            AND OWNER_ID = 
                (
                    SELECT OWNER_ID 
                    FROM OWNER 
                    WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
                    AND upper(OWNER_FAMILYNAME) = 'JONES')
    )
    AND 
    VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
);

-- ADD next visit

INSERT INTO VISIT (visit_id, 
                visit_date_time, 
                visit_length, 
                visit_notes, 
                visit_weight, 
                visit_total_cost, 
                animal_id, 
                vet_id, 
                clinic_id, 
                from_visit_id)
VALUES (
    visit_pk_seq.NEXTVAL,
    TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI') + 7,
    30,
    NULL,
    NULL,
    NULL,
    (
    SELECT ANIMAL_ID FROM ANIMAL 
    WHERE upper(ANIMAL_NAME) = upper('Oreo') AND ANIMAL_BORN = TO_DATE('2018-06-01', 'YYYY-MM-DD')
    AND ATYPE_ID = (
        SELECT ATYPE_ID 
        FROM ANIMAL_TYPE 
        WHERE upper(ATYPE_DESCRIPTION) = upper('Rabbit')
        )
    AND OWNER_ID = 
        (
            SELECT OWNER_ID 
            FROM OWNER 
            WHERE upper(OWNER_GIVENNAME) = upper('Jack') 
            AND upper(OWNER_FAMILYNAME) = 'JONES')
    ),
    (
    SELECT VET_ID 
    FROM VET 
    WHERE upper(VET_GIVENNAME) = upper('Anna') 
    AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
),
3,
(
    SELECT VISIT_ID
    FROM VISIT 
    WHERE VET_ID = (
        SELECT VET_ID 
        FROM VET 
        WHERE upper(VET_GIVENNAME) = upper('Anna') 
        AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
    )
    AND
    VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI')
    )
);

-- Visit Service
INSERT INTO VISIT_SERVICE (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST)
SELECT visit_pk_seq.CURRVAL, SERVICE_CODE, NULL  -- pricing not yet finalized
FROM SERVICE 
WHERE upper(SERVICE_DESC) = upper('ear infection treatment');


commit;




/*(d)*/

DELETE FROM VISIT_SERVICE
WHERE VISIT_ID = (
    SELECT VISIT_ID 
    FROM VISIT 
    WHERE VET_ID = (
        SELECT VET_ID 
        FROM VET 
        WHERE upper(VET_GIVENNAME) = upper('Anna') 
        AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
    )
    AND 
    VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI') + 7
);

DELETE FROM VISIT
WHERE VISIT_ID = (
    SELECT VISIT_ID 
    FROM VISIT 
    WHERE VET_ID = (
        SELECT VET_ID 
        FROM VET 
        WHERE upper(VET_GIVENNAME) = upper('Anna') 
        AND upper(VET_FAMILYNAME) = upper('KOWALSKI')
    )
    AND 
    VISIT_DATE_TIME = TO_DATE('2024-05-19 14:00', 'YYYY-MM-DD HH24:MI') + 7
);

commit;
