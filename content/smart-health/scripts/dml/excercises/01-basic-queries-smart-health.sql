-- ##################################################
-- #     CONSULTAS DE PRÁCTICA - SMART HEALTH      #
-- ##################################################

-- 1. Listar todos los pacientes de género femenino registrados en el sistema,
-- mostrando su nombre completo, correo electrónico y fecha de nacimiento,
-- ordenados por apellido de forma ascendente.

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '') AS paciente,
    email AS correo_electronico,
    birth_date AS fecha_nacimiento
FROM smart_health.patients
WHERE gender = 'F'
ORDER BY first_name, first_surname
LIMIT 5;

-- 2. Consultar todos los médicos que ingresaron al hospital después del año 2020,
-- mostrando su código interno, nombre completo y fecha de admisión,
-- ordenados por fecha de ingreso de más reciente a más antiguo.

SELECT
    T1.internal_code AS codigo_interno,
    (T1.first_name || ' ' || T1.last_name) AS nombre_completo,
    T1.hospital_admission_date AS fecha_admision
FROM smart_health.doctors T1
WHERE T1.hospital_admission_date > DATE '2020-12-31'
ORDER BY T1.hospital_admission_date DESC;

-- 3. Obtener todas las citas médicas con estado 'Scheduled' (Programada),
-- mostrando la fecha, hora de inicio y motivo de la consulta,
-- ordenadas por fecha y hora de manera ascendente.

SELECT
  ap.appointment_date AS fecha,
  ap.start_time AS hora_inicio,
  ap.reason AS motivo_consulta
FROM smart_health.appointments ap
WHERE ap.status = 'Scheduled'    
ORDER BY ap.appointment_date ASC, ap.start_time ASC;


-- 4. Listar todos los medicamentos cuyo nombre comercial comience con la letra 'A',
-- mostrando el código ATC, nombre comercial y principio activo,
-- ordenados alfabéticamente por nombre comercial.

SELECT
    T1.atc_code AS codigo_atc,
    T1.commercial_name AS nombre_comercial,
    T1.active_ingredient AS principio_activo
FROM smart_health.medications T1
WHERE T1.commercial_name ILIKE 'A%'
ORDER BY T1.commercial_name ASC;


-- 5. Consultar todos los diagnósticos que contengan la palabra 'diabetes' en su descripción,
-- mostrando el código CIE-10 y la descripción completa,
-- ordenados por código de diagnóstico.

SELECT
    T1.icd_code AS codigo_cie10,
    T1.description AS descripcion
FROM smart_health.diagnoses T1
WHERE T1.description ILIKE '%diabetes%'
ORDER BY T1.icd_code ASC;

-- 6. Listar todas las salas de atención activas del hospital con capacidad mayor a 5 personas,
-- mostrando el nombre, tipo y ubicación de cada sala,
-- ordenadas por capacidad de mayor a menor.

SELECT
    T1.room_name AS nombre,
    T1.room_type AS tipo,
    T1.location AS ubicacion,
    T1.capacity AS capacidad
FROM smart_health.rooms T1
WHERE T1.active = TRUE
  AND T1.capacity > 5
ORDER BY T1.capacity DESC;

-- 7. Obtener todos los pacientes que tienen tipo de sangre O+ o O-,
-- mostrando su nombre completo, tipo de sangre y fecha de nacimiento,
-- ordenados por tipo de sangre y luego por apellido.

SELECT
    (T1.first_name || ' ' || T1.second_surname) AS nombre_completo,
    T1.blood_type AS tipo_sangre,
    T1.birth_date AS fecha_nacimiento
FROM smart_health.patients T1
WHERE T1.blood_type IN ('O+', 'O-')
ORDER BY T1.blood_type ASC, T1.second_surname ASC;
-- 8. Consultar todas las direcciones activas ubicadas en un municipio específico,
-- mostrando la línea de dirección, código postal y código del municipio,
-- ordenadas por código postal.

SELECT
    T1.address_line AS linea_direccion,
    T1.postal_code AS codigo_postal,
    T1.municipality_code AS codigo_municipio
FROM smart_health.addresses T1
WHERE T1.active = TRUE
  AND T1.municipality_code = '05001'
ORDER BY T1.postal_code ASC;

-- 9. Listar todas las prescripciones médicas realizadas en los últimos 30 días,
-- mostrando la dosis, frecuencia y duración del tratamiento,
-- ordenadas por fecha de prescripción de más reciente a más antigua.

SELECT
    T1.dosage AS dosis,
    T1.frequency AS frecuencia,
    T1.duration AS duracion,
    T1.prescription_date AS fecha_prescripcion
FROM smart_health.prescriptions T1
WHERE T1.prescription_date >= (CURRENT_DATE - INTERVAL '30 days')
ORDER BY T1.prescription_date DESC;


-- 10. Obtener todos los registros médicos de tipo 'historia inicial',
-- mostrando el resumen del registro, signos vitales y fecha de registro,
-- ordenados por fecha de registro descendente para visualizar los más recientes primero.

-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################