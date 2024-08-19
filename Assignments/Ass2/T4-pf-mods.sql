/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T4-pf-mods.sql

--Student ID: 32837011
--Student Name: Cheah Jit Yung


/* Comments for your marker:

I assume that the outstanding amount can be worked out using query,
The specs specifies the need to indicate whether there's an outstanding, but not the outstanding amount.
Thus, I have added a binary value to indicate whether there's an outstanding payment or not,
but not a outstanding amount column.
(which can be queried if needed).

*/

/*(a)*/

-- UPDATE SERVICE TABLE WITH A NEW COLUMN COUNT_NON_STD_PRICING

-- PREVIEW OF TABLE BEFORE CHANGE, only 3 columns
select * from SERVICE;
DESC SERVICE;

ALTER TABLE SERVICE
ADD COUNT_NON_STD_PRICING NUMBER(5) DEFAULT 0 NOT NULL;

UPDATE SERVICE s
SET COUNT_NON_STD_PRICING = (
    SELECT COUNT(*)
    FROM VISIT_SERVICE vs
    WHERE vs.VISIT_SERVICE_LINECOST <> s.SERVICE_STD_COST
    AND vs.SERVICE_CODE = s.SERVICE_CODE
);

COMMENT ON COLUMN SERVICE.COUNT_NON_STD_PRICING IS
    'Number of visits with non-standard pricing for this service';

commit;

-- a new column is added to service table (4 columns total and ROW COUNT is not affected)
select * from SERVICE;
DESC SERVICE;

/*(b)*/



-- structure of visit table before adding column 'STILL_OUTSTANDING'
SELECT * FROM VISIT;
DESC VISIT;

-- THIS binary value is used to determine outstanding payment or not, and it is mainly for efficiency (instead of needing to query all values in the database again)
ALTER TABLE VISIT
ADD STILL_OUTSTANDING CHAR(1) DEFAULT 'Y' NOT NULL; 

-- ADD CONSTRAINT FOR BINARY VALUE
ALTER TABLE VISIT
    ADD CONSTRAINT STILL_OUTSTANDING_CHK CHECK (STILL_OUTSTANDING IN ('Y', 'N'));

-- all current visits don't have outstanding (Could use the sysdate here but it will affect the result of the query)
UPDATE VISIT
SET STILL_OUTSTANDING = 'N'
WHERE VISIT_TOTAL_COST IS NOT NULL
;

-- structure of visit table after adding column 'STILL_OUTSTANDING' (1 additional column)
SELECT * FROM VISIT;
DESC VISIT;


DROP TABLE PAYMENT_METHOD CASCADE CONSTRAINTS PURGE;
DROP TABLE PAYMENT CASCADE CONSTRAINTS PURGE;

CREATE TABLE PAYMENT_METHOD(
    PAYMENT_METHOD_ID NUMBER(2) NOT NULL,
    PAYMENT_METHOD_NAME VARCHAR2(20) NOT NULL
);


COMMENT ON COLUMN PAYMENT_METHOD.PAYMENT_METHOD_ID IS
    'Payment method identifier';

COMMENT ON COLUMN PAYMENT_METHOD.PAYMENT_METHOD_NAME IS
    'Payment method name';

ALTER TABLE
    PAYMENT_METHOD ADD CONSTRAINT PAYMENT_METHOD_PK PRIMARY KEY (PAYMENT_METHOD_ID);

CREATE TABLE PAYMENT (
    VISIT_ID NUMBER(5) NOT NULL,
    PAYMENT_DATETIME DATE NOT NULL,  -- TO TRACK THE LAST INSTALLMENT DATE (IF APPLICABLE)
    PAYMENT_AMOUNT NUMBER(6,2) NOT NULL,  -- 6 derived from table VISIT
    PAYMENT_METHOD_ID NUMBER(2) NOT NULL
);

COMMENT ON COLUMN PAYMENT.VISIT_ID IS
    'Identifier for visit';

COMMENT ON COLUMN PAYMENT.PAYMENT_DATETIME IS
    'Date and time of payment';

COMMENT ON COLUMN PAYMENT.PAYMENT_AMOUNT IS
    'Amount paid';

COMMENT ON COLUMN PAYMENT.PAYMENT_METHOD_ID IS
    'Payment method identifier';

ALTER TABLE
    PAYMENT ADD CONSTRAINT PAYMENT_PK PRIMARY KEY (VISIT_ID, PAYMENT_DATETIME);

ALTER TABLE PAYMENT
    ADD CONSTRAINT VISIT_PAYMENT_FK FOREIGN KEY (VISIT_ID) 
    REFERENCES VISIT(VISIT_ID);

ALTER TABLE PAYMENT
    ADD CONSTRAINT PAYMENT_METHOD_PAYMENT_FK FOREIGN KEY (PAYMENT_METHOD_ID) 
    REFERENCES PAYMENT_METHOD(PAYMENT_METHOD_ID);

-- added two tables (payment_method serves as lookup table)
desc payment_method;
desc payment;


-- TO LIMIT CHANCE OF PENALTY, PERHAPS USE SEQUENCE?

DROP SEQUENCE payment_method_pk_seq;

CREATE SEQUENCE payment_method_pk_seq
START WITH 1
INCREMENT BY 1;

INSERT INTO PAYMENT_METHOD VALUES (payment_method_pk_seq.NEXTVAL, 'Historical');

-- CREATE PAYMENT FOR PAID visits
INSERT INTO PAYMENT 
    (VISIT_ID, PAYMENT_DATETIME, PAYMENT_AMOUNT, PAYMENT_METHOD_ID)
    SELECT VISIT_ID, VISIT_DATE_TIME, VISIT_TOTAL_COST, payment_method_pk_seq.CURRVAL
    FROM VISIT
    WHERE STILL_OUTSTANDING = 'N'
;

INSERT INTO PAYMENT_METHOD VALUES (payment_method_pk_seq.NEXTVAL, 'Card');
INSERT INTO PAYMENT_METHOD VALUES (payment_method_pk_seq.NEXTVAL, 'Cash');


select * from payment;

commit;