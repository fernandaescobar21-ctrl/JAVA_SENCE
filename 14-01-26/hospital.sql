DROP DATABASE IF EXISTS Hospital;
CREATE DATABASE Hospital;
USE Hospital;

-- =====================================================
-- CREACIÓN DE TABLAS
-- =====================================================

-- Tabla 1: Departamentos
CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100),
    telefono VARCHAR(15),
    presupuesto DECIMAL(12,2)
);

-- Tabla 2: Médicos
CREATE TABLE Medicos (
    id_medico INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(100),
    fecha_contratacion DATE,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

-- Tabla 3: Pacientes
CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'Otro'),
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    email VARCHAR(100),
    tipo_sangre VARCHAR(5),
    alergias TEXT
);

-- Tabla 4: Habitaciones
CREATE TABLE Habitaciones (
    id_habitacion INT PRIMARY KEY AUTO_INCREMENT,
    numero_habitacion VARCHAR(10) NOT NULL UNIQUE,
    tipo ENUM('Individual', 'Doble', 'UCI', 'Emergencia') NOT NULL,
    precio_dia DECIMAL(10,2),
    estado ENUM('Disponible', 'Ocupada', 'Mantenimiento') DEFAULT 'Disponible',
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

-- Tabla 5: Citas
CREATE TABLE Citas (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(200),
    estado ENUM('Programada', 'Completada', 'Cancelada') DEFAULT 'Programada',
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);

-- Tabla 6: Hospitalizaciones
CREATE TABLE Hospitalizaciones (
    id_hospitalizacion INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_habitacion INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    fecha_alta DATETIME,
    diagnostico TEXT,
    estado ENUM('Activa', 'Alta', 'Transferido') DEFAULT 'Activa',
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES Habitaciones(id_habitacion),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);

-- Tabla 7: Medicamentos
CREATE TABLE Medicamentos (
    id_medicamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10,2),
    stock INT DEFAULT 0,
    fecha_vencimiento DATE
);

-- Tabla 8: Prescripciones
CREATE TABLE Prescripciones (
    id_prescripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_cita INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosis VARCHAR(100),
    frecuencia VARCHAR(100),
    duracion_dias INT,
    instrucciones TEXT,
    FOREIGN KEY (id_cita) REFERENCES Citas(id_cita),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);

-- Tabla 9: Enfermeros
CREATE TABLE Enfermeros (
    id_enfermero INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    turno ENUM('Mañana', 'Tarde', 'Noche'),
    fecha_contratacion DATE,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

-- Tabla 10: Facturas
CREATE TABLE Facturas (
    id_factura INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    fecha_emision DATE NOT NULL,
    subtotal DECIMAL(12,2),
    impuesto DECIMAL(12,2),
    total DECIMAL(12,2),
    estado ENUM('Pendiente', 'Pagada', 'Vencida') DEFAULT 'Pendiente',
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);

-- Departamentos (4 registros)
INSERT INTO Departamentos (nombre, ubicacion, telefono, presupuesto) VALUES
('Cardiología', 'Piso 3, Ala Este', '555-0301', 500000.00),
('Pediatría', 'Piso 2, Ala Oeste', '555-0302', 350000.00),
('Urgencias', 'Planta Baja', '555-0303', 750000.00),
('Cirugía General', 'Piso 4, Ala Norte', '555-0304', 600000.00);

-- Médicos (4 registros)
INSERT INTO Medicos (nombre, apellido, especialidad, telefono, email, fecha_contratacion, id_departamento) VALUES
('Carlos', 'Ramírez', 'Cardiólogo', '555-1001', 'cramirez@hospital.com', '2020-03-15', 1),
('Ana', 'Martínez', 'Pediatra', '555-1002', 'amartinez@hospital.com', '2019-07-22', 2),
('Roberto', 'López', 'Médico de Urgencias', '555-1003', 'rlopez@hospital.com', '2021-01-10', 3),
('María', 'González', 'Cirujana', '555-1004', 'mgonzalez@hospital.com', '2018-11-05', 4);

-- Pacientes (4 registros)
INSERT INTO Pacientes (nombre, apellido, fecha_nacimiento, genero, direccion, telefono, email, tipo_sangre, alergias) VALUES
('Juan', 'Pérez', '1985-05-20', 'M', 'Av. Principal 123', '555-2001', 'jperez@email.com', 'O+', 'Penicilina'),
('Laura', 'Sánchez', '1990-08-15', 'F', 'Calle Secundaria 456', '555-2002', 'lsanchez@email.com', 'A+', 'Ninguna'),
('Pedro', 'Torres', '2015-03-10', 'M', 'Calle Tercera 789', '555-2003', 'ptorres@email.com', 'B+', 'Aspirina'),
('Sofia', 'Rojas', '1978-12-25', 'F', 'Av. Central 321', '555-2004', 'srojas@email.com', 'AB-', 'Polen');

-- Habitaciones (2 registros)
INSERT INTO Habitaciones (numero_habitacion, tipo, precio_dia, estado, id_departamento) VALUES
('301-A', 'Individual', 150.00, 'Disponible', 1),
('201-B', 'Doble', 100.00, 'Ocupada', 2);

-- Citas (2 registros)
INSERT INTO Citas (id_paciente, id_medico, fecha_hora, motivo, estado, observaciones) VALUES
(1, 1, '2026-01-20 10:00:00', 'Chequeo cardiológico', 'Programada', 'Primera consulta'),
(2, 2, '2026-01-18 15:30:00', 'Control pediátrico', 'Completada', 'Paciente en buen estado');

-- Hospitalizaciones (1 registro)
INSERT INTO Hospitalizaciones (id_paciente, id_habitacion, id_medico, fecha_ingreso, diagnostico, estado) VALUES
(3, 2, 2, '2026-01-15 08:00:00', 'Neumonía', 'Activa');

-- Medicamentos (2 registros)
INSERT INTO Medicamentos (nombre, descripcion, precio_unitario, stock, fecha_vencimiento) VALUES
('Paracetamol 500mg', 'Analgésico y antipirético', 5.50, 1000, '2027-12-31'),
('Amoxicilina 500mg', 'Antibiótico', 12.75, 500, '2027-06-30');

-- Prescripciones (1 registro)
INSERT INTO Prescripciones (id_cita, id_medicamento, dosis, frecuencia, duracion_dias, instrucciones) VALUES
(2, 1, '500mg', 'Cada 8 horas', 5, 'Tomar después de las comidas');

-- Enfermeros (2 registros)
INSERT INTO Enfermeros (nombre, apellido, telefono, email, turno, fecha_contratacion, id_departamento) VALUES
('Carmen', 'Flores', '555-3001', 'cflores@hospital.com', 'Mañana', '2020-05-12', 2),
('Miguel', 'Castro', '555-3002', 'mcastro@hospital.com', 'Noche', '2021-09-18', 3);

-- Facturas (2 registros)
INSERT INTO Facturas (id_paciente, fecha_emision, subtotal, impuesto, total, estado, metodo_pago) VALUES
(1, '2026-01-15', 250.00, 40.00, 290.00, 'Pendiente', NULL),
(2, '2026-01-18', 150.00, 24.00, 174.00, 'Pagada', 'Tarjeta de Crédito');
