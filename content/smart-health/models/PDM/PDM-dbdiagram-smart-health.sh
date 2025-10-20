// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table patients {
  patient_id int [pk]
  first_name varchar
  middle_name varchar
  last_name varchar
  maternal_surname varchar
  birth_date date
  sex char
  email varchar
  registration_date date
  active boolean
}

Table patient_documents {
  document_number varchar
  issuing_country varchar
  issue_date date
  patient_id int [ref: > patients.patient_id]
}

Table patient_addresses {
  address_type varchar
  street_address varchar
  municipality varchar
  department varchar
  country_code varchar
  latitude varchar
  longitude varchar
  postal_code varchar
  patient_id int [ref: > patients.patient_id]
}

Table patient_phones {
  phone_type varchar
  phone_number varchar
  primary boolean
  patient_id int [ref: > patients.patient_id]
}

Table emergency_contacts {
  name varchar
  relationship varchar
  phone varchar
  email varchar
  instructions varchar
  patient_id int [ref: > patients.patient_id]
}

Table doctors {
  doctor_id int [pk]
  internal_code varchar
  license_number varchar
  first_name varchar
  last_name varchar
  professional_email varchar
  hospital_entry_date date
  active boolean
}

Table doctor_specialties {
  specialty_id int [pk]
  doctor_id int [ref: > doctors.doctor_id]
}

Table doctor_phones {
  phone_type varchar
  phone_number varchar
  doctor_id int [ref: > doctors.doctor_id]
}

Table doctor_addresses {
  address_type varchar
  department varchar
  municipality varchar
  address_text varchar
  service_hours varchar
  doctor_id int [ref: > doctors.doctor_id]
}

Table doctor_schedules {
  weekday varchar
  start_time timestamp
  end_time timestamp
  modality varchar
  doctor_id int [ref: > doctors.doctor_id]
}

Table appointments {
  appointment_id int [pk]
  date date
  start_time time
  end_time time
  care_type varchar
  status varchar
  room_id varchar
  reason varchar
  created_by varchar
  creation_date date
  patient_id int [ref: > patients.patient_id]
  doctor_id int [ref: > doctors.doctor_id]
}

Table medical_records {
  record_id int [pk]
  record_datetime datetime
  record_type varchar
  summary_text varchar
  structured_summary text
  doctor_id int [ref: > doctors.doctor_id]
  patient_id int [ref: > patients.patient_id]
}

Table prescriptions {
  prescription_id int [pk]
  dosage varchar
  frequency varchar
  duration varchar
  notes varchar
  record_id int [ref: > medical_records.record_id]
}

Table vital_signs {
  vital_sign_id int [pk]
  vital_type varchar
  value varchar
  unit varchar
  record_datetime datetime
  record_id int [ref: > medical_records.record_id]
}

Table diagnoses {
  diagnosis_id int [pk]
  icd_code varchar
  description varchar
  record_id int [ref: > medical_records.record_id]
}

Table medications {
  medication_id int [pk]
  atc_code varchar
  trade_name varchar
  active_principle varchar
  presentation varchar
  prescription_id int [ref: > prescriptions.prescription_id]
}

Table insurers {
  insurer_id int [pk]
  name varchar
  contact varchar
}

Table insurance_policies {
  policy_id int [pk]
  policy_number varchar
  coverage_summary varchar
  start_date date
  end_date date
  status varchar
  patient_id int [ref: > patients.patient_id]
  insurer_id int [ref: > insurers.insurer_id]
}
