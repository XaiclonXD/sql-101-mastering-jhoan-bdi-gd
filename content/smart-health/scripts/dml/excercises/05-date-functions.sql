-- ##################################################
-- # CONSULTAS DATEPART, NOW, CURRENT_DATE, EXTRACT, AGE, INTERVAL - SMART HEALTH #
-- ##################################################

-- 1. Obtener todos los pacientes que nacieron en el mes actual,
-- mostrando su nombre completo, fecha de nacimiento y edad actual en años.
-- Dificultad: BAJA
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS nombre_completo,
    p.birth_date AS fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) AS edad_actual
FROM smart_health.patients p
WHERE EXTRACT(MONTH FROM p.birth_date) = EXTRACT(MONTH FROM CURRENT_DATE)
ORDER BY p.birth_date;


-- 2. Listar todas las citas programadas para los próximos 7 días,
-- mostrando la fecha de la cita, el nombre del paciente, el nombre del doctor,
-- y cuántos días faltan desde hoy hasta la cita.
-- Dificultad: BAJA
SELECT
    a.appointment_date AS fecha_cita,
    CONCAT(p.first_name, ' ', p.last_name) AS paciente,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor,
    (a.appointment_date::date - CURRENT_DATE) AS dias_restantes
FROM smart_health.appointments a
JOIN smart_health.patients p ON a.patient_id = p.patient_id
JOIN smart_health.doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date::date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '7 days')
ORDER BY a.appointment_date;


-- 3. Mostrar todos los médicos que ingresaron al hospital hace más de 5 años,
-- incluyendo su nombre completo, fecha de ingreso, y la cantidad exacta de años,
-- meses y días que han trabajado en el hospital.
-- Dificultad: BAJA-INTERMEDIA
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS nombre_completo,
    d.hire_date AS fecha_ingreso,
    AGE(CURRENT_DATE, d.hire_date) AS tiempo_trabajado
FROM smart_health.doctors d
WHERE d.hire_date <= (CURRENT_DATE - INTERVAL '5 years')
ORDER BY d.hire_date;


-- 4. Obtener las prescripciones emitidas en el último mes,
-- mostrando la fecha de prescripción, el nombre del medicamento,
-- el nombre del paciente, cuántos días han pasado desde la prescripción,
-- y el día de la semana en que fue prescrito.
-- Dificultad: INTERMEDIA
SELECT
    pr.prescription_date AS fecha_prescripcion,
    m.medication_name AS medicamento,
    CONCAT(p.first_name, ' ', p.last_name) AS paciente,
    (CURRENT_DATE - pr.prescription_date::date) AS dias_transcurridos,
    TO_CHAR(pr.prescription_date, 'Day') AS dia_semana
FROM smart_health.prescriptions pr
JOIN smart_health.medications m ON pr.medication_id = m.medication_id
JOIN smart_health.patients p ON pr.patient_id = p.patient_id
WHERE pr.prescription_date >= (CURRENT_DATE - INTERVAL '1 month')
ORDER BY pr.prescription_date DESC;


-- 5. Listar todos los pacientes registrados en el sistema durante el trimestre actual,
-- mostrando su nombre completo, fecha de registro, edad actual,
-- el trimestre de registro, y cuántas semanas han pasado desde su registro,
-- ordenados por fecha de registro más reciente primero.
-- Dificultad: INTERMEDIA
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS nombre_completo,
    p.registration_date AS fecha_registro,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) AS edad_actual,
    CEIL(EXTRACT(MONTH FROM p.registration_date) / 3.0) AS trimestre_registro,
    ROUND((CURRENT_DATE - p.registration_date::date) / 7, 1) AS semanas_transcurridas
FROM smart_health.patients p
WHERE DATE_PART('quarter', p.registration_date) = DATE_PART('quarter', CURRENT_DATE)
ORDER BY p.registration_date DESC;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################