CREATE DATABASE SolidaridadActiva3;

USE SolidaridadActiva3;

CREATE TABLE Voluntarios (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    direccion VARCHAR(255),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    fecha_baja DATE
);

CREATE TABLE Beneficiarios (
    id_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(15),
    necesidades TEXT,
    fecha_registro DATE NOT NULL
);

CREATE TABLE CategoriasActividades (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Actividades (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    fecha DATE NOT NULL,
    lugar VARCHAR(100) NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES CategoriasActividades(id_categoria) ON DELETE SET NULL,
    estado ENUM('Programada', 'Realizada', 'Cancelada') DEFAULT 'Programada'
);

CREATE TABLE Donaciones (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
    fecha DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario) ON DELETE CASCADE
);

CREATE TABLE Recursos (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    fecha_ingreso DATE NOT NULL,
    id_donacion INT,
    FOREIGN KEY (id_donacion) REFERENCES Donaciones(id_donacion) ON DELETE CASCADE
);

CREATE TABLE Participaciones (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    id_actividad INT,
    fecha_participacion DATE NOT NULL,
    FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad) ON DELETE CASCADE
);

CREATE INDEX idx_monto_donaciones ON Donaciones(monto);
CREATE INDEX idx_fecha_actividades ON Actividades(fecha);

DELIMITER //
CREATE PROCEDURE AgregarVoluntario (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(255)
)
BEGIN
    INSERT INTO Voluntarios (nombre, apellido, telefono, email, fecha_ingreso, direccion)
    VALUES (p_nombre, p_apellido, p_telefono, p_email, NOW(), p_direccion);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarDonacion (
    IN p_id_voluntario INT,
    IN p_monto DECIMAL(10, 2),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO Donaciones (id_voluntario, monto, fecha, descripcion)
    VALUES (p_id_voluntario, p_monto, NOW(), p_descripcion);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarParticipacion (
    IN p_id_voluntario INT,
    IN p_id_actividad INT
)
BEGIN
    INSERT INTO Participaciones (id_voluntario, id_actividad, fecha_participacion)
    VALUES (p_id_voluntario, p_id_actividad, NOW());
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerVoluntariosActivos ()
BEGIN
    SELECT * FROM Voluntarios WHERE estado = 'Activo';
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_baja_voluntario
BEFORE UPDATE ON Voluntarios
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Inactivo' THEN
        SET NEW.fecha_baja = NOW();
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_no_eliminar_beneficiario
BEFORE DELETE ON Beneficiarios
FOR EACH ROW
BEGIN
    DECLARE actividad_count INT;
    SELECT COUNT(*) INTO actividad_count FROM Actividades WHERE id_beneficiario = OLD.id_beneficiario;
    IF actividad_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el beneficiario porque tiene actividades asociadas.';
    END IF;
END //
DELIMITER ;

-- Voluntario
INSERT INTO Voluntarios (nombre, apellido, telefono, email, fecha_ingreso, direccion)
VALUES ('Juan', 'Pérez', '123456789', 'juan@correo.com', '2024-12-01', 'Calle Ficticia 123');

-- Cat. Actividad
INSERT INTO CategoriasActividades (nombre_categoria, descripcion)
VALUES ('Recolección de Ropa', 'Actividades relacionadas con la recolección de ropa usada para personas necesitadas.');

-- Actividad
INSERT INTO Actividades (descripcion, fecha, lugar, id_categoria)
VALUES ('Recolección de ropa', '2024-12-30', 'Plaza Principal', 1);

-- Donacion
INSERT INTO Donaciones (id_voluntario, monto, fecha, descripcion)
VALUES (1, 100.00, '2024-12-15', 'Donación para recursos médicos');

-- Recurso
INSERT INTO Recursos (descripcion, cantidad, fecha_ingreso, id_donacion)
VALUES ('Ropa usada', 500, '2024-12-16', 1);

-- Participacion
INSERT INTO Participaciones (id_voluntario, id_actividad, fecha_participacion)
VALUES (1, 1, '2024-12-30');
