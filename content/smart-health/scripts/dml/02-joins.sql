-- La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar
--  la localización geográfica, mostrando los 15 primeros resultados.

-- INNER JOIN
-- 1. Tablas asociadas
-- smart_health.municipalities T1
-- smart_health.departments T2

-- 2. Llaves de cruce
-- T1.department_code
-- T2.department_code
SELECT
    T1.municipality_code AS codigo_municipio,
    T1.municipality_name AS municipio,
    T2.department_name AS departamento

FROM municipalities T1
INNER JOIN departments T2 ON T1.department_code = T2.department_code
ORDER BY T2.department_name
LIMIT 15;

-- Contar los pacientes que tengan o no tengan
-- un numero de telefono asociado.

-- RIGTH JOIN
-- 1. Tablas asociadas
-- smart_health.patients T1
-- smart_health.patients_phones T2

-- 2. Llaves de cruce
-- T1.patient_id
-- T2.patient_id
SELECT
    COUNT(DISTINCT T1.patient_id)
FROM patient_phones T1
RIGHT JOIN patients T2 ON T1.patient_id = T2.patient_id;

-- 3.

-- Contar los doctores que no tengan una especialidad.
SELECT
    COUNT(*)
FROM doctor_specialties T1
LEFT JOIN  doctors T2 ON T1.doctor_id = T2.doctor_id
WHERE T1.specialty_id= NULL;



-- 4. Mostrar las citas que se haya cancelado
-- entre el 20 de octubre del 2025 y el 23 de octubre del 2025.
-- Adicionalmente, es importante conocer, en que cuarto se iban 
-- a atender estas citas. Y la razon de la cancelacion si la hay.
-- Mostrar solo los 10 primeros registros.
-- Rehabilitación
SELECT
    T1.appointment_date,
    T2.room_name,
    T1.appointment_type,
    T1.reason

FROM appointments T1
INNER JOIN rooms T2 ON T1.room_id = T2.room_id
WHERE appointment_date BETWEEN '2025-10-20' AND '2025-10-23'
AND T1.status = 'Cancelled'
ORDER BY T2.room_name
LIMIT 10;

-- -- 3️⃣ La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar la localización 
-- geográfica, mostrando los 15 primeros resultados.




-- Obtener los pacientes (primer nombre, genero, correo), con sus numeros de telefono
-- que tengan los siguientes numeros de documentos

-- '1006631391',
-- '1009149871',
-- '1298083',
-- '1004928596',
-- '1008188849',
-- '1607132',
-- '30470003'

-- INNER JOIN

-- smart_health.patients : patient_id (PK)
-- smart_health.patient_phones : patient_id (FK)

-- primer nombre
-- genero
-- correo
-- numero_telefono
SELECT
    A.first_name AS primer_nombre,
    A.gender AS genero,
    A.email AS correo,
    B.phone_number AS numero_telefono

FROM smart_health.patients A
INNER JOIN smart_health.patient_phones B 
    ON A.patient_id = B.patient_id
WHERE A.document_number IN
(
    '1006631391',
    '1009149871',
    '1298083',
    '1004928596',
    '1008188849',
    '1607132',
    '30470003'  
);

-- Obtener los pacientes (primer nombre, genero, correo), con sus numeros de telefono
-- que tengan los siguientes numeros de documentos.
-- tengan o no tengan un numero de telefono asociado.

-- '1006631391',
-- '1009149871',
-- '1298083',
-- '1004928596',
-- '1008188849',
-- '1607132',
-- '30470003'

-- RIGTH JOIN

-- smart_health.patients : patient_id (PK)
-- smart_health.patient_phones : patient_id (FK)

-- primer nombre
-- genero
-- correo
-- numero_telefono
SELECT
    B.first_name AS primer_nombre,
    B.gender AS genero,
    B.email AS correo,
    A.phone_number AS numero_telefono

FROM smart_health.patient_phones  A
RIGHT JOIN smart_health.patients B 
    ON A.patient_id = B.patient_id
WHERE B.document_number IN
(
    '30451580',
    '1006631391',
    '1009149871',
    '1298083',
    '1004928596',
    '1008188849',
    '1607132',
    '30470003'  
);

-- Obtener cuantos medicos, no tienen una direccion
-- asociada.

-- LEFT JOIN

-- smart_health.doctors: doctor_id (PK)
-- smart_health.doctor_addresses: doctor_id (PK)
SELECT
    COUNT(*) AS total_doctores_sin_direccion

FROM smart_health.doctors A
LEFT JOIN smart_health.doctor_addresses B
    ON A.doctor_id = B.doctor_id
WHERE B.doctor_id IS NULL;


-- Mostrar direccion, genero, nombre_completo, municipio, direccion
-- viven en pamplona
-- ordenar por primer nombre
-- mostrar 5

SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.gender AS genero,
    T1.blood_type AS tipo_sangre,
    T2.address_type AS tipo_direccion,
    T3.address_line AS direccion,
    T3.postal_code AS codigo_postal,
    T4.municipality_name AS ciudad,
    T5.department_name AS departamento

FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.addresses T3
    ON T3.address_id = T2.address_id
INNER JOIN smart_health.municipalities T4
    ON T4.municipality_code = T3.municipality_code
INNER JOIN smart_health.departments T5
    ON T5.department_code = T4.department_code
WHERE T4.municipality_name LIKE '%PAMPLONA%'
ORDER BY T1.first_name
LIMIT 5;

--1. Obtener los nombres, apellidos y número de documento de los pacientes 
--junto con el nombre del tipo de documento al que pertenecen.

-- INNER JOIN
-- 1. Tablas asociadas
-- smart_health.patients (T1)
-- smart_health.document_types (T2)

-- 2. Llaves de cruce
-- T1.document_type_id = T2.document_type_id

SELECT
    T1.first_name AS nombre,
    T1.first_surname AS apellido,
    T1.document_number AS numero_documento,
    T2.document_type_name AS tipo_documento

FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id;

--2. Listar los nombres de los municipios y las direcciones registradas en cada uno, 
--de manera que se muestren todos los municipios, incluso los que no tengan direcciones asociadas.

-- LEFT JOIN
-- 1. Tablas asociadas
-- smart_health.municipalities (T1)
-- smart_health.addresses (T2)

-- 2. Llaves de cruce
-- T1.municipality_code = T2.municipality_code

SELECT
    T1.municipality_name AS municipio,
    T2.address_line AS direccion

FROM smart_health.municipalities T1
LEFT JOIN smart_health.addresses T2
    ON T1.municipality_code = T2.municipality_code
ORDER BY T1.municipality_name;

--3. Consultar las citas médicas junto con el nombre y apellido del médico asignado,
-- filtrando solo las citas con estado “Confirmed”.

-- INNER JOIN
-- 1. Tablas asociadas
-- smart_health.appointments (T1)
-- smart_health.doctors (T2)

-- 2. Llaves de cruce
-- T1.doctor_id = T2.doctor_id

SELECT
    T1.appointment_id AS codigo_cita,
    T1.appointment_date AS fecha_cita,
    T1.status AS estado,
    T2.first_name || ' ' || T2.first_surname AS medico

FROM smart_health.appointments T1
INNER JOIN smart_health.doctors T2
    ON T1.doctor_id = T2.doctor_id
WHERE T1.status = 'Confirmed'
ORDER BY T1.appointment_date DESC;


--4. Mostrar los nombres y apellidos de los pacientes junto con su dirección principal, 
--de forma que aparezcan también los pacientes sin dirección registrada.

-- LEFT JOIN
-- 1. Tablas asociadas
-- smart_health.patients (T1)
-- smart_health.patient_addresses (T2)
-- smart_health.addresses (T3)

-- 2. Llaves de cruce
-- T1.patient_id = T2.patient_id
-- T2.address_id = T3.address_id

SELECT
    T1.first_name || ' ' || T1.first_surname AS paciente,
    T3.address_line AS direccion_principal

FROM smart_health.patients T1
LEFT JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
LEFT JOIN smart_health.addresses T3
    ON T2.address_id = T3.address_id
ORDER BY T1.first_name;


--5. Agrupar los pacientes por tipo de sangre y mostrar la cantidad de tipos de sangre que tienen cada uno.

-- GROUP BY
-- 1. Tabla: smart_health.patients

-- La consulta cuenta cuántos pacientes pertenecen a cada tipo de sangre.
-- Se muestra primero la cantidad (count) y luego el tipo de sangre.
-- Los resultados se ordenan de mayor a menor cantidad.

SELECT
    COUNT(*) AS count,
    blood_type
FROM smart_health.patients
GROUP BY blood_type
ORDER BY count DESC;
