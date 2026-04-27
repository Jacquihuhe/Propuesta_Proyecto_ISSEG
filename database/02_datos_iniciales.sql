-- ============================================
-- SCRIPT DE DATOS INICIALES
-- Base de datos: ISSEG_DB
-- Inserta datos en catálogos y tablas maestras
-- ============================================

USE ISSEG_DB
GO

-- ============================================
-- 1. TABLA: rol (Roles de Seguridad)
-- ============================================

INSERT INTO [rol] ([clave], [nombre], [descripcion], [activo])
VALUES 
('ADMIN', 'Administrador', 'Acceso total al sistema', 1),
('DIRECTOR', 'Director/a', 'Dirección de áreas y aprobación de solicitudes', 1),
('JEFE', 'Jefe/a de Área', 'Gestión del área y recursos', 1),
('COORDINADOR', 'Coordinador/a', 'Coordinación de solicitudes y proyectos', 1),
('DESARROLLADOR', 'Desarrollador/a', 'Ejecución de tareas y solicitudes técnicas', 1),
('USUARIO', 'Usuario Final', 'Creación y seguimiento de solicitudes', 1),
('AUDITOR', 'Auditor/a', 'Revisión y auditoría del sistema', 1)
GO

-- ============================================
-- 2. TABLA: tipo_solicitud (Tipos de Solicitud)
-- ============================================

INSERT INTO [tipo_solicitud] ([clave], [nombre], [activa])
VALUES 
('INCIDENTE', 'Incidente', 1),
('CAMBIO', 'Cambio', 1),
('MEJORA', 'Mejora', 1),
('SOPORTE', 'Soporte Técnico', 1),
('CONSULTA', 'Consulta de Información', 1),
('ACCESO', 'Solicitud de Acceso', 1),
('CAPACITACION', 'Capacitación', 1)
GO

-- ============================================
-- 3. TABLA: estado_solicitud (Estados de Solicitud)
-- ============================================

INSERT INTO [estado_solicitud] ([clave], [nombre], [secuencia])
VALUES 
('ABIERTA', 'Abierta', 1),
('ASIGNADA', 'Asignada', 2),
('EN_PROCESO', 'En Proceso', 3),
('RESUELTA', 'Resuelta', 4),
('CERRADA', 'Cerrada', 5),
('RECHAZADA', 'Rechazada', 6),
('SUSPENDIDA', 'Suspendida', 7)
GO

-- ============================================
-- 4. TABLA: prioridad_solicitud (Prioridades)
-- ============================================

INSERT INTO [prioridad_solicitud] ([clave], [nombre], [orden])
VALUES 
('BAJA', 'Baja', 3),
('MEDIA', 'Media', 2),
('ALTA', 'Alta', 1),
('CRITICA', 'Crítica', 0)
GO

-- ============================================
-- 5. TABLA: tipo_modificacion (Tipos de Modificación)
-- ============================================

INSERT INTO [tipo_modificacion] ([clave], [nombre], [activa])
VALUES 
('TITULO', 'Cambio de Título', 1),
('DESCRIPCION', 'Cambio de Descripción', 1),
('PRIORIDAD', 'Cambio de Prioridad', 1),
('ASIGNADO', 'Reasignación de Responsable', 1),
('PLAZO', 'Prórroga de Plazo', 1),
('DOCUMENTO', 'Actualización de Documentación', 1)
GO

-- ============================================
-- 6. TABLA: area (Estructura Organizacional)
-- ============================================

INSERT INTO [area] ([area_padre_id], [clave], [nombre], [tipo_area], [nivel], [activa])
VALUES 
(NULL, 'DIR', 'Dirección General', 'Dirección', 0, 1),
(1, 'DTIN', 'Dirección de Tecnología e Innovación', 'Dirección', 1, 1),
(1, 'DADM', 'Dirección Administrativa', 'Dirección', 1, 1),
(2, 'COORD_DS', 'Coordinación de Desarrollo de Software', 'Coordinación', 2, 1),
(2, 'COORD_IT', 'Coordinación de Infraestructura TI', 'Coordinación', 2, 1),
(2, 'COORD_SO', 'Coordinación de Soporte Operativo', 'Coordinación', 2, 1),
(3, 'COORD_RRHH', 'Coordinación de Recursos Humanos', 'Coordinación', 2, 1)
GO

-- ============================================
-- 7. TABLA: sistema (Sistemas Disponibles)
-- ============================================

INSERT INTO [sistema] ([clave], [nombre], [descripcion], [activo])
VALUES 
('ISSEG', 'ISSEG - Sistema de Gestión de Solicitudes', 'Sistema principal de gestión de solicitudes y proyectos', 1),
('ERP', 'Sistema ERP', 'Sistema de planificación de recursos empresariales', 1),
('RRHH', 'Sistema de Recursos Humanos', 'Gestión de personal y nómina', 1),
('FINANZAS', 'Sistema de Finanzas', 'Contabilidad y gestión financiera', 1),
('CRM', 'Sistema CRM', 'Gestión de relaciones con el cliente', 1),
('PORTAL', 'Portal Institucional', 'Portal web de información pública', 1)
GO

-- ============================================
-- 8. TABLA: menu_opcion (Opciones de Menú)
-- ============================================

INSERT INTO [menu_opcion] ([clave], [nombre], [descripcion], [url_modulo], [sistema_id], [orden], [activo])
VALUES 
('SOLICITUDES', 'Solicitudes', 'Gestión de solicitudes', '/solicitudes', 1, 1, 1),
('MIS_SOLICITUDES', 'Mis Solicitudes', 'Mis solicitudes creadas', '/mis-solicitudes', 1, 2, 1),
('TAREAS', 'Tareas', 'Gestión de tareas de desarrollo', '/tareas', 1, 3, 1),
('PROYECTOS', 'Proyectos', 'Gestión de proyectos', '/proyectos', 1, 4, 1),
('REPORTES', 'Reportes', 'Generación de reportes', '/reportes', 1, 5, 1),
('USUARIOS', 'Usuarios', 'Administración de usuarios', '/usuarios', 1, 10, 1),
('ROLES', 'Roles', 'Administración de roles', '/roles', 1, 11, 1),
('CONFIGURACION', 'Configuración', 'Configuración del sistema', '/config', 1, 12, 1)
GO

-- ============================================
-- Resumen de inserciones
-- ============================================

PRINT '✓ Base de datos ISSEG_DB inicializada con datos catálogo'
PRINT '✓ Roles: 7'
PRINT '✓ Tipos de solicitud: 7'
PRINT '✓ Estados: 7'
PRINT '✓ Prioridades: 4'
PRINT '✓ Tipos de modificación: 6'
PRINT '✓ Áreas organizacionales: 7'
PRINT '✓ Sistemas: 6'
PRINT '✓ Opciones de menú: 8'

GO
