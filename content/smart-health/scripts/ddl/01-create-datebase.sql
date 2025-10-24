-- 01 create user --
CREATE USER sm_admin WITH PASSWORD 'sm2025**';

--02. create database (with ENCODIGN='UTF8',TEMPLATE=template)--
CREATE DATABASE smarthdb WITH
    ENCODING ='UTF8'
    LC_COLLATE='es_CO.UTF-8'
    LC_CTYPE='es_CO.UTF-8'
    TEMPLATE=template0
    OWNER = sm_admin;

--03.Grant privilages
GRANT ALL PRIVILAGES ON DATABASE smarthdb TO sm_admin;

--04. Create Schema
CREATE SCHEMA IF NOT EXISTS smart_health AUTHORIZATION sd_admin;

--05. Comment on database 
COMMENT ON DATABASE musicdb IS 'Base de datos para el control de pacientes y citas'

-- 06. Comment of schema
COMMENT ON SCHEMA smarth_health IS 'Esquema principal para el sistema de pacientes y citas';