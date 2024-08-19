-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2024-05-02 00:38:51 SGT
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c

-- Capture run of script in file called custorders_schema_output.txt
set echo on
SPOOL pat_schema_output.txt

--student id: 33369003, 32669747, 32837011
--student name: Khadija Hafiz, Chua Xian Loong, Cheah Jit Yung

DROP TABLE driver CASCADE CONSTRAINTS;

DROP TABLE driver_language CASCADE CONSTRAINTS;

DROP TABLE driver_training_module CASCADE CONSTRAINTS;

DROP TABLE feature CASCADE CONSTRAINTS;

DROP TABLE language CASCADE CONSTRAINTS;

DROP TABLE location CASCADE CONSTRAINTS;

DROP TABLE noc CASCADE CONSTRAINTS;

DROP TABLE official CASCADE CONSTRAINTS;

DROP TABLE training CASCADE CONSTRAINTS;

DROP TABLE trip CASCADE CONSTRAINTS;

DROP TABLE vehicle CASCADE CONSTRAINTS;

DROP TABLE vehicle_details CASCADE CONSTRAINTS;

DROP TABLE vehicle_feature CASCADE CONSTRAINTS;

DROP TABLE vehicle_make CASCADE CONSTRAINTS;

DROP TABLE vehicle_model CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE driver (
    driver_id             NUMBER(4) NOT NULL,
    driver_family_name    VARCHAR2(50) NOT NULL,
    driver_given_name     VARCHAR2(50) NOT NULL,
    driver_license_no     NUMBER(18) NOT NULL,
    driver_dob            DATE NOT NULL,
    driver_security       CHAR(1) DEFAULT 'R' NOT NULL,
    driver_is_suspended   CHAR(1),
    driver_training_count NUMBER(2) NOT NULL
);

ALTER TABLE driver
    ADD CONSTRAINT chk_driversecurity CHECK ( driver_security IN ( 'F', 'R' ) );

ALTER TABLE driver
    ADD CONSTRAINT chk_driversuspended CHECK ( driver_is_suspended IN ( 'F', 'T' ) );

COMMENT ON COLUMN driver.driver_id IS
    'Driver ID';

COMMENT ON COLUMN driver.driver_family_name IS
    'Driver''s family name';

COMMENT ON COLUMN driver.driver_given_name IS
    'Driver''s given name';

COMMENT ON COLUMN driver.driver_license_no IS
    'Driver license number';

COMMENT ON COLUMN driver.driver_dob IS
    'driver date of birth';

COMMENT ON COLUMN driver.driver_security IS
    'Driver''s security clearance, R -  Restricted, F - Full';

COMMENT ON COLUMN driver.driver_is_suspended IS
    'Check is driver suspended, T - True, F - False';

COMMENT ON COLUMN driver.driver_training_count IS
    'count of driver completed training modules';

ALTER TABLE driver ADD CONSTRAINT driver_pk PRIMARY KEY ( driver_id );

CREATE TABLE driver_language (
    driver_id NUMBER(4) NOT NULL,
    l_iso     VARCHAR2(10) NOT NULL
);

COMMENT ON COLUMN driver_language.driver_id IS
    'Driver ID';

COMMENT ON COLUMN driver_language.l_iso IS
    'Language ISO Code';

ALTER TABLE driver_language ADD CONSTRAINT driver_language_pk PRIMARY KEY ( driver_id,
                                                                            l_iso );

CREATE TABLE driver_training_module (
    dtm_id             NUMBER(5) NOT NULL,
    training_code      CHAR(7) NOT NULL,
    dtm_date_completed DATE NOT NULL,
    driver_id          NUMBER(4) NOT NULL
);

COMMENT ON COLUMN driver_training_module.dtm_id IS
    'surrogate key';

COMMENT ON COLUMN driver_training_module.training_code IS
    'training code';

COMMENT ON COLUMN driver_training_module.dtm_date_completed IS
    'date of training module completion';

COMMENT ON COLUMN driver_training_module.driver_id IS
    'Driver ID';

ALTER TABLE driver_training_module ADD CONSTRAINT driver_training_module_nk PRIMARY KEY ( dtm_id );

ALTER TABLE driver_training_module
    ADD CONSTRAINT driver_training_module_pk UNIQUE ( training_code,
                                                      dtm_date_completed,
                                                      driver_id );

CREATE TABLE feature (
    feature_id   NUMBER(4) NOT NULL,
    feature_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN feature.feature_id IS
    'feature id';

COMMENT ON COLUMN feature.feature_name IS
    'feature name';

ALTER TABLE feature ADD CONSTRAINT feature_pk PRIMARY KEY ( feature_id );

CREATE TABLE language (
    l_iso  VARCHAR2(10) NOT NULL,
    l_name VARCHAR2(15) NOT NULL
);

COMMENT ON COLUMN language.l_iso IS
    'Language ISO Code';

COMMENT ON COLUMN language.l_name IS
    'language name';

ALTER TABLE language ADD CONSTRAINT language_pk PRIMARY KEY ( l_iso );

CREATE TABLE location (
    location_id      NUMBER(4) NOT NULL,
    location_name    VARCHAR2(50) NOT NULL,
    location_type    VARCHAR2(50) NOT NULL,
    location_address VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN location.location_id IS
    'Location ID';

COMMENT ON COLUMN location.location_name IS
    'Location name ';

COMMENT ON COLUMN location.location_type IS
    'Location type';

COMMENT ON COLUMN location.location_address IS
    'Location address';

ALTER TABLE location ADD CONSTRAINT location_pk PRIMARY KEY ( location_id );

CREATE TABLE noc (
    noc_ioc_code   CHAR(3) NOT NULL,
    noc_name       VARCHAR2(50) NOT NULL,
    noc_population NUMBER(4) NOT NULL
);

COMMENT ON COLUMN noc.noc_ioc_code IS
    'IOC code';

COMMENT ON COLUMN noc.noc_name IS
    'NOC name';

COMMENT ON COLUMN noc.noc_population IS
    'noc population';

ALTER TABLE noc ADD CONSTRAINT noc_pk PRIMARY KEY ( noc_ioc_code );

CREATE TABLE official (
    off_id       VARCHAR2(7) NOT NULL,
    off_name     VARCHAR2(50) NOT NULL,
    off_role     VARCHAR2(50),
    noc_ioc_code CHAR(3) NOT NULL,
    off_id1      VARCHAR2(7)
);

COMMENT ON COLUMN official.off_id IS
    'official id';

COMMENT ON COLUMN official.off_name IS
    'official name';

COMMENT ON COLUMN official.off_role IS
    'official role';

COMMENT ON COLUMN official.noc_ioc_code IS
    'IOC code';

COMMENT ON COLUMN official.off_id1 IS
    'official id';

ALTER TABLE official ADD CONSTRAINT official_pk PRIMARY KEY ( off_id );

CREATE TABLE training (
    training_code   CHAR(7) NOT NULL,
    training_name   VARCHAR2(50) NOT NULL,
    training_desc   VARCHAR2(100) NOT NULL,
    training_expiry NUMBER(2),
    training_length NUMBER(2) NOT NULL
);

COMMENT ON COLUMN training.training_code IS
    'training code';

COMMENT ON COLUMN training.training_name IS
    'module name';

COMMENT ON COLUMN training.training_desc IS
    'training_description';

COMMENT ON COLUMN training.training_expiry IS
    'training expiry period';

COMMENT ON COLUMN training.training_length IS
    'training duration (days)';

ALTER TABLE training ADD CONSTRAINT training_pk PRIMARY KEY ( training_code );

CREATE TABLE trip (
    trip_id                        CHAR(4) NOT NULL,
    trip_passenger_number          NUMBER(2) NOT NULL,
    trip_intended_pickup_datetime  DATE NOT NULL,
    trip_actual_pickup_datetime    DATE,
    trip_intended_dropoff_datetime DATE NOT NULL,
    trip_actual_dropoff_datetime   DATE,
    off_id                         VARCHAR2(7) NOT NULL,
    vehicle_vin                    CHAR(17) NOT NULL,
    driver_id                      NUMBER(4) NOT NULL,
    l_iso                          VARCHAR2(10) NOT NULL,
    location_id                    NUMBER(4) NOT NULL,
    location_id1                   NUMBER(4) NOT NULL
);

COMMENT ON COLUMN trip.trip_id IS
    'trip code';

COMMENT ON COLUMN trip.trip_passenger_number IS
    'num passenger';

COMMENT ON COLUMN trip.trip_intended_pickup_datetime IS
    'intended pickup datetime';

COMMENT ON COLUMN trip.trip_actual_pickup_datetime IS
    'actual pickup datetime';

COMMENT ON COLUMN trip.trip_intended_dropoff_datetime IS
    'intended dropoff datetime';

COMMENT ON COLUMN trip.trip_actual_dropoff_datetime IS
    'actual dropoff datetime';

COMMENT ON COLUMN trip.off_id IS
    'official id';

COMMENT ON COLUMN trip.vehicle_vin IS
    'vin num';

COMMENT ON COLUMN trip.driver_id IS
    'Driver ID';

COMMENT ON COLUMN trip.l_iso IS
    'Language ISO Code';

COMMENT ON COLUMN trip.location_id IS
    'Location ID';

COMMENT ON COLUMN trip.location_id1 IS
    'Location ID';

ALTER TABLE trip ADD CONSTRAINT trip_pk PRIMARY KEY ( trip_id,
                                                      vehicle_vin );

CREATE TABLE vehicle (
    vehicle_vin      CHAR(17) NOT NULL,
    vehicle_lp       CHAR(7) NOT NULL,
    vehicle_status   CHAR(1) NOT NULL,
    vehicle_capacity NUMBER(2) NOT NULL,
    vehicle_year     CHAR(4) NOT NULL,
    vehicle_odometer VARCHAR2(7) NOT NULL,
    vehicle_model_id NUMBER(4) NOT NULL
);

ALTER TABLE vehicle
    ADD CONSTRAINT vehicle_availability CHECK ( vehicle_status IN ( 'F', 'T' ) );

COMMENT ON COLUMN vehicle.vehicle_vin IS
    'vin num';

COMMENT ON COLUMN vehicle.vehicle_lp IS
    'license plate num';

COMMENT ON COLUMN vehicle.vehicle_status IS
    'Vehicle''s availability, T - Available, F - Not Available';

COMMENT ON COLUMN vehicle.vehicle_capacity IS
    'vehicle''s capacity';

COMMENT ON COLUMN vehicle.vehicle_year IS
    'Vehicle year';

COMMENT ON COLUMN vehicle.vehicle_odometer IS
    'Vehicle odometer';

COMMENT ON COLUMN vehicle.vehicle_model_id IS
    'model_id';

ALTER TABLE vehicle ADD CONSTRAINT vehicle_pk PRIMARY KEY ( vehicle_vin );

CREATE TABLE vehicle_details (
    vehicle_model_id NUMBER(4) NOT NULL,
    vehicle_make_id  NUMBER(4) NOT NULL
);

COMMENT ON COLUMN vehicle_details.vehicle_model_id IS
    'model_id';

COMMENT ON COLUMN vehicle_details.vehicle_make_id IS
    'vehicle make id';

ALTER TABLE vehicle_details ADD CONSTRAINT vehicle_model_pk PRIMARY KEY ( vehicle_model_id );

CREATE TABLE vehicle_feature (
    vehicle_vin CHAR(17) NOT NULL,
    feature_id  NUMBER(4) NOT NULL
);

COMMENT ON COLUMN vehicle_feature.vehicle_vin IS
    'vin num';

COMMENT ON COLUMN vehicle_feature.feature_id IS
    'feature id';

ALTER TABLE vehicle_feature ADD CONSTRAINT feature_pkv1 PRIMARY KEY ( vehicle_vin,
                                                                      feature_id );

CREATE TABLE vehicle_make (
    vehicle_make_id NUMBER(4) NOT NULL,
    vehicle_make    VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN vehicle_make.vehicle_make_id IS
    'vehicle make id';

COMMENT ON COLUMN vehicle_make.vehicle_make IS
    'vehicle make';

ALTER TABLE vehicle_make ADD CONSTRAINT vehicle_make_pk PRIMARY KEY ( vehicle_make_id );

CREATE TABLE vehicle_model (
    vehicle_model_id   NUMBER(4) NOT NULL,
    vehicle_model_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN vehicle_model.vehicle_model_id IS
    'model_id';

COMMENT ON COLUMN vehicle_model.vehicle_model_name IS
    'model name';

ALTER TABLE vehicle_model ADD CONSTRAINT vehicle_model_pkv1 PRIMARY KEY ( vehicle_model_id );

ALTER TABLE driver_language
    ADD CONSTRAINT driver_language_fk FOREIGN KEY ( driver_id )
        REFERENCES driver ( driver_id );

ALTER TABLE driver_training_module
    ADD CONSTRAINT driver_training_fk FOREIGN KEY ( driver_id )
        REFERENCES driver ( driver_id );

ALTER TABLE trip
    ADD CONSTRAINT driver_trip_fk FOREIGN KEY ( driver_id )
        REFERENCES driver ( driver_id );

ALTER TABLE vehicle_feature
    ADD CONSTRAINT feature_vehicle_feature_fk FOREIGN KEY ( feature_id )
        REFERENCES feature ( feature_id );

ALTER TABLE driver_language
    ADD CONSTRAINT language_driver_fk FOREIGN KEY ( l_iso )
        REFERENCES language ( l_iso );

ALTER TABLE trip
    ADD CONSTRAINT language_trip_fk FOREIGN KEY ( l_iso )
        REFERENCES language ( l_iso );

ALTER TABLE trip
    ADD CONSTRAINT location_trip FOREIGN KEY ( location_id )
        REFERENCES location ( location_id );

ALTER TABLE official
    ADD CONSTRAINT noc_official_fk FOREIGN KEY ( noc_ioc_code )
        REFERENCES noc ( noc_ioc_code );

ALTER TABLE official
    ADD CONSTRAINT official_chef_fk FOREIGN KEY ( off_id1 )
        REFERENCES official ( off_id );

ALTER TABLE trip
    ADD CONSTRAINT official_trip_fk FOREIGN KEY ( off_id )
        REFERENCES official ( off_id );

ALTER TABLE trip
    ADD CONSTRAINT relation_20 FOREIGN KEY ( location_id1 )
        REFERENCES location ( location_id );

ALTER TABLE driver_training_module
    ADD CONSTRAINT training_module_fk FOREIGN KEY ( training_code )
        REFERENCES training ( training_code );

ALTER TABLE vehicle_feature
    ADD CONSTRAINT vehicle_feature_fk FOREIGN KEY ( vehicle_vin )
        REFERENCES vehicle ( vehicle_vin );

ALTER TABLE vehicle_details
    ADD CONSTRAINT vehicle_make_vehicle_model_fk FOREIGN KEY ( vehicle_make_id )
        REFERENCES vehicle_make ( vehicle_make_id );

ALTER TABLE vehicle
    ADD CONSTRAINT vehicle_model_fk FOREIGN KEY ( vehicle_model_id )
        REFERENCES vehicle_details ( vehicle_model_id );

ALTER TABLE vehicle_details
    ADD CONSTRAINT vehicle_model_vehicle_fk FOREIGN KEY ( vehicle_model_id )
        REFERENCES vehicle_model ( vehicle_model_id );

ALTER TABLE trip
    ADD CONSTRAINT vehicle_trip_fk FOREIGN KEY ( vehicle_vin )
        REFERENCES vehicle ( vehicle_vin );

SPOOL off
set echo off

-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             0
-- ALTER TABLE                             36
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
