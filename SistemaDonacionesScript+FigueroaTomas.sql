-- Crear la base de datos
CREATE DATABASE SolidaridadActiva;

-- Usar la base de datos
USE SolidaridadActiva;

-- Crear la tabla Voluntarios
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

-- Crear la tabla Beneficiarios
CREATE TABLE Beneficiarios (
    id_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(15),
    necesidades TEXT,
    fecha_registro DATE NOT NULL
);

-- Crear la tabla Categorías de Actividades
CREATE TABLE CategoriasActividades (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Crear la tabla Actividades
CREATE TABLE Actividades (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    fecha DATE NOT NULL,
    lugar VARCHAR(100) NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES CategoriasActividades(id_categoria) ON DELETE SET NULL,
    estado ENUM('Programada', 'Realizada', 'Cancelada') DEFAULT 'Programada'
);

-- Crear la tabla Donaciones
CREATE TABLE Donaciones (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
    fecha DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario) ON DELETE CASCADE
);

-- Crear la tabla Recursos
CREATE TABLE Recursos (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    fecha_ingreso DATE NOT NULL,
    id_donacion INT,
    FOREIGN KEY (id_donacion) REFERENCES Donaciones(id_donacion) ON DELETE CASCADE
);

-- Crear la tabla Participaciones
CREATE TABLE Participaciones (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    id_actividad INT,
    fecha_participacion DATE NOT NULL,
    FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad) ON DELETE CASCADE
);

-- Crear un índice en la tabla Donaciones para optimizar búsquedas por monto
CREATE INDEX idx_monto_donaciones ON Donaciones(monto);

-- Crear un índice en la tabla Actividades para optimizar búsquedas por fecha
CREATE INDEX idx_fecha_actividades ON Actividades(fecha);

-- Crear un procedimiento almacenado para agregar un nuevo voluntario
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

-- Crear un procedimiento almacenado para registrar una donación
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

-- Crear un procedimiento almacenado para registrar una participación
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

-- Crear un procedimiento almacenado para obtener todos los voluntarios activos
DELIMITER //
CREATE PROCEDURE ObtenerVoluntariosActivos ()
BEGIN
    SELECT * FROM Voluntarios WHERE estado = 'Activo';
END //
DELIMITER ;

-- Crear un trigger para actualizar la fecha de baja en Voluntarios al cambiar su estado a 'Inactivo'
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

-- Crear un trigger para evitar que se eliminen beneficiarios si tienen actividades asociadas
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
