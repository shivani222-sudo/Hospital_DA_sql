create database hospital_analysis;
use hospital_analysis;

CREATE TABLE PATIENT (
    patient_id VARCHAR(10) PRIMARY KEY,  
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    address VARCHAR(255),
    registration_date DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(50),
    email VARCHAR(100)
);


CREATE TABLE DOCTORS (
    doctor_id VARCHAR(10) PRIMARY KEY, 
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    phone_number VARCHAR(20),
    years_experience INT,
    hospital_branch VARCHAR(50),
    email VARCHAR(100)
);
CREATE TABLE TREATMENTS (
    treatment_id VARCHAR(10) PRIMARY KEY,   
    appointment_id VARCHAR(10),             
    treatment_type VARCHAR(50),
    description VARCHAR(255),
    cost DECIMAL(10,2),
    treatment_date DATE
);

CREATE TABLE BILLING(
bill_id VARCHAR(40) PRIMARY KEY,
patient_id VARCHAR(10),
treatment_id VARCHAR(10),
bill_date DATE,
amount DECIMAL(10,2),
payment_method VARCHAR(60),
payment_status VARCHAR(60),
FOREIGN KEY(PATIENT_ID) REFERENCES PATIENT(PATIENT_ID),
FOREIGN KEY(TREATMENT_ID) REFERENCES TREATMENTS(TREATMENT_ID));
