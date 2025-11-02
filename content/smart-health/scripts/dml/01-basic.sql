-- Mostrar el nombre completo, correo y el genero de los pacientes  nacidas entre 
-- 1990 1993. Listar Las 5 primeras personas, ordenadas alfabeticament por
-- su primer nombre.

-- FROM: Pacientes --> smart_health.patientes ;
--front, condicion, ordenar, limit
SELECT 
    first_name||' '||first_surname AS fullname,
    gender,
    email,
    birth_date

FROM smart_health.patients
WHERE birth_date BETWEEN '1990-01-01' AND '1993-12-31'
ORDER BY first_name
LIMIT 5;

------------------------------------------------
--modificar consulta anterior. personas nacidas entre 2005 y 2008, y que el genero
--sea masculino o femenino, ordenar descendentemente por primer apellido, mostrar los primeros
--8 resultados

SELECT 
    first_name||' '||first_surname AS fullname,
    gender,
    email,
    birth_date

FROM smart_health.patients
WHERE birth_date BETWEEN '2005-01-01' AND '2008-12-31' 
AND  gender IN ('M') 
ORDER BY first_surname DESC
LIMIT 8;

------------------------------------------------
--Mostrar los medicamentos, que tienen un ingrediente activo como paracetamol o ibuprofeno

SELECT 
    commercial_name,
    active_ingredient
FROM smart_health.medications
ORDER BY commercial_name;
LIMIT 25;

------------------------------------------------
----Mostrar Los primeros 5 medicos, que tienen dominio institucional @hospitalcentral.com

SELECT first_name||' '||last_name  AS fullname,
    professional_email
FROM smart_health.doctors
WHERE professional_email LIKE '%@hospitalcentral.com'
LIMIT 20;
-------------------------------------------------
---Mostrar nombre completo,genero,tipo identificacion,numero de documento
--- y lafecha de registro, de los 5 pacientes mas jovenes que tengan estado activo

SELECT first_name||' '||first_surname AS fullname,
    gender,
    document_type_id,
    document_number,
    registration_date
    FROM smart_health.patients
    WHERE active = true
    ORDER BY birth_date DESC
    LIMIT 5;

----------------------------------------------------
--Mostrar las 10 primeras citas, que se hicieron entre el 25 de 
--Febrero del 2025 y el 28 de octubre del 2025

SELECT
    *
    FROM smart_health.appointments
    WHERE appointment_date BETWEEN '2025-02-25' AND '2025-10-28'
    ORDER BY creation_date 
    LIMIT 10;

  ------------------------------------------------------
  --Mostrar los datos del numero de telefono, para los siguientes pacientes

SELECT
    patient_id,
    phone_type,
    phone_number
FROM smart_health.patient_phones
WHERE patient_id IN 
(
    SELECT patient_id FROM smart_health.patients
    WHERE document_number IN ('30451580',
'1006631391',
'1009149871',
'1298083',
'1004928596',
'1008188849',
'1607132',
'30470003')
);

--  patient_id | phone_type | phone_number
-- ----------+------------+--------------
--       11118 | Móvil      | 3117935551
--         855 | Móvil      | 3014649922
--       15919 | Móvil      | 3201212554
--       11188 | Móvil      | 3149662006
--        7453 | Fijo       | 6043698899
--       14125 | Móvil      | 3185171082
-- (6 filas)
