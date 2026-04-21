/*
  Extension del modelo SGSPCSI para cubrir pantallas de:
  - Usuario solicitante
  - Desarrollador
  - PM
  Script incremental e idempotente para SQL Server.
*/

SET NOCOUNT ON;
GO

/* ======================================================
   1) AUTENTICACION Y MENUS DINAMICOS
   ====================================================== */

IF OBJECT_ID('dbo.usuario_credencial', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.usuario_credencial (
        usuario_id               INT NOT NULL PRIMARY KEY,
        login_usuario            VARCHAR(80) NOT NULL UNIQUE,
        password_hash            VARBINARY(512) NOT NULL,
        password_salt            VARBINARY(128) NOT NULL,
        algoritmo_hash           VARCHAR(30) NOT NULL CONSTRAINT DF_usuario_credencial_algoritmo DEFAULT ('PBKDF2'),
        iteraciones              INT NOT NULL CONSTRAINT DF_usuario_credencial_iteraciones DEFAULT (100000),
        ultimo_acceso            DATETIME2 NULL,
        intentos_fallidos        SMALLINT NOT NULL CONSTRAINT DF_usuario_credencial_intentos DEFAULT (0),
        bloqueado_hasta          DATETIME2 NULL,
        requiere_cambio_password BIT NOT NULL CONSTRAINT DF_usuario_credencial_requiere_cambio DEFAULT (0),
        fecha_actualizacion      DATETIME2 NOT NULL CONSTRAINT DF_usuario_credencial_fecha_act DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_usuario_credencial_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
    );
END;
GO

IF OBJECT_ID('dbo.menu_opcion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.menu_opcion (
        menu_opcion_id           INT IDENTITY(1,1) PRIMARY KEY,
        clave                    VARCHAR(60) NOT NULL UNIQUE,
        nombre                   VARCHAR(120) NOT NULL,
        ruta                     VARCHAR(220) NOT NULL,
        icono                    VARCHAR(80) NULL,
        orden                    INT NOT NULL,
        activa                   BIT NOT NULL CONSTRAINT DF_menu_opcion_activa DEFAULT (1),
        menu_padre_id            INT NULL,
        CONSTRAINT FK_menu_opcion_padre FOREIGN KEY (menu_padre_id) REFERENCES dbo.menu_opcion(menu_opcion_id)
    );
END;
GO

IF OBJECT_ID('dbo.rol_menu_opcion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.rol_menu_opcion (
        rol_menu_opcion_id       INT IDENTITY(1,1) PRIMARY KEY,
        rol_id                   INT NOT NULL,
        menu_opcion_id           INT NOT NULL,
        puede_ver                BIT NOT NULL CONSTRAINT DF_rol_menu_ver DEFAULT (1),
        puede_editar             BIT NOT NULL CONSTRAINT DF_rol_menu_editar DEFAULT (0),
        puede_aprobar            BIT NOT NULL CONSTRAINT DF_rol_menu_aprobar DEFAULT (0),
        CONSTRAINT FK_rol_menu_opcion_rol FOREIGN KEY (rol_id) REFERENCES dbo.rol(rol_id),
        CONSTRAINT FK_rol_menu_opcion_menu FOREIGN KEY (menu_opcion_id) REFERENCES dbo.menu_opcion(menu_opcion_id),
        CONSTRAINT UQ_rol_menu UNIQUE (rol_id, menu_opcion_id)
    );
END;
GO

/* ======================================================
   2) FORMULARIOS Y DATOS ESPECIFICOS DE SOLICITUD
   ====================================================== */

IF OBJECT_ID('dbo.tipo_modificacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tipo_modificacion (
        tipo_modificacion_id     INT IDENTITY(1,1) PRIMARY KEY,
        clave                    VARCHAR(30) NOT NULL UNIQUE, /* ADAPTATIVA | EVOLUTIVA | CORRECTIVA */
        nombre                   VARCHAR(80) NOT NULL,
        activa                   BIT NOT NULL CONSTRAINT DF_tipo_modificacion_activa DEFAULT (1)
    );
END;
GO

IF OBJECT_ID('dbo.solicitud_modificacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitud_modificacion (
        solicitud_modificacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        solicitud_id              BIGINT NOT NULL UNIQUE,
        tipo_modificacion_id      INT NOT NULL,
        sistema_version_actual    VARCHAR(80) NULL,
        modulo_afectado           VARCHAR(200) NULL,
        impacto_tecnico           VARCHAR(1500) NULL,
        justificacion             VARCHAR(2000) NULL,
        fecha_registro            DATETIME2 NOT NULL CONSTRAINT DF_solicitud_modificacion_fecha DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_solicitud_modificacion_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_solicitud_modificacion_tipo FOREIGN KEY (tipo_modificacion_id) REFERENCES dbo.tipo_modificacion(tipo_modificacion_id)
    );
END;
GO

IF OBJECT_ID('dbo.solicitud_requerimiento_tecnico', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitud_requerimiento_tecnico (
        solicitud_requerimiento_tecnico_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        solicitud_id                       BIGINT NOT NULL UNIQUE,
        arquitectura_propuesta             VARCHAR(2000) NULL,
        alcance_tecnico                    VARCHAR(2000) NULL,
        dependencias                       VARCHAR(2000) NULL,
        criterios_aceptacion               VARCHAR(2000) NULL,
        riesgos                            VARCHAR(2000) NULL,
        plan_pruebas                       VARCHAR(2000) NULL,
        observaciones                      VARCHAR(2000) NULL,
        elaborado_por_usuario_id           INT NOT NULL,
        fecha_elaboracion                  DATETIME2 NOT NULL CONSTRAINT DF_solicitud_reqtec_fecha DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_solicitud_reqtec_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_solicitud_reqtec_usuario FOREIGN KEY (elaborado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
    );
END;
GO

/* ======================================================
   3) OPERACION TECNICA (DESARROLLADOR)
   ====================================================== */

IF OBJECT_ID('dbo.tarea_desarrollo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tarea_desarrollo (
        tarea_desarrollo_id       BIGINT IDENTITY(1,1) PRIMARY KEY,
        solicitud_id              BIGINT NOT NULL,
        titulo                    VARCHAR(220) NOT NULL,
        descripcion               VARCHAR(2000) NULL,
        prioridad_solicitud_id    INT NOT NULL,
        estado_tarea              VARCHAR(30) NOT NULL, /* PENDIENTE | EN_DESARROLLO | COMPLETADA | BLOQUEADA */
        fecha_inicio              DATETIME2 NULL,
        fecha_compromiso          DATETIME2 NULL,
        fecha_cierre              DATETIME2 NULL,
        creado_por_usuario_id     INT NOT NULL,
        activo                    BIT NOT NULL CONSTRAINT DF_tarea_desarrollo_activo DEFAULT (1),
        CONSTRAINT FK_tarea_desarrollo_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_tarea_desarrollo_prioridad FOREIGN KEY (prioridad_solicitud_id) REFERENCES dbo.prioridad_solicitud(prioridad_solicitud_id),
        CONSTRAINT FK_tarea_desarrollo_creador FOREIGN KEY (creado_por_usuario_id) REFERENCES dbo.usuario(usuario_id),
        CONSTRAINT CK_tarea_desarrollo_estado CHECK (estado_tarea IN ('PENDIENTE','EN_DESARROLLO','COMPLETADA','BLOQUEADA'))
    );
END;
GO

IF OBJECT_ID('dbo.tarea_desarrollo_asignacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tarea_desarrollo_asignacion (
        tarea_desarrollo_asignacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        tarea_desarrollo_id            BIGINT NOT NULL,
        usuario_id                     INT NOT NULL,
        rol_tecnico                    VARCHAR(30) NOT NULL, /* RESPONSABLE | PARTICIPANTE */
        activa                         BIT NOT NULL CONSTRAINT DF_tarea_asignacion_activa DEFAULT (1),
        fecha_asignacion               DATETIME2 NOT NULL CONSTRAINT DF_tarea_asignacion_fecha DEFAULT (SYSDATETIME()),
        fecha_fin                      DATETIME2 NULL,
        CONSTRAINT FK_tarea_asignacion_tarea FOREIGN KEY (tarea_desarrollo_id) REFERENCES dbo.tarea_desarrollo(tarea_desarrollo_id),
        CONSTRAINT FK_tarea_asignacion_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
        CONSTRAINT CK_tarea_asignacion_rol CHECK (rol_tecnico IN ('RESPONSABLE','PARTICIPANTE'))
    );
END;
GO

IF OBJECT_ID('dbo.actividad_reciente', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.actividad_reciente (
        actividad_reciente_id      BIGINT IDENTITY(1,1) PRIMARY KEY,
        solicitud_id               BIGINT NULL,
        tarea_desarrollo_id        BIGINT NULL,
        usuario_id                 INT NOT NULL,
        tipo_actividad             VARCHAR(40) NOT NULL, /* ASIGNACION | MENSAJE | CAMBIO_ESTADO | COMENTARIO | CARGA_DOCUMENTO */
        titulo                     VARCHAR(220) NOT NULL,
        detalle                    VARCHAR(2000) NULL,
        fecha_actividad            DATETIME2 NOT NULL CONSTRAINT DF_actividad_reciente_fecha DEFAULT (SYSDATETIME()),
        visible_para_pm            BIT NOT NULL CONSTRAINT DF_actividad_pm DEFAULT (1),
        visible_para_desarrollador BIT NOT NULL CONSTRAINT DF_actividad_dev DEFAULT (1),
        CONSTRAINT FK_actividad_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_actividad_tarea FOREIGN KEY (tarea_desarrollo_id) REFERENCES dbo.tarea_desarrollo(tarea_desarrollo_id),
        CONSTRAINT FK_actividad_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id)
    );
END;
GO

/* ======================================================
   4) PROYECTOS, DOCUMENTOS Y CALENDARIO
   ====================================================== */

IF OBJECT_ID('dbo.proyecto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.proyecto (
        proyecto_id                BIGINT IDENTITY(1,1) PRIMARY KEY,
        clave                      VARCHAR(40) NOT NULL UNIQUE,
        nombre                     VARCHAR(200) NOT NULL,
        descripcion                VARCHAR(1500) NULL,
        estado_proyecto            VARCHAR(30) NOT NULL, /* PLANEADO | EN_EJECUCION | PAUSADO | CERRADO */
        fecha_inicio               DATE NULL,
        fecha_fin_planeada         DATE NULL,
        fecha_fin_real             DATE NULL,
        pm_usuario_id              INT NOT NULL,
        activo                     BIT NOT NULL CONSTRAINT DF_proyecto_activo DEFAULT (1),
        CONSTRAINT FK_proyecto_pm FOREIGN KEY (pm_usuario_id) REFERENCES dbo.usuario(usuario_id),
        CONSTRAINT CK_proyecto_estado CHECK (estado_proyecto IN ('PLANEADO','EN_EJECUCION','PAUSADO','CERRADO'))
    );
END;
GO

IF OBJECT_ID('dbo.proyecto_solicitud', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.proyecto_solicitud (
        proyecto_solicitud_id      BIGINT IDENTITY(1,1) PRIMARY KEY,
        proyecto_id                BIGINT NOT NULL,
        solicitud_id               BIGINT NOT NULL,
        fecha_vinculacion          DATETIME2 NOT NULL CONSTRAINT DF_proyecto_solicitud_fecha DEFAULT (SYSDATETIME()),
        CONSTRAINT FK_proyecto_solicitud_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
        CONSTRAINT FK_proyecto_solicitud_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT UQ_proyecto_solicitud UNIQUE (proyecto_id, solicitud_id)
    );
END;
GO

IF OBJECT_ID('dbo.proyecto_miembro', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.proyecto_miembro (
        proyecto_miembro_id        BIGINT IDENTITY(1,1) PRIMARY KEY,
        proyecto_id                BIGINT NOT NULL,
        usuario_id                 INT NOT NULL,
        rol_en_proyecto            VARCHAR(40) NOT NULL, /* PM | DESARROLLADOR | ANALISTA | TESTER | LIDER_TECNICO */
        carga_estimada_pct         DECIMAL(5,2) NULL,
        activo                     BIT NOT NULL CONSTRAINT DF_proyecto_miembro_activo DEFAULT (1),
        fecha_inicio               DATETIME2 NOT NULL CONSTRAINT DF_proyecto_miembro_fecha_inicio DEFAULT (SYSDATETIME()),
        fecha_fin                  DATETIME2 NULL,
        CONSTRAINT FK_proyecto_miembro_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
        CONSTRAINT FK_proyecto_miembro_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
        CONSTRAINT UQ_proyecto_miembro UNIQUE (proyecto_id, usuario_id)
    );
END;
GO

IF OBJECT_ID('dbo.documento_proyecto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.documento_proyecto (
        documento_proyecto_id      BIGINT IDENTITY(1,1) PRIMARY KEY,
        proyecto_id                BIGINT NOT NULL,
        solicitud_id               BIGINT NULL,
        nombre_documento           VARCHAR(255) NOT NULL,
        tipo_documento             VARCHAR(50) NOT NULL, /* ERS | DISENO | MANUAL | MINUTA | OTRO */
        version_documento          VARCHAR(40) NULL,
        ruta_archivo               VARCHAR(600) NOT NULL,
        tamanio_bytes              BIGINT NULL,
        subido_por_usuario_id      INT NOT NULL,
        fecha_subida               DATETIME2 NOT NULL CONSTRAINT DF_documento_proyecto_fecha DEFAULT (SYSDATETIME()),
        visible_para_participantes BIT NOT NULL CONSTRAINT DF_documento_proyecto_visible DEFAULT (1),
        CONSTRAINT FK_documento_proyecto_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
        CONSTRAINT FK_documento_proyecto_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_documento_proyecto_usuario FOREIGN KEY (subido_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
    );
END;
GO

IF OBJECT_ID('dbo.evento_calendario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.evento_calendario (
        evento_calendario_id       BIGINT IDENTITY(1,1) PRIMARY KEY,
        proyecto_id                BIGINT NULL,
        solicitud_id               BIGINT NULL,
        titulo                     VARCHAR(220) NOT NULL,
        descripcion                VARCHAR(2000) NULL,
        tipo_evento                VARCHAR(40) NOT NULL, /* REUNION | ENTREGA | REVISION | DESPLIEGUE | ACTIVIDAD */
        fecha_inicio               DATETIME2 NOT NULL,
        fecha_fin                  DATETIME2 NULL,
        creado_por_usuario_id      INT NOT NULL,
        es_todo_dia                BIT NOT NULL CONSTRAINT DF_evento_todo_dia DEFAULT (0),
        CONSTRAINT FK_evento_calendario_proyecto FOREIGN KEY (proyecto_id) REFERENCES dbo.proyecto(proyecto_id),
        CONSTRAINT FK_evento_calendario_solicitud FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id),
        CONSTRAINT FK_evento_calendario_usuario FOREIGN KEY (creado_por_usuario_id) REFERENCES dbo.usuario(usuario_id)
    );
END;
GO

IF OBJECT_ID('dbo.evento_participante', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.evento_participante (
        evento_participante_id     BIGINT IDENTITY(1,1) PRIMARY KEY,
        evento_calendario_id       BIGINT NOT NULL,
        usuario_id                 INT NOT NULL,
        asistencia                 VARCHAR(20) NOT NULL CONSTRAINT DF_evento_participante_asistencia DEFAULT ('PENDIENTE'),
        CONSTRAINT FK_evento_participante_evento FOREIGN KEY (evento_calendario_id) REFERENCES dbo.evento_calendario(evento_calendario_id),
        CONSTRAINT FK_evento_participante_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id),
        CONSTRAINT UQ_evento_participante UNIQUE (evento_calendario_id, usuario_id),
        CONSTRAINT CK_evento_participante_asistencia CHECK (asistencia IN ('PENDIENTE','CONFIRMADA','RECHAZADA'))
    );
END;
GO

/* ======================================================
   5) VISTAS DE DASHBOARD (SIN DUPLICAR DATOS)
   ====================================================== */

CREATE OR ALTER VIEW dbo.vw_usuario_resumen_inicio
AS
SELECT
    s.creado_por_usuario_id AS usuario_id,
    COUNT(*) AS total_solicitudes,
    SUM(CASE WHEN es.clave IN ('ASIGNADA','EN_DESARROLLO','EN_PRUEBAS') THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN es.clave = 'APROBADA' THEN 1 ELSE 0 END) AS aprobadas,
    SUM(CASE WHEN es.clave IN ('EN_REVISION_PM','ASIGNADA','EN_DESARROLLO','EN_PRUEBAS') THEN 1 ELSE 0 END) AS en_proceso,
    SUM(CASE WHEN es.clave = 'REGISTRADA' THEN 1 ELSE 0 END) AS reportadas
FROM dbo.solicitud s
INNER JOIN dbo.estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id
GROUP BY s.creado_por_usuario_id;
GO

CREATE OR ALTER VIEW dbo.vw_desarrollador_resumen
AS
SELECT
    sd.usuario_id,
    COUNT(*) AS total_asignadas,
    SUM(CASE WHEN es.clave = 'ASIGNADA' THEN 1 ELSE 0 END) AS trabajos_pendientes,
    SUM(CASE WHEN es.clave = 'EN_DESARROLLO' THEN 1 ELSE 0 END) AS en_desarrollo,
    SUM(CASE WHEN es.clave = 'CERRADA' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN ps.clave = 'CRITICA' OR ts.clave = 'URGENTE' THEN 1 ELSE 0 END) AS urgencias
FROM dbo.solicitud_desarrollador sd
INNER JOIN dbo.solicitud s ON s.solicitud_id = sd.solicitud_id
INNER JOIN dbo.estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id
INNER JOIN dbo.prioridad_solicitud ps ON ps.prioridad_solicitud_id = s.prioridad_solicitud_id
INNER JOIN dbo.tipo_solicitud ts ON ts.tipo_solicitud_id = s.tipo_solicitud_id
WHERE sd.activo = 1
GROUP BY sd.usuario_id;
GO

CREATE OR ALTER VIEW dbo.vw_pm_resumen_general
AS
SELECT
    COUNT(*) AS total_solicitudes,
    SUM(CASE WHEN es.clave = 'EN_REVISION_PM' THEN 1 ELSE 0 END) AS pendientes_revision,
    SUM(CASE WHEN es.clave = 'APROBADA' THEN 1 ELSE 0 END) AS aprobadas,
    SUM(CASE WHEN es.clave = 'RECHAZADA' THEN 1 ELSE 0 END) AS rechazadas,
    AVG(CASE WHEN s.fecha_resolucion IS NOT NULL THEN DATEDIFF(HOUR, s.fecha_solicitud, s.fecha_resolucion) * 1.0 END) AS tiempo_promedio_horas,
    SUM(CASE WHEN es.clave = 'APROBADA' THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN es.clave IN ('APROBADA','RECHAZADA') THEN 1 ELSE 0 END), 0) AS tasa_aprobacion_pct
FROM dbo.solicitud s
INNER JOIN dbo.estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id;
GO

CREATE OR ALTER VIEW dbo.vw_pm_solicitudes_por_mes
AS
SELECT
    YEAR(s.fecha_solicitud) AS anio,
    MONTH(s.fecha_solicitud) AS mes,
    COUNT(*) AS total_solicitudes,
    SUM(CASE WHEN es.clave = 'APROBADA' THEN 1 ELSE 0 END) AS aprobadas,
    SUM(CASE WHEN es.clave = 'RECHAZADA' THEN 1 ELSE 0 END) AS rechazadas,
    SUM(CASE WHEN es.clave = 'CERRADA' THEN 1 ELSE 0 END) AS cerradas
FROM dbo.solicitud s
INNER JOIN dbo.estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id
GROUP BY YEAR(s.fecha_solicitud), MONTH(s.fecha_solicitud);
GO

CREATE OR ALTER VIEW dbo.vw_pm_carga_desarrollador
AS
SELECT
    u.usuario_id,
    u.nombre,
    COUNT(CASE WHEN es.clave IN ('ASIGNADA','EN_DESARROLLO','EN_PRUEBAS') THEN 1 END) AS carga_activa,
    COUNT(CASE WHEN es.clave = 'CERRADA' THEN 1 END) AS completadas,
    AVG(CASE WHEN s.fecha_resolucion IS NOT NULL THEN DATEDIFF(HOUR, s.fecha_solicitud, s.fecha_resolucion) * 1.0 END) AS tiempo_promedio_horas
FROM dbo.usuario u
INNER JOIN dbo.solicitud_desarrollador sd ON sd.usuario_id = u.usuario_id AND sd.activo = 1
INNER JOIN dbo.solicitud s ON s.solicitud_id = sd.solicitud_id
INNER JOIN dbo.estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id
GROUP BY u.usuario_id, u.nombre;
GO

/* ======================================================
   6) CATALOGOS MINIMOS NUEVOS
   ====================================================== */

IF NOT EXISTS (SELECT 1 FROM dbo.tipo_modificacion)
BEGIN
    INSERT INTO dbo.tipo_modificacion (clave, nombre)
    VALUES
    ('ADAPTATIVA', 'Modificacion adaptativa'),
    ('EVOLUTIVA', 'Modificacion evolutiva'),
    ('CORRECTIVA', 'Modificacion correctiva');
END;
GO
