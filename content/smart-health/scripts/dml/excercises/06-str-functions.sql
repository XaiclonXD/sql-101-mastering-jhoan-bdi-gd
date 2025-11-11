-- ##################################################
-- # CONSULTAS UPPER, LOWER, CONCAT, LENGTH, SUBSTRING - SMART HEALTH #
-- ##################################################

-- 1. Mostrar el nombre completo de todos los pacientes en mayúsculas,
-- junto con la longitud total de su nombre completo,
-- ordenados por la longitud del nombre de mayor a menor.
-- Dificultad: BAJA
SELECT
    UPPER(CONCAT(T1.first_name, ' ', T1.last_name)) AS nombre_completo_mayus,
    LENGTH(CONCAT(T1.first_name, ' ', T1.last_name)) AS longitud_nombre
FROM smart_health.patients T1
ORDER BY longitud_nombre DESC;


-- 2. Listar todos los médicos mostrando su nombre en minúsculas,
-- su apellido en mayúsculas, y el correo electrónico profesional
-- con el dominio extraído después del símbolo '@'.
-- Dificultad: BAJA
SELECT
    LOWER(T1.first_name) AS nombre_minusculas,
    UPPER(T1.last_name) AS apellido_mayusculas,
    SPLIT_PART(T1.email, '@', 2) AS dominio_email
FROM smart_health.doctors T1
ORDER BY apellido_mayusculas;


-- 3. Obtener los nombres comerciales de todos los medicamentos en formato título
-- (primera letra mayúscula), junto con las primeras 3 letras del código ATC,
-- y la longitud del principio activo.
-- Dificultad: BAJA-INTERMEDIA
SELECT
    INITCAP(T1.medication_name) AS nombre_comercial_titulo,
    SUBSTRING(T1.atc_code, 1, 3) AS codigo_atc_parcial,
    LENGTH(T1.active_substance) AS longitud_principio_activo
FROM smart_health.medications T1
ORDER BY nombre_comercial_titulo;


-- 4. Mostrar el nombre completo de los pacientes concatenado con su tipo de documento,
-- las iniciales del paciente en mayúsculas (primera letra del nombre y apellido),
-- y los últimos 4 dígitos de su número de documento.
-- Dificultad: INTERMEDIA
SELECT
    CONCAT(T1.first_name, ' ', T1.last_name, ' - ', T2.type_name) AS nombre_y_documento,
    UPPER(SUBSTRING(T1.first_name, 1, 1) || SUBSTRING(T1.last_name, 1, 1)) AS iniciales,
    RIGHT(T1.document_number, 4) AS ultimos_4_digitos
FROM smart_health.patients T1
JOIN smart_health.document_types T2 ON T1.document_type_id = T2.document_type_id
ORDER BY T1.last_name;


-- 5. Listar las especialidades médicas mostrando el nombre en mayúsculas,
-- los primeros 10 caracteres de la descripción, la longitud total de la descripción,
-- y un código generado con las primeras 3 letras de la especialidad en mayúsculas.
-- Dificultad: INTERMEDIA
SELECT
    UPPER(T1.specialty_name) AS especialidad_mayus,
    SUBSTRING(T1.description, 1, 10) AS descripcion_corta,
    LENGTH(T1.description) AS longitud_descripcion,
    UPPER(SUBSTRING(T1.specialty_name, 1, 3)) AS codigo_especialidad
FROM smart_health.specialties T1
ORDER BY especialidad_mayus;


-- 6. Obtener información de las citas mostrando el nombre del paciente en formato título,
-- el tipo de cita en minúsculas, el motivo con solo los primeros 20 caracteres,
-- y un código de referencia concatenando el ID de la cita con las iniciales del doctor.
-- Dificultad: INTERMEDIA-ALTA
SELECT
    INITCAP(CONCAT(T2.first_name, ' ', T2.last_name)) AS nombre_paciente,
    LOWER(T1.appointment_type) AS tipo_cita,
    SUBSTRING(T1.reason, 1, 20) AS motivo_resumido,
    CONCAT('REF-', T1.appointment_id, '-', 
           UPPER(SUBSTRING(T3.first_name, 1, 1)), 
           UPPER(SUBSTRING(T3.last_name, 1, 1))) AS codigo_referencia
FROM smart_health.appointments T1
JOIN smart_health.patients T2 ON T1.patient_id = T2.patient_id
JOIN smart_health.doctors T3 ON T1.doctor_id = T3.doctor_id
ORDER BY T1.appointment_id DESC;


-- 7. Mostrar las direcciones completas concatenando todos sus componentes,
-- el código del municipio en mayúsculas, los primeros 5 caracteres de la línea de dirección,
-- la longitud de la dirección completa, y el código postal formateado en minúsculas,
-- junto con el nombre del municipio y departamento en formato título.
-- Dificultad: ALTA
SELECT
    CONCAT(T1.address_line, ', ', T2.city_name, ', ', T3.department_name) AS direccion_completa,
    UPPER(T2.city_code) AS codigo_municipio,
    SUBSTRING(T1.address_line, 1, 5) AS direccion_corta,
    LENGTH(CONCAT(T1.address_line, ', ', T2.city_name, ', ', T3.department_name)) AS longitud_direccion,
    LOWER(T1.postal_code) AS codigo_postal,
    INITCAP(T2.city_name) AS municipio_titulo,
    INITCAP(T3.department_name) AS departamento_titulo
FROM smart_health.addresses T1
JOIN smart_health.cities T2 ON T1.city_id = T2.city_id
JOIN smart_health.departments T3 ON T2.department_id = T3.department_id
ORDER BY T2.city_name;

-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################