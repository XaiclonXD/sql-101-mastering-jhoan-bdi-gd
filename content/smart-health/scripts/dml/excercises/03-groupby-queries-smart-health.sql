-- ##################################################
-- # CONSULTAS CON JOINS Y AGREGACIÓN - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes están registrados por cada tipo de documento,
-- mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- ordenados por cantidad de mayor a menor.

-- INNER JOIN
-- smart_health.patients: FK (document_type_id)
-- smart_health.document_types: PK(document_type_id)
-- AGGREGATION FUNCTION: COUNT
SELECT
    T2.type_name AS tipo_documento,
    COUNT(*) AS total_documentos


FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;




-- 2. Obtener la cantidad de citas programadas por cada médico,
-- mostrando el nombre completo del doctor y el total de citas,
-- filtrando solo médicos con más de 5 citas, ordenados por cantidad descendente.

SELECT
    (T1.first_name || ' ' || T1.last_name) AS nombre_doctor,
    COUNT(T2.appointment_id) AS total_citas
FROM smart_health.doctors T1
JOIN smart_health.appointments T2
  ON T1.doctor_id = T2.doctor_id
GROUP BY nombre_doctor
HAVING COUNT(T2.appointment_id) > 5
ORDER BY total_citas DESC;


-- 3. Contar cuántas especialidades tiene cada médico activo,
-- mostrando el nombre del doctor y el número total de especialidades,
-- ordenados por cantidad de especialidades de mayor a menor.

SELECT
    (T1.first_name || ' ' || T1.last_name) AS nombre_doctor,
    COUNT(T2.specialty_id) AS total_especialidades
FROM smart_health.doctors T1
JOIN smart_health.doctor_specialties T2
  ON T1.doctor_id = T2.doctor_id
WHERE T2.is_active = TRUE
GROUP BY nombre_doctor
ORDER BY total_especialidades DESC;


-- 4. Calcular cuántos pacientes residen en cada departamento,
-- mostrando el nombre del departamento y la cantidad total de pacientes,
-- filtrando solo departamentos con al menos 3 pacientes, ordenados alfabéticamente.

SELECT
    T4.department_name AS departamento,
    COUNT(DISTINCT T1.patient_id) AS total_pacientes
FROM smart_health.patient_addresses T1
JOIN smart_health.addresses T2
  ON T1.address_id = T2.address_id
JOIN smart_health.municipalities T3
  ON T2.municipality_code = T3.municipality_code
JOIN smart_health.departments T4
  ON T3.department_code = T4.department_code
GROUP BY T4.department_name
HAVING COUNT(DISTINCT T1.patient_id) >= 3
ORDER BY T4.department_name ASC;


-- 5. Contar cuántas citas ha tenido cada paciente por estado de cita,
-- mostrando el nombre del paciente, estado de la cita y cantidad,
-- ordenados por nombre de paciente y estado.

SELECT
    (T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, '')) AS nombre_paciente,
    T2.status AS estado_cita,
    COUNT(T2.appointment_id) AS total_citas
FROM smart_health.patients T1
JOIN smart_health.appointments T2
  ON T1.patient_id = T2.patient_id
GROUP BY nombre_paciente, T2.status
ORDER BY nombre_paciente ASC, T2.status ASC;


-- 6. Calcular cuántos registros médicos ha realizado cada doctor,
-- mostrando el nombre del doctor y el total de registros,
-- filtrando solo doctores con más de 10 registros, ordenados por cantidad descendente.

SELECT
    (T1.first_name || ' ' || T1.last_name) AS nombre_doctor,
    COUNT(T2.medical_record_id) AS total_registros
FROM smart_health.doctors T1
JOIN smart_health.medical_records T2
  ON T1.doctor_id = T2.doctor_id
GROUP BY nombre_doctor
HAVING COUNT(T2.medical_record_id) > 10
ORDER BY total_registros DESC;


-- 7. Contar cuántas prescripciones se han emitido para cada medicamento,
-- mostrando el nombre comercial del medicamento y el total de prescripciones,
-- filtrando medicamentos con al menos 2 prescripciones, ordenados por cantidad descendente.

SELECT
    T1.commercial_name AS medicamento,
    COUNT(T2.prescription_id) AS total_prescripciones
FROM smart_health.medications T1
JOIN smart_health.prescriptions T2
  ON T1.medication_id = T2.medication_id
GROUP BY T1.commercial_name
HAVING COUNT(T2.prescription_id) >= 2
ORDER BY total_prescripciones DESC;


-- 8. Calcular cuántos pacientes tienen alergias por cada medicamento,
-- mostrando el nombre del medicamento y la cantidad de pacientes alérgicos,
-- ordenados por cantidad de mayor a menor.

SELECT
    T2.commercial_name AS medicamento,
    COUNT(DISTINCT T1.patient_id) AS pacientes_alergicos
FROM smart_health.patient_allergies T1
JOIN smart_health.medications T2
  ON T1.medication_id = T2.medication_id
GROUP BY T2.commercial_name
ORDER BY pacientes_alergicos DESC;


-- 9. Contar cuántas direcciones tiene registrado cada paciente,
-- mostrando el nombre del paciente y el total de direcciones,
-- filtrando solo pacientes con más de 1 dirección, ordenados por cantidad descendente.

SELECT
    (T2.first_name || ' ' || COALESCE(T2.middle_name || ' ', '') || T2.first_surname || ' ' || COALESCE(T2.second_surname, '')) AS nombre_paciente,
    COUNT(T1.address_id) AS total_direcciones
FROM smart_health.patient_addresses T1
JOIN smart_health.patients T2
  ON T1.patient_id = T2.patient_id
GROUP BY nombre_paciente
HAVING COUNT(T1.address_id) > 1
ORDER BY total_direcciones DESC;


-- 10. Calcular cuántas salas de cada tipo están activas en el hospital,
-- mostrando el tipo de sala y la cantidad total,
-- filtrando solo tipos con al menos 2 salas, ordenados por cantidad descendente.

SELECT
    T1.room_type AS tipo_sala,
    COUNT(T1.room_id) AS total_salas
FROM smart_health.rooms T1
WHERE T1.active = TRUE
GROUP BY T1.room_type
HAVING COUNT(T1.room_id) >= 2
ORDER BY total_salas DESC;


-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################