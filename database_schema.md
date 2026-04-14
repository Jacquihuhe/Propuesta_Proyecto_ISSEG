# Esquema de Base de Datos - SGSPCSI
## SQL Server 2019+

---

## 1. TABLAS MAESTRAS

### 1.1 Tabla: `roles`
Catálogo de roles del sistema.

```sql
CREATE TABLE roles (
    rol_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    permisos NVARCHAR(MAX),
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE()
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| rol_id | INT | PK, Identity | ID único del rol |
| nombre_rol | NVARCHAR(50) | NOT NULL, UNIQUE | developer, product_manager, user, admin |
| descripcion | NVARCHAR(255) | | Descripción del rol |
| permisos | NVARCHAR(MAX) | | JSON con permisos (crear, editar, aprobar, etc) |
| estado | BIT | NOT NULL, DEFAULT 1 | 1 = Activo, 0 = Inactivo |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | Registro de auditoría |
| fecha_modificacion | DATETIME | DEFAULT GETDATE() | Registro de auditoría |

---

### 1.2 Tabla: `departamentos`
Estructura organizacional.

```sql
CREATE TABLE departamentos (
    departamento_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_departamento NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255),
    jefe_departamento_id INT,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE()
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| departamento_id | INT | PK, Identity | ID único del departamento |
| nombre_departamento | NVARCHAR(100) | NOT NULL | Sistemas, Finanzas, RH, etc. |
| descripcion | NVARCHAR(255) | | |
| jefe_departamento_id | INT | FK usuarios | Jefe del departamento |
| estado | BIT | NOT NULL, DEFAULT 1 | |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |
| fecha_modificacion | DATETIME | DEFAULT GETDATE() | |

---

### 1.3 Tabla: `usuarios`
Datos de login y autenticación.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| usuario_id | INT | PK, Identity | ID único del usuario |
| email | NVARCHAR(100) | NOT NULL, UNIQUE | usuario@isseg.gob.mx |
| contraseña | NVARCHAR(255) | NOT NULL | Hash bcrypt o similar |
| rol_id | INT | NOT NULL, FK | Referencia directa al rol |
| estado | BIT | NOT NULL, DEFAULT 1 | Activo/Inactivo |
| intentos_fallidos | INT | DEFAULT 0 | Para bloqueo por intentos |
| ultimo_acceso | DATETIME | | Timestamp del último login |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |
| fecha_modificacion | DATETIME | DEFAULT GETDATE() | |

---

### 1.4 Tabla: `personas`
Información personal y profesional.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| persona_id | INT | PK, Identity | ID único de la persona |
| usuario_id | INT | NOT NULL, FK, UNIQUE | Vinculación 1:1 con usuario |
| nombre | NVARCHAR(100) | NOT NULL | Nombre(s) |
| apellido_paterno | NVARCHAR(100) | NOT NULL | |
| apellido_materno | NVARCHAR(100) | | |
| numero_empleado | NVARCHAR(20) | | EMP-2024-0123 |
| departamento_id | INT | FK | Departamento actual |
| puesto | NVARCHAR(100) | | Jefe de Área, Empleado, etc. |
| telefono | NVARCHAR(20) | | |
| extension | NVARCHAR(10) | | |
| fotografia | NVARCHAR(255) | | Path/URL de la foto |
| estado | BIT | NOT NULL, DEFAULT 1 | |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |
| fecha_modificacion | DATETIME | DEFAULT GETDATE() | |

---

### 1.5 Tabla: `tipos_solicitud`
Catálogo de tipos de solicitud.

```sql
CREATE TABLE tipos_solicitud (
    tipo_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_tipo NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    prefijo_folio NVARCHAR(5),
    requiere_aprobacion BIT DEFAULT 1,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| tipo_id | INT | PK, Identity | ID único del tipo |
| nombre_tipo | NVARCHAR(50) | NOT NULL, UNIQUE | nuevo_sistema, requerimientos, modificacion, urgente |
| descripcion | NVARCHAR(255) | | |
| prefijo_folio | NVARCHAR(5) | | REQ, MOD, URG, etc. |
| requiere_aprobacion | BIT | DEFAULT 1 | ¿Necesita aprobación del PM? |
| estado | BIT | NOT NULL, DEFAULT 1 | |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |

---

### 1.6 Tabla: `estados_solicitud`
Estados del ciclo de vida de una solicitud.

```sql
CREATE TABLE estados_solicitud (
    estado_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_estado NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    orden INT,
    es_terminal BIT DEFAULT 0,
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| estado_id | INT | PK, Identity | ID único del estado |
| nombre_estado | NVARCHAR(50) | NOT NULL, UNIQUE | pendiente, aprobada, en_desarrollo, completada, rechazada |
| descripcion | NVARCHAR(255) | | |
| orden | INT | | Orden en el flujo (1, 2, 3...) |
| es_terminal | BIT | DEFAULT 0 | ¿Es estado final? (completada, rechazada) |
| estado | BIT | NOT NULL, DEFAULT 1 | |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |

---

### 1.7 Tabla: `subtipo_modificacion`
Sub-tipos si el tipo es "modificación".

```sql
CREATE TABLE subtipos_modificacion (
    subtipo_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_subtipo NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    estado BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| subtipo_id | INT | PK, Identity | |
| nombre_subtipo | NVARCHAR(50) | NOT NULL, UNIQUE | correctiva, evolutiva, adaptativa |
| descripcion | NVARCHAR(255) | | |
| estado | BIT | NOT NULL, DEFAULT 1 | |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |

---

## 2. TABLAS TRANSACCIONALES

### 2.1 Tabla: `solicitudes`
Tabla principal de solicitudes.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| solicitud_id | INT | PK, Identity | ID único |
| folio | NVARCHAR(20) | NOT NULL, UNIQUE | REQ-2026-001, MOD-2026-005, URG-2026-003 |
| tipo_id | INT | NOT NULL, FK | Referencia al tipo |
| subtipo_id | INT | FK | Solo si tipo es modificación |
| state_id | INT | NOT NULL, FK | Estado actual |
| usuario_solicitante_id | INT | NOT NULL, FK | Usuario que la creó |
| titulo | NVARCHAR(255) | NOT NULL | Título corto |
| descripcion | NVARCHAR(MAX) | | Detalle completo |
| prioridad | NVARCHAR(20) | | Alta, Media, Baja |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |
| fecha_vencimiento | DATETIME | | SLA o deadline |
| fecha_envio | DATETIME | | Cuándo se envió a revisión |
| fecha_aprobacion | DATETIME | | Cuándo fue aprobada |
| fecha_inicio_desarrollo | DATETIME | | Cuándo comenzó a desarrollarse |
| fecha_finalizacion | DATETIME | | Cuándo se completó |
| motivo_rechazo | NVARCHAR(MAX) | | Razón si fue rechazada |
| observaciones | NVARCHAR(MAX) | | Notas adicionales |
| estado | BIT | NOT NULL, DEFAULT 1 | |

---

### 2.2 Tabla: `aprobaciones`
Registro de aprobaciones/rechazos.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| aprobacion_id | INT | PK, Identity | |
| solicitud_id | INT | NOT NULL, FK | |
| usuario_aprobador_id | INT | NOT NULL, FK | Product Manager que aprobó |
| estado_aprobacion | NVARCHAR(20) | NOT NULL | aprobada, rechazada, pendiente_info |
| comentarios | NVARCHAR(MAX) | | Feedback o motivo del rechazo |
| fecha_aprobacion | DATETIME | DEFAULT GETDATE() | |

---

### 2.3 Tabla: `asignaciones`
Asignación de solicitudes a desarrolladores.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| asignacion_id | INT | PK, Identity | |
| solicitud_id | INT | NOT NULL, FK | |
| desarrollador_id | INT | NOT NULL, FK | Developer asignado |
| porcentaje_asignacion | INT | DEFAULT 100 | % dedicación a la tarea |
| fecha_asignacion | DATETIME | DEFAULT GETDATE() | |
| fecha_desasignacion | DATETIME | | Si se quita |
| estado_asignacion | BIT | DEFAULT 1 | Activa/Inactiva |

---

### 2.4 Tabla: `archivos_adjuntos`
Gestión de documentos y evidencias.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| archivo_id | INT | PK, Identity | |
| solicitud_id | INT | NOT NULL, FK | |
| nombre_archivo | NVARCHAR(255) | NOT NULL | Nombre original |
| tipo_archivo | NVARCHAR(50) | | pdf, docx, xlsx, etc. |
| ruta_almacenamiento | NVARCHAR(MAX) | NOT NULL | /storage/solicitud_123/archivo.pdf |
| tamaño_bytes | BIGINT | | Para validar cuota |
| usuario_cargador_id | INT | FK | Quién lo subió |
| fecha_carga | DATETIME | DEFAULT GETDATE() | |
| estado | BIT | NOT NULL, DEFAULT 1 | |

---

### 2.5 Tabla: `notificaciones`
Sistema de notificaciones.

```sql
CREATE TABLE notificaciones (
    notificacion_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_destino_id INT NOT NULL,
    titulo NVARCHAR(100) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    tipo NVARCHAR(20),
    solicitud_id INT,
    leida BIT DEFAULT 0,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_lectura DATETIME,
    canal_entrega NVARCHAR(50),
    FOREIGN KEY (usuario_destino_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(solicitud_id)
);
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| notificacion_id | INT | PK, Identity | |
| usuario_destino_id | INT | NOT NULL, FK | Destinatario |
| titulo | NVARCHAR(100) | NOT NULL | Asunto |
| mensaje | NVARCHAR(MAX) | NOT NULL | Cuerpo del mensaje |
| tipo | NVARCHAR(20) | | success, info, warning, danger |
| solicitud_id | INT | FK | Referencia a solicitud |
| leida | BIT | DEFAULT 0 | ¿Fue leída? |
| fecha_creacion | DATETIME | DEFAULT GETDATE() | |
| fecha_lectura | DATETIME | | Cuándo se leyó |
| canal_entrega | NVARCHAR(50) | | email, sistema, sms, etc. |

---

## 3. TABLAS DE AUDITORÍA

### 3.1 Tabla: `auditoria_solicitudes`
Historial de cambios en solicitudes.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| auditoria_id | INT | PK, Identity | |
| solicitud_id | INT | NOT NULL, FK | |
| usuario_id | INT | FK | Quién hizo el cambio |
| accion | NVARCHAR(50) | | CREATE, UPDATE, DELETE, STATE_CHANGE |
| campo_modificado | NVARCHAR(100) | | Columna que cambió |
| valor_anterior | NVARCHAR(MAX) | | Valor antes |
| valor_nuevo | NVARCHAR(MAX) | | Valor después |
| fecha_evento | DATETIME | DEFAULT GETDATE() | |

---

### 3.2 Tabla: `auditoria_acceso`
Registro de accesos al sistema.

```sql
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
```

| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|-------------|
| acceso_id | INT | PK, Identity | |
| usuario_id | INT | NOT NULL, FK | |
| tipo_acceso | NVARCHAR(20) | | LOGIN, LOGOUT, ERROR |
| ip_origen | NVARCHAR(50) | | IP del cliente |
| user_agent | NVARCHAR(500) | | Browser/Client info |
| exitoso | BIT | DEFAULT 1 | ¿Fue exitoso? |
| fecha_acceso | DATETIME | DEFAULT GETDATE() | |

---

## 4. RELACIONES PRINCIPALES

```
usuarios (1) ──────────────── (N) solicitudes
  └─ rol_id ──→ roles

usuarios (1) ──────────────── (N) personas
  └─ usuario_id (UNIQUE)

personas ──→ departamentos

solicitudes (1) ────────────── (N) aprobaciones
solicitudes (1) ────────────── (N) asignaciones
solicitudes (1) ────────────── (N) archivos_adjuntos
solicitudes (1) ────────────── (N) auditoria_solicitudes
solicitudes (1) ────────────── (N) notificaciones

solicitudes ──→ tipos_solicitud
solicitudes ──→ estados_solicitud
solicitudes ──→ subtipos_modificacion (cuando tipo = modificación)

aprobaciones ──→ usuarios (usuario_aprobador_id)
asignaciones ──→ usuarios (desarrollador_id)
```

---

## 5. ÍNDICES RECOMENDADOS

```sql
CREATE INDEX idx_solicitudes_folio ON solicitudes(folio);
CREATE INDEX idx_solicitudes_usuario_solicitante ON solicitudes(usuario_solicitante_id);
CREATE INDEX idx_solicitudes_estado ON solicitudes(state_id);
CREATE INDEX idx_solicitudes_tipo ON solicitudes(tipo_id);
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_aprobaciones_solicitud ON aprobaciones(solicitud_id);
CREATE INDEX idx_asignaciones_solicitud ON asignaciones(solicitud_id);
CREATE INDEX idx_asignaciones_desarrollador ON asignaciones(desarrollador_id);
CREATE INDEX idx_notificaciones_usuario_destino ON notificaciones(usuario_destino_id);
CREATE INDEX idx_notificaciones_leida ON notificaciones(leida);
CREATE INDEX idx_auditoria_solicitud ON auditoria_solicitudes(solicitud_id);
CREATE INDEX idx_auditoria_acceso_usuario ON auditoria_acceso(usuario_id);
```

---

## 6. RESTRICCIONES Y VALIDACIONES

- Los correos deben ser únicos en `usuarios`.
- El `folio` debe ser único y seguir el patrón: `{prefijo}-{año}-{secuencial}`.
- Un usuario no puede ser asignado a la misma solicitud dos veces activas simultáneamente.
- Las solicitudes en estado terminal no pueden cambiar de estado.
- Las aprobaciones/rechazos generan auditoría automática.
- Los archivos adjuntos deben tener ruta y validarse en el servidor de almacenamiento.

