/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-pf-json.sql

--Student ID: 32837011
--Student Name: Cheah Jit Yung


/* Comments for your marker:




*/

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE 
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    JSON_OBJECT ( '_id' VALUE v_s.clinic_id,
                 'name' VALUE clinic_name,
                 'address' VALUE clinic_address,
                 'phone' VALUE clinic_phone,
                 'head_vet' VALUE JSON_OBJECT (
                                'id' VALUE h_vet_id,
                                'name' VALUE h_VET_GIVENNAME
                                || ' '
                                || h_VET_FAMILYNAME),
                 'no_of_vets' VALUE COUNT ( v_s.vet_id ),
                 'vets' VALUE JSON_ARRAYAGG (
                    JSON_OBJECT (
                        'id' VALUE v_s.vet_id,
                        'name' VALUE v_s.VET_GIVENNAME
                        || ' '
                        || v_s.VET_FAMILYNAME,
                        'specialisation' VALUE SPEC_DESCRIPTION
                    )
                 )

    FORMAT JSON )
    || ','
FROM
(  
    -- Vet with filtered specialisation
    (   
        SELECT clinic_id, vet_id, VET_FAMILYNAME, VET_GIVENNAME, SPEC_DESCRIPTION
        FROM VET
        JOIN SPECIALISATION ON vet.SPEC_ID = SPECIALISATION.SPEC_ID

        UNION

        SELECT clinic_id, vet_id, VET_FAMILYNAME, VET_GIVENNAME, 'N/A' AS SPEC_DESCRIPTION
        FROM VET
        WHERE SPEC_ID IS NULL
    ) v_s

    JOIN

    -- Clinic with head vet
    (
        SELECT clinic.*, h_vet_id, h_vet_givenname, h_vet_familyname
        FROM clinic
        JOIN (
            SELECT vet_id AS h_vet_id, VET_GIVENNAME AS h_vet_givenname, VET_FAMILYNAME AS h_vet_familyname
            FROM vet
        ) ON clinic.VET_ID = h_vet_id
    ) c_v

    ON v_s.clinic_id = c_v.clinic_id
)
GROUP BY
    v_s.clinic_id,
    clinic_name,
    clinic_address,
    clinic_phone,
    h_vet_id,
    h_VET_GIVENNAME,
    h_VET_FAMILYNAME
;
