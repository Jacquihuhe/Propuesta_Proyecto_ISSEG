-- ============================================
-- BASE DE DATOS: SGSPCSI
-- Motor: SQL Server 2019+
-- Creado: Abril 14, 2026
-- Usuario Admin: jacquihuhe (l21121538@morelia.tecnm.mx)
-- ============================================

-- 1. CREAR BASE DE DATOS
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SGSPCSI')
    DROP DATABASE SGSPCSI;
GO

CREATE DATABASE SGSPCSI;
GO

USE SGSPCSI;
GO

-- ============================================
-- 2. CREAR TABLAS MAESTRAS
-- ============================================

-- Tabla: roles
CREATE TABLE roles (
    rol_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    permisos NVARCHAR(MAX),
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla: departamentos
CREATE TABLE departamentos (
    departamento_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_departamento NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255),
    jefe_departamento_id INT,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla: usuarios
CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(100) NOT NULL UNIQUE,
    contraseña NVARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    estado BIT NOT NULL DEFAULT 1,
    intentos_fallidos INT DEFAULT 0,
    ultimo_acceso DATETIME,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id)
);
GO

-- Tabla: personas
CREATE TABLE personas (
    persona_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT NOT NULL UNIQUE,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100),
    numero_empleado NVARCHAR(20),
    departamento_id INT,
    puesto NVARCHAR(100),
    telefono NVARCHAR(20),
    extension NVARCHAR(10),
    fotografia NVARCHAR(255),
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(departamento_id)
);
GO

-- Agregar la relación jefe_departamento_id después de crear personas
ALTER TABLE departamentos
ADD CONSTRAINT fk_departamentos_jefe FOREIGN KEY (jefe_departamento_id) REFERENCES usuarios(usuario_id);
GO

-- Tabla: tipos_solicitud
CREATE TABLE tipos_solicitud (
    tipo_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_tipo NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    prefijo_folio NVARCHAR(5),
    requiere_aprobacion BIT DEFAULT 1,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla: subtipos_modificacion
CREATE TABLE subtipos_modificacion (
    subtipo_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_subtipo NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla: estados_solicitud
CREATE TABLE estados_solicitud (
    estado_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_estado NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    orden INT,
    es_terminal BIT DEFAULT 0,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO

-- ============================================
-- 3. CREAR TABLAS TRANSACCIONALES
-- ============================================

-- Tabla: solicitudes
CREATE TABLE solicitudes (
    solicitud_id INT PRIMARY KEY IDENTITY(1,1),
    folio NVARCHAR(20) NOT NULL UNIQUE,
    tipo_id INT NOT NULL,
    subtipo_id INT,
    state_id INT NOT NULL,
    usuario_solicitante_id INT NOT NULL,
    titulo NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(MAX),
    prioridad NVARCHAR(20),
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_vencimiento DATETIME,
    fecha_envio DATETIME,
    fecha_aprobacion DATETIME,
    fecha_inicio_desarrollo DATETIME,
    fecha_finalizacion DATETIME,
    motivo_rechazo NVARCHAR(MAX),
    observaciones NVARCHAR(MAX),
    estado BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (tipo_id) REFERENCES tipos_solicitud(tipo_id),
    FOREIGN KEY (subtipo_id) REFERENCES subtipos_modificacion(subtipo_id),
    FOREIGN KEY (state_id) REFERENCES estados_solicitud(estado_id),
    FOREIGN KEY (usuario_solicitante_id) REFERENCES usuarios(usuario_id)
);
GO

-- Tabla: aprobaciones
CREATE TABLE aprobaciones (
    aprobacion_id INT PRIMARY KEY IDENTITY(1,1),
    solicitud_id INT NOT NULL,
    usuario_aprobador_id INT NOT NULL,
    estado_aprobacion NVARCHAR(20) NOT NULL,
    comentarios NVARCHAR(MAX),
    fecha_aprobacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id),
    FOREIGN KEY (usuario_aprobador_id) REFERENCES usuarios(usuario_id)
);
GO

-- Tabla: asignaciones
CREATE TABLE asignaciones (
    asignacion_id INT PRIMARY KEY IDENTITY(1,1),
    solicitud_id INT NOT NULL,
    desarrollador_id INT NOT NULL,
    porcentaje_asignacion INT DEFAULT 100,
    fecha_asignacion DATETIME DEFAULT GETDATE(),
    fecha_desasignacion DATETIME,
    estado_asignacion BIT DEFAULT 1,
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id),
    FOREIGN KEY (desarrollador_id) REFERENCES usuarios(usuario_id)
);
GO

-- Tabla: archivos_adjuntos
CREATE TABLE archivos_adjuntos (
    archivo_id INT PRIMARY KEY IDENTITY(1,1),
    solicitud_id INT NOT NULL,
    nombre_archivo NVARCHAR(255) NOT NULL,
    tipo_archivo NVARCHAR(50),
    ruta_almacenamiento NVARCHAR(MAX) NOT NULL,
    tamaño_bytes BIGINT,
    usuario_cargador_id INT,
    fecha_carga DATETIME DEFAULT GETDATE(),
    estado BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id),
    FOREIGN KEY (usuario_cargador_id) REFERENCES usuarios(usuario_id)
);
GO

-- Tabla: notificaciones
CREATE TABLE notificaciones (
    notificacion_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_destino_id INT NOT NULL,
    titulo NVARCHAR(100) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    tipo NVARCHAR(20) DEFAULT 'info',
    solicitud_id INT,
    leida BIT DEFAULT 0,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_lectura DATETIME,
    canal_entrega NVARCHAR(50) DEFAULT 'sistema',
    FOREIGN KEY (usuario_destino_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id)
);
GO

-- ============================================
-- 4. CREAR TABLAS DE AUDITORÍA
-- ============================================

-- Tabla: auditoria_solicitudes
CREATE TABLE auditoria_solicitudes (
    auditoria_id INT PRIMARY KEY IDENTITY(1,1),
    solicitud_id INT NOT NULL,
    usuario_id INT,
    accion NVARCHAR(50),
    campo_modificado NVARCHAR(100),
    valor_anterior NVARCHAR(MAX),
    valor_nuevo NVARCHAR(MAX),
    fecha_evento DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);
GO

-- Tabla: auditoria_acceso
CREATE TABLE auditoria_acceso (
    acceso_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT NOT NULL,
    tipo_acceso NVARCHAR(20),
    ip_origen NVARCHAR(50),
    user_agent NVARCHAR(500),
    exitoso BIT DEFAULT 1,
    fecha_acceso DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);
GO

-- ============================================
-- 5. CREAR ÍNDICES
-- ============================================

-- Índices en roles
CREATE UNIQUE INDEX idx_roles_nombre ON roles(nombre_rol);

-- Índices en usuarios
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios(email);

-- Índices en solicitudes
CREATE UNIQUE INDEX idx_solicitudes_folio ON solicitudes(folio);
CREATE INDEX idx_solicitudes_usuario_solicitante ON solicitudes(usuario_solicitante_id);
CREATE INDEX idx_solicitudes_estado ON solicitudes(state_id);
CREATE INDEX idx_solicitudes_tipo ON solicitudes(tipo_id);
CREATE INDEX idx_solicitudes_fecha_creacion ON solicitudes(fecha_creacion DESC);

-- Índices en aprobaciones
CREATE INDEX idx_aprobaciones_solicitud ON aprobaciones(solicitud_id);
CREATE INDEX idx_aprobaciones_usuario ON aprobaciones(usuario_aprobador_id);

-- Índices en asignaciones
CREATE INDEX idx_asignaciones_solicitud ON asignaciones(solicitud_id);
CREATE INDEX idx_asignaciones_desarrollador ON asignaciones(desarrollador_id);

-- Índices en notificaciones
CREATE INDEX idx_notificaciones_usuario ON notificaciones(usuario_destino_id);
CREATE INDEX idx_notificaciones_leida ON notificaciones(leida);

-- Índices en auditoría
CREATE INDEX idx_auditoria_solicitud ON auditoria_solicitudes(solicitud_id);
CREATE INDEX idx_auditoria_acceso_usuario ON auditoria_acceso(usuario_id);
CREATE INDEX idx_auditoria_acceso_fecha ON auditoria_acceso(fecha_acceso DESC);

GO

-- ============================================
-- 6. INSERTAR DATOS INICIALES
-- ============================================

-- Insertar roles
INSERT INTO roles (nombre_rol, descripcion, permisos, estado) VALUES
('user', 'Usuario Final / Cliente', '{"crear_solicitud":true,"ver_solicitudes":true,"cargar_archivos":true}', 1),
('developer', 'Desarrollador', '{"ver_asignadas":true,"actualizar_estado":true,"cargar_archivos":true}', 1),
('product_manager', 'Product Manager', '{"aprobar_solicitudes":true,"rechazar_solicitudes":true,"asignar_desarrolladores":true,"generar_reportes":true}', 1),
('admin', 'Administrador', '{"crear_usuarios":true,"gestionar_roles":true,"acceso_total":true}', 1);
GO

-- Insertar departamentos
INSERT INTO departamentos (nombre_departamento, descripcion, estado) VALUES
('Sistemas', 'Departamento de Sistemas e Informática', 1),
('Finanzas', 'Departamento de Finanzas', 1),
('Recursos Humanos', 'Departamento de Recursos Humanos', 1),
('Dirección', 'Dirección General', 1);
GO

-- Insertar usuarios
INSERT INTO usuarios (email, contraseña, rol_id, estado) VALUES
('usuario@isseg.gob.mx', 'user123', (SELECT rol_id FROM roles WHERE nombre_rol = 'user'), 1),
('desarrollador@isseg.gob.mx', 'dev123', (SELECT rol_id FROM roles WHERE nombre_rol = 'developer'), 1),
('pm@isseg.gob.mx', 'pm123', (SELECT rol_id FROM roles WHERE nombre_rol = 'product_manager'), 1),
('admin@isseg.gob.mx', 'admin123', (SELECT rol_id FROM roles WHERE nombre_rol = 'admin'), 1);
GO

-- Insertar personas
INSERT INTO personas (usuario_id, nombre, apellido_paterno, apellido_materno, numero_empleado, departamento_id, puesto, telefono, extension, estado) VALUES
((SELECT usuario_id FROM usuarios WHERE email = 'usuario@isseg.gob.mx'), 'Juan Carlos', 'García', 'Hernández', 'EMP-2024-0123', 1, 'Empleado', '(473) 123-4567', '1234', 1),
((SELECT usuario_id FROM usuarios WHERE email = 'desarrollador@isseg.gob.mx'), 'Laura', 'Martínez', 'López', 'EMP-DEV-042', 1, 'Desarrollador', '(473) 555-1122', '9988', 1),
((SELECT usuario_id FROM usuarios WHERE email = 'pm@isseg.gob.mx'), 'Roberto', 'Sánchez', 'García', 'EMP-PM-001', 1, 'Product Manager', '(473) 555-9876', '5678', 1),
((SELECT usuario_id FROM usuarios WHERE email = 'admin@isseg.gob.mx'), 'Administrador', 'Sistema', '', 'EMP-ADM-001', 1, 'Administrador', '(473) 555-0000', '0000', 1);
GO

-- Insertar tipos de solicitud
INSERT INTO tipos_solicitud (nombre_tipo, descripcion, prefijo_folio, requiere_aprobacion, estado) VALUES
('nuevo_sistema', 'Solicitud de nuevo sistema', 'SIS', 1, 1),
('requerimientos', 'Requerimientos técnicos', 'REQ', 1, 1),
('modificacion', 'Solicitud de modificación', 'MOD', 1, 1),
('urgente', 'Falla urgente', 'URG', 1, 1);
GO

-- Insertar subtipos de modificación
INSERT INTO subtipos_modificacion (nombre_subtipo, descripcion, estado) VALUES
('correctiva', 'Corrección de errores', 1),
('evolutiva', 'Mejora o nueva funcionalidad', 1),
('adaptativa', 'Adaptación a normativa', 1);
GO

-- Insertar estados de solicitud
INSERT INTO estados_solicitud (nombre_estado, descripcion, orden, es_terminal, estado) VALUES
('pendiente', 'Solicitud creada, esperando revisión', 1, 0, 1),
('aprobada', 'Solicitud aprobada, lista para desarrollo', 2, 0, 1),
('en_desarrollo', 'En desarrollo', 3, 0, 1),
('completada', 'Solicitud completada y entregada', 4, 1, 1),
('rechazada', 'Solicitud rechazada', 5, 1, 1);
GO

-- ============================================
-- 7. VISTAS ÚTILES
-- ============================================

-- Vista: Solicitudes con detalles completos
CREATE VIEW vw_solicitudes_completa AS
SELECT 
    s.solicitud_id,
    s.folio,
    ts.nombre_tipo as tipo,
    sm.nombre_subtipo as subtipo,
    es.nombre_estado as estado,
    s.titulo,
    s.descripcion,
    s.prioridad,
    p.nombre + ' ' + p.apellido_paterno as solicitante,
    s.fecha_creacion,
    s.fecha_vencimiento,
    s.fecha_aprobacion,
    s.fecha_finalizacion,
    (SELECT COUNT(*) FROM archivos_adjuntos WHERE solicitud_id = s.solicitud_id) as cantidad_archivos,
    (SELECT COUNT(*) FROM asignaciones WHERE solicitud_id = s.solicitud_id AND estado_asignacion = 1) as cantidad_desarrolladores
FROM 
    solicitudes s
    INNER JOIN tipos_solicitud ts ON s.tipo_id = ts.tipo_id
    LEFT JOIN subtipos_modificacion sm ON s.subtipo_id = sm.subtipo_id
    INNER JOIN estados_solicitud es ON s.state_id = es.estado_id
    INNER JOIN usuarios u ON s.usuario_solicitante_id = u.usuario_id
    INNER JOIN personas p ON u.usuario_id = p.usuario_id
WHERE s.estado = 1;
GO

-- Vista: Notificaciones no leídas
CREATE VIEW vw_notificaciones_pendientes AS
SELECT 
    n.notificacion_id,
    p.nombre + ' ' + p.apellido_paterno as usuario,
    n.titulo,
    n.mensaje,
    n.tipo,
    n.fecha_creacion,
    s.folio as solicitud_relacionada
FROM 
    notificaciones n
    INNER JOIN usuarios u ON n.usuario_destino_id = u.usuario_id
    INNER JOIN personas p ON u.usuario_id = p.usuario_id
    LEFT JOIN solicitudes s ON n.solicitud_id = s.solicitud_id
WHERE n.leida = 0
ORDER BY n.fecha_creacion DESC;
GO

-- ============================================
-- 8. PROCEDIMIENTOS ALMACENADOS
-- ============================================

-- Procedimiento: Crear nueva solicitud
CREATE PROCEDURE sp_crear_solicitud
    @folio NVARCHAR(20),
    @tipo_id INT,
    @subtipo_id INT = NULL,
    @usuario_solicitante_id INT,
    @titulo NVARCHAR(255),
    @descripcion NVARCHAR(MAX),
    @prioridad NVARCHAR(20) = 'Media'
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @estado_pendiente INT = (SELECT estado_id FROM estados_solicitud WHERE nombre_estado = 'pendiente')
        
        INSERT INTO solicitudes (
            folio, tipo_id, subtipo_id, state_id, usuario_solicitante_id, 
            titulo, descripcion, prioridad, fecha_creacion, estado
        ) VALUES (
            @folio, @tipo_id, @subtipo_id, @estado_pendiente, @usuario_solicitante_id, 
            @titulo, @descripcion, @prioridad, GETDATE(), 1
        )
        
        DECLARE @solicitud_id INT = SCOPE_IDENTITY()
        
        -- Registrar en auditoría
        INSERT INTO auditoria_solicitudes (solicitud_id, accion, campo_modificado, valor_nuevo, fecha_evento)
        VALUES (@solicitud_id, 'CREATE', 'folio', @folio, GETDATE())
        
        COMMIT TRANSACTION
        PRINT 'Solicitud creada exitosamente'
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

-- Procedimiento: Cambiar estado de solicitud
CREATE PROCEDURE sp_cambiar_estado_solicitud
    @solicitud_id INT,
    @nuevo_estado_id INT,
    @usuario_id INT,
    @comentario NVARCHAR(MAX) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @estado_anterior INT
        SELECT @estado_anterior = state_id FROM solicitudes WHERE solicitud_id = @solicitud_id
        
        UPDATE solicitudes 
        SET state_id = @nuevo_estado_id,
            fecha_modificacion = GETDATE()
        WHERE solicitud_id = @solicitud_id
        
        -- Registrar en auditoría
        INSERT INTO auditoria_solicitudes (solicitud_id, usuario_id, accion, campo_modificado, valor_anterior, valor_nuevo, fecha_evento)
        VALUES (@solicitud_id, @usuario_id, 'STATE_CHANGE', 'state_id', 
            (SELECT nombre_estado FROM estados_solicitud WHERE estado_id = @estado_anterior),
            (SELECT nombre_estado FROM estados_solicitud WHERE estado_id = @nuevo_estado_id),
            GETDATE())
        
        COMMIT TRANSACTION
        PRINT 'Estado actualizado exitosamente'
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

-- ============================================
-- 9. CONFIRMAR CREACIÓN
-- ============================================

PRINT '========================================='
PRINT 'Base de datos SGSPCSI creada exitosamente'
PRINT '========================================='
PRINT 'Tablas creadas: 14'
PRINT 'Índices creados: 11'
PRINT 'Vistas creadas: 2'
PRINT 'Procedimientos almacenados: 2'
PRINT ''
PRINT 'Datos iniciales:'
PRINT '- 4 roles'
PRINT '- 4 departamentos'
PRINT '- 4 usuarios de prueba'
PRINT '- 4 personas'
PRINT '- 4 tipos de solicitud'
PRINT '- 3 subtipos de modificación'
PRINT '- 5 estados de solicitud'
PRINT '========================================='
GO
