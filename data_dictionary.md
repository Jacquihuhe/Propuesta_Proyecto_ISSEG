# Diccionario de Datos - SGSPCSI
## Base de Datos SQL Server

**Proyecto:** Sistema de Gestión de Solicitudes de Proyectos de la Coordinación de Sistemas Institucionales (SGSPCSI)
**Versión:** 1.0
**Fecha:** Abril 14, 2026
**Usuario Admin:** jacquihuhe (l21121538@morelia.tecnm.mx)

---

## 📋 TABLA: roles
**Descripción:** Define los roles del sistema y sus permisos asociados.
**Tipo:** Maestro
**Clave Primaria:** rol_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **rol_id** | INT | NO | Identity(1,1) | | Identificador único |
| **nombre_rol** | NVARCHAR(50) | NO | | | UNIQUE - Valores: developer, product_manager, user, admin |
| **descripcion** | NVARCHAR(255) | SÍ | | | Descripción del rol |
| **permisos** | NVARCHAR(MAX) | SÍ | | | JSON con permisos específicos |
| **estado** | BIT | NO | 1 | | 1=Activo, 0=Inactivo |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | Auditoría |
| **fecha_modificacion** | DATETIME | NO | GETDATE() | | Auditoría |

**Índices:**
```sql
CREATE UNIQUE INDEX idx_roles_nombre ON roles(nombre_rol);
```

---

## 📋 TABLA: departamentos
**Descripción:** Estructura organizacional de ISSEG.
**Tipo:** Maestro
**Clave Primaria:** departamento_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **departamento_id** | INT | NO | Identity(1,1) | | Identificador único |
| **nombre_departamento** | NVARCHAR(100) | NO | | | Ej: Sistemas, Finanzas, RH |
| **descripcion** | NVARCHAR(255) | SÍ | | | |
| **jefe_departamento_id** | INT | SÍ | | usuarios | Referencia al jefe (puede ser NULL) |
| **estado** | BIT | NO | 1 | | |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |
| **fecha_modificacion** | DATETIME | NO | GETDATE() | | |

---

## 📋 TABLA: usuarios
**Descripción:** Datos de autenticación y autorización del sistema.
**Tipo:** Maestro
**Clave Primaria:** usuario_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **usuario_id** | INT | NO | Identity(1,1) | | Identificador único |
| **email** | NVARCHAR(100) | NO | | | UNIQUE - usuario@isseg.gob.mx |
| **contraseña** | NVARCHAR(255) | NO | | | Hash bcrypt (min 256 caracteres) |
| **rol_id** | INT | NO | | roles | Foreign Key |
| **estado** | BIT | NO | 1 | | 1=Activo, 0=Bloqueado o Inactivo |
| **intentos_fallidos** | INT | SÍ | 0 | | Para implementar bloqueo temporal |
| **ultimo_acceso** | DATETIME | SÍ | | | Último login exitoso |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |
| **fecha_modificacion** | DATETIME | NO | GETDATE() | | |

**Índices:**
```sql
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios(email);
```

**Restricciones:**
- El email debe ser válido y único.
- Bloquear usuario si intentos_fallidos > 5.

---

## 📋 TABLA: personas
**Descripción:** Información personal y profesional de cada usuario.
**Tipo:** Maestro
**Clave Primaria:** persona_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **persona_id** | INT | NO | Identity(1,1) | | Identificador único |
| **usuario_id** | INT | NO | | usuarios | UNIQUE - Relación 1:1 |
| **nombre** | NVARCHAR(100) | NO | | | Nombre(s) de la persona |
| **apellido_paterno** | NVARCHAR(100) | NO | | | |
| **apellido_materno** | NVARCHAR(100) | SÍ | | | |
| **numero_empleado** | NVARCHAR(20) | SÍ | | | EMP-2024-0123 |
| **departamento_id** | INT | SÍ | | departamentos | Departamento actual |
| **puesto** | NVARCHAR(100) | SÍ | | | Jefe de Área, Empleado, etc. |
| **telefono** | NVARCHAR(20) | SÍ | | | Teléfono de contacto |
| **extension** | NVARCHAR(10) | SÍ | | | Extensión interna |
| **fotografia** | NVARCHAR(255) | SÍ | | | Path/URL de la foto de perfil |
| **estado** | BIT | NO | 1 | | 1=Activo, 0=Inactivo |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |
| **fecha_modificacion** | DATETIME | NO | GETDATE() | | |

---

## 📋 TABLA: tipos_solicitud
**Descripción:** Catálogo de tipos de solicitud que soporta el sistema.
**Tipo:** Maestro
**Clave Primaria:** tipo_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **tipo_id** | INT | NO | Identity(1,1) | | Identificador único |
| **nombre_tipo** | NVARCHAR(50) | NO | | | UNIQUE - nuevo_sistema, requerimientos, modificacion, urgente |
| **descripcion** | NVARCHAR(255) | SÍ | | | |
| **prefijo_folio** | NVARCHAR(5) | SÍ | | | REQ, MOD, URG, SIS |
| **requiere_aprobacion** | BIT | NO | 1 | | ¿Necesita aprobación del PM? |
| **estado** | BIT | NO | 1 | | |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |

---

## 📋 TABLA: estados_solicitud
**Descripción:** Estados del ciclo de vida de una solicitud.
**Tipo:** Maestro
**Clave Primaria:** estado_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **estado_id** | INT | NO | Identity(1,1) | | Identificador único |
| **nombre_estado** | NVARCHAR(50) | NO | | | UNIQUE - pendiente, aprobada, en_desarrollo, completada, rechazada |
| **descripcion** | NVARCHAR(255) | SÍ | | | |
| **orden** | INT | SÍ | | | Orden en el flujo (1,2,3...) |
| **es_terminal** | BIT | NO | 0 | | ¿Es estado final? (completada, rechazada = 1) |
| **estado** | BIT | NO | 1 | | |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |

**Nota:** Los valores iniciales son:
1. pendiente (orden=1, es_terminal=0)
2. aprobada (orden=2, es_terminal=0)
3. en_desarrollo (orden=3, es_terminal=0)
4. completada (orden=4, es_terminal=1)
5. rechazada (orden=5, es_terminal=1)

---

## 📋 TABLA: subtipos_modificacion
**Descripción:** Sub-tipos de solicitud de modificación.
**Tipo:** Maestro
**Clave Primaria:** subtipo_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **subtipo_id** | INT | NO | Identity(1,1) | | Identificador único |
| **nombre_subtipo** | NVARCHAR(50) | NO | | | UNIQUE - correctiva, evolutiva, adaptativa |
| **descripcion** | NVARCHAR(255) | SÍ | | | |
| **estado** | BIT | NO | 1 | | |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |

---

## 📋 TABLA: solicitudes
**Descripción:** Entidad principal - Registro completo de cada solicitud.
**Tipo:** Transaccional
**Clave Primaria:** solicitud_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **solicitud_id** | INT | NO | Identity(1,1) | | Identificador único |
| **folio** | NVARCHAR(20) | NO | | | UNIQUE - Formato: REQ-2026-001 |
| **tipo_id** | INT | NO | | tipos_solicitud | FK |
| **subtipo_id** | INT | SÍ | | subtipos_modificacion | FK - Obligatorio si tipo=modificacion |
| **state_id** | INT | NO | | estados_solicitud | FK |
| **usuario_solicitante_id** | INT | NO | | usuarios | FK - Quién creó la solicitud |
| **titulo** | NVARCHAR(255) | NO | | | Título corto de la solicitud |
| **descripcion** | NVARCHAR(MAX) | SÍ | | | Detalle completo |
| **prioridad** | NVARCHAR(20) | SÍ | | | Alta, Media, Baja |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |
| **fecha_vencimiento** | DATETIME | SÍ | | | SLA o deadline |
| **fecha_envio** | DATETIME | SÍ | | | Cuándo se envió a revisión |
| **fecha_aprobacion** | DATETIME | SÍ | | | Primera aprobación |
| **fecha_inicio_desarrollo** | DATETIME | SÍ | | | Cuándo comenzó |
| **fecha_finalizacion** | DATETIME | SÍ | | | Cuándo se completó |
| **motivo_rechazo** | NVARCHAR(MAX) | SÍ | | | Razón del rechazo |
| **observaciones** | NVARCHAR(MAX) | SÍ | | | Notas adicionales |
| **estado** | BIT | NO | 1 | | 1=Vigente, 0=Archivado |

**Índices:**
```sql
CREATE UNIQUE INDEX idx_solicitudes_folio ON solicitudes(folio);
CREATE INDEX idx_solicitudes_usuario_solicitante ON solicitudes(usuario_solicitante_id);
CREATE INDEX idx_solicitudes_estado ON solicitudes(state_id);
CREATE INDEX idx_solicitudes_tipo ON solicitudes(tipo_id);
CREATE INDEX idx_solicitudes_fecha_creacion ON solicitudes(fecha_creacion DESC);
```

**Reglas de Negocio:**
- El folio debe ser único y generarse automáticamente.
- Un estado terminal no puede cambiar.
- fecha_aprobacion se completa cuando state_id cambia a aprobada.

---

## 📋 TABLA: aprobaciones
**Descripción:** Registro de todas las aprobaciones/rechazos de solicitudes.
**Tipo:** Transaccional
**Clave Primaria:** aprobacion_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **aprobacion_id** | INT | NO | Identity(1,1) | | Identificador único |
| **solicitud_id** | INT | NO | | solicitudes | FK |
| **usuario_aprobador_id** | INT | NO | | usuarios | FK - Product Manager que aprobó |
| **estado_aprobacion** | NVARCHAR(20) | NO | | | aprobada, rechazada, pendiente_info |
| **comentarios** | NVARCHAR(MAX) | SÍ | | | Feedback o motivo |
| **fecha_aprobacion** | DATETIME | NO | GETDATE() | | |

**Índices:**
```sql
CREATE INDEX idx_aprobaciones_solicitud ON aprobaciones(solicitud_id);
CREATE INDEX idx_aprobaciones_usuario ON aprobaciones(usuario_aprobador_id);
```

---

## 📋 TABLA: asignaciones
**Descripción:** Vinculación de solicitudes con desarrolladores.
**Tipo:** Transaccional
**Clave Primaria:** asignacion_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **asignacion_id** | INT | NO | Identity(1,1) | | Identificador único |
| **solicitud_id** | INT | NO | | solicitudes | FK |
| **desarrollador_id** | INT | NO | | usuarios | FK - Developer asignado |
| **porcentaje_asignacion** | INT | NO | 100 | | % dedicación (0-100) |
| **fecha_asignacion** | DATETIME | NO | GETDATE() | | Cuándo se asignó |
| **fecha_desasignacion** | DATETIME | SÍ | | | Cuándo se removió |
| **estado_asignacion** | BIT | NO | 1 | | 1=Activa, 0=Inactiva |

**Restricciones:**
- Un desarrollador no puede estar asignado 2 veces activas a la misma solicitud.
- Validar que desarrollador_id tenga rol = 'developer'.

---

## 📋 TABLA: archivos_adjuntos
**Descripción:** Gestión de documentos, evidencias y archivos de solicitudes.
**Tipo:** Transaccional
**Clave Primaria:** archivo_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **archivo_id** | INT | NO | Identity(1,1) | | Identificador único |
| **solicitud_id** | INT | NO | | solicitudes | FK |
| **nombre_archivo** | NVARCHAR(255) | NO | | | Nombre original del archivo |
| **tipo_archivo** | NVARCHAR(50) | SÍ | | | pdf, docx, xlsx, jpg, etc. |
| **ruta_almacenamiento** | NVARCHAR(MAX) | NO | | | /storage/solicitud_123/archivo.pdf |
| **tamaño_bytes** | BIGINT | SÍ | | | Para validar cuota de almacenamiento |
| **usuario_cargador_id** | INT | SÍ | | usuarios | FK - Quién subió el archivo |
| **fecha_carga** | DATETIME | NO | GETDATE() | | |
| **estado** | BIT | NO | 1 | | 1=Disponible, 0=Eliminado/Archivado |

**Validaciones:**
- Tamaño máximo por archivo: 50MB.
- Tipos permitidos: pdf, doc, docx, xls, xlsx, jpg, png, gif.
- Cuota total por usuario: 500MB.

---

## 📋 TABLA: notificaciones
**Descripción:** Sistema de notificaciones push/email del sistema.
**Tipo:** Transaccional
**Clave Primaria:** notificacion_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **notificacion_id** | INT | NO | Identity(1,1) | | Identificador único |
| **usuario_destino_id** | INT | NO | | usuarios | FK - Destinatario |
| **titulo** | NVARCHAR(100) | NO | | | Asunto |
| **mensaje** | NVARCHAR(MAX) | NO | | | Cuerpo del mensaje |
| **tipo** | NVARCHAR(20) | SÍ | info | | success, info, warning, danger |
| **solicitud_id** | INT | SÍ | | solicitudes | FK - Referencia a solicitud (opcional) |
| **leida** | BIT | NO | 0 | | ¿Fue leída? |
| **fecha_creacion** | DATETIME | NO | GETDATE() | | |
| **fecha_lectura** | DATETIME | SÍ | | | Cuándo se leyó |
| **canal_entrega** | NVARCHAR(50) | SÍ | sistema | | email, sistema, sms, etc. |

**Índices:**
```sql
CREATE INDEX idx_notificaciones_usuario ON notificaciones(usuario_destino_id);
CREATE INDEX idx_notificaciones_leida ON notificaciones(leida);
CREATE INDEX idx_notificaciones_fecha ON notificaciones(fecha_creacion DESC);
```

---

## 📋 TABLA: auditoria_solicitudes
**Descripción:** Historial completo de cambios en solicitudes.
**Tipo:** Auditoría
**Clave Primaria:** auditoria_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **auditoria_id** | INT | NO | Identity(1,1) | | Identificador único |
| **solicitud_id** | INT | NO | | solicitudes | FK |
| **usuario_id** | INT | SÍ | | usuarios | FK - Quién hizo el cambio |
| **accion** | NVARCHAR(50) | NO | | | CREATE, UPDATE, DELETE, STATE_CHANGE |
| **campo_modificado** | NVARCHAR(100) | SÍ | | | Nombre de la columna que cambió |
| **valor_anterior** | NVARCHAR(MAX) | SÍ | | | Valor antes del cambio |
| **valor_nuevo** | NVARCHAR(MAX) | SÍ | | | Valor después del cambio |
| **fecha_evento** | DATETIME | NO | GETDATE() | | |

**Política de Retención:** 7 años (máximo legal).

---

## 📋 TABLA: auditoria_acceso
**Descripción:** Registro de accesos y login del sistema.
**Tipo:** Auditoría
**Clave Primaria:** acceso_id

| Columna | Tipo de Dato | Nulo | Predeterminado | FK | Notas |
|---------|--------------|------|-----------------|-----|-------|
| **acceso_id** | INT | NO | Identity(1,1) | | Identificador único |
| **usuario_id** | INT | NO | | usuarios | FK |
| **tipo_acceso** | NVARCHAR(20) | NO | | | LOGIN, LOGOUT, ERROR, TIMEOUT |
| **ip_origen** | NVARCHAR(50) | SÍ | | | IP del cliente |
| **user_agent** | NVARCHAR(500) | SÍ | | | Browser/Client info |
| **exitoso** | BIT | NO | 1 | | 1=Exitoso, 0=Fallido |
| **fecha_acceso** | DATETIME | NO | GETDATE() | | |

**Índices:**
```sql
CREATE INDEX idx_auditoria_acceso_usuario ON auditoria_acceso(usuario_id);
CREATE INDEX idx_auditoria_acceso_fecha ON auditoria_acceso(fecha_acceso DESC);
```

---

## 🔐 SEGURIDAD Y PERMISOS

### Por Rol:

#### **user (Cliente)**
- Ver mis solicitudes
- Crear nueva solicitud
- Ver estado de solicitudes
- Cargar archivos
- Recibir notificaciones

#### **developer**
- Ver solicitudes asignadas
- Actualizar estado de solicitudes
- Cargar archivos (evidencia)
- Ver mi tareas
- Ver equipo

#### **product_manager**
- Ver todas las solicitudes
- Aprobar/Rechazar solicitudes
- Asignar a desarrolladores
- Generar reportes
- Gestionar equipo

#### **admin** (no visible en la UI actual)
- Acceso total
- Crear/editar roles
- Crear/editar usuarios
- Generar reportes
- Administrar configuración

---

## 📊 ESTADÍSTICAS Y REPORTES CLAVE

### Consultas Frecuentes:
```sql
-- Solicitudes por estado
SELECT state_id, COUNT(*) as cantidad FROM solicitudes GROUP BY state_id;

-- Solicitudes por usuario en los últimos 30 días
SELECT usuario_solicitante_id, COUNT(*) as cantidad 
FROM solicitudes 
WHERE fecha_creacion >= DATEADD(DAY, -30, GETDATE())
GROUP BY usuario_solicitante_id;

-- Carga de trabajo por desarrollador
SELECT a.desarrollador_id, COUNT(*) as solicitudes_asignadas 
FROM asignaciones a 
WHERE a.estado_asignacion = 1 
GROUP BY a.desarrollador_id;

-- Solicitudes por aprobar
SELECT COUNT(*) as pendientes_aprobacion 
FROM solicitudes 
WHERE state_id = (SELECT estado_id FROM estados_solicitud WHERE nombre_estado = 'pendiente');
```

---

## 📝 SCRIPTS DE INICIALIZACIÓN

Ver archivo `database_initialization.sql` para:
- Creación de tablas
- Inserción de catálogos iniciales (roles, tipos, estados, etc.)
- Creación de índices
- Creación de triggers de auditoría

