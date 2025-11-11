-- ##################################################
-- #   CONSULTAS CON JOINS - SMART HEALTH          #
-- ##################################################

-- 1. Listar todos los pacientes con su tipo de documento correspondiente,
-- mostrando el nombre completo del paciente, número de documento y nombre del tipo de documento,
-- ordenados por apellido del paciente.
SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.document_number AS numero_documento,
    T2.type_name AS tipo_documento

FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
ORDER BY T1.first_surname
LIMIT 10; 


-- 2. Consultar todas las citas médicas con la información del paciente y del doctor asignado,
-- mostrando nombres completos, fecha y hora de la cita,
-- ordenadas por fecha de cita de forma descendente.

SELECT
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS paciente,
    T1.appointment_date AS fecha_cita,
    T1.start_time AS hora_inicio_cita,
    T1.end_time AS hora_fin_cita,
    'Dr. '||' '||T3.first_name||' '||COALESCE(T3.last_name, '') AS doctor_asignado,
    T3.internal_code AS codigo_medico

FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
ORDER BY T1.appointment_date DESC
LIMIT 10;


-- 3. Obtener todas las direcciones de pacientes con información completa del municipio y departamento,
-- mostrando el nombre del paciente, dirección completa y ubicación geográfica,
-- ordenadas por departamento y municipio.

SELECT
    T1.patient_id,
    (P.first_name || ' ' || COALESCE(P.middle_name || ' ', '') || P.first_surname || ' ' || COALESCE(P.second_surname, '')) AS nombre_paciente,
    A.address_line || ', CP ' || A.postal_code || ', ' || M.municipality_name || ', ' || D.department_name AS direccion_completa,
    M.municipality_name AS municipio,
    D.department_name AS departamento
FROM smart_health.patient_addresses T1
JOIN smart_health.patients P
  ON T1.patient_id = P.patient_id
JOIN smart_health.addresses A
  ON T1.address_id = A.address_id
JOIN smart_health.municipalities M
  ON A.municipality_code = M.municipality_code
JOIN smart_health.departments D
  ON M.department_code = D.department_code
WHERE A.active = TRUE
ORDER BY D.department_name ASC, M.municipality_name ASC;

-- 4. Listar todos los médicos con sus especialidades asignadas,
-- mostrando el nombre del doctor, especialidad y fecha de certificación,
-- filtrando solo especialidades activas y ordenadas por apellido del médico.

SELECT
    T1.doctor_id,
    (T1.first_name || ' ' || COALESCE(T1.professional_email, '') || ' ' || T1.last_name) AS nombre_doctor,
    S.specialty_name AS especialidad,
    DS.certification_date AS fecha_certificacion
FROM smart_health.doctors T1
JOIN smart_health.doctor_specialties DS
  ON T1.doctor_id = DS.doctor_id
JOIN smart_health.specialties S
  ON DS.specialty_id = S.specialty_id
WHERE DS.is_active = TRUE
ORDER BY T1.last_name ASC;
LIMIT 5;

-- [NO REALIZAR]
-- 5. Consultar todas las alergias de pacientes con información del medicamento asociado,
-- mostrando el nombre del paciente, medicamento, severidad y descripción de la reacción,
-- filtrando solo alergias graves o críticas, ordenadas por severidad.

SELECT
    P.patient_id,
    (P.first_name || ' ' || COALESCE(P.middle_name || ' ', '') || P.first_surname || ' ' || COALESCE(P.second_surname, '')) AS nombre_paciente,
    M.commercial_name AS medicamento,
    PA.severity AS severidad,
    PA.reaction_description AS descripcion_reaccion
FROM smart_health.patient_allergies PA
JOIN smart_health.patients P
  ON PA.patient_id = P.patient_id
LEFT JOIN smart_health.medications M
  ON PA.medication_id = M.medication_id
WHERE (
      PA.severity ILIKE '%grave%'
   OR PA.severity ILIKE '%critical%'
   OR PA.severity IN ('Severe','Critical','Grave','Crítica')
)
ORDER BY PA.severity DESC;

-- [NO REALIZAR]
-- 6. Obtener todos los registros médicos con el diagnóstico principal asociado,
-- mostrando el paciente, doctor que registró, diagnóstico y fecha del registro,
-- filtrando registros del último año, ordenados por fecha de registro descendente.

SELECT
    MR.medical_record_id,
    (PT.first_name || ' ' || COALESCE(PT.middle_name || ' ', '') || PT.first_surname || ' ' || COALESCE(PT.second_surname, '')) AS paciente,
    (DCT.first_name || ' ' || DCT.last_name) AS doctor_registrador,
    DG.icd_code AS codigo_diag,
    DG.description AS descripcion_diag,
    MR.registration_datetime AS fecha_registro
FROM smart_health.medical_records MR
JOIN smart_health.patients PT
  ON MR.patient_id = PT.patient_id
JOIN smart_health.doctors DCT
  ON MR.doctor_id = DCT.doctor_id
LEFT JOIN smart_health.diagnoses DG
  ON MR.primary_diagnosis_id = DG.diagnosis_id
WHERE MR.registration_datetime >= (CURRENT_DATE - INTERVAL '1 year')
ORDER BY MR.registration_datetime DESC;


-- 7. Listar todas las prescripciones médicas con información del medicamento y registro médico asociado,
-- mostrando el paciente, medicamento prescrito, dosis y si se generó alguna alerta,
-- filtrando prescripciones con alertas generadas, ordenadas por fecha de prescripción.

SELECT
    PR.prescription_id,
    (PT.first_name || ' ' || COALESCE(PT.middle_name || ' ', '') || PT.first_surname || ' ' || COALESCE(PT.second_surname, '')) AS paciente,
    M.commercial_name AS medicamento,
    PR.dosage AS dosis,
    PR.frequency AS frecuencia,
    PR.duration AS duracion,
    PR.alert_generated AS alerta,
    PR.prescription_date AS fecha_prescripcion
FROM smart_health.prescriptions PR
JOIN smart_health.medical_records MR
  ON PR.medical_record_id = MR.medical_record_id
JOIN smart_health.patients PT
  ON MR.patient_id = PT.patient_id
JOIN smart_health.medications M
  ON PR.medication_id = M.medication_id
WHERE PR.alert_generated = TRUE
ORDER BY PR.prescription_date DESC;

-- 8. Consultar todas las citas con información de la sala asignada (si tiene),
-- mostrando paciente, doctor, sala y horario,
-- usando LEFT JOIN para incluir citas sin sala asignada, ordenadas por fecha y hora.

SELECT
    A.appointment_id,
    (P.first_name || ' ' || COALESCE(P.middle_name || ' ', '') || P.first_surname || ' ' || COALESCE(P.second_surname, '')) AS paciente,
    (D.first_name || ' ' || D.last_name) AS doctor,
    R.room_name AS sala,
    A.appointment_date,
    A.start_time,
    A.end_time
FROM smart_health.appointments A
JOIN smart_health.patients P
  ON A.patient_id = P.patient_id
JOIN smart_health.doctors D
  ON A.doctor_id = D.doctor_id
LEFT JOIN smart_health.rooms R
  ON A.room_id = R.room_id
ORDER BY A.appointment_date ASC, A.start_time ASC;

-- 9. Listar todos los teléfonos de pacientes con información completa del paciente,
-- mostrando nombre, tipo de teléfono, número y si es el teléfono principal,
-- filtrando solo teléfonos móviles, ordenados por nombre del paciente.

SELECT
    PH.patient_phone_id,
    (PT.first_name || ' ' || COALESCE(PT.middle_name || ' ', '') || PT.first_surname || ' ' || COALESCE(PT.second_surname, '')) AS nombre_paciente,
    PH.phone_type AS tipo_telefono,
    PH.phone_number AS numero,
    PH.is_primary AS es_principal
FROM smart_health.patient_phones PH
JOIN smart_health.patients PT
  ON PH.patient_id = PT.patient_id
WHERE (PH.phone_type ILIKE '%mobile%' OR PH.phone_type ILIKE '%movil%' OR PH.phone_type ILIKE '%móvil%')
ORDER BY PT.first_name ASC, PT.first_surname ASC;

-- 10. Obtener todos los doctores que NO tienen especialidades asignadas (ANTI JOIN),
-- mostrando su información básica y fecha de ingreso,
-- útil para identificar médicos que requieren actualización de información,
-- ordenados por fecha de ingreso al hospital.

SELECT
    D.doctor_id,
    (D.first_name || ' ' || D.last_name) AS nombre_doctor,
    D.internal_code,
    D.hospital_admission_date AS fecha_ingreso
FROM smart_health.doctors D
WHERE NOT EXISTS (
    SELECT 1
    FROM smart_health.doctor_specialties DS
    WHERE DS.doctor_id = D.doctor_id
)
ORDER BY D.hospital_admission_date ASC;

-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################