/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-pf-insert.sql

--Student ID: 32837011
--Student Name: Cheah Jit Yung

/* Comments for your marker:




*/


--------------------------------------
--INSERT INTO visit
--------------------------------------
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (1, TO_DATE('2024-04-08 13:00', 'YYYY-MM-DD HH24:MI'), 61, 'Revisit recommended', 40, 369.99, 1, 1001, 1, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (2, TO_DATE('2024-04-07 13:00', 'YYYY-MM-DD HH24:MI'), 40, 'Revisit recommended', 30, 464.99, 2, 1003, 2, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (3, TO_DATE('2024-06-10 13:00', 'YYYY-MM-DD HH24:MI'), 41, NULL, NULL, NULL, 1, 1001, 1, 1);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (4, TO_DATE('2024-04-11 13:00', 'YYYY-MM-DD HH24:MI'), 69, 'In a more stable condition than visit', 33, 569.99, 2, 1003, 2, 2);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (5, TO_DATE('2024-04-12 14:00', 'YYYY-MM-DD HH24:MI'), 86, 'Revisit recommended', 50, 484.99, 6, 1004, 3, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (6, TO_DATE('2024-04-13 14:00', 'YYYY-MM-DD HH24:MI'), 90, 'Gained too much weight compared to previous visit', 57, 429.99, 6, 1004, 3, 5);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (7, TO_DATE('2024-04-14 14:00', 'YYYY-MM-DD HH24:MI'), 60, 'Animal is Healthy', 35, 150, 3, 1001, 1, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (8, TO_DATE('2024-04-15 15:00', 'YYYY-MM-DD HH24:MI'), 58, 'Animal is Healthy', 200, 520, 10, 1003, 2, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (9, TO_DATE('2024-04-16 15:00', 'YYYY-MM-DD HH24:MI'), 39, NULL, 50, 135, 4, 1003, 2, NULL);
INSERT INTO visit (visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id) VALUES (10, TO_DATE('2024-06-17 15:00', 'YYYY-MM-DD HH24:MI'), 30, NULL, NULL, NULL, 5, 1004, 3, NULL);

--------------------------------------
--INSERT INTO visit_service
--------------------------------------
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (1, 'S001', 60);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (1, 'S011', 90);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (2, 'S002', 45);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (2, 'S011', 200);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (4, 'S004', 150);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (4, 'S014', 200);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (5, 'S005', 125);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (5, 'S015', 140);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (6, 'S006', 80);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (6, 'S016', 130);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (7, 'S007', 50);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (7, 'S017', 100);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (8, 'S008', 400);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (8, 'S018', 120);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (9, 'S009', 85);
INSERT INTO visit_service (visit_id, SERVICE_CODE, VISIT_SERVICE_LINECOST) VALUES (9, 'S019', 50);

--------------------------------------
--INSERT INTO visit_drug
--------------------------------------
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (1, 101, 5, 2, 10, 120);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (1, 102, 1, 1, 1, 99.99);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (2, 101, 5, 2, 10, 120);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (2, 102, 1, 1, 1, 99.99);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (4, 101, 5, 2, 10, 120);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (4, 102, 1, 1, 1, 99.99);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (5, 101, 5, 2, 10, 120);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (5, 102, 1, 1, 1, 99.99);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (6, 101, 5, 2, 10, 120);
INSERT INTO visit_drug (visit_id, drug_id, VISIT_DRUG_DOSE, VISIT_DRUG_FREQUENCY, VISIT_DRUG_QTYSUPPLIED, VISIT_DRUG_LINECOST) VALUES (6, 102, 1, 1, 1, 99.99);

COMMIT;