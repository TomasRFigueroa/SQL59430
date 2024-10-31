Descripción de la Temática de la Base de Datos
La base de datos "Solidaridad Activa" está diseñada para gestionar la información de un grupo de voluntarios que asisten a personas en situación de emergencia en el barrio de Carcova, Argentina. El sistema permitirá registrar la información de los voluntarios, beneficiarios, actividades realizadas, donaciones recibidas y recursos disponibles. Esto facilitará la organización y la gestión de la ayuda humanitaria, mejorando la eficiencia en la atención a las necesidades de la comunidad.

Diagrama de Entidades-Relación (DER)

Voluntarios

id_voluntario (PK)
nombre
apellido
telefono
email
fecha_ingreso
direccion
estado
fecha_baja
Beneficiarios

id_beneficiario (PK)
nombre
apellido
direccion
telefono
necesidades
fecha_registro
CategoriasActividades

id_categoria (PK)
nombre_categoria
descripcion
Actividades

id_actividad (PK)
descripcion
fecha
lugar
id_categoria (FK)
estado
Donaciones

id_donacion (PK)
id_voluntario (FK)
monto
fecha
descripcion
Recursos

id_recurso (PK)
descripcion
cantidad
fecha_ingreso
id_donacion (FK)
Participaciones

id_participacion (PK)
id_voluntario (FK)
id_actividad (FK)
fecha_participacion
Listado de las Tablas y Descripción
Voluntarios

Descripción: Almacena información sobre los voluntarios que participan en las actividades de ayuda.
Campos:
id_voluntario (INT, PK)
nombre (VARCHAR)
apellido (VARCHAR)
telefono (VARCHAR)
email (VARCHAR, UNIQUE)
fecha_ingreso (DATE)
direccion (VARCHAR)
estado (ENUM)
fecha_baja (DATE)
Beneficiarios

Descripción: Contiene datos sobre las personas que reciben ayuda.
Campos:
id_beneficiario (INT, PK)
nombre (VARCHAR)
apellido (VARCHAR)
direccion (VARCHAR)
telefono (VARCHAR)
necesidades (TEXT)
fecha_registro (DATE)
CategoriasActividades

Descripción: Define las categorías de las actividades realizadas por los voluntarios.
Campos:
id_categoria (INT, PK)
nombre_categoria (VARCHAR)
descripcion (TEXT)
Actividades

Descripción: Registra las actividades realizadas por los voluntarios.
Campos:
id_actividad (INT, PK)
descripcion (TEXT)
fecha (DATE)
lugar (VARCHAR)
id_categoria (INT, FK)
estado (ENUM)
Donaciones

Descripción: Almacena información sobre las donaciones realizadas al grupo.
Campos:
id_donacion (INT, PK)
id_voluntario (INT, FK)
monto (DECIMAL)
fecha (DATE)
descripcion (TEXT)
Recursos

Descripción: Contiene información sobre los recursos disponibles.
Campos:
id_recurso (INT, PK)
descripcion (VARCHAR)
cantidad (INT)
fecha_ingreso (DATE)
id_donacion (INT, FK)
Participaciones

Descripción: Registra la participación de los voluntarios en las actividades.
Campos:
id_participacion (INT, PK)
id_voluntario (INT, FK)
id_actividad (INT, FK)
fecha_participacion (DATE)
Resumen de Claves
Primarias (PK): Cada tabla tiene una clave primaria que identifica de forma única cada registro.
Foráneas (FK): Se establecen relaciones entre las tablas utilizando claves foráneas para mantener la integridad referencial.
Índices: Se pueden crear índices en campos que se utilizan frecuentemente en consultas para optimizar el rendimiento.
