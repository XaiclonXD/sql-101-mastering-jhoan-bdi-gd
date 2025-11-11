-- ##################################################
-- # CONSULTAS GROUP BY QUERIES AND AGG FUNCTIONS WITH DATE AND STRING FUNCTIONS LIKE DATEPART, SPLIT, AGE, INTERVAL, UPPER, LOWER AND SO ON, USING JOINS - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes nacieron en cada mes del año,
-- mostrando el número del mes y el nombre del mes en mayúsculas,
-- junto con la cantidad total de pacientes nacidos en ese mes.
-- Dificultad: BAJA

SELECT
    EXTRACT(MONTH FROM T1.birth_date) AS mes_numero,
    UPPER(TO_CHAR(T1.birth_date, 'Month')) AS mes_nombre,
    COUNT(*) AS total_pacientes
FROM smart_health.patients T1
GROUP BY mes_numero, mes_nombre
ORDER BY mes_numero;


-- 2. Mostrar el número de citas programadas agrupadas por día de la semana,
-- incluyendo el nombre del día en español y la cantidad de citas,
-- ordenadas por la cantidad de citas de mayor a menor.
-- Dificultad: BAJA

SELECT
    TO_CHAR(T1.appointment_date, 'ID')::INT AS dia_numero,
    INITCAP(TO_CHAR(T1.appointment_date, 'TMDay')) AS dia_semana,
    COUNT(*) AS total_citas
FROM smart_health.appointments T1
WHERE T1.status = 'Scheduled'
GROUP BY dia_numero, dia_semana
ORDER BY total_citas DESC;


-- 3. Calcular la cantidad de años promedio que los médicos han trabajado en el hospital,
-- agrupados por especialidad, mostrando el nombre de la especialidad en mayúsculas
-- y el promedio de años de experiencia redondeado a un decimal.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    UPPER(T2.specialty_name) AS especialidad,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, T1.admission_date))), 1) AS promedio_anios_experiencia
FROM smart_health.doctors T1
JOIN smart_health.doctor_specialties T3
  ON T1.doctor_id = T3.doctor_id
JOIN smart_health.specialties T2
  ON T3.specialty_id = T2.specialty_id
WHERE T3.is_active = TRUE
GROUP BY T2.specialty_name
ORDER BY promedio_anios_experiencia DESC;


-- 4. Obtener el número de pacientes registrados por año,
-- mostrando el año de registro, el trimestre, y el total de pacientes,
-- solo para aquellos trimestres que tengan más de 2 pacientes registrados.
-- Dificultad: INTERMEDIA

SELECT
    EXTRACT(YEAR FROM T1.registration_date) AS anio_registro,
    EXTRACT(QUARTER FROM T1.registration_date) AS trimestre,
    COUNT(*) AS total_pacientes
FROM smart_health.patients T1
GROUP BY anio_registro, trimestre
HAVING COUNT(*) > 2
ORDER BY anio_registro, trimestre;


-- 5. Listar el número de prescripciones emitidas por mes y año,
-- mostrando el mes en formato texto con la primera letra en mayúscula,
-- el año, y el total de prescripciones, junto con el nombre del medicamento más prescrito.
-- Dificultad: INTERMEDIA

SELECT
    INITCAP(TO_CHAR(T1.prescription_date, 'Month')) AS mes,
    EXTRACT(YEAR FROM T1.prescription_date) AS anio,
    COUNT(*) AS total_prescripciones,
    (
        SELECT T3.commercial_name
        FROM smart_health.prescriptions T4
        JOIN smart_health.medications T3
          ON T4.medication_id = T3.medication_id
        WHERE DATE_TRUNC('month', T4.prescription_date) = DATE_TRUNC('month', T1.prescription_date)
        GROUP BY T3.commercial_name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS medicamento_mas_prescrito
FROM smart_health.prescriptions T1
GROUP BY mes, anio, DATE_TRUNC('month', T1.prescription_date)
ORDER BY anio DESC, mes;


-- 6. Calcular la edad promedio de los pacientes agrupados por tipo de sangre,
-- mostrando el tipo de sangre, la edad mínima, la edad máxima y la edad promedio,
-- solo para grupos que tengan al menos 3 pacientes.
-- Dificultad: INTERMEDIA

SELECT
    T1.blood_type AS tipo_sangre,
    MIN(EXTRACT(YEAR FROM AGE(CURRENT_DATE, T1.birth_date))) AS edad_minima,
    MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, T1.birth_date))) AS edad_maxima,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, T1.birth_date))), 1) AS edad_promedio
FROM smart_health.patients T1
GROUP BY T1.blood_type
HAVING COUNT(*) >= 3
ORDER BY edad_promedio DESC;


-- 7. Mostrar el número de citas por médico y por mes,
-- incluyendo el nombre completo del doctor en mayúsculas, el mes y año de la cita,
-- la duración promedio de las citas en minutos, y el total de citas realizadas,
-- solo para aquellos médicos que tengan más de 5 citas en el mes.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    UPPER(T2.first_name || ' ' || T2.last_name) AS nombre_doctor,
    EXTRACT(YEAR FROM T1.appointment_date) AS anio,
    TO_CHAR(T1.appointment_date, 'Month') AS mes,
    ROUND(AVG(EXTRACT(EPOCH FROM (T1.end_time - T1.start_time)) / 60), 1) AS duracion_promedio_min,
    COUNT(*) AS total_citas
FROM smart_health.appointments T1
JOIN smart_health.doctors T2
  ON T1.doctor_id = T2.doctor_id
GROUP BY nombre_doctor, anio, mes
HAVING COUNT(*) > 5
ORDER BY anio DESC, mes, total_citas DESC;


-- 8. Obtener estadísticas de alergias por severidad y mes de diagnóstico,
-- mostrando la severidad en minúsculas, el nombre del mes abreviado,
-- el total de alergias registradas, y el número de pacientes únicos afectados,
-- junto con el nombre comercial del medicamento más común en cada grupo.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    LOWER(T1.severity) AS severidad,
    TO_CHAR(T1.diagnosis_date, 'Mon') AS mes_diagnostico,
    COUNT(*) AS total_alergias,
    COUNT(DISTINCT T1.patient_id) AS pacientes_unicos,
    (
        SELECT T3.commercial_name
        FROM smart_health.patient_allergies T4
        JOIN smart_health.medications T3
          ON T4.medication_id = T3.medication_id
        WHERE LOWER(T4.severity) = LOWER(T1.severity)
          AND DATE_TRUNC('month', T4.diagnosis_date) = DATE_TRUNC('month', T1.diagnosis_date)
        GROUP BY T3.commercial_name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS medicamento_mas_comun
FROM smart_health.patient_allergies T1
GROUP BY severidad, mes_diagnostico, DATE_TRUNC('month', T1.diagnosis_date)
ORDER BY total_alergias DESC;

-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################