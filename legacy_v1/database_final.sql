-- ============================================
-- SGSPCSI - SCRIPT FINAL SQL SERVER 2019+
-- Modelo validado por fases 1 a 5
-- ============================================

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF DB_ID(N'SGSPCSI') IS NULL
BEGIN
    CREATE DATABASE SGSPCSI;
END;
GO

USE SGSPCSI;
GO

-- ============================================
-- TABLAS MAESTRAS
-- ============================================

IF OBJECT_ID(N'dbo.roles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.roles (
        rol_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_roles PRIMARY KEY,
        nombre_rol NVARCHAR(50) NOT NULL CONSTRAINT UQ_roles_nombre_rol UNIQUE,
        descripcion NVARCHAR(255) NULL,
        permisos NVARCHAR(MAX) NULL,
        estado BIT NOT NULL CONSTRAINT DF_roles_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_roles_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_modificacion DATETIME2 NOT NULL CONSTRAINT DF_roles_fecha_modificacion DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF OBJECT_ID(N'dbo.departamentos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.departamentos (
        departamento_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_departamentos PRIMARY KEY,
        nombre_departamento NVARCHAR(200) NOT NULL,
        descripcion NVARCHAR(255) NULL,
        jefe_departamento_id INT NULL,
        estado BIT NOT NULL CONSTRAINT DF_departamentos_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_departamentos_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_modificacion DATETIME2 NOT NULL CONSTRAINT DF_departamentos_fecha_modificacion DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF OBJECT_ID(N'dbo.usuarios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.usuarios (
        usuario_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_usuarios PRIMARY KEY,
        correo_electronico NVARCHAR(100) NOT NULL CONSTRAINT UQ_usuarios_correo_electronico UNIQUE,
        contrasena_hash NVARCHAR(255) NOT NULL,
        rol_id INT NOT NULL,
        estado BIT NOT NULL CONSTRAINT DF_usuarios_estado DEFAULT (1),
        intentos_fallidos INT NOT NULL CONSTRAINT DF_usuarios_intentos_fallidos DEFAULT (0),
        ultimo_acceso DATETIME2 NULL,
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_usuarios_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_modificacion DATETIME2 NOT NULL CONSTRAINT DF_usuarios_fecha_modificacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_usuarios_roles FOREIGN KEY (rol_id) REFERENCES dbo.roles(rol_id),
        CONSTRAINT CK_usuarios_intentos_fallidos CHECK (intentos_fallidos >= 0)
    );
END;
GO

IF OBJECT_ID(N'dbo.personas', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.personas (
        persona_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_personas PRIMARY KEY,
        usuario_id INT NOT NULL CONSTRAINT UQ_personas_usuario_id UNIQUE,
        nombre NVARCHAR(100) NOT NULL,
        apellido_paterno NVARCHAR(100) NOT NULL,
        apellido_materno NVARCHAR(100) NULL,
        numero_empleado NVARCHAR(20) NULL,
        departamento_id INT NULL,
        puesto NVARCHAR(100) NULL,
        telefono NVARCHAR(20) NULL,
        extension NVARCHAR(10) NULL,
        fotografia NVARCHAR(255) NULL,
        estado BIT NOT NULL CONSTRAINT DF_personas_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_personas_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_modificacion DATETIME2 NOT NULL CONSTRAINT DF_personas_fecha_modificacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_personas_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT FK_personas_departamentos FOREIGN KEY (departamento_id) REFERENCES dbo.departamentos(departamento_id)
    );
END;
GO

IF OBJECT_ID(N'dbo.tipos_solicitud', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tipos_solicitud (
        tipo_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_tipos_solicitud PRIMARY KEY,
        nombre_tipo NVARCHAR(50) NOT NULL CONSTRAINT UQ_tipos_solicitud_nombre_tipo UNIQUE,
        descripcion NVARCHAR(255) NULL,
        prefijo_folio NVARCHAR(5) NOT NULL,
        requiere_aprobacion BIT NOT NULL CONSTRAINT DF_tipos_solicitud_requiere_aprobacion DEFAULT (1),
        estado BIT NOT NULL CONSTRAINT DF_tipos_solicitud_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_tipos_solicitud_fecha_creacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_tipos_solicitud_prefijo CHECK (LEN(prefijo_folio) BETWEEN 2 AND 5)
    );
END;
GO

IF OBJECT_ID(N'dbo.subtipos_modificacion', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.subtipos_modificacion (
        subtipo_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_subtipos_modificacion PRIMARY KEY,
        nombre_subtipo NVARCHAR(50) NOT NULL CONSTRAINT UQ_subtipos_modificacion_nombre_subtipo UNIQUE,
        descripcion NVARCHAR(255) NULL,
        estado BIT NOT NULL CONSTRAINT DF_subtipos_modificacion_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_subtipos_modificacion_fecha_creacion DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF OBJECT_ID(N'dbo.estados_solicitud', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.estados_solicitud (
        estado_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_estados_solicitud PRIMARY KEY,
        nombre_estado NVARCHAR(50) NOT NULL CONSTRAINT UQ_estados_solicitud_nombre_estado UNIQUE,
        descripcion NVARCHAR(255) NULL,
        orden INT NULL,
        es_terminal BIT NOT NULL CONSTRAINT DF_estados_solicitud_es_terminal DEFAULT (0),
        estado BIT NOT NULL CONSTRAINT DF_estados_solicitud_estado DEFAULT (1),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_estados_solicitud_fecha_creacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_estados_solicitud_orden CHECK (orden IS NULL OR orden > 0)
    );
END;
GO

-- ============================================
-- TABLAS TRANSACCIONALES
-- ============================================

IF OBJECT_ID(N'dbo.solicitudes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitudes (
        solicitud_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_solicitudes PRIMARY KEY,
        folio NVARCHAR(20) NOT NULL CONSTRAINT UQ_solicitudes_folio UNIQUE,
        tipo_id INT NOT NULL,
        subtipo_id INT NULL,
        estado_id INT NOT NULL,
        usuario_solicitante_id INT NOT NULL,
        solicitud_padre_id INT NULL,
        titulo NVARCHAR(255) NOT NULL,
        descripcion NVARCHAR(MAX) NOT NULL,
        prioridad NVARCHAR(20) NOT NULL CONSTRAINT DF_solicitudes_prioridad DEFAULT (N'Media'),
        impacto NVARCHAR(20) NULL,
        riesgo_tecnico NVARCHAR(20) NULL,
        complejidad_estimada NVARCHAR(20) NULL,
        criterios_exito NVARCHAR(MAX) NULL,
        tiempo_estimado_horas INT NULL,
        requiere_requerimientos BIT NOT NULL CONSTRAINT DF_solicitudes_requiere_requerimientos DEFAULT (0),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_solicitudes_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_vencimiento DATETIME2 NULL,
        fecha_envio DATETIME2 NULL,
        fecha_aprobacion DATETIME2 NULL,
        fecha_inicio_desarrollo DATETIME2 NULL,
        fecha_pausa DATETIME2 NULL,
        fecha_reanudacion DATETIME2 NULL,
        fecha_finalizacion DATETIME2 NULL,
        motivo_rechazo NVARCHAR(MAX) NULL,
        motivo_pausa NVARCHAR(MAX) NULL,
        observaciones NVARCHAR(MAX) NULL,
        estado_registro BIT NOT NULL CONSTRAINT DF_solicitudes_estado_registro DEFAULT (1),
        fecha_modificacion DATETIME2 NOT NULL CONSTRAINT DF_solicitudes_fecha_modificacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_solicitudes_tipos_solicitud FOREIGN KEY (tipo_id) REFERENCES dbo.tipos_solicitud(tipo_id),
        CONSTRAINT FK_solicitudes_subtipos_modificacion FOREIGN KEY (subtipo_id) REFERENCES dbo.subtipos_modificacion(subtipo_id),
        CONSTRAINT FK_solicitudes_estados_solicitud FOREIGN KEY (estado_id) REFERENCES dbo.estados_solicitud(estado_id),
        CONSTRAINT FK_solicitudes_usuarios FOREIGN KEY (usuario_solicitante_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT FK_solicitudes_padre FOREIGN KEY (solicitud_padre_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT CK_solicitudes_prioridad CHECK (prioridad IN (N'Alta', N'Media', N'Baja')),
        CONSTRAINT CK_solicitudes_impacto CHECK (impacto IS NULL OR impacto IN (N'bajo', N'medio', N'alto', N'critico')),
        CONSTRAINT CK_solicitudes_riesgo_tecnico CHECK (riesgo_tecnico IS NULL OR riesgo_tecnico IN (N'bajo', N'medio', N'alto')),
        CONSTRAINT CK_solicitudes_complejidad CHECK (complejidad_estimada IS NULL OR complejidad_estimada IN (N'baja', N'media', N'alta')),
        CONSTRAINT CK_solicitudes_tiempo_estimado CHECK (tiempo_estimado_horas IS NULL OR tiempo_estimado_horas > 0),
        CONSTRAINT CK_solicitudes_requerimientos CHECK (requiere_requerimientos IN (0,1)),
        CONSTRAINT CK_solicitudes_estado_registro CHECK (estado_registro IN (0,1)),
        CONSTRAINT CK_solicitudes_fechas CHECK (
            (fecha_reanudacion IS NULL OR fecha_pausa IS NULL OR fecha_reanudacion >= fecha_pausa)
            AND (fecha_finalizacion IS NULL OR fecha_inicio_desarrollo IS NULL OR fecha_finalizacion >= fecha_inicio_desarrollo)
        )
    );
END;
GO

IF OBJECT_ID(N'dbo.aprobaciones', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.aprobaciones (
        aprobacion_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_aprobaciones PRIMARY KEY,
        solicitud_id INT NOT NULL,
        usuario_aprobador_id INT NOT NULL,
        estado_aprobacion NVARCHAR(20) NOT NULL,
        comentarios NVARCHAR(MAX) NULL,
        fecha_aprobacion DATETIME2 NOT NULL CONSTRAINT DF_aprobaciones_fecha_aprobacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_aprobaciones_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT FK_aprobaciones_usuarios FOREIGN KEY (usuario_aprobador_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_aprobaciones_estado CHECK (estado_aprobacion IN (N'aprobada', N'rechazada', N'solicitar_info'))
    );
END;
GO

IF OBJECT_ID(N'dbo.asignaciones', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.asignaciones (
        asignacion_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_asignaciones PRIMARY KEY,
        solicitud_id INT NOT NULL,
        desarrollador_id INT NOT NULL,
        asignado_por_id INT NOT NULL,
        porcentaje_asignacion INT NOT NULL CONSTRAINT DF_asignaciones_porcentaje DEFAULT (100),
        fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_asignaciones_fecha_asignacion DEFAULT SYSUTCDATETIME(),
        fecha_desasignacion DATETIME2 NULL,
        motivo_desasignacion NVARCHAR(255) NULL,
        es_activa BIT NOT NULL CONSTRAINT DF_asignaciones_es_activa DEFAULT (1),
        CONSTRAINT FK_asignaciones_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT FK_asignaciones_desarrollador FOREIGN KEY (desarrollador_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT FK_asignaciones_asignado_por FOREIGN KEY (asignado_por_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_asignaciones_porcentaje CHECK (porcentaje_asignacion BETWEEN 1 AND 100),
        CONSTRAINT CK_asignaciones_es_activa CHECK (es_activa IN (0,1))
    );
END;
GO

IF OBJECT_ID(N'dbo.archivos_adjuntos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.archivos_adjuntos (
        archivo_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_archivos_adjuntos PRIMARY KEY,
        solicitud_id INT NOT NULL,
        usuario_cargador_id INT NOT NULL,
        nombre_archivo NVARCHAR(255) NOT NULL,
        extension NVARCHAR(10) NOT NULL,
        tipo_mime NVARCHAR(100) NULL,
        tamaño_bytes BIGINT NOT NULL,
        ruta_almacenamiento NVARCHAR(MAX) NOT NULL,
        hash_archivo NVARCHAR(128) NULL,
        fecha_carga DATETIME2 NOT NULL CONSTRAINT DF_archivos_adjuntos_fecha_carga DEFAULT SYSUTCDATETIME(),
        estado_registro BIT NOT NULL CONSTRAINT DF_archivos_adjuntos_estado_registro DEFAULT (1),
        CONSTRAINT FK_archivos_adjuntos_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT FK_archivos_adjuntos_usuarios FOREIGN KEY (usuario_cargador_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_archivos_adjuntos_tamaño CHECK (tamaño_bytes > 0),
        CONSTRAINT CK_archivos_adjuntos_estado_registro CHECK (estado_registro IN (0,1))
    );
END;
GO

IF OBJECT_ID(N'dbo.notificaciones', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.notificaciones (
        notificacion_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_notificaciones PRIMARY KEY,
        usuario_destino_id INT NOT NULL,
        solicitud_id INT NULL,
        titulo NVARCHAR(120) NOT NULL,
        mensaje NVARCHAR(MAX) NOT NULL,
        tipo NVARCHAR(20) NOT NULL CONSTRAINT DF_notificaciones_tipo DEFAULT (N'informacion'),
        canal NVARCHAR(20) NOT NULL CONSTRAINT DF_notificaciones_canal DEFAULT (N'sistema'),
        leida BIT NOT NULL CONSTRAINT DF_notificaciones_leida DEFAULT (0),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_notificaciones_fecha_creacion DEFAULT SYSUTCDATETIME(),
        fecha_lectura DATETIME2 NULL,
        estado_registro BIT NOT NULL CONSTRAINT DF_notificaciones_estado_registro DEFAULT (1),
        CONSTRAINT FK_notificaciones_usuarios FOREIGN KEY (usuario_destino_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT FK_notificaciones_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT CK_notificaciones_tipo CHECK (tipo IN (N'exito', N'informacion', N'advertencia', N'peligro')),
        CONSTRAINT CK_notificaciones_canal CHECK (canal IN (N'sistema', N'correo', N'ambos')),
        CONSTRAINT CK_notificaciones_leida CHECK (leida IN (0,1)),
        CONSTRAINT CK_notificaciones_estado_registro CHECK (estado_registro IN (0,1)),
        CONSTRAINT CK_notificaciones_fecha_lectura CHECK (leida = 0 OR fecha_lectura IS NOT NULL)
    );
END;
GO

IF OBJECT_ID(N'dbo.preferencias_usuario', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.preferencias_usuario (
        preferencia_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_preferencias_usuario PRIMARY KEY,
        usuario_id INT NOT NULL CONSTRAINT UQ_preferencias_usuario_usuario_id UNIQUE,
        tema NVARCHAR(20) NOT NULL CONSTRAINT DF_preferencias_usuario_tema DEFAULT (N'claro'),
        idioma NVARCHAR(10) NOT NULL CONSTRAINT DF_preferencias_usuario_idioma DEFAULT (N'es'),
        notificaciones_email BIT NOT NULL CONSTRAINT DF_preferencias_usuario_notif_email DEFAULT (1),
        notificaciones_sistema BIT NOT NULL CONSTRAINT DF_preferencias_usuario_notif_sistema DEFAULT (1),
        formato_fecha NVARCHAR(20) NOT NULL CONSTRAINT DF_preferencias_usuario_formato_fecha DEFAULT (N'dd/MM/yyyy'),
        zona_horaria NVARCHAR(100) NOT NULL CONSTRAINT DF_preferencias_usuario_zona_horaria DEFAULT (N'America/Mexico_City'),
        items_por_pagina INT NOT NULL CONSTRAINT DF_preferencias_usuario_items DEFAULT (10),
        fecha_actualizacion DATETIME2 NOT NULL CONSTRAINT DF_preferencias_usuario_fecha_actualizacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_preferencias_usuario_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_preferencias_usuario_tema CHECK (tema IN (N'claro', N'oscuro')),
        CONSTRAINT CK_preferencias_usuario_items CHECK (items_por_pagina BETWEEN 5 AND 100)
    );
END;
GO

IF OBJECT_ID(N'dbo.certificados_usuarios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.certificados_usuarios (
        certificado_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_certificados_usuarios PRIMARY KEY,
        usuario_id INT NOT NULL,
        nombre_certificado NVARCHAR(200) NOT NULL,
        institucion_emisora NVARCHAR(200) NOT NULL,
        archivo_ruta NVARCHAR(MAX) NULL,
        url_validacion NVARCHAR(500) NULL,
        fecha_emision DATETIME2 NOT NULL,
        fecha_vencimiento DATETIME2 NULL,
        estado NVARCHAR(20) NOT NULL CONSTRAINT DF_certificados_usuarios_estado DEFAULT (N'activo'),
        fecha_creacion DATETIME2 NOT NULL CONSTRAINT DF_certificados_usuarios_fecha_creacion DEFAULT SYSUTCDATETIME(),
        estado_registro BIT NOT NULL CONSTRAINT DF_certificados_usuarios_estado_registro DEFAULT (1),
        CONSTRAINT FK_certificados_usuarios_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_certificados_usuarios_estado CHECK (estado IN (N'activo', N'vencido', N'suspendido')),
        CONSTRAINT CK_certificados_usuarios_fechas CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_emision)
    );
END;
GO

IF OBJECT_ID(N'dbo.desarrollador_especialidades', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.desarrollador_especialidades (
        especialidad_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_desarrollador_especialidades PRIMARY KEY,
        usuario_id INT NOT NULL,
        especialidad NVARCHAR(100) NOT NULL,
        nivel_experiencia INT NULL,
        fecha_obtencion DATETIME2 NOT NULL CONSTRAINT DF_desarrollador_especialidades_fecha_obtencion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_desarrollador_especialidades_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_desarrollador_especialidades_nivel CHECK (nivel_experiencia IS NULL OR nivel_experiencia BETWEEN 1 AND 5)
    );
END;
GO

IF OBJECT_ID(N'dbo.disponibilidad_desarrollador', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.disponibilidad_desarrollador (
        disponibilidad_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_disponibilidad_desarrollador PRIMARY KEY,
        usuario_id INT NOT NULL,
        fecha DATE NOT NULL,
        horas_disponibles INT NOT NULL,
        motivo_ausencia NVARCHAR(255) NULL,
        fecha_registro DATETIME2 NOT NULL CONSTRAINT DF_disponibilidad_desarrollador_fecha_registro DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_disponibilidad_desarrollador_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_disponibilidad_desarrollador_horas CHECK (horas_disponibles BETWEEN 0 AND 24)
    );
END;
GO

IF OBJECT_ID(N'dbo.auditoria_solicitudes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.auditoria_solicitudes (
        auditoria_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_auditoria_solicitudes PRIMARY KEY,
        solicitud_id INT NOT NULL,
        usuario_id INT NULL,
        accion NVARCHAR(40) NOT NULL,
        campo_modificado NVARCHAR(120) NULL,
        valor_anterior NVARCHAR(MAX) NULL,
        valor_nuevo NVARCHAR(MAX) NULL,
        motivo NVARCHAR(500) NULL,
        origen NVARCHAR(20) NOT NULL CONSTRAINT DF_auditoria_solicitudes_origen DEFAULT (N'web'),
        fecha_evento DATETIME2 NOT NULL CONSTRAINT DF_auditoria_solicitudes_fecha_evento DEFAULT SYSUTCDATETIME(),
        ip_origen NVARCHAR(50) NULL,
        agente_usuario NVARCHAR(500) NULL,
        CONSTRAINT FK_auditoria_solicitudes_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT FK_auditoria_solicitudes_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_auditoria_solicitudes_origen CHECK (origen IN (N'web', N'api', N'sistema'))
    );
END;
GO

IF OBJECT_ID(N'dbo.auditoria_acceso', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.auditoria_acceso (
        acceso_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_auditoria_acceso PRIMARY KEY,
        usuario_id INT NOT NULL,
        tipo_evento NVARCHAR(30) NOT NULL,
        exitoso BIT NOT NULL,
        ip_origen NVARCHAR(50) NULL,
        agente_usuario NVARCHAR(500) NULL,
        detalle NVARCHAR(500) NULL,
        fecha_evento DATETIME2 NOT NULL CONSTRAINT DF_auditoria_acceso_fecha_evento DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_auditoria_acceso_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_auditoria_acceso_tipo_evento CHECK (tipo_evento IN (N'INICIO_SESION_OK', N'INICIO_SESION_FALLIDO', N'CIERRE_SESION', N'TOKEN_EXPIRADO', N'CAMBIO_CONTRASENA'))
    );
END;
GO

IF OBJECT_ID(N'dbo.historial_estados_solicitud', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.historial_estados_solicitud (
        historial_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_historial_estados_solicitud PRIMARY KEY,
        solicitud_id INT NOT NULL,
        estado_origen_id INT NULL,
        estado_destino_id INT NOT NULL,
        usuario_id INT NULL,
        motivo_cambio NVARCHAR(500) NULL,
        fecha_inicio DATETIME2 NOT NULL CONSTRAINT DF_historial_estados_fecha_inicio DEFAULT SYSUTCDATETIME(),
        fecha_fin DATETIME2 NULL,
        duracion_minutos INT NULL,
        activo BIT NOT NULL CONSTRAINT DF_historial_estados_activo DEFAULT (1),
        CONSTRAINT FK_historial_estados_solicitudes FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitudes(solicitud_id),
        CONSTRAINT FK_historial_estados_origen FOREIGN KEY (estado_origen_id) REFERENCES dbo.estados_solicitud(estado_id),
        CONSTRAINT FK_historial_estados_destino FOREIGN KEY (estado_destino_id) REFERENCES dbo.estados_solicitud(estado_id),
        CONSTRAINT FK_historial_estados_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_historial_estados_activo CHECK (activo IN (0,1)),
        CONSTRAINT CK_historial_estados_duracion CHECK (duracion_minutos IS NULL OR duracion_minutos >= 0)
    );
END;
GO

IF OBJECT_ID(N'dbo.auditoria_documentos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.auditoria_documentos (
        documento_auditoria_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_auditoria_documentos PRIMARY KEY,
        archivo_id INT NOT NULL,
        usuario_id INT NOT NULL,
        tipo_evento NVARCHAR(20) NOT NULL,
        exitoso BIT NOT NULL CONSTRAINT DF_auditoria_documentos_exitoso DEFAULT (1),
        ip_origen NVARCHAR(50) NULL,
        agente_usuario NVARCHAR(500) NULL,
        detalle NVARCHAR(500) NULL,
        fecha_evento DATETIME2 NOT NULL CONSTRAINT DF_auditoria_documentos_fecha_evento DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_auditoria_documentos_archivos FOREIGN KEY (archivo_id) REFERENCES dbo.archivos_adjuntos(archivo_id),
        CONSTRAINT FK_auditoria_documentos_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
        CONSTRAINT CK_auditoria_documentos_tipo_evento CHECK (tipo_evento IN (N'VER', N'DESCARGAR'))
    );
END;
GO

-- Relaciones circulares / diferidas
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_departamentos_jefe_departamento')
BEGIN
    ALTER TABLE dbo.departamentos
    ADD CONSTRAINT FK_departamentos_jefe_departamento FOREIGN KEY (jefe_departamento_id) REFERENCES dbo.usuarios(usuario_id);
END;
GO

-- Ajustes de compatibilidad para ambientes existentes (tabla ya creada)
IF COL_LENGTH(N'dbo.solicitudes', N'impacto') IS NULL
    ALTER TABLE dbo.solicitudes ADD impacto NVARCHAR(20) NULL;
GO
IF COL_LENGTH(N'dbo.solicitudes', N'riesgo_tecnico') IS NULL
    ALTER TABLE dbo.solicitudes ADD riesgo_tecnico NVARCHAR(20) NULL;
GO
IF COL_LENGTH(N'dbo.solicitudes', N'complejidad_estimada') IS NULL
    ALTER TABLE dbo.solicitudes ADD complejidad_estimada NVARCHAR(20) NULL;
GO
IF COL_LENGTH(N'dbo.solicitudes', N'criterios_exito') IS NULL
    ALTER TABLE dbo.solicitudes ADD criterios_exito NVARCHAR(MAX) NULL;
GO
IF COL_LENGTH(N'dbo.solicitudes', N'tiempo_estimado_horas') IS NULL
    ALTER TABLE dbo.solicitudes ADD tiempo_estimado_horas INT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_solicitudes_impacto')
    ALTER TABLE dbo.solicitudes ADD CONSTRAINT CK_solicitudes_impacto CHECK (impacto IS NULL OR impacto IN (N'bajo', N'medio', N'alto', N'critico'));
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_solicitudes_riesgo_tecnico')
    ALTER TABLE dbo.solicitudes ADD CONSTRAINT CK_solicitudes_riesgo_tecnico CHECK (riesgo_tecnico IS NULL OR riesgo_tecnico IN (N'bajo', N'medio', N'alto'));
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_solicitudes_complejidad')
    ALTER TABLE dbo.solicitudes ADD CONSTRAINT CK_solicitudes_complejidad CHECK (complejidad_estimada IS NULL OR complejidad_estimada IN (N'baja', N'media', N'alta'));
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_solicitudes_tiempo_estimado')
    ALTER TABLE dbo.solicitudes ADD CONSTRAINT CK_solicitudes_tiempo_estimado CHECK (tiempo_estimado_horas IS NULL OR tiempo_estimado_horas > 0);
GO

-- ============================================
-- ÍNDICES
-- ============================================

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_usuarios_correo_electronico' AND object_id = OBJECT_ID(N'dbo.usuarios'))
    CREATE UNIQUE INDEX UX_usuarios_correo_electronico ON dbo.usuarios(correo_electronico);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_usuarios_rol_id' AND object_id = OBJECT_ID(N'dbo.usuarios'))
    CREATE INDEX IX_usuarios_rol_id ON dbo.usuarios(rol_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_personas_usuario_id' AND object_id = OBJECT_ID(N'dbo.personas'))
    CREATE UNIQUE INDEX UX_personas_usuario_id ON dbo.personas(usuario_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_personas_departamento_id' AND object_id = OBJECT_ID(N'dbo.personas'))
    CREATE INDEX IX_personas_departamento_id ON dbo.personas(departamento_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_solicitudes_folio' AND object_id = OBJECT_ID(N'dbo.solicitudes'))
    CREATE UNIQUE INDEX UX_solicitudes_folio ON dbo.solicitudes(folio);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_solicitudes_usuario_solicitante_id' AND object_id = OBJECT_ID(N'dbo.solicitudes'))
    CREATE INDEX IX_solicitudes_usuario_solicitante_id ON dbo.solicitudes(usuario_solicitante_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_solicitudes_tipo_id' AND object_id = OBJECT_ID(N'dbo.solicitudes'))
    CREATE INDEX IX_solicitudes_tipo_id ON dbo.solicitudes(tipo_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_solicitudes_estado_id' AND object_id = OBJECT_ID(N'dbo.solicitudes'))
    CREATE INDEX IX_solicitudes_estado_id ON dbo.solicitudes(estado_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_solicitudes_fecha_creacion' AND object_id = OBJECT_ID(N'dbo.solicitudes'))
    CREATE INDEX IX_solicitudes_fecha_creacion ON dbo.solicitudes(fecha_creacion DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_asignaciones_activas' AND object_id = OBJECT_ID(N'dbo.asignaciones'))
    CREATE UNIQUE INDEX UX_asignaciones_activas ON dbo.asignaciones(solicitud_id, desarrollador_id) WHERE es_activa = 1;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_aprobaciones_solicitud_id' AND object_id = OBJECT_ID(N'dbo.aprobaciones'))
    CREATE INDEX IX_aprobaciones_solicitud_id ON dbo.aprobaciones(solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_aprobaciones_usuario_aprobador_id' AND object_id = OBJECT_ID(N'dbo.aprobaciones'))
    CREATE INDEX IX_aprobaciones_usuario_aprobador_id ON dbo.aprobaciones(usuario_aprobador_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_asignaciones_solicitud_id' AND object_id = OBJECT_ID(N'dbo.asignaciones'))
    CREATE INDEX IX_asignaciones_solicitud_id ON dbo.asignaciones(solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_asignaciones_desarrollador_id' AND object_id = OBJECT_ID(N'dbo.asignaciones'))
    CREATE INDEX IX_asignaciones_desarrollador_id ON dbo.asignaciones(desarrollador_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_archivos_adjuntos_solicitud_id' AND object_id = OBJECT_ID(N'dbo.archivos_adjuntos'))
    CREATE INDEX IX_archivos_adjuntos_solicitud_id ON dbo.archivos_adjuntos(solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_notificaciones_usuario_destino_id' AND object_id = OBJECT_ID(N'dbo.notificaciones'))
    CREATE INDEX IX_notificaciones_usuario_destino_id ON dbo.notificaciones(usuario_destino_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_notificaciones_leida' AND object_id = OBJECT_ID(N'dbo.notificaciones'))
    CREATE INDEX IX_notificaciones_leida ON dbo.notificaciones(leida);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_preferencias_usuario_usuario_id' AND object_id = OBJECT_ID(N'dbo.preferencias_usuario'))
    CREATE UNIQUE INDEX UX_preferencias_usuario_usuario_id ON dbo.preferencias_usuario(usuario_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_certificados_usuarios_usuario_id' AND object_id = OBJECT_ID(N'dbo.certificados_usuarios'))
    CREATE INDEX IX_certificados_usuarios_usuario_id ON dbo.certificados_usuarios(usuario_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_certificados_usuarios_estado' AND object_id = OBJECT_ID(N'dbo.certificados_usuarios'))
    CREATE INDEX IX_certificados_usuarios_estado ON dbo.certificados_usuarios(estado, fecha_vencimiento);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_desarrollador_especialidades_usuario_id' AND object_id = OBJECT_ID(N'dbo.desarrollador_especialidades'))
    CREATE INDEX IX_desarrollador_especialidades_usuario_id ON dbo.desarrollador_especialidades(usuario_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_disponibilidad_desarrollador_usuario_fecha' AND object_id = OBJECT_ID(N'dbo.disponibilidad_desarrollador'))
    CREATE UNIQUE INDEX UX_disponibilidad_desarrollador_usuario_fecha ON dbo.disponibilidad_desarrollador(usuario_id, fecha);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_disponibilidad_desarrollador_fecha' AND object_id = OBJECT_ID(N'dbo.disponibilidad_desarrollador'))
    CREATE INDEX IX_disponibilidad_desarrollador_fecha ON dbo.disponibilidad_desarrollador(fecha);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_solicitudes_solicitud_id' AND object_id = OBJECT_ID(N'dbo.auditoria_solicitudes'))
    CREATE INDEX IX_auditoria_solicitudes_solicitud_id ON dbo.auditoria_solicitudes(solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_solicitudes_fecha_evento' AND object_id = OBJECT_ID(N'dbo.auditoria_solicitudes'))
    CREATE INDEX IX_auditoria_solicitudes_fecha_evento ON dbo.auditoria_solicitudes(fecha_evento DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_acceso_usuario_id' AND object_id = OBJECT_ID(N'dbo.auditoria_acceso'))
    CREATE INDEX IX_auditoria_acceso_usuario_id ON dbo.auditoria_acceso(usuario_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_acceso_fecha_evento' AND object_id = OBJECT_ID(N'dbo.auditoria_acceso'))
    CREATE INDEX IX_auditoria_acceso_fecha_evento ON dbo.auditoria_acceso(fecha_evento DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_historial_estados_solicitud_solicitud_id' AND object_id = OBJECT_ID(N'dbo.historial_estados_solicitud'))
    CREATE INDEX IX_historial_estados_solicitud_solicitud_id ON dbo.historial_estados_solicitud(solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_historial_estados_activo' AND object_id = OBJECT_ID(N'dbo.historial_estados_solicitud'))
    CREATE INDEX IX_historial_estados_activo ON dbo.historial_estados_solicitud(activo, solicitud_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_documentos_archivo_id' AND object_id = OBJECT_ID(N'dbo.auditoria_documentos'))
    CREATE INDEX IX_auditoria_documentos_archivo_id ON dbo.auditoria_documentos(archivo_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_auditoria_documentos_fecha_evento' AND object_id = OBJECT_ID(N'dbo.auditoria_documentos'))
    CREATE INDEX IX_auditoria_documentos_fecha_evento ON dbo.auditoria_documentos(fecha_evento DESC);
GO

-- ============================================
-- CARGA INICIAL DE CATÁLOGOS
-- ============================================

IF NOT EXISTS (SELECT 1 FROM dbo.roles)
BEGIN
    INSERT INTO dbo.roles (nombre_rol, descripcion, permisos, estado)
    VALUES
        (N'usuario', N'Usuario Final / Cliente', N'{"crear_solicitud":true,"ver_solicitudes":true,"cargar_archivos":true}', 1),
        (N'desarrollador', N'Desarrollador', N'{"ver_asignadas":true,"actualizar_estado":true,"cargar_archivos":true}', 1),
        (N'gestor_producto', N'Gestor de Producto', N'{"aprobar_solicitudes":true,"rechazar_solicitudes":true,"asignar_desarrolladores":true,"generar_reportes":true}', 1),
        (N'administrador', N'Administrador', N'{"crear_usuarios":true,"gestionar_roles":true,"acceso_total":true}', 1);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.tipos_solicitud)
BEGIN
    INSERT INTO dbo.tipos_solicitud (nombre_tipo, descripcion, prefijo_folio, requiere_aprobacion, estado)
    VALUES
        (N'nuevo_sistema', N'Solicitud de nuevo sistema', N'SIS', 1, 1),
        (N'requerimientos', N'Requerimientos técnicos', N'REQ', 1, 1),
        (N'modificacion', N'Solicitud de modificación', N'MOD', 1, 1),
        (N'urgente', N'Falla urgente', N'URG', 1, 1);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.subtipos_modificacion)
BEGIN
    INSERT INTO dbo.subtipos_modificacion (nombre_subtipo, descripcion, estado)
    VALUES
        (N'correctiva', N'Corrección de errores', 1),
        (N'evolutiva', N'Mejora o nueva funcionalidad', 1),
        (N'adaptativa', N'Adaptación a normativa', 1);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.estados_solicitud)
BEGIN
    INSERT INTO dbo.estados_solicitud (nombre_estado, descripcion, orden, es_terminal, estado)
    VALUES
        (N'pendiente', N'Solicitud creada, esperando revisión', 1, 0, 1),
        (N'aprobada', N'Solicitud aprobada, lista para desarrollo', 2, 0, 1),
        (N'en_desarrollo', N'En desarrollo', 3, 0, 1),
        (N'pausada', N'Desarrollo pausado por urgencia u otro bloqueo', 4, 0, 1),
        (N'completada', N'Solicitud completada y entregada', 5, 1, 1),
        (N'rechazada', N'Solicitud rechazada', 6, 1, 1);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.departamentos)
BEGIN
    DECLARE @DepartamentosJson NVARCHAR(MAX) = N'["COORD DE ANÁL DE INV EN CAPITALES DIVISAS Y DERIV", "COORD DE VIG. DE DER. Y ARCHIVO", "COORD. CONTABILIDAD", "COORD. DE RECURSOS HUMANOS", "COORDINACIÓN DE ANÁLISIS DE INVERSIÓN EN MERCADO DE DEUDA Y PROYECTOS DE INVERSIÓN", "COORDINACION DE ANALISIS ESTADISTICO Y ECONOMICO", "COORDINACION DE ANALISIS NORMATIVO Y PROYECTOS", "COORDINACIÓN DE COBRANZA DE PRESTACIONES", "COORDINACION DE COMUNICACIÓN SOCIAL Y RELACIONES PUBLICAS", "COORDINACIÓN DE CONTROL INTERNO Y TRANSPARENCIA", "COORDINACION DE COSTOS E INVENTARIOS", "COORDINACION DE EGRESOS Y SERVICIOS FINANCIEROS", "COORDINACION DE ESTRATEGIA E INTELIGENCIA DE PRECIOS", "COORDINACION DE ESTUDIOS ACTUARIALES", "COORDINACION DE INGRESOS", "COORDINACIÓN DE INVESTIGACIÓN", "COORDINACIÓN DE LO CONTENCIOSO Y PROCEDIMIENTOS JURIDICOS", "COORDINACIÓN DE MERCADOTECNIA", "COORDINACIÓN DE PLANEACIÓN Y DESARROLLO INSTITUCIONAL", "COORDINACIÓN DE PRESTAMOS CON GARANTIA HIPOTECARIA", "COORDINACIÓN DE PRESTAMOS PERSONALES Y SERVICIOS", "COORDINACION DE PRESUPUESTO Y GASTO DE LA DIRECCION COMERCIAL", "COORDINACION DE RECURSOS EN FARMACIA", "COORDINACION DE RECURSOS MATERIALES Y SERVICIOS GENERALES", "COORDINACION DE REDES Y SOPORTE TECNICO", "COORDINACION DE RIESGOS FINANCIEROS", "COORDINACIÓN DE SEGUROS", "COORDINACION DE SISTEMAS COMERCIALES", "COORDINACION DE SISTEMAS INSTITUCIONALES", "COORDINACION DE SUBSTANCIACION Y RESOLUCION", "COORDINACION DE VENTAS Y OPERACIONES", "COORDINACION JURIDICA DE ADMINISTRACION LEGAL", "COORDINACION JURIDICA DE CONSULTORIA Y ANALISIS NORMATIVO", "COORDINACION JURIDICA DE LITIGIO Y COBRANZA", "COORDINACION JURIDICA DE SEGUROS", "COORDINACION OPERATIVA DE AUDITORIA INTERNA", "COORDINACION OPERATIVA DE EVALUACION Y SEGUIMIENTO", "DEPARTAMENTO DE ADQUISICIONES", "DEPARTAMENTO DE AFILIACIÓN", "DEPARTAMENTO DE ALMACEN DE RECURSOS MATE", "DEPARTAMENTO DE CAPACITACIÓN Y DESARROLLO", "DEPARTAMENTO DE COBRANZA COMERCIAL", "DEPARTAMENTO DE COBRANZA DE PRESTACIONES", "DEPARTAMENTO DE CONTROL BANCARIO Y CONTABLE", "DEPARTAMENTO DE CONTROL DE ARCHIVOS", "DEPARTAMENTO DE CONTROL DE BIENES MUEBLES", "DEPARTAMENTO DE CONTROL DE PAGOS", "DEPARTAMENTO DE COSTOS", "DEPARTAMENTO DE DEVOLUCIONES", "DEPARTAMENTO DE DIGITALIZACION", "DEPARTAMENTO DE GESTION DE COBRANZA", "DEPARTAMENTO DE INFRAESTRUCTURA Y SEGURIDAD", "DEPARTAMENTO DE INGRESO Y ESTRUCTURA", "DEPARTAMENTO DE INGRESOS COMERCIALES", "DEPARTAMENTO DE INGRESOS VARIOS", "DEPARTAMENTO DE INVENTARIOS", "DEPARTAMENTO DE MANTENIMIENTO", "DEPARTAMENTO DE MANTENIMIENTO A INMUEBLES", "DEPARTAMENTO DE OPERACION INTERNA Y GESTION ADMINISTRATIVA", "DEPARTAMENTO DE OPERACIONES DIVERSAS", "DEPARTAMENTO DE PAGO A PROVEEDORES", "DEPARTAMENTO DE PAGOS DE SEGUROS", "DEPARTAMENTO DE PENSIONES Y SEGUROS", "DEPARTAMENTO DE PRESUPUESTO", "DEPARTAMENTO DE PROCESOS, SEGURIDAD E HIGIENE", "DEPARTAMENTO DE PROYECTOS FINANCIEROS", "DEPARTAMENTO DE RECEPCION Y REABASTO", "DEPARTAMENTO DE REMESAS", "DEPARTAMENTO DE SERVICIOS GENERALES", "DEPARTAMENTO DE SISTEMAS AUTOMATIZADOS DE ALMACEN", "DEPARTAMENTO DE SURTIMIENTO", "DEPARTAMENTO DE TRANSACCIONES EN EFECTIVO", "DEPARTAMENTO EN COBRANZA E INCUMPLIMIENTO", "DEPARTAMENTO FISCAL", "DEPARTAMENTO PROMOCION", "DEPTO. DE ARCHIVO", "DEPTO. DE ARRENDAMIENTOS Y PROYS", "DEPTO. DE CONCS. BANCARIAS", "DEPTO. DE DISEÑO", "DEPTO. DE ESTACIONAMIENTOS", "DEPTO. DE MANTENIMIENTO E IMAGEN", "DEPTO. DE NOMINA", "DEPTO. DE PREST. Y SERVS AL PERS.", "DEPTO. DE SISTEMA DE AHORRO VOL.", "DEPTO. DE TRAFICO Y DISTRIBUCION", "DEPTO. DE VIGENCIA DE DERECHOS", "DIRECCION COMERCIAL", "DIRECCION DE ADMINISTRACION", "DIRECCIÓN DE AFILIACIÓN, VIGENCIA DE DERECHOS Y COBRANZA", "DIRECCION DE ANALISIS ACTUARIAL, ECONOMICO Y DE RIESGOS FINANCIEROS", "DIRECCION DE COMPRAS Y LOGÍSTICA", "DIRECCION DE FINANZAS", "DIRECCION DE INVERSIONES", "DIRECCION DE PLANEACION", "DIRECCIÓN DE PRESTACIONES", "DIRECCIÓN DE SEGUROS", "DIRECCION DE TECNOLOGIAS DE  INFORMACION", "DIRECCION GENERAL DE SEG. SOCIAL", "DIRECCION INMOBILIARIA", "DIRECCION JURIDICA", "GCIA DE DESARROLLO INMOBILIARIO", "GERENCIA DE ADMINISTRACION  Y COMERCIALIZACION DE INMUEBLES", "GERENCIA DE COMPRAS", "GERENCIA DE LOGISTICA", "GERENCIA DE VENTAS", "ORGANO INTERNO DE CONTROL", "SECRETARIA PARTICULAR", "SERVICIOS FUNERARIOS", "SUBDIR. GENERAL DE PLANEACION", "SUBDIR. GRAL DE PRESTACIONES", "SUBDIR.GRAL DE UNI.DE NEGS.", "SUBDIRECCIÓN GENERAL DE ADMINISTRACIÓN, FINANZAS E INVERSIONES"]';

    INSERT INTO dbo.departamentos (nombre_departamento, descripcion, estado)
    SELECT LTRIM(RTRIM(j.[value])) AS nombre_departamento,
           LTRIM(RTRIM(j.[value])) AS descripcion,
           1 AS estado
    FROM OPENJSON(@DepartamentosJson) AS j
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.departamentos d
        WHERE d.nombre_departamento = LTRIM(RTRIM(j.[value]))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.usuarios)
BEGIN
    INSERT INTO dbo.usuarios (correo_electronico, contrasena_hash, rol_id, estado)
    SELECT N'usuario@isseg.gob.mx', LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', N'user123'), 2)), r.rol_id, 1
    FROM dbo.roles r WHERE r.nombre_rol = N'usuario';

    INSERT INTO dbo.usuarios (correo_electronico, contrasena_hash, rol_id, estado)
    SELECT N'desarrollador@isseg.gob.mx', LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', N'dev123'), 2)), r.rol_id, 1
    FROM dbo.roles r WHERE r.nombre_rol = N'desarrollador';

    INSERT INTO dbo.usuarios (correo_electronico, contrasena_hash, rol_id, estado)
    SELECT N'pm@isseg.gob.mx', LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', N'pm123'), 2)), r.rol_id, 1
    FROM dbo.roles r WHERE r.nombre_rol = N'gestor_producto';

    INSERT INTO dbo.usuarios (correo_electronico, contrasena_hash, rol_id, estado)
    SELECT N'admin@isseg.gob.mx', LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', N'admin123'), 2)), r.rol_id, 1
    FROM dbo.roles r WHERE r.nombre_rol = N'administrador';
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.personas)
BEGIN
    INSERT INTO dbo.personas (usuario_id, nombre, apellido_paterno, apellido_materno, numero_empleado, departamento_id, puesto, telefono, extension, fotografia, estado)
    SELECT u.usuario_id, N'Juan Carlos', N'García', N'Hernández', N'EMP-2024-0123', (SELECT TOP 1 departamento_id FROM dbo.departamentos ORDER BY departamento_id), N'Empleado', N'(473) 123-4567', N'1234', NULL, 1
    FROM dbo.usuarios u WHERE u.correo_electronico = N'usuario@isseg.gob.mx';

    INSERT INTO dbo.personas (usuario_id, nombre, apellido_paterno, apellido_materno, numero_empleado, departamento_id, puesto, telefono, extension, fotografia, estado)
    SELECT u.usuario_id, N'Laura', N'Martínez', N'López', N'EMP-DEV-042', (SELECT TOP 1 departamento_id FROM dbo.departamentos ORDER BY departamento_id), N'Desarrollador', N'(473) 555-1122', N'9988', NULL, 1
    FROM dbo.usuarios u WHERE u.correo_electronico = N'desarrollador@isseg.gob.mx';

    INSERT INTO dbo.personas (usuario_id, nombre, apellido_paterno, apellido_materno, numero_empleado, departamento_id, puesto, telefono, extension, fotografia, estado)
    SELECT u.usuario_id, N'Roberto', N'Sánchez', N'García', N'EMP-PM-001', (SELECT TOP 1 departamento_id FROM dbo.departamentos ORDER BY departamento_id), N'Gestor de Producto', N'(473) 555-9876', N'5678', NULL, 1
    FROM dbo.usuarios u WHERE u.correo_electronico = N'pm@isseg.gob.mx';

    INSERT INTO dbo.personas (usuario_id, nombre, apellido_paterno, apellido_materno, numero_empleado, departamento_id, puesto, telefono, extension, fotografia, estado)
    SELECT u.usuario_id, N'Administrador', N'Sistema', NULL, N'EMP-ADM-001', (SELECT TOP 1 departamento_id FROM dbo.departamentos ORDER BY departamento_id), N'Administrador', N'(473) 555-0000', N'0000', NULL, 1
    FROM dbo.usuarios u WHERE u.correo_electronico = N'admin@isseg.gob.mx';
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.departamentos WHERE jefe_departamento_id IS NOT NULL)
BEGIN
    UPDATE d
    SET jefe_departamento_id = pm.usuario_id
    FROM dbo.departamentos d
    CROSS JOIN (SELECT TOP 1 usuario_id FROM dbo.usuarios WHERE correo_electronico = N'pm@isseg.gob.mx') pm
    WHERE d.jefe_departamento_id IS NULL AND d.nombre_departamento LIKE N'DIRECCION%';
END;
GO

-- ============================================
-- VISTAS OPERATIVAS
-- ============================================

CREATE OR ALTER VIEW dbo.vw_solicitudes_resumen
AS
SELECT
    s.solicitud_id,
    s.folio,
    ts.nombre_tipo AS tipo_solicitud,
    sm.nombre_subtipo AS subtipo_modificacion,
    es.nombre_estado AS estado_actual,
    s.titulo,
    s.prioridad,
    CONCAT(p.nombre, N' ', p.apellido_paterno) AS solicitante,
    s.fecha_creacion,
    s.fecha_aprobacion,
    s.fecha_inicio_desarrollo,
    s.fecha_finalizacion
FROM dbo.solicitudes s
INNER JOIN dbo.tipos_solicitud ts ON ts.tipo_id = s.tipo_id
LEFT JOIN dbo.subtipos_modificacion sm ON sm.subtipo_id = s.subtipo_id
INNER JOIN dbo.estados_solicitud es ON es.estado_id = s.estado_id
INNER JOIN dbo.usuarios u ON u.usuario_id = s.usuario_solicitante_id
INNER JOIN dbo.personas p ON p.usuario_id = u.usuario_id
WHERE s.estado_registro = 1;
GO

CREATE OR ALTER VIEW dbo.vw_solicitudes_pendientes_pm
AS
SELECT
    s.solicitud_id,
    s.folio,
    ts.nombre_tipo AS tipo_solicitud,
    s.titulo,
    s.prioridad,
    s.fecha_creacion,
    CONCAT(p.nombre, N' ', p.apellido_paterno) AS solicitante
FROM dbo.solicitudes s
INNER JOIN dbo.tipos_solicitud ts ON ts.tipo_id = s.tipo_id
INNER JOIN dbo.estados_solicitud es ON es.estado_id = s.estado_id
INNER JOIN dbo.usuarios u ON u.usuario_id = s.usuario_solicitante_id
INNER JOIN dbo.personas p ON p.usuario_id = u.usuario_id
WHERE es.nombre_estado = N'pendiente'
  AND ts.requiere_aprobacion = 1
  AND s.estado_registro = 1;
GO

CREATE OR ALTER VIEW dbo.vw_solicitudes_asignadas_dev
AS
SELECT
    a.asignacion_id,
    s.solicitud_id,
    s.folio,
    s.titulo,
    s.prioridad,
    es.nombre_estado AS estado_actual,
    CONCAT(pd.nombre, N' ', pd.apellido_paterno) AS desarrollador,
    a.fecha_asignacion,
    a.es_activa
FROM dbo.asignaciones a
INNER JOIN dbo.solicitudes s ON s.solicitud_id = a.solicitud_id
INNER JOIN dbo.estados_solicitud es ON es.estado_id = s.estado_id
INNER JOIN dbo.usuarios udev ON udev.usuario_id = a.desarrollador_id
INNER JOIN dbo.personas pd ON pd.usuario_id = udev.usuario_id
WHERE a.es_activa = 1;
GO

CREATE OR ALTER VIEW dbo.vw_auditoria_solicitud_detalle
AS
SELECT
    N'auditoria_solicitudes' AS fuente,
    a.solicitud_id,
    s.folio,
    a.usuario_id,
    CONCAT(COALESCE(p.nombre, N''), N' ', COALESCE(p.apellido_paterno, N'')) AS actor,
    a.accion AS evento,
    a.campo_modificado,
    a.motivo,
    a.valor_anterior,
    a.valor_nuevo,
    a.fecha_evento
FROM dbo.auditoria_solicitudes a
INNER JOIN dbo.solicitudes s ON s.solicitud_id = a.solicitud_id
LEFT JOIN dbo.usuarios u ON u.usuario_id = a.usuario_id
LEFT JOIN dbo.personas p ON p.usuario_id = u.usuario_id
UNION ALL
SELECT
    N'aprobaciones' AS fuente,
    ap.solicitud_id,
    s.folio,
    ap.usuario_aprobador_id AS usuario_id,
    CONCAT(COALESCE(p.nombre, N''), N' ', COALESCE(p.apellido_paterno, N'')) AS actor,
    ap.estado_aprobacion AS evento,
    N'estado_aprobacion' AS campo_modificado,
    ap.comentarios AS motivo,
    NULL AS valor_anterior,
    ap.estado_aprobacion AS valor_nuevo,
    ap.fecha_aprobacion AS fecha_evento
FROM dbo.aprobaciones ap
INNER JOIN dbo.solicitudes s ON s.solicitud_id = ap.solicitud_id
LEFT JOIN dbo.usuarios u ON u.usuario_id = ap.usuario_aprobador_id
LEFT JOIN dbo.personas p ON p.usuario_id = u.usuario_id
UNION ALL
SELECT
    N'asignaciones' AS fuente,
    asg.solicitud_id,
    s.folio,
    asg.asignado_por_id AS usuario_id,
    CONCAT(COALESCE(p.nombre, N''), N' ', COALESCE(p.apellido_paterno, N'')) AS actor,
    CASE WHEN asg.es_activa = 1 THEN N'ASIGNADO' ELSE N'DESASIGNADO' END AS evento,
    N'asignacion' AS campo_modificado,
    asg.motivo_desasignacion AS motivo,
    NULL AS valor_anterior,
    CONCAT(N'desarrollador_id=', asg.desarrollador_id) AS valor_nuevo,
    asg.fecha_asignacion AS fecha_evento
FROM dbo.asignaciones asg
INNER JOIN dbo.solicitudes s ON s.solicitud_id = asg.solicitud_id
LEFT JOIN dbo.usuarios u ON u.usuario_id = asg.asignado_por_id
LEFT JOIN dbo.personas p ON p.usuario_id = u.usuario_id
UNION ALL
SELECT
    N'archivos_adjuntos' AS fuente,
    fa.solicitud_id,
    s.folio,
    fa.usuario_cargador_id AS usuario_id,
    CONCAT(COALESCE(p.nombre, N''), N' ', COALESCE(p.apellido_paterno, N'')) AS actor,
    N'ADJUNTO' AS evento,
    fa.extension AS campo_modificado,
    NULL AS motivo,
    NULL AS valor_anterior,
    fa.nombre_archivo AS valor_nuevo,
    fa.fecha_carga AS fecha_evento
FROM dbo.archivos_adjuntos fa
INNER JOIN dbo.solicitudes s ON s.solicitud_id = fa.solicitud_id
LEFT JOIN dbo.usuarios u ON u.usuario_id = fa.usuario_cargador_id
LEFT JOIN dbo.personas p ON p.usuario_id = u.usuario_id
UNION ALL
SELECT
    N'historial_estados_solicitud' AS fuente,
    h.solicitud_id,
    s.folio,
    h.usuario_id,
    CONCAT(COALESCE(p.nombre, N''), N' ', COALESCE(p.apellido_paterno, N'')) AS actor,
    N'CAMBIO_ESTADO' AS evento,
    N'estado_destino_id' AS campo_modificado,
    h.motivo_cambio AS motivo,
    CONCAT(N'estado_origen_id=', COALESCE(CONVERT(NVARCHAR(20), h.estado_origen_id), N'NULL')) AS valor_anterior,
    CONCAT(N'estado_destino_id=', h.estado_destino_id) AS valor_nuevo,
    h.fecha_inicio AS fecha_evento
FROM dbo.historial_estados_solicitud h
INNER JOIN dbo.solicitudes s ON s.solicitud_id = h.solicitud_id
LEFT JOIN dbo.usuarios u ON u.usuario_id = h.usuario_id
LEFT JOIN dbo.personas p ON p.usuario_id = u.usuario_id;
GO

CREATE OR ALTER VIEW dbo.vw_notificaciones_no_leidas
AS
SELECT
    n.notificacion_id,
    n.usuario_destino_id,
    CONCAT(p.nombre, N' ', p.apellido_paterno) AS usuario_destino,
    n.solicitud_id,
    s.folio,
    n.titulo,
    n.mensaje,
    n.tipo,
    n.canal,
    n.fecha_creacion
FROM dbo.notificaciones n
INNER JOIN dbo.usuarios u ON u.usuario_id = n.usuario_destino_id
INNER JOIN dbo.personas p ON p.usuario_id = u.usuario_id
LEFT JOIN dbo.solicitudes s ON s.solicitud_id = n.solicitud_id
WHERE n.leida = 0;
GO

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================

CREATE OR ALTER PROCEDURE dbo.sp_registrar_auditoria_solicitud
    @solicitud_id INT,
    @usuario_id INT = NULL,
    @accion NVARCHAR(40),
    @campo_modificado NVARCHAR(120) = NULL,
    @valor_anterior NVARCHAR(MAX) = NULL,
    @valor_nuevo NVARCHAR(MAX) = NULL,
    @motivo NVARCHAR(500) = NULL,
    @origen NVARCHAR(20) = N'web',
    @ip_origen NVARCHAR(50) = NULL,
    @agente_usuario NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.auditoria_solicitudes
    (
        solicitud_id, usuario_id, accion, campo_modificado,
        valor_anterior, valor_nuevo, motivo, origen, fecha_evento,
        ip_origen, agente_usuario
    )
    VALUES
    (
        @solicitud_id, @usuario_id, @accion, @campo_modificado,
        @valor_anterior, @valor_nuevo, @motivo, @origen, SYSUTCDATETIME(),
        @ip_origen, @agente_usuario
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_auditoria_acceso
    @usuario_id INT,
    @tipo_evento NVARCHAR(30),
    @exitoso BIT,
    @ip_origen NVARCHAR(50) = NULL,
    @agente_usuario NVARCHAR(500) = NULL,
    @detalle NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.auditoria_acceso
    (
        usuario_id, tipo_evento, exitoso, ip_origen,
        agente_usuario, detalle, fecha_evento
    )
    VALUES
    (
        @usuario_id, @tipo_evento, @exitoso, @ip_origen,
        @agente_usuario, @detalle, SYSUTCDATETIME()
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_auditoria_documento
    @archivo_id INT,
    @usuario_id INT,
    @tipo_evento NVARCHAR(20),
    @exitoso BIT = 1,
    @ip_origen NVARCHAR(50) = NULL,
    @agente_usuario NVARCHAR(500) = NULL,
    @detalle NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.auditoria_documentos
    (
        archivo_id, usuario_id, tipo_evento, exitoso,
        ip_origen, agente_usuario, detalle, fecha_evento
    )
    VALUES
    (
        @archivo_id, @usuario_id, @tipo_evento, @exitoso,
        @ip_origen, @agente_usuario, @detalle, SYSUTCDATETIME()
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_historial_estado
    @solicitud_id INT,
    @estado_origen_id INT = NULL,
    @estado_destino_id INT,
    @usuario_id INT = NULL,
    @motivo_cambio NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.historial_estados_solicitud
    (
        solicitud_id, estado_origen_id, estado_destino_id, usuario_id,
        motivo_cambio, fecha_inicio, fecha_fin, duracion_minutos, activo
    )
    VALUES
    (
        @solicitud_id, @estado_origen_id, @estado_destino_id, @usuario_id,
        @motivo_cambio, SYSUTCDATETIME(), NULL, NULL, 1
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_crear_solicitud
    @tipo_id INT,
    @usuario_solicitante_id INT,
    @titulo NVARCHAR(255),
    @descripcion NVARCHAR(MAX),
    @folio_generado NVARCHAR(20) OUTPUT,
    @subtipo_id INT = NULL,
    @prioridad NVARCHAR(20) = N'Media',
    @fecha_vencimiento DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @prefijo NVARCHAR(5);
    DECLARE @tipo_modificacion_id INT;
    DECLARE @anio NVARCHAR(4) = CONVERT(NVARCHAR(4), YEAR(SYSUTCDATETIME()));
    DECLARE @secuencia INT;
    DECLARE @estado_pendiente INT;

    SELECT @prefijo = prefijo_folio
    FROM dbo.tipos_solicitud
    WHERE tipo_id = @tipo_id;

    IF @prefijo IS NULL
        THROW 50001, 'El tipo de solicitud no existe.', 1;

    SELECT @tipo_modificacion_id = tipo_id
    FROM dbo.tipos_solicitud
    WHERE nombre_tipo = N'modificacion';

    IF @tipo_id = @tipo_modificacion_id AND @subtipo_id IS NULL
        THROW 50004, 'Las solicitudes de modificación requieren subtipo.', 1;

    SELECT @secuencia = ISNULL(MAX(TRY_CAST(RIGHT(folio, 3) AS INT)), 0) + 1
    FROM dbo.solicitudes
    WHERE folio LIKE CONCAT(@prefijo, N'-', @anio, N'-%');

    SET @folio_generado = CONCAT(@prefijo, N'-', @anio, N'-', RIGHT(CONCAT(N'000', @secuencia), 3));

    SELECT @estado_pendiente = estado_id
    FROM dbo.estados_solicitud
    WHERE nombre_estado = N'pendiente';

    BEGIN TRANSACTION;

    INSERT INTO dbo.solicitudes
    (
        folio, tipo_id, subtipo_id, estado_id, usuario_solicitante_id,
        titulo, descripcion, prioridad, fecha_vencimiento,
        fecha_creacion, estado_registro, fecha_modificacion
    )
    VALUES
    (
        @folio_generado, @tipo_id,
        CASE WHEN @tipo_id = (SELECT tipo_id FROM dbo.tipos_solicitud WHERE nombre_tipo = N'modificacion') THEN @subtipo_id ELSE NULL END,
        @estado_pendiente, @usuario_solicitante_id,
        @titulo, @descripcion, @prioridad, @fecha_vencimiento,
        SYSUTCDATETIME(), 1, SYSUTCDATETIME()
    );

    DECLARE @solicitud_id INT = SCOPE_IDENTITY();

    EXEC dbo.sp_registrar_historial_estado
        @solicitud_id = @solicitud_id,
        @estado_origen_id = NULL,
        @estado_destino_id = @estado_pendiente,
        @usuario_id = @usuario_solicitante_id,
        @motivo_cambio = N'Creación inicial de solicitud';

    EXEC dbo.sp_registrar_auditoria_solicitud
        @solicitud_id = @solicitud_id,
        @usuario_id = @usuario_solicitante_id,
        @accion = N'CREAR',
        @campo_modificado = N'FILA',
        @valor_nuevo = @folio_generado,
        @motivo = N'Creación de solicitud';

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_cambiar_estado_solicitud
    @solicitud_id INT,
    @nuevo_estado_id INT,
    @usuario_id INT = NULL,
    @motivo_cambio NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @estado_actual_id INT;
    DECLARE @estado_actual_nombre NVARCHAR(50);
    DECLARE @nuevo_estado_nombre NVARCHAR(50);
    DECLARE @ahora DATETIME2 = SYSUTCDATETIME();

    SELECT @estado_actual_id = estado_id
    FROM dbo.solicitudes
    WHERE solicitud_id = @solicitud_id;

    IF @estado_actual_id IS NULL
        THROW 50002, 'La solicitud no existe.', 1;

    SELECT @estado_actual_nombre = nombre_estado
    FROM dbo.estados_solicitud
    WHERE estado_id = @estado_actual_id;

    SELECT @nuevo_estado_nombre = nombre_estado
    FROM dbo.estados_solicitud
    WHERE estado_id = @nuevo_estado_id;

    IF @nuevo_estado_nombre IS NULL
        THROW 50003, 'El nuevo estado no existe.', 1;

    BEGIN TRANSACTION;

    UPDATE dbo.historial_estados_solicitud
    SET fecha_fin = @ahora,
        duracion_minutos = DATEDIFF(MINUTE, fecha_inicio, @ahora),
        activo = 0
    WHERE solicitud_id = @solicitud_id
      AND activo = 1;

    UPDATE dbo.solicitudes
    SET estado_id = @nuevo_estado_id,
        fecha_modificacion = @ahora,
        fecha_aprobacion = CASE WHEN @nuevo_estado_nombre = N'aprobada' AND fecha_aprobacion IS NULL THEN @ahora ELSE fecha_aprobacion END,
        fecha_inicio_desarrollo = CASE WHEN @nuevo_estado_nombre = N'en_desarrollo' AND fecha_inicio_desarrollo IS NULL THEN @ahora ELSE fecha_inicio_desarrollo END,
        fecha_pausa = CASE WHEN @nuevo_estado_nombre = N'pausada' THEN @ahora ELSE fecha_pausa END,
        fecha_reanudacion = CASE WHEN @estado_actual_nombre = N'pausada' AND @nuevo_estado_nombre = N'en_desarrollo' THEN @ahora ELSE fecha_reanudacion END,
        fecha_finalizacion = CASE WHEN @nuevo_estado_nombre = N'completada' THEN @ahora ELSE fecha_finalizacion END,
        motivo_pausa = CASE WHEN @nuevo_estado_nombre = N'pausada' THEN COALESCE(@motivo_cambio, motivo_pausa) ELSE motivo_pausa END,
        motivo_rechazo = CASE WHEN @nuevo_estado_nombre = N'rechazada' THEN COALESCE(@motivo_cambio, motivo_rechazo) ELSE motivo_rechazo END
    WHERE solicitud_id = @solicitud_id;

    EXEC dbo.sp_registrar_historial_estado
        @solicitud_id = @solicitud_id,
        @estado_origen_id = @estado_actual_id,
        @estado_destino_id = @nuevo_estado_id,
        @usuario_id = @usuario_id,
        @motivo_cambio = @motivo_cambio;

    EXEC dbo.sp_registrar_auditoria_solicitud
        @solicitud_id = @solicitud_id,
        @usuario_id = @usuario_id,
        @accion = N'CAMBIO_ESTADO',
        @campo_modificado = N'estado_id',
        @valor_anterior = @estado_actual_nombre,
        @valor_nuevo = @nuevo_estado_nombre,
        @motivo = @motivo_cambio,
        @origen = N'sistema';

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_aprobacion
    @solicitud_id INT,
    @usuario_aprobador_id INT,
    @decision NVARCHAR(20),
    @comentarios NVARCHAR(MAX) = NULL,
    @motivo_cambio NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rol_nombre NVARCHAR(50);
    DECLARE @estado_destino_id INT;
    DECLARE @estado_actual_id INT;

    IF @decision NOT IN (N'aprobada', N'rechazada', N'solicitar_info')
        THROW 50009, 'La decisión no es válida.', 1;

    SELECT @rol_nombre = r.nombre_rol
    FROM dbo.usuarios u
    INNER JOIN dbo.roles r ON r.rol_id = u.rol_id
    WHERE u.usuario_id = @usuario_aprobador_id;

    IF @rol_nombre IS NULL
        THROW 50013, 'El usuario aprobador no existe.', 1;

    IF @rol_nombre <> N'gestor_producto'
        THROW 50010, 'Solo un Gestor de Producto puede registrar aprobaciones.', 1;

    IF @decision = N'rechazada' AND (@comentarios IS NULL OR LTRIM(RTRIM(@comentarios)) = N'')
        THROW 50011, 'Si la decisión es rechazada, los comentarios son obligatorios.', 1;

    SELECT @estado_actual_id = estado_id
    FROM dbo.solicitudes
    WHERE solicitud_id = @solicitud_id;

    IF @estado_actual_id IS NULL
        THROW 50012, 'La solicitud no existe.', 1;

    SELECT @estado_destino_id = estado_id
    FROM dbo.estados_solicitud
    WHERE nombre_estado = CASE
        WHEN @decision = N'aprobada' THEN N'aprobada'
        WHEN @decision = N'rechazada' THEN N'rechazada'
        ELSE N'pendiente'
    END;

    BEGIN TRANSACTION;

    INSERT INTO dbo.aprobaciones (solicitud_id, usuario_aprobador_id, estado_aprobacion, comentarios, fecha_aprobacion)
    VALUES (@solicitud_id, @usuario_aprobador_id, @decision, @comentarios, SYSUTCDATETIME());

    IF @decision = N'aprobada'
        EXEC dbo.sp_cambiar_estado_solicitud @solicitud_id = @solicitud_id, @nuevo_estado_id = @estado_destino_id, @usuario_id = @usuario_aprobador_id, @motivo_cambio = @motivo_cambio;
    ELSE IF @decision = N'rechazada'
        EXEC dbo.sp_cambiar_estado_solicitud @solicitud_id = @solicitud_id, @nuevo_estado_id = @estado_destino_id, @usuario_id = @usuario_aprobador_id, @motivo_cambio = @comentarios;

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_asignar_desarrollador
    @solicitud_id INT,
    @desarrollador_id INT,
    @asignado_por_id INT,
    @porcentaje_asignacion INT = 100,
    @motivo_desasignacion NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rol_nombre NVARCHAR(50);
    DECLARE @rol_asigna NVARCHAR(50);
    DECLARE @valor_nuevo_auditoria NVARCHAR(100);
    SELECT @rol_nombre = r.nombre_rol
    FROM dbo.usuarios u
    INNER JOIN dbo.roles r ON r.rol_id = u.rol_id
    WHERE u.usuario_id = @desarrollador_id;

    SELECT @rol_asigna = r.nombre_rol
    FROM dbo.usuarios u
    INNER JOIN dbo.roles r ON r.rol_id = u.rol_id
    WHERE u.usuario_id = @asignado_por_id;

    IF @rol_nombre IS NULL
        THROW 50022, 'El desarrollador no existe.', 1;

    IF @rol_asigna IS NULL
        THROW 50023, 'El usuario que asigna no existe.', 1;

    IF @rol_nombre <> N'desarrollador'
        THROW 50020, 'El usuario destino debe tener rol desarrollador.', 1;

    IF @rol_asigna <> N'gestor_producto'
        THROW 50021, 'Solo un Gestor de Producto puede asignar desarrolladores.', 1;

    BEGIN TRANSACTION;

    UPDATE dbo.asignaciones
    SET es_activa = 0,
        fecha_desasignacion = SYSUTCDATETIME(),
        motivo_desasignacion = COALESCE(@motivo_desasignacion, motivo_desasignacion)
    WHERE solicitud_id = @solicitud_id
      AND desarrollador_id = @desarrollador_id
      AND es_activa = 1;

    INSERT INTO dbo.asignaciones
    (
        solicitud_id, desarrollador_id, asignado_por_id,
        porcentaje_asignacion, fecha_asignacion,
        fecha_desasignacion, motivo_desasignacion, es_activa
    )
    VALUES
    (
        @solicitud_id, @desarrollador_id, @asignado_por_id,
        @porcentaje_asignacion, SYSUTCDATETIME(),
        NULL, NULL, 1
    );

    SET @valor_nuevo_auditoria = CONCAT(N'desarrollador_id=', CONVERT(NVARCHAR(20), @desarrollador_id));

    EXEC dbo.sp_registrar_auditoria_solicitud
        @solicitud_id = @solicitud_id,
        @usuario_id = @asignado_por_id,
        @accion = N'ASIGNAR',
        @campo_modificado = N'desarrollador_id',
        @valor_anterior = NULL,
        @valor_nuevo = @valor_nuevo_auditoria,
        @motivo = N'Asignación de desarrollador',
        @origen = N'sistema';

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_marcar_notificacion_leida
    @notificacion_id INT,
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.notificaciones
    SET leida = 1,
        fecha_lectura = COALESCE(fecha_lectura, SYSUTCDATETIME())
    WHERE notificacion_id = @notificacion_id
      AND usuario_destino_id = @usuario_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_descarga_documento
    @archivo_id INT,
    @usuario_id INT,
    @tipo_evento NVARCHAR(20),
    @ip_origen NVARCHAR(50) = NULL,
    @agente_usuario NVARCHAR(500) = NULL,
    @detalle NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    EXEC dbo.sp_registrar_auditoria_documento
        @archivo_id = @archivo_id,
        @usuario_id = @usuario_id,
        @tipo_evento = @tipo_evento,
        @exitoso = 1,
        @ip_origen = @ip_origen,
        @agente_usuario = @agente_usuario,
        @detalle = @detalle;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_guardar_preferencias_usuario
    @usuario_id INT,
    @tema NVARCHAR(20) = N'claro',
    @idioma NVARCHAR(10) = N'es',
    @notificaciones_email BIT = 1,
    @notificaciones_sistema BIT = 1,
    @formato_fecha NVARCHAR(20) = N'dd/MM/yyyy',
    @zona_horaria NVARCHAR(100) = N'America/Mexico_City',
    @items_por_pagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuarios WHERE usuario_id = @usuario_id)
        THROW 50030, 'El usuario no existe.', 1;

    MERGE dbo.preferencias_usuario AS destino
    USING (SELECT @usuario_id AS usuario_id) AS origen
    ON destino.usuario_id = origen.usuario_id
    WHEN MATCHED THEN
        UPDATE SET
            tema = @tema,
            idioma = @idioma,
            notificaciones_email = @notificaciones_email,
            notificaciones_sistema = @notificaciones_sistema,
            formato_fecha = @formato_fecha,
            zona_horaria = @zona_horaria,
            items_por_pagina = @items_por_pagina,
            fecha_actualizacion = SYSUTCDATETIME()
    WHEN NOT MATCHED THEN
        INSERT (usuario_id, tema, idioma, notificaciones_email, notificaciones_sistema, formato_fecha, zona_horaria, items_por_pagina, fecha_actualizacion)
        VALUES (@usuario_id, @tema, @idioma, @notificaciones_email, @notificaciones_sistema, @formato_fecha, @zona_horaria, @items_por_pagina, SYSUTCDATETIME())
    ;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_certificado_usuario
    @usuario_id INT,
    @nombre_certificado NVARCHAR(200),
    @institucion_emisora NVARCHAR(200),
    @fecha_emision DATETIME2,
    @fecha_vencimiento DATETIME2 = NULL,
    @archivo_ruta NVARCHAR(MAX) = NULL,
    @url_validacion NVARCHAR(500) = NULL,
    @estado NVARCHAR(20) = N'activo'
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuarios WHERE usuario_id = @usuario_id)
        THROW 50031, 'El usuario no existe.', 1;

    INSERT INTO dbo.certificados_usuarios
    (
        usuario_id, nombre_certificado, institucion_emisora,
        archivo_ruta, url_validacion, fecha_emision, fecha_vencimiento,
        estado, fecha_creacion, estado_registro
    )
    VALUES
    (
        @usuario_id, @nombre_certificado, @institucion_emisora,
        @archivo_ruta, @url_validacion, @fecha_emision, @fecha_vencimiento,
        @estado, SYSUTCDATETIME(), 1
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_especialidad_desarrollador
    @usuario_id INT,
    @especialidad NVARCHAR(100),
    @nivel_experiencia INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuarios WHERE usuario_id = @usuario_id)
        THROW 50032, 'El usuario no existe.', 1;

    INSERT INTO dbo.desarrollador_especialidades
    (
        usuario_id, especialidad, nivel_experiencia, fecha_obtencion
    )
    VALUES
    (
        @usuario_id, @especialidad, @nivel_experiencia, SYSUTCDATETIME()
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_disponibilidad_desarrollador
    @usuario_id INT,
    @fecha DATE,
    @horas_disponibles INT,
    @motivo_ausencia NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuarios WHERE usuario_id = @usuario_id)
        THROW 50033, 'El usuario no existe.', 1;

    MERGE dbo.disponibilidad_desarrollador AS destino
    USING (SELECT @usuario_id AS usuario_id, @fecha AS fecha) AS origen
    ON destino.usuario_id = origen.usuario_id AND destino.fecha = origen.fecha
    WHEN MATCHED THEN
        UPDATE SET
            horas_disponibles = @horas_disponibles,
            motivo_ausencia = @motivo_ausencia,
            fecha_registro = SYSUTCDATETIME()
    WHEN NOT MATCHED THEN
        INSERT (usuario_id, fecha, horas_disponibles, motivo_ausencia, fecha_registro)
        VALUES (@usuario_id, @fecha, @horas_disponibles, @motivo_ausencia, SYSUTCDATETIME())
    ;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_obtener_carga_desarrollador
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuarios WHERE usuario_id = @usuario_id)
        THROW 50034, 'El usuario no existe.', 1;

    SELECT
        @usuario_id AS usuario_id,
        COUNT(DISTINCT a.solicitud_id) AS solicitudes_activas,
        ISNULL(SUM(a.porcentaje_asignacion), 0) AS carga_porcentaje,
        dd.fecha,
        dd.horas_disponibles,
        dd.motivo_ausencia
    FROM dbo.asignaciones a
    LEFT JOIN dbo.disponibilidad_desarrollador dd
        ON dd.usuario_id = @usuario_id
       AND dd.fecha = CAST(SYSUTCDATETIME() AS DATE)
    WHERE a.desarrollador_id = @usuario_id
      AND a.es_activa = 1
    GROUP BY dd.fecha, dd.horas_disponibles, dd.motivo_ausencia;
END;
GO

-- ============================================
-- VALIDACIÓN FINAL
-- ============================================

PRINT N'=========================================';
PRINT N'SGSPCSI - Script final cargado correctamente';
PRINT N'=========================================';
PRINT N'Tablas maestras: roles, departamentos, usuarios, personas, tipos_solicitud, subtipos_modificacion, estados_solicitud';
PRINT N'Tablas operativas: solicitudes, aprobaciones, asignaciones, archivos_adjuntos, notificaciones, preferencias_usuario, certificados_usuarios, desarrollador_especialidades, disponibilidad_desarrollador';
PRINT N'Auditoría: auditoria_solicitudes, auditoria_acceso, historial_estados_solicitud, auditoria_documentos';
PRINT N'Vistas: vw_solicitudes_resumen, vw_solicitudes_pendientes_pm, vw_solicitudes_asignadas_dev, vw_auditoria_solicitud_detalle, vw_notificaciones_no_leidas';
PRINT N'Procedimientos: creación, cambio de estado, aprobación, asignación, notificaciones, auditoría, preferencias, certificados y carga de equipo';
PRINT N'=========================================';
GO



