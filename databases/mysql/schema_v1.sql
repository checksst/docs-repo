CREATE DATABASE checksst_app;
USE checksst_app;

-- Tabla de Usuarios
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    perfil VARCHAR(50),
    max_listas_chequeo INT DEFAULT 0,
    max_charlas INT DEFAULT 0,
    max_colaboradores INT DEFAULT 0,
    publicidad BOOLEAN DEFAULT FALSE
);

-- Tabla de Organizaciones
CREATE TABLE organizations (
    organization_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Tabla de Cargos
CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    organization_id INT,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE
);

-- Tabla de Áreas
CREATE TABLE areas (
    area_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    organization_id INT,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE
);

-- Tabla de Inspecciones
CREATE TABLE inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cargo_id INT,
    area_id INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    firma_inspector TEXT,
    firma_responsable TEXT,
    FOREIGN KEY (cargo_id) REFERENCES positions(position_id) ON DELETE SET NULL,
    FOREIGN KEY (area_id) REFERENCES areas(area_id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Tabla de Listas de Chequeo
CREATE TABLE checklists (
    checklist_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    sector_economico VARCHAR(255),
    programa_gestion VARCHAR(255),
    tipo_inspeccion VARCHAR(255),
    norma VARCHAR(255),
    creador_id INT,
    organization_id INT,
    FOREIGN KEY (creador_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE SET NULL
);

-- Tabla de Preguntas de la Lista de Chequeo
CREATE TABLE checklist_questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    checklist_id INT,
    pregunta TEXT NOT NULL,
    opcion_si BOOLEAN DEFAULT FALSE,
    opcion_no BOOLEAN DEFAULT FALSE,
    opcion_no_aplica BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (checklist_id) REFERENCES checklists(checklist_id) ON DELETE CASCADE
);

-- Tabla de Respuestas de Inspección
CREATE TABLE inspection_answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_id INT,
    question_id INT,
    respuesta ENUM('SI', 'NO', 'NO_APLICA'),
    observacion TEXT,
    accion_id INT,
    foto VARCHAR(255),
    archivo VARCHAR(255),
    FOREIGN KEY (inspection_id) REFERENCES inspections(inspection_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES checklist_questions(question_id) ON DELETE CASCADE,
    FOREIGN KEY (accion_id) REFERENCES actions(action_id) ON DELETE SET NULL
);

-- Tabla de Acciones
CREATE TABLE actions (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT NOT NULL,
    evidencia VARCHAR(255),
    causa TEXT,
    efectiva ENUM('SI', 'NO')
);