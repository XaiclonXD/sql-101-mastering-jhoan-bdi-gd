--1. Contar cuantos pacientes estan registrados por tipo de documentos,
--mostrando el nombre del tipo de documento y la cantidad total de pacientes,
--ordenados por cantidad mayor o menor

--smart_health.patients: FK (document_type_id)
--smart_health.document_types: PK (document_type_id)
--AGREGATION FUNTION: COUNT
SELECT 
    T2.type_name AS tipo_documento,
    COUNT(*) AS total_documentos


FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;

--Calcule el promedio de edad 
SELECT 
    AVG(EXTRACT(YEAR FROM AGE(birth_date))) AS avg_years
FROM smart_health.patients;

--primera y ultima cita con nombre completo
SELECT
    T1.first_name 
    MAX(appointment_date)  
FROM smart_health.patient T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id
GROUP BY T1.first_name
LIMIT 1;


--TOPPPPPP 5 PACIENTES MAS VIEJOS
SELECT 
    first_name||' '||second_surname
    AVG(EXTRACT(YEAR FROM birth_date)) AS avg_years

FROM smart_health.patient
GROUP BY birth_date 
ORDER BY age DESC
LIMIT 5

-- ##################################################
-- # CONSULTAS GROUP BY QUERIES - SMART HEALTH #
-- ##################################################

-- # 1. Contar cuántos pacientes están registrados por tipo de documento
-- # Mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- # ordenados por cantidad de mayor a menor.

-- smart_health.patients: FK (document_type_id)
-- smart_health.document_types: PK (document_type_id)
-- AGGREGATION FUNCTION: COUNT

SELECT 
    T2.type_name AS tipo_documento,
    COUNT(*) AS total_pacientes
FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_pacientes DESC;

-- # 2. Mostrar el número de citas programadas por cada médico,
-- # incluyendo el nombre completo del doctor y el total de citas,
-- # ordenadas alfabéticamente por apellido del médico.

-- smart_health.appointments: FK (appointment_id)
-- smart_health.attends: FK (doctor_id, appointment_id)
-- smart_health.doctors: PK (doctor_id)
-- AGGREGATION FUNCTION: COUNT

SELECT 
    CONCAT(T3.surnames, ' ', T3.names) AS nombre_completo_doctor,
    COUNT(T1.appointment_id) AS total_citas
FROM smart_health.appointments T1
INNER JOIN smart_health.attends T2
    ON T1.appointment_id = T2.appointment_id
INNER JOIN smart_health.doctors T3
    ON T2.doctor_id = T3.doctor_id
GROUP BY T3.surnames, T3.names
ORDER BY T3.surnames ASC;

-- # 3. Calcular el promedio de edad de los pacientes agrupados por género,
-- # mostrando el género y la edad promedio redondeada a dos decimales.

-- smart_health.patients: ATTRIBUTES (gender, birth_date)
-- AGGREGATION FUNCTION: AVG

SELECT 
    T1.gender AS genero,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, T1.birth_date, CURDATE())), 2) AS edad_promedio
FROM smart_health.patients T1
GROUP BY T1.gender;

-- # 4. Obtener el número total de prescripciones realizadas por cada medicamento,
-- # mostrando el nombre comercial, el principio activo y la cantidad de veces prescrito,
-- # solo para medicamentos con al menos 5 prescripciones.

-- smart_health.prescription: PK (prescription_id)
-- smart_health.dosage: FK (prescription_id, medication_id)
-- smart_health.medication: PK (medication_id)
-- AGGREGATION FUNCTION: COUNT

SELECT 
    T3.commercial_name AS nombre_medicamento,
    T3.active_ingredient AS principio_activo,
    COUNT(T1.prescription_id) AS total_prescripciones
FROM smart_health.prescription T1
INNER JOIN smart_health.dosage T2
    ON T1.prescription_id = T2.prescription_id
INNER JOIN smart_health.medication T3
    ON T2.medication_id = T3.medication_id
GROUP BY T3.commercial_name, T3.active_ingredient
HAVING COUNT(T1.prescription_id) >= 5
ORDER BY total_prescripciones DESC;

-- # 5. Listar el número de citas por estado y tipo de cita,
-- # mostrando cuántas citas existen para cada combinación,
-- # ordenadas primero por estado y luego por cantidad de mayor a menor,
-- # incluyendo solo aquellas combinaciones que tengan más de 3 citas.

-- smart_health.appointments: ATTRIBUTES (status, appointment_type)
-- AGGREGATION FUNCTION: COUNT

SELECT 
    T1.status AS estado_cita,
    T1.appointment_type AS tipo_cita,
    COUNT(T1.appointment_id) AS total_citas
FROM smart_health.appointments T1
GROUP BY T1.status, T1.appointment_type
HAVING COUNT(T1.appointment_id) > 3
ORDER BY T1.status ASC, total_citas DESC;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################