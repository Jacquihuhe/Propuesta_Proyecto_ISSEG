-- ============================================================
-- ISSEG_DB - Script de creacion de base de datos
-- Motor: SQL Server 2022
-- Modelo: SGSPCSI 4NF (33 tablas)
-- ============================================================

USE [master];
GO

IF DB_ID(N'ISSEG_DB') IS NOT NULL
BEGIN
    ALTER DATABASE [ISSEG_DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [ISSEG_DB];
END;
GO

CREATE DATABASE [ISSEG_DB];
GO

USE [ISSEG_DB];
GO

-- ============================================================
-- 1) CATALOGOS BASE
-- ============================================================

CREATE TABLE dbo.rol (
    rol_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(30) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo BIT NOT NULL CONSTRAINT DF_rol_activo DEFAULT (1),
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_rol_fecha_creacion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_rol PRIMARY KEY CLUSTERED (rol_id),
    CONSTRAINT UQ_rol_clave UNIQUE (clave)
);
GO

CREATE TABLE dbo.usuario (
    usuario_id INT IDENTITY(1,1) NOT NULL,
    nombre_pila VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NULL,
    correo_institucional VARCHAR(180) NOT NULL,
    puesto VARCHAR(120) NULL,
    activo BIT NOT NULL CONSTRAINT DF_usuario_activo DEFAULT (1),
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_usuario_fecha_creacion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_usuario PRIMARY KEY CLUSTERED (usuario_id),
    CONSTRAINT UQ_usuario_correo UNIQUE (correo_institucional)
);
GO

CREATE TABLE dbo.area (
    area_id INT IDENTITY(1,1) NOT NULL,
    area_padre_id INT NULL,
    clave VARCHAR(50) NULL,
    nombre VARCHAR(220) NOT NULL,
    tipo_area VARCHAR(30) NOT NULL,
    nivel TINYINT NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_area_activa DEFAULT (1),
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_area_fecha_creacion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_area PRIMARY KEY CLUSTERED (area_id),
    CONSTRAINT FK_area_area_padre FOREIGN KEY (area_padre_id) REFERENCES dbo.area(area_id),
    CONSTRAINT UQ_area_nombre UNIQUE (nombre),
    CONSTRAINT CK_area_nivel CHECK (nivel >= 1)
);
GO

CREATE UNIQUE INDEX UX_area_clave_notnull ON dbo.area(clave) WHERE clave IS NOT NULL;
GO

CREATE TABLE dbo.sistema (
    sistema_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(50) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500) NULL,
    activo BIT NOT NULL CONSTRAINT DF_sistema_activo DEFAULT (1),
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_sistema_fecha_creacion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_sistema PRIMARY KEY CLUSTERED (sistema_id),
    CONSTRAINT UQ_sistema_clave UNIQUE (clave)
);
GO

CREATE TABLE dbo.tipo_solicitud (
    tipo_solicitud_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(40) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_tipo_solicitud_activa DEFAULT (1),
    CONSTRAINT PK_tipo_solicitud PRIMARY KEY CLUSTERED (tipo_solicitud_id),
    CONSTRAINT UQ_tipo_solicitud_clave UNIQUE (clave)
);
GO

CREATE TABLE dbo.prioridad_solicitud (
    prioridad_solicitud_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(30) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    orden INT NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_prioridad_solicitud_activa DEFAULT (1),
    CONSTRAINT PK_prioridad_solicitud PRIMARY KEY CLUSTERED (prioridad_solicitud_id),
    CONSTRAINT UQ_prioridad_solicitud_clave UNIQUE (clave),
    CONSTRAINT UQ_prioridad_solicitud_orden UNIQUE (orden)
);
GO

CREATE TABLE dbo.estado_solicitud (
    estado_solicitud_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(30) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    es_terminal BIT NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_estado_solicitud_activa DEFAULT (1),
    CONSTRAINT PK_estado_solicitud PRIMARY KEY CLUSTERED (estado_solicitud_id),
    CONSTRAINT UQ_estado_solicitud_clave UNIQUE (clave)
);
GO

-- ============================================================
-- 2) RELACIONES DE SEGURIDAD Y ORGANIZACION
-- ============================================================

CREATE TABLE dbo.usuario_rol (
    usuario_rol_id INT IDENTITY(1,1) NOT NULL,
    usuario_id INT NOT NULL,
    rol_id INT NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_usuario_rol_activo DEFAULT (1),
    fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_usuario_rol_fecha_asignacion DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_usuario_rol PRIMARY KEY CLUSTERED (usuario_rol_id),
    CONSTRAINT FK_usuario_rol_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
    CONSTRAINT FK_usuario_rol_rol FOREIGN KEY (rol_id) REFERENCES dbo.rol(rol_id),
    CONSTRAINT UQ_usuario_rol UNIQUE (usuario_id, rol_id)
);
GO

CREATE TABLE dbo.usuario_area (
    usuario_area_id INT IDENTITY(1,1) NOT NULL,
    usuario_id INT NOT NULL,
    area_id INT NOT NULL,
    es_titular BIT NOT NULL CONSTRAINT DF_usuario_area_es_titular DEFAULT (0),
    activo BIT NOT NULL CONSTRAINT DF_usuario_area_activo DEFAULT (1),
    fecha_inicio DATETIME2 NOT NULL CONSTRAINT DF_usuario_area_fecha_inicio DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_usuario_area PRIMARY KEY CLUSTERED (usuario_area_id),
    CONSTRAINT FK_usuario_area_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
    CONSTRAINT FK_usuario_area_area FOREIGN KEY (area_id) REFERENCES dbo.area(area_id)
);
GO

CREATE TABLE dbo.area_sistema (
    area_sistema_id INT IDENTITY(1,1) NOT NULL,
    area_id INT NOT NULL,
    sistema_id INT NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_area_sistema_activo DEFAULT (1),
    fecha_alta DATETIME2 NOT NULL CONSTRAINT DF_area_sistema_fecha_alta DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_area_sistema PRIMARY KEY CLUSTERED (area_sistema_id),
    CONSTRAINT FK_area_sistema_area FOREIGN KEY (area_id) REFERENCES dbo.area(area_id),
    CONSTRAINT FK_area_sistema_sistema FOREIGN KEY (sistema_id) REFERENCES dbo.sistema(sistema_id),
    CONSTRAINT UQ_area_sistema UNIQUE (area_id, sistema_id)
);
GO

CREATE TABLE dbo.sistema_desarrollador (
    sistema_desarrollador_id INT IDENTITY(1,1) NOT NULL,
    sistema_id INT NOT NULL,
    usuario_id INT NOT NULL,
    tipo_participacion VARCHAR(20) NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_sistema_desarrollador_activo DEFAULT (1),
    fecha_inicio DATETIME2 NOT NULL CONSTRAINT DF_sistema_desarrollador_fecha_inicio DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_sistema_desarrollador PRIMARY KEY CLUSTERED (sistema_desarrollador_id),
    CONSTRAINT FK_sistema_desarrollador_sistema FOREIGN KEY (sistema_id) REFERENCES dbo.sistema(sistema_id),
    CONSTRAINT FK_sistema_desarrollador_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
    CONSTRAINT UQ_sistema_desarrollador UNIQUE (sistema_id, usuario_id)
);
GO

-- ============================================================
-- 3) SOLICITUDES
-- ============================================================

CREATE TABLE dbo.solicitud (
    solicitud_id BIGINT IDENTITY(1,1) NOT NULL,
    folio VARCHAR(40) NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion VARCHAR(MAX) NOT NULL,
    area_solicitante_id INT NOT NULL,
    sistema_id INT NULL,
    tipo_solicitud_id INT NOT NULL,
    prioridad_solicitud_id INT NOT NULL,
    estado_solicitud_id INT NOT NULL,
    creado_por_usuario_id INT NOT NULL,
    fecha_solicitud DATETIME2 NOT NULL CONSTRAINT DF_solicitud_fecha_solicitud DEFAULT (SYSDATETIME()),
    fecha_compromiso DATETIME2 NULL,
    fecha_resolucion DATETIME2 NULL,
    esfuerzo_horas DECIMAL(10,2) NULL,
    activo BIT NOT NULL CONSTRAINT DF_solicitud_activo DEFAULT (1),
    CONSTRAINT PK_solicitud PRIMARY KEY CLUSTERED (solicitud_id),
    CONSTRAINT UQ_solicitud_folio UNIQUE (folio),
    CONSTRAINT FK_solicitud_area FOREIGN KEY (area_solicitante_id) REFERENCES dbo.area(area_id),
    CONSTRAINT FK_solicitud_sistema FOREIGN KEY (sistema_id) REFERENCES dbo.sistema(sistema_id),
    CONSTRAINT FK_solicitud_tipo FOREIGN KEY (tipo_solicitud_id) REFERENCES dbo.tipo_solicitud(tipo_solicitud_id),
    CONSTRAINT FK_solicitud_prioridad FOREIGN KEY (prioridad_solicitud_id) REFERENCES dbo.prioridad_solicitud(prioridad_solicitud_id),
    CONSTRAINT FK_solicitud_estado FOREIGN KEY (estado_solicitud_id) REFERENCES dbo.estado_solicitud(estado_solicitud_id),
    CONSTRAINT FK_solicitud_creador FOREIGN KEY (creado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.solicitud_desarrollador (
    solicitud_desarrollador_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    usuario_id INT NOT NULL,
    tipo_participacion VARCHAR(20) NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_solicitud_desarrollador_activo DEFAULT (1),
    fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_solicitud_desarrollador_fecha_asignacion DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_solicitud_desarrollador PRIMARY KEY CLUSTERED (solicitud_desarrollador_id),
    CONSTRAINT FK_solicitud_desarrollador_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_desarrollador_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
    CONSTRAINT UQ_solicitud_desarrollador UNIQUE (solicitud_id, usuario_id)
);
GO

CREATE TABLE dbo.solicitud_historial_estado (
    solicitud_historial_estado_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    estado_anterior_id INT NULL,
    estado_nuevo_id INT NOT NULL,
    comentario VARCHAR(800) NULL,
    cambiado_por_usuario_id INT NOT NULL,
    fecha_cambio DATETIME2 NOT NULL CONSTRAINT DF_solicitud_historial_estado_fecha DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_historial_estado PRIMARY KEY CLUSTERED (solicitud_historial_estado_id),
    CONSTRAINT FK_solicitud_historial_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_historial_estado_anterior FOREIGN KEY (estado_anterior_id) REFERENCES dbo.estado_solicitud(estado_solicitud_id),
    CONSTRAINT FK_solicitud_historial_estado_nuevo FOREIGN KEY (estado_nuevo_id) REFERENCES dbo.estado_solicitud(estado_solicitud_id),
    CONSTRAINT FK_solicitud_historial_usuario FOREIGN KEY (cambiado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.solicitud_aprobacion (
    solicitud_aprobacion_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    aprobado_por_usuario_id INT NOT NULL,
    estatus_aprobacion VARCHAR(20) NOT NULL,
    motivo VARCHAR(1000) NULL,
    fecha_aprobacion DATETIME2 NOT NULL CONSTRAINT DF_solicitud_aprobacion_fecha DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_aprobacion PRIMARY KEY CLUSTERED (solicitud_aprobacion_id),
    CONSTRAINT FK_solicitud_aprobacion_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_aprobacion_usuario FOREIGN KEY (aprobado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.solicitud_comentario (
    solicitud_comentario_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    autor_usuario_id INT NOT NULL,
    comentario VARCHAR(2000) NOT NULL,
    es_interno BIT NOT NULL CONSTRAINT DF_solicitud_comentario_interno DEFAULT (0),
    fecha_comentario DATETIME2 NOT NULL CONSTRAINT DF_solicitud_comentario_fecha DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_comentario PRIMARY KEY CLUSTERED (solicitud_comentario_id),
    CONSTRAINT FK_solicitud_comentario_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_comentario_autor FOREIGN KEY (autor_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.solicitud_adjunto (
    solicitud_adjunto_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_mime VARCHAR(120) NULL,
    tamanio_bytes BIGINT NULL,
    subido_por_usuario_id INT NOT NULL,
    fecha_subida DATETIME2 NOT NULL CONSTRAINT DF_solicitud_adjunto_fecha DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_adjunto PRIMARY KEY CLUSTERED (solicitud_adjunto_id),
    CONSTRAINT FK_solicitud_adjunto_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_adjunto_usuario FOREIGN KEY (subido_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.notificacion (
    notificacion_id BIGINT IDENTITY(1,1) NOT NULL,
    usuario_id INT NOT NULL,
    solicitud_id BIGINT NULL,
    titulo VARCHAR(220) NOT NULL,
    mensaje VARCHAR(1500) NOT NULL,
    leida BIT NOT NULL CONSTRAINT DF_notificacion_leida DEFAULT (0),
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_notificacion_fecha_creacion DEFAULT (SYSDATETIME()),
    fecha_lectura DATETIME2 NULL,
    CONSTRAINT PK_notificacion PRIMARY KEY CLUSTERED (notificacion_id),
    CONSTRAINT FK_notificacion_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
    CONSTRAINT FK_notificacion_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id)
);
GO

-- ============================================================
-- 4) AUTENTICACION, MENU Y MODIFICACIONES
-- ============================================================

CREATE TABLE dbo.usuario_credencial (
    usuario_id INT NOT NULL,
    login_usuario VARCHAR(80) NOT NULL,
    password_hash VARBINARY(512) NOT NULL,
    password_salt VARBINARY(128) NOT NULL,
    algoritmo_hash VARCHAR(30) NOT NULL CONSTRAINT DF_usuario_cred_algoritmo DEFAULT ('PBKDF2'),
    iteraciones INT NOT NULL CONSTRAINT DF_usuario_cred_iteraciones DEFAULT (100000),
    ultimo_acceso DATETIME2 NULL,
    intentos_fallidos SMALLINT NOT NULL CONSTRAINT DF_usuario_cred_intentos DEFAULT (0),
    bloqueado_hasta DATETIME2 NULL,
    requiere_cambio_password BIT NOT NULL CONSTRAINT DF_usuario_cred_cambio DEFAULT (0),
    fecha_actualizacion DATETIME2 NOT NULL CONSTRAINT DF_usuario_cred_fecha_actualizacion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_usuario_credencial PRIMARY KEY CLUSTERED (usuario_id),
    CONSTRAINT UQ_usuario_credencial_login UNIQUE (login_usuario),
    CONSTRAINT FK_usuario_credencial_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.menu_opcion (
    menu_opcion_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(60) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    ruta VARCHAR(220) NOT NULL,
    icono VARCHAR(80) NULL,
    orden INT NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_menu_opcion_activa DEFAULT (1),
    menu_padre_id INT NULL,
    CONSTRAINT PK_menu_opcion PRIMARY KEY CLUSTERED (menu_opcion_id),
    CONSTRAINT UQ_menu_opcion_clave UNIQUE (clave),
    CONSTRAINT FK_menu_opcion_padre FOREIGN KEY (menu_padre_id) REFERENCES dbo.menu_opcion(menu_opcion_id)
);
GO

CREATE TABLE dbo.rol_menu_opcion (
    rol_menu_opcion_id INT IDENTITY(1,1) NOT NULL,
    rol_id INT NOT NULL,
    menu_opcion_id INT NOT NULL,
    puede_ver BIT NOT NULL CONSTRAINT DF_rol_menu_opcion_puede_ver DEFAULT (1),
    puede_editar BIT NOT NULL CONSTRAINT DF_rol_menu_opcion_puede_editar DEFAULT (0),
    puede_aprobar BIT NOT NULL CONSTRAINT DF_rol_menu_opcion_puede_aprobar DEFAULT (0),
    CONSTRAINT PK_rol_menu_opcion PRIMARY KEY CLUSTERED (rol_menu_opcion_id),
    CONSTRAINT UQ_rol_menu_opcion UNIQUE (rol_id, menu_opcion_id),
    CONSTRAINT FK_rol_menu_opcion_rol FOREIGN KEY (rol_id) REFERENCES dbo.rol(rol_id),
    CONSTRAINT FK_rol_menu_opcion_menu FOREIGN KEY (menu_opcion_id) REFERENCES dbo.menu_opcion(menu_opcion_id)
);
GO

CREATE TABLE dbo.tipo_modificacion (
    tipo_modificacion_id INT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(30) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    activa BIT NOT NULL CONSTRAINT DF_tipo_modificacion_activa DEFAULT (1),
    CONSTRAINT PK_tipo_modificacion PRIMARY KEY CLUSTERED (tipo_modificacion_id),
    CONSTRAINT UQ_tipo_modificacion_clave UNIQUE (clave)
);
GO

CREATE TABLE dbo.solicitud_modificacion (
    solicitud_modificacion_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    tipo_modificacion_id INT NOT NULL,
    sistema_version_actual VARCHAR(80) NULL,
    modulo_afectado VARCHAR(200) NULL,
    impacto_tecnico VARCHAR(1500) NULL,
    justificacion VARCHAR(2000) NULL,
    fecha_registro DATETIME2 NOT NULL CONSTRAINT DF_solicitud_modificacion_fecha_registro DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_modificacion PRIMARY KEY CLUSTERED (solicitud_modificacion_id),
    CONSTRAINT UQ_solicitud_modificacion_solicitud UNIQUE (solicitud_id),
    CONSTRAINT FK_solicitud_modificacion_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_modificacion_tipo FOREIGN KEY (tipo_modificacion_id) REFERENCES dbo.tipo_modificacion(tipo_modificacion_id)
);
GO

CREATE TABLE dbo.solicitud_requerimiento_tecnico (
    solicitud_requerimiento_tecnico_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    arquitectura_propuesta VARCHAR(2000) NULL,
    alcance_tecnico VARCHAR(2000) NULL,
    dependencias VARCHAR(2000) NULL,
    criterios_aceptacion VARCHAR(2000) NULL,
    riesgos VARCHAR(2000) NULL,
    plan_pruebas VARCHAR(2000) NULL,
    observaciones VARCHAR(2000) NULL,
    elaborado_por_usuario_id INT NOT NULL,
    fecha_elaboracion DATETIME2 NOT NULL CONSTRAINT DF_solicitud_reqtec_fecha_elaboracion DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_solicitud_requerimiento_tecnico PRIMARY KEY CLUSTERED (solicitud_requerimiento_tecnico_id),
    CONSTRAINT UQ_solicitud_requerimiento_tecnico_solicitud UNIQUE (solicitud_id),
    CONSTRAINT FK_solicitud_reqtec_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_solicitud_reqtec_elaborado_por FOREIGN KEY (elaborado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

-- ============================================================
-- 5) TAREAS, ACTIVIDAD, PROYECTOS Y CALENDARIO
-- ============================================================

CREATE TABLE dbo.tarea_desarrollo (
    tarea_desarrollo_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NOT NULL,
    titulo VARCHAR(220) NOT NULL,
    descripcion VARCHAR(2000) NULL,
    prioridad_solicitud_id INT NOT NULL,
    estado_tarea VARCHAR(30) NOT NULL,
    fecha_inicio DATETIME2 NULL,
    fecha_compromiso DATETIME2 NULL,
    fecha_cierre DATETIME2 NULL,
    creado_por_usuario_id INT NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_tarea_desarrollo_activo DEFAULT (1),
    CONSTRAINT PK_tarea_desarrollo PRIMARY KEY CLUSTERED (tarea_desarrollo_id),
    CONSTRAINT FK_tarea_desarrollo_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_tarea_desarrollo_prioridad FOREIGN KEY (prioridad_solicitud_id) REFERENCES dbo.prioridad_solicitud(prioridad_solicitud_id),
    CONSTRAINT FK_tarea_desarrollo_creador FOREIGN KEY (creado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.tarea_desarrollo_asignacion (
    tarea_desarrollo_asignacion_id BIGINT IDENTITY(1,1) NOT NULL,
    tarea_desarrollo_id BIGINT NOT NULL,
    usuario_id INT NOT NULL,
    rol_asignacion VARCHAR(40) NULL,
    activo BIT NOT NULL CONSTRAINT DF_tarea_desarrollo_asig_activo DEFAULT (1),
    fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_tarea_desarrollo_asig_fecha DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_tarea_desarrollo_asignacion PRIMARY KEY CLUSTERED (tarea_desarrollo_asignacion_id),
    CONSTRAINT UQ_tarea_desarrollo_asignacion UNIQUE (tarea_desarrollo_id, usuario_id),
    CONSTRAINT FK_tarea_desarrollo_asig_tarea FOREIGN KEY (tarea_desarrollo_id) REFERENCES dbo.tarea_desarrollo(tarea_desarrollo_id),
    CONSTRAINT FK_tarea_desarrollo_asig_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.actividad_reciente (
    actividad_reciente_id BIGINT IDENTITY(1,1) NOT NULL,
    solicitud_id BIGINT NULL,
    tarea_desarrollo_id BIGINT NULL,
    usuario_id INT NOT NULL,
    tipo_actividad VARCHAR(40) NOT NULL,
    titulo VARCHAR(220) NOT NULL,
    detalle VARCHAR(2000) NULL,
    fecha_actividad DATETIME2 NOT NULL CONSTRAINT DF_actividad_reciente_fecha DEFAULT (SYSDATETIME()),
    visible_para_pm BIT NOT NULL CONSTRAINT DF_actividad_reciente_visible_pm DEFAULT (1),
    visible_para_desarrollador BIT NOT NULL CONSTRAINT DF_actividad_reciente_visible_dev DEFAULT (1),
    CONSTRAINT PK_actividad_reciente PRIMARY KEY CLUSTERED (actividad_reciente_id),
    CONSTRAINT FK_actividad_reciente_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_actividad_reciente_tarea FOREIGN KEY (tarea_desarrollo_id) REFERENCES dbo.tarea_desarrollo(tarea_desarrollo_id),
    CONSTRAINT FK_actividad_reciente_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.proyecto (
    proyecto_id BIGINT IDENTITY(1,1) NOT NULL,
    clave VARCHAR(40) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(1500) NULL,
    estado_proyecto VARCHAR(30) NOT NULL,
    fecha_inicio DATE NULL,
    fecha_fin_planeada DATE NULL,
    fecha_fin_real DATE NULL,
    pm_usuario_id INT NOT NULL,
    activo BIT NOT NULL CONSTRAINT DF_proyecto_activo DEFAULT (1),
    CONSTRAINT PK_proyecto PRIMARY KEY CLUSTERED (proyecto_id),
    CONSTRAINT UQ_proyecto_clave UNIQUE (clave),
    CONSTRAINT FK_proyecto_pm FOREIGN KEY (pm_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.proyecto_solicitud (
    proyecto_solicitud_id BIGINT IDENTITY(1,1) NOT NULL,
    proyecto_id BIGINT NOT NULL,
    solicitud_id BIGINT NOT NULL,
    fecha_vinculacion DATETIME2 NOT NULL CONSTRAINT DF_proyecto_solicitud_fecha_vinc DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_proyecto_solicitud PRIMARY KEY CLUSTERED (proyecto_solicitud_id),
    CONSTRAINT UQ_proyecto_solicitud UNIQUE (proyecto_id, solicitud_id),
    CONSTRAINT FK_proyecto_solicitud_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
    CONSTRAINT FK_proyecto_solicitud_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id)
);
GO

CREATE TABLE dbo.proyecto_miembro (
    proyecto_miembro_id BIGINT IDENTITY(1,1) NOT NULL,
    proyecto_id BIGINT NOT NULL,
    usuario_id INT NOT NULL,
    rol_en_proyecto VARCHAR(40) NOT NULL,
    carga_estimada_pct DECIMAL(5,2) NULL,
    activo BIT NOT NULL CONSTRAINT DF_proyecto_miembro_activo DEFAULT (1),
    fecha_inicio DATETIME2 NOT NULL CONSTRAINT DF_proyecto_miembro_fecha_inicio DEFAULT (SYSDATETIME()),
    fecha_fin DATETIME2 NULL,
    CONSTRAINT PK_proyecto_miembro PRIMARY KEY CLUSTERED (proyecto_miembro_id),
    CONSTRAINT UQ_proyecto_miembro UNIQUE (proyecto_id, usuario_id),
    CONSTRAINT FK_proyecto_miembro_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
    CONSTRAINT FK_proyecto_miembro_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.documento_proyecto (
    documento_proyecto_id BIGINT IDENTITY(1,1) NOT NULL,
    proyecto_id BIGINT NOT NULL,
    solicitud_id BIGINT NULL,
    nombre_documento VARCHAR(255) NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    version_documento VARCHAR(40) NULL,
    ruta_archivo VARCHAR(600) NOT NULL,
    tamanio_bytes BIGINT NULL,
    subido_por_usuario_id INT NOT NULL,
    fecha_subida DATETIME2 NOT NULL CONSTRAINT DF_documento_proyecto_fecha_subida DEFAULT (SYSDATETIME()),
    visible_para_participantes BIT NOT NULL CONSTRAINT DF_documento_proyecto_visible DEFAULT (1),
    CONSTRAINT PK_documento_proyecto PRIMARY KEY CLUSTERED (documento_proyecto_id),
    CONSTRAINT FK_documento_proyecto_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
    CONSTRAINT FK_documento_proyecto_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_documento_proyecto_usuario FOREIGN KEY (subido_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.evento_calendario (
    evento_calendario_id BIGINT IDENTITY(1,1) NOT NULL,
    proyecto_id BIGINT NULL,
    solicitud_id BIGINT NULL,
    titulo VARCHAR(220) NOT NULL,
    descripcion VARCHAR(2000) NULL,
    tipo_evento VARCHAR(40) NOT NULL,
    fecha_inicio DATETIME2 NOT NULL,
    fecha_fin DATETIME2 NULL,
    creado_por_usuario_id INT NOT NULL,
    es_todo_dia BIT NOT NULL CONSTRAINT DF_evento_calendario_todo_dia DEFAULT (0),
    CONSTRAINT PK_evento_calendario PRIMARY KEY CLUSTERED (evento_calendario_id),
    CONSTRAINT FK_evento_calendario_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
    CONSTRAINT FK_evento_calendario_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
    CONSTRAINT FK_evento_calendario_usuario FOREIGN KEY (creado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

CREATE TABLE dbo.evento_participante (
    evento_participante_id BIGINT IDENTITY(1,1) NOT NULL,
    evento_calendario_id BIGINT NOT NULL,
    usuario_id INT NOT NULL,
    asistencia VARCHAR(20) NOT NULL,
    CONSTRAINT PK_evento_participante PRIMARY KEY CLUSTERED (evento_participante_id),
    CONSTRAINT UQ_evento_participante UNIQUE (evento_calendario_id, usuario_id),
    CONSTRAINT FK_evento_participante_evento FOREIGN KEY (evento_calendario_id) REFERENCES dbo.evento_calendario(evento_calendario_id),
    CONSTRAINT FK_evento_participante_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
);
GO

-- ============================================================
-- 6) INDICES DE APOYO OPERATIVO
-- ============================================================

CREATE INDEX IX_usuario_area_usuario_activo ON dbo.usuario_area(usuario_id, activo);
CREATE INDEX IX_area_sistema_area_activo ON dbo.area_sistema(area_id, activo);
CREATE INDEX IX_sistema_desarrollador_usuario_activo ON dbo.sistema_desarrollador(usuario_id, activo);
CREATE INDEX IX_solicitud_estado_fecha ON dbo.solicitud(estado_solicitud_id, fecha_solicitud DESC);
CREATE INDEX IX_solicitud_area_estado ON dbo.solicitud(area_solicitante_id, estado_solicitud_id);
CREATE INDEX IX_solicitud_historial_solicitud_fecha ON dbo.solicitud_historial_estado(solicitud_id, fecha_cambio DESC);
CREATE INDEX IX_tarea_solicitud_estado ON dbo.tarea_desarrollo(solicitud_id, estado_tarea);
CREATE INDEX IX_notificacion_usuario_leida ON dbo.notificacion(usuario_id, leida, fecha_creacion DESC);
CREATE INDEX IX_actividad_reciente_fecha ON dbo.actividad_reciente(fecha_actividad DESC);
GO

PRINT 'Esquema ISSEG_DB creado correctamente en SQL Server 2022.';
GO
