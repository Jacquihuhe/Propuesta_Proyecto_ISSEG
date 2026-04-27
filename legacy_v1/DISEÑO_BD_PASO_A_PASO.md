# Diseño de Base de Datos SGSPCSI - Revisión Paso a Paso

**Fecha:** Abril 14, 2026  
**Usuario Admin:** jacquihuhe (l21121538@morelia.tecnm.mx)  
**Motor:** SQL Server 2019+

---

## ✅ FASE 1: TABLAS MAESTRAS (Catálogos)

Estas son las tablas que almacenan información de referencia estática del sistema.

### 1.1 TABLA: `roles`
**Propósito:** Definir los roles del sistema y sus permisos.

```
Columnas:
├── rol_id (INT, PK, Identity)              → ID único
├── nombre_rol (NVARCHAR(50), UNIQUE)       → developer, product_manager, user, admin
├── descripcion (NVARCHAR(255))             → Descripción del rol
├── permisos (NVARCHAR(MAX))                → JSON con permisos específicos
├── estado (BIT, DEFAULT 1)                 → 1=Activo, 0=Inactivo
├── fecha_creacion (DATETIME, DEFAULT NOW)  → Auditoría
└── fecha_modificacion (DATETIME, DEFAULT NOW) → Auditoría
```

**Datos iniciales esperados:**
- user
- developer
- product_manager
- admin

---

### 1.2 TABLA: `departamentos`
**Propósito:** Estructura organizacional de ISSEG.

```
Columnas:
├── departamento_id (INT, PK, Identity)
├── nombre_departamento (NVARCHAR(100))     → Catálogo abierto (todos los departamentos de ISSEG)
├── descripcion (NVARCHAR(255))
├── jefe_departamento_id (INT, FK usuarios) → Referencia al jefe (puede ser NULL)
├── estado (BIT, DEFAULT 1)
├── fecha_creacion (DATETIME)
└── fecha_modificacion (DATETIME)
```

**Datos iniciales esperados:**
- Carga inicial con todos los departamentos oficiales de ISSEG.
- La tabla queda abierta para altas/bajas/cambios administrativos sin alterar el modelo.

**Fuente validada en repositorio:**
- Archivo [Adscripciones.xlsx](Adscripciones.xlsx)
- Hoja: `Hoja1`
- Registros detectados: `112` áreas únicas (columna única, sin encabezado formal)

---

### 1.3 TABLA: `usuarios`
**Propósito:** Autenticación y autorización del sistema.

```
Columnas:
├── usuario_id (INT, PK, Identity)
├── correo_electronico (NVARCHAR(100), UNIQUE) → usuario@isseg.gob.mx
├── contraseña (NVARCHAR(255))              → Hash bcrypt (no plano)
├── rol_id (INT, FK roles, NOT NULL)        → Relación con roles
├── estado (BIT, DEFAULT 1)                 → 1=Activo, 0=Bloqueado
├── intentos_fallidos (INT, DEFAULT 0)      → Para bloqueo temporal
├── ultimo_acceso (DATETIME)                → Tracking de login
├── fecha_creacion (DATETIME)
└── fecha_modificacion (DATETIME)
```

**Usuarios de prueba iniciales propuestos:**
| correo_electronico | rol | contraseña_plaintext (para inicialización) |
|-------|-----|---------------------------------------------|
| usuario@isseg.gob.mx | usuario | user123 |
| desarrollador@isseg.gob.mx | desarrollador | dev123 |
| pm@isseg.gob.mx | gestor_producto | pm123 |
| admin@isseg.gob.mx | administrador | admin123 |

⚠️ **Nota:** Las contraseñas deben ser hasheadas antes de guardar.

---

### 1.4 TABLA: `personas`
**Propósito:** Información personal y profesional de usuarios.

```
Columnas:
├── persona_id (INT, PK, Identity)
├── usuario_id (INT, FK usuarios, UNIQUE)   → Relación 1:1 con usuarios
├── nombre (NVARCHAR(100), NOT NULL)
├── apellido_paterno (NVARCHAR(100), NOT NULL)
├── apellido_materno (NVARCHAR(100))
├── numero_empleado (NVARCHAR(20))          → EMP-2024-0123
├── departamento_id (INT, FK departamentos)
├── puesto (NVARCHAR(100))                  → Jefe de Área, Empleado, etc.
├── telefono (NVARCHAR(20))
├── extension (NVARCHAR(10))
├── fotografia (NVARCHAR(255))              → Path/URL
├── estado (BIT, DEFAULT 1)
├── fecha_creacion (DATETIME)
└── fecha_modificacion (DATETIME)
```

**Relación con usuarios:**
- 1 usuario = 1 persona (1:1)
- Cada usuario debe tener su registro de persona

---

### 1.5 TABLA: `tipos_solicitud`
**Propósito:** Catálogo de tipos de solicitud que soporta el sistema.

```
Columnas:
├── tipo_id (INT, PK, Identity)
├── nombre_tipo (NVARCHAR(50), UNIQUE)      → nuevo_sistema, requerimientos, modificacion, urgente
├── descripcion (NVARCHAR(255))
├── prefijo_folio (NVARCHAR(5))             → REQ, MOD, URG, SIS
├── requiere_aprobacion (BIT, DEFAULT 1)    → ¿Pasa por revisión del PM?
├── estado (BIT, DEFAULT 1)
└── fecha_creacion (DATETIME)
```

**Datos iniciales requeridos:**

| tipo_id | nombre_tipo | prefijo_folio | requiere_aprobacion | Descripción |
|---------|-------------|---------------|----------------------|-------------|
| 1 | nuevo_sistema | SIS | 1 | Solicitud de nuevo sistema |
| 2 | requerimientos | REQ | 1 | Requerimientos técnicos |
| 3 | modificacion | MOD | 1 | Modificación de sistema existente |
| 4 | urgente | URG | 1 | Falla o incidente urgente |

---

### 1.6 TABLA: `subtipos_modificacion`
**Propósito:** Sub-tipos solo para solicitudes de modificación.

```
Columnas:
├── subtipo_id (INT, PK, Identity)
├── nombre_subtipo (NVARCHAR(50), UNIQUE)   → correctiva, evolutiva, adaptativa
├── descripcion (NVARCHAR(255))
├── estado (BIT, DEFAULT 1)
└── fecha_creacion (DATETIME)
```

**Datos iniciales requeridos:**

| subtipo_id | nombre_subtipo | Descripción |
|------------|----------------|-------------|
| 1 | correctiva | Corrección de errores (bugs) |
| 2 | evolutiva | Mejora o nueva funcionalidad |
| 3 | adaptativa | Adaptación a normativa |

---

### 1.7 TABLA: `estados_solicitud`
**Propósito:** Define el ciclo de vida de cada solicitud.

```
Columnas:
├── estado_id (INT, PK, Identity)
├── nombre_estado (NVARCHAR(50), UNIQUE)    → pendiente, aprobada, en_desarrollo, pausada, completada, rechazada
├── descripcion (NVARCHAR(255))
├── orden (INT)                             → Secuencia en el flujo (1, 2, 3...)
├── es_terminal (BIT, DEFAULT 0)            → ¿Es estado final? (no puede cambiar después)
├── estado (BIT, DEFAULT 1)
└── fecha_creacion (DATETIME)
```

**Datos iniciales requeridos:**

| estado_id | nombre_estado | orden | es_terminal | Descripción |
|-----------|---------------|-------|-------------|-------------|
| 1 | pendiente | 1 | 0 | Solicitud creada, esperando revisión |
| 2 | aprobada | 2 | 0 | Solicitud aprobada, lista para desarrollo |
| 3 | en_desarrollo | 3 | 0 | Actualmente en desarrollo |
| 4 | pausada | 4 | 0 | Desarrollo pausado por atención a urgencia u otro bloqueo |
| 5 | completada | 5 | 1 | Finalizada y entregada |
| 6 | rechazada | 6 | 1 | Rechazada por el PM |

---

## 📋 RESUMEN FASE 1

**Tablas maestras a crear: 7**

```
roles (4 registros)
    ↓
    departamentos (112 registros iniciales en Adscripciones.xlsx)
    ↓
usuarios (4 registros) → roles
    ↓
personas (4 registros) → usuarios + departamentos
    ↓
tipos_solicitud (4 registros)
    ↓
subtipos_modificacion (3 registros)
    ↓
estados_solicitud (6 registros)
```

**Relaciones fase 1:**
```
roles (1) ──────── (N) usuarios
departamentos (1) ──── (N) personas
usuarios (1) ────── (1) personas
usuarios (1) ────── (N) departamentos (jefe_departamento_id)
```

---

## ❓ VALIDACIÓN FASE 1

Resultado de validación hasta ahora:

1. **Roles:** Confirmados.

2. **Departamentos:** Confirmado catálogo abierto con carga inicial de 111 áreas.

3. **Tipos de solicitud:** Pendiente confirmación final.
   - nuevo_sistema
   - requerimientos
   - modificacion
   - urgente

4. **Subtipos de modificación:** Confirmados.
   - correctiva
   - evolutiva
   - adaptativa

5. **Estados:** Confirmados con pausa.
    - pendiente → aprobada → en_desarrollo ↔ pausada → completada/rechazada

6. **Usuarios de prueba:** Pendiente confirmar si se conservan en script de demo.

---

## ✅ FASE 2: TABLAS TRANSACCIONALES

Estas tablas almacenan la operación diaria del sistema: solicitudes, aprobación, asignación, adjuntos y notificaciones.

### 2.1 TABLA: `solicitudes`
**Propósito:** Entidad principal del sistema; cada fila representa un folio.

```
Columnas:
├── solicitud_id (INT, PK, Identity)
├── folio (NVARCHAR(20), UNIQUE, NOT NULL)  → REQ-2026-001, MOD-2026-010, URG-2026-003
├── tipo_id (INT, FK tipos_solicitud, NOT NULL)
├── subtipo_id (INT, FK subtipos_modificacion, NULL)
├── estado_id (INT, FK estados_solicitud, NOT NULL)
├── usuario_solicitante_id (INT, FK usuarios, NOT NULL)
├── titulo (NVARCHAR(255), NOT NULL)
├── descripcion (NVARCHAR(MAX), NOT NULL)
├── prioridad (NVARCHAR(20), NOT NULL)      → Alta, Media, Baja
├── fecha_creacion (DATETIME, DEFAULT NOW)
├── fecha_envio (DATETIME, NULL)
├── fecha_aprobacion (DATETIME, NULL)
├── fecha_inicio_desarrollo (DATETIME, NULL)
├── fecha_pausa (DATETIME, NULL)
├── fecha_reanudacion (DATETIME, NULL)
├── fecha_finalizacion (DATETIME, NULL)
├── motivo_rechazo (NVARCHAR(MAX), NULL)
├── motivo_pausa (NVARCHAR(MAX), NULL)
├── requiere_requerimientos (BIT, DEFAULT 0)
├── solicitud_padre_id (INT, FK solicitudes, NULL)
├── estado_registro (BIT, DEFAULT 1)
└── fecha_modificacion (DATETIME, DEFAULT NOW)
```

**Reglas clave:**
- `subtipo_id` solo se llena cuando `tipo_id = modificacion`.
- `motivo_pausa` se llena cuando el estado cambia a `pausada`.
- `solicitud_padre_id` se usa para ligar una urgencia a la solicitud pausada.
- `requiere_requerimientos = 1` cuando el tipo es `nuevo_sistema` aprobado.

---

### 2.2 TABLA: `aprobaciones`
**Propósito:** Historial de decisiones del Product Manager.

```
Columnas:
├── aprobacion_id (INT, PK, Identity)
├── solicitud_id (INT, FK solicitudes, NOT NULL)
├── usuario_aprobador_id (INT, FK usuarios, NOT NULL)
├── decision (NVARCHAR(20), NOT NULL)       → aprobada, rechazada, solicitar_info
├── comentarios (NVARCHAR(MAX), NULL)
├── fecha_decision (DATETIME, DEFAULT NOW)
└── estado_registro (BIT, DEFAULT 1)
```

**Reglas clave:**
- Solo usuarios con rol `product_manager` pueden registrar una decisión.
- Si `decision = rechazada`, debe existir `comentarios`.

---

### 2.3 TABLA: `asignaciones`
**Propósito:** Asignar solicitudes a desarrolladores y controlar historial de reasignaciones.

```
Columnas:
├── asignacion_id (INT, PK, Identity)
├── solicitud_id (INT, FK solicitudes, NOT NULL)
├── desarrollador_id (INT, FK usuarios, NOT NULL)
├── asignado_por_id (INT, FK usuarios, NOT NULL)
├── fecha_asignacion (DATETIME, DEFAULT NOW)
├── fecha_desasignacion (DATETIME, NULL)
├── motivo_desasignacion (NVARCHAR(255), NULL)
├── es_activa (BIT, DEFAULT 1)
└── porcentaje_asignacion (INT, DEFAULT 100)
```

**Reglas clave:**
- Un mismo desarrollador no puede tener dos asignaciones activas sobre la misma solicitud.
- `asignado_por_id` normalmente será el PM.

---

### 2.4 TABLA: `archivos_adjuntos`
**Propósito:** Evidencias y documentos de respaldo por solicitud.

```
Columnas:
├── archivo_id (INT, PK, Identity)
├── solicitud_id (INT, FK solicitudes, NOT NULL)
├── usuario_cargador_id (INT, FK usuarios, NOT NULL)
├── nombre_archivo (NVARCHAR(255), NOT NULL)
├── extension (NVARCHAR(10), NOT NULL)
├── tipo_mime (NVARCHAR(100), NULL)
├── tamaño_bytes (BIGINT, NOT NULL)
├── ruta_almacenamiento (NVARCHAR(MAX), NOT NULL)
├── hash_archivo (NVARCHAR(128), NULL)
├── fecha_carga (DATETIME, DEFAULT NOW)
└── estado_registro (BIT, DEFAULT 1)
```

**Reglas clave:**
- Controlar tipos permitidos (pdf, docx, xlsx, png, jpg).
- Guardar hash para validar integridad.

---

### 2.5 TABLA: `notificaciones`
**Propósito:** Mensajería del sistema hacia usuarios por eventos de solicitud.

```
Columnas:
├── notificacion_id (INT, PK, Identity)
├── usuario_destino_id (INT, FK usuarios, NOT NULL)
├── solicitud_id (INT, FK solicitudes, NULL)
├── titulo (NVARCHAR(120), NOT NULL)
├── mensaje (NVARCHAR(MAX), NOT NULL)
├── tipo (NVARCHAR(20), DEFAULT 'info')     → success, info, warning, danger
├── canal (NVARCHAR(20), DEFAULT 'sistema') → sistema, correo, ambos
├── leida (BIT, DEFAULT 0)
├── fecha_creacion (DATETIME, DEFAULT NOW)
├── fecha_lectura (DATETIME, NULL)
└── estado_registro (BIT, DEFAULT 1)
```

**Reglas clave:**
- Si `leida = 1`, debe registrarse `fecha_lectura`.
- Puede existir notificación sin solicitud (`solicitud_id NULL`) para mensajes generales.

---

## 📋 RESUMEN FASE 2

**Tablas transaccionales a crear: 5**

```
solicitudes (núcleo del proceso)
    ├── aprobaciones (decisiones PM)
    ├── asignaciones (trabajo dev)
    ├── archivos_adjuntos (evidencias)
    └── notificaciones (comunicación)
```

**Relaciones fase 2:**
```
usuarios (1) ──────── (N) solicitudes [creador]
tipos_solicitud (1) ── (N) solicitudes
estados_solicitud (1) ─ (N) solicitudes
subtipos_modificacion (1) ─ (N) solicitudes

solicitudes (1) ────── (N) aprobaciones
usuarios (1) ──────── (N) aprobaciones [PM]

solicitudes (1) ────── (N) asignaciones
usuarios (1) ──────── (N) asignaciones [developer]

solicitudes (1) ────── (N) archivos_adjuntos
usuarios (1) ──────── (N) archivos_adjuntos

usuarios (1) ──────── (N) notificaciones
solicitudes (1) ────── (N) notificaciones
```

---

## ❓ PUNTOS DE VALIDACIÓN FASE 2

1. ¿Confirmas que `solicitud_padre_id` se use para vincular urgencias que pausan otra solicitud?
2. ¿Te parece bien guardar `motivo_pausa` y `fecha_reanudacion` en `solicitudes`?
3. ¿La decisión `solicitar_info` en `aprobaciones` la dejamos activa?
4. ¿Aceptas notificaciones generales sin folio (`solicitud_id NULL`)?
5. ¿Mantenemos `prioridad` como texto (Alta/Media/Baja) o prefieres catálogo separado?

---

**Siguiente paso al validar Fase 2:**
- FASE 3: tablas de auditoría y reglas de trazabilidad.

---

## ✅ FASE 3: AUDITORÍA Y TRAZABILIDAD

Esta fase asegura control histórico, cumplimiento y posibilidad de reconstruir exactamente qué pasó con cada solicitud, quién lo hizo y cuándo.

### 3.1 TABLA: `auditoria_solicitudes`
**Propósito:** Registrar cambios funcionales y de estado sobre una solicitud.

```
Columnas:
├── auditoria_id (BIGINT, PK, Identity)
├── solicitud_id (INT, FK solicitudes, NOT NULL)
├── usuario_id (INT, FK usuarios, NULL)
├── accion (NVARCHAR(40), NOT NULL)         → CREAR, ACTUALIZAR, CAMBIO_ESTADO, ASIGNAR, DESASIGNAR, CERRAR
├── campo_modificado (NVARCHAR(120), NULL)
├── valor_anterior (NVARCHAR(MAX), NULL)
├── valor_nuevo (NVARCHAR(MAX), NULL)
├── motivo (NVARCHAR(500), NULL)
├── origen (NVARCHAR(20), DEFAULT 'web')    → web, api, sistema
├── fecha_evento (DATETIME2, DEFAULT SYSUTCDATETIME())
├── ip_origen (NVARCHAR(50), NULL)
└── agente_usuario (NVARCHAR(500), NULL)
```

**Reglas clave:**
- Toda transición de estado genera un registro (`CAMBIO_ESTADO`).
- Cambios sensibles (prioridad, asignado, fechas, rechazo, pausa/reanudación) generan registro obligatorio.
- Si el cambio lo hace un proceso automático, `usuario_id` puede ser NULL y `origen='sistema'`.

---

### 3.2 TABLA: `auditoria_acceso`
**Propósito:** Registrar actividad de acceso y seguridad de usuarios.

```
Columnas:
├── acceso_id (BIGINT, PK, Identity)
├── usuario_id (INT, FK usuarios, NOT NULL)
├── tipo_evento (NVARCHAR(30), NOT NULL)    → INICIO_SESION_OK, INICIO_SESION_FALLIDO, CIERRE_SESION, TOKEN_EXPIRADO, CAMBIO_CONTRASENA
├── exitoso (BIT, NOT NULL)
├── ip_origen (NVARCHAR(50), NULL)
├── agente_usuario (NVARCHAR(500), NULL)
├── detalle (NVARCHAR(500), NULL)
└── fecha_evento (DATETIME2, DEFAULT SYSUTCDATETIME())
```

**Reglas clave:**
- Cada intento de login (exitoso o fallido) debe registrarse.
- Cambios de contraseña y cierre de sesión también.
- Este historial no se edita; solo inserciones (append-only).

---

### 3.3 TABLA OPCIONAL RECOMENDADA: `historial_estados_solicitud`
**Propósito:** Trazar explícitamente la línea de tiempo de estados para reportes SLA.

```
Columnas:
├── historial_id (BIGINT, PK, Identity)
├── solicitud_id (INT, FK solicitudes, NOT NULL)
├── estado_origen_id (INT, FK estados_solicitud, NULL)
├── estado_destino_id (INT, FK estados_solicitud, NOT NULL)
├── usuario_id (INT, FK usuarios, NULL)
├── motivo_cambio (NVARCHAR(500), NULL)
├── fecha_inicio (DATETIME2, NOT NULL)
├── fecha_fin (DATETIME2, NULL)
└── duracion_minutos (AS DATEDIFF(MINUTE, fecha_inicio, fecha_fin))
```

**Reglas clave:**
- Al cambiar estado, se cierra el registro anterior (`fecha_fin`) y se abre uno nuevo.
- Permite saber cuánto tiempo estuvo una solicitud en `pausada` o `en_desarrollo`.

---

## 🔎 EVENTOS OBLIGATORIOS A AUDITAR

1. Creación de solicitud.
2. Cambio de estado (incluyendo pausa y reanudación).
3. Aprobación/rechazo/solicitud de información.
4. Asignación o desasignación de desarrollador.
5. Carga/eliminación lógica de adjuntos.
6. Login exitoso y fallido.
7. Cambio de contraseña y cierre de sesión.

---

## 🧭 REGLAS DE TRAZABILIDAD

1. **Inmutabilidad de auditoría:** no se actualiza ni elimina historial de auditoría.
2. **UTC en auditoría:** usar `SYSUTCDATETIME()` para eventos y convertir a horario local en UI.
3. **Idempotencia:** evitar doble registro del mismo evento cuando hay reintentos.
4. **Integridad referencial:** todo evento funcional debe apuntar a una solicitud válida.
5. **Trazabilidad mínima por folio:** para cada solicitud debe poder reconstruirse:
    - quién la creó,
    - quién la aprobó/rechazó,
    - quién la trabajó,
    - cuándo estuvo pausada,
    - cuándo se cerró.

---

## 🗄️ RETENCIÓN DE DATOS (PROPUESTA)

1. `auditoria_solicitudes`: conservación permanente con archivo histórico.
2. `auditoria_acceso`: conservación permanente con archivo histórico.
3. `historial_estados_solicitud`: conservación permanente con archivo histórico.

Nota: no se eliminan registros; si se requiere, se mueven a particiones/archivos históricos para mantener consulta, integridad y cumplimiento.

---

## 📋 RESUMEN FASE 3

**Tablas de control propuestas: 2 obligatorias + 1 recomendada**

```
Obligatorias:
- auditoria_solicitudes
- auditoria_acceso

Recomendada:
- historial_estados_solicitud
```

---

## ❓ PUNTOS DE VALIDACIÓN FASE 3

1. ¿Te parece bien que `historial_estados_solicitud` sea obligatoria en vez de opcional?
2. ¿Mantenemos retención de 5 años para auditoría funcional?
3. ¿Usamos siempre UTC en backend y mostramos hora local en frontend?
4. ¿Confirmas eventos obligatorios de auditoría tal como están listados?
5. ¿Quieres incluir también auditoría de descarga/visualización de documentos?

Respuesta sugerida:
- Sí, para documentos sensibles debe auditarse la visualización y la descarga.
- Esto permite saber qué información se consultó, por quién y cuándo.
- Si el documento es público o de bajo riesgo, la regla puede ser opcional por tipo de archivo.

---

**Siguiente paso al validar Fase 3:**
- FASE 4: índices, constraints CHECK, claves únicas de negocio y vistas operativas.

---

## ✅ FASE 4: INTEGRIDAD, ÍNDICES Y VISTAS OPERATIVAS

Esta fase deja lista la base para rendimiento, consistencia y consultas frecuentes del sistema.

### 4.1 RESTRICCIONES DE INTEGRIDAD (CHECK / UNIQUE)

#### En `solicitudes`
```
Reglas propuestas:
├── folio debe ser único.
├── prioridad solo admite: Alta, Media, Baja.
├── estado_registro solo admite: 0, 1.
├── fecha_reanudacion no puede ser menor que fecha_pausa.
├── fecha_finalizacion no puede ser menor que fecha_inicio_desarrollo.
├── si tipo_id = modificacion, subtipo_id no puede ser NULL.
├── si estado = pausada, motivo_pausa no puede ser NULL.
├── si estado = rechazada, motivo_rechazo no puede ser NULL.
└── si solicitud_padre_id tiene valor, debe apuntar a una solicitud activa previa.
```

#### En `aprobaciones`
```
Reglas propuestas:
├── decision solo admite: aprobada, rechazada, solicitar_info.
├── si decision = rechazada, comentarios no puede ser NULL.
├── un mismo usuario aprobador no debe duplicar una decisión idéntica sobre la misma solicitud en el mismo instante.
└── solo usuarios con rol product_manager pueden registrar una aprobación.
```

#### En `asignaciones`
```
Reglas propuestas:
├── es_activa solo admite: 0, 1.
├── porcentaje_asignacion debe estar entre 1 y 100.
├── un desarrollador no puede tener dos asignaciones activas sobre la misma solicitud.
└── asignado_por_id debe pertenecer al rol product_manager.
```

#### En `notificaciones`
```
Reglas propuestas:
├── tipo solo admite: success, info, warning, danger.
├── canal solo admite: sistema, correo, ambos.
├── si leida = 1, fecha_lectura no puede ser NULL.
└── solicitud_id puede ser NULL solo para notificaciones generales.
```

#### En auditoría
```
Reglas propuestas:
├── las tablas de auditoría no se actualizan ni eliminan.
├── fecha_evento siempre se guarda en UTC.
├── origen solo admite: web, api, sistema.
└── tipo_evento en auditoria_acceso debe seguir catálogo cerrado.
```

---

### 4.2 ÍNDICES RECOMENDADOS

#### `usuarios`
```sql
CREATE UNIQUE INDEX UX_usuarios_correo_electronico ON usuarios(correo_electronico);
CREATE INDEX IX_usuarios_rol_id ON usuarios(rol_id);
```

#### `personas`
```sql
CREATE UNIQUE INDEX UX_personas_usuario_id ON personas(usuario_id);
CREATE INDEX IX_personas_departamento_id ON personas(departamento_id);
```

#### `solicitudes`
```sql
CREATE UNIQUE INDEX UX_solicitudes_folio ON solicitudes(folio);
CREATE INDEX IX_solicitudes_usuario_solicitante_id ON solicitudes(usuario_solicitante_id);
CREATE INDEX IX_solicitudes_tipo_id ON solicitudes(tipo_id);
CREATE INDEX IX_solicitudes_estado_id ON solicitudes(estado_id);
CREATE INDEX IX_solicitudes_prioridad ON solicitudes(prioridad);
CREATE INDEX IX_solicitudes_fecha_creacion ON solicitudes(fecha_creacion DESC);
```

#### `aprobaciones`
```sql
CREATE INDEX IX_aprobaciones_solicitud_id ON aprobaciones(solicitud_id);
CREATE INDEX IX_aprobaciones_usuario_aprobador_id ON aprobaciones(usuario_aprobador_id);
CREATE INDEX IX_aprobaciones_fecha_decision ON aprobaciones(fecha_decision DESC);
```

#### `asignaciones`
```sql
CREATE INDEX IX_asignaciones_solicitud_id ON asignaciones(solicitud_id);
CREATE INDEX IX_asignaciones_desarrollador_id ON asignaciones(desarrollador_id);
CREATE INDEX IX_asignaciones_activas ON asignaciones(es_activa, solicitud_id, desarrollador_id);
```

#### `archivos_adjuntos`
```sql
CREATE INDEX IX_archivos_solicitud_id ON archivos_adjuntos(solicitud_id);
CREATE INDEX IX_archivos_usuario_cargador_id ON archivos_adjuntos(usuario_cargador_id);
CREATE INDEX IX_archivos_fecha_carga ON archivos_adjuntos(fecha_carga DESC);
```

#### `notificaciones`
```sql
CREATE INDEX IX_notificaciones_destino ON notificaciones(usuario_destino_id);
CREATE INDEX IX_notificaciones_leida ON notificaciones(leida);
CREATE INDEX IX_notificaciones_fecha_creacion ON notificaciones(fecha_creacion DESC);
```

#### `auditoria_solicitudes`
```sql
CREATE INDEX IX_auditoria_solicitudes_solicitud_id ON auditoria_solicitudes(solicitud_id);
CREATE INDEX IX_auditoria_solicitudes_usuario_id ON auditoria_solicitudes(usuario_id);
CREATE INDEX IX_auditoria_solicitudes_fecha_evento ON auditoria_solicitudes(fecha_evento DESC);
```

#### `auditoria_acceso`
```sql
CREATE INDEX IX_auditoria_acceso_usuario_id ON auditoria_acceso(usuario_id);
CREATE INDEX IX_auditoria_acceso_fecha_evento ON auditoria_acceso(fecha_evento DESC);
CREATE INDEX IX_auditoria_acceso_tipo_evento ON auditoria_acceso(tipo_evento);
```

---

### 4.3 VISTAS OPERATIVAS PROPUESTAS

#### Vista 1: `vw_solicitudes_resumen`
**Propósito:** Mostrar solicitudes con su estado, tipo, solicitante y fechas principales.

Campos sugeridos:
- folio
- tipo de solicitud
- subtipo
- estado actual
- nombre del solicitante
- prioridad
- fecha_creacion
- fecha_aprobacion
- fecha_inicio_desarrollo
- fecha_finalizacion

#### Vista 2: `vw_solicitudes_pendientes_pm`
**Propósito:** Solicitudes que esperan revisión del Product Manager.

Filtros sugeridos:
- estado = pendiente
- requiere_aprobacion = 1

#### Vista 3: `vw_solicitudes_asignadas_dev`
**Propósito:** Solicitudes activas del desarrollador.

Campos sugeridos:
- folio
- solicitud
- estado
- desarrollador asignado
- fecha_asignacion
- prioridad

#### Vista 4: `vw_auditoria_solicitud_detalle`
**Propósito:** Ver todo el historial de una solicitud en una sola consulta.

Incluye:
- eventos de auditoría funcional
- cambios de estado
- aprobaciones
- asignaciones
- adjuntos

#### Vista 5: `vw_notificaciones_no_leidas`
**Propósito:** Consultar notificaciones pendientes por usuario.

---

### 4.4 CONSULTAS FRECUENTES QUE DEBE SOPORTAR LA BD

1. Solicitudes por estado y por tipo.
2. Solicitudes pendientes de aprobación.
3. Solicitudes activas por desarrollador.
4. Historial completo de una solicitud por folio.
5. Notificaciones no leídas por usuario.
6. Auditoría de accesos y eventos por fecha.

---

## 📋 RESUMEN FASE 4

```
Integridad:
- CHECK y UNIQUE para reglas de negocio.

Rendimiento:
- Índices por folio, estado, tipo, usuario, fechas y relaciones FK.

Operación:
- Vistas para PM, desarrolladores, usuario final y auditoría.
```

---

## ❓ PUNTOS DE VALIDACIÓN FASE 4

1. ¿Te parecen correctas las reglas de integridad propuestas para solicitudes, aprobaciones y asignaciones?
2. ¿Mantenemos `prioridad` como catálogo lógico con CHECK o prefieres tabla aparte?
3. ¿Quieres que `vw_solicitudes_resumen` y `vw_auditoria_solicitud_detalle` sean obligatorias en el script final?
4. ¿Agregamos alguna vista específica para Product Manager o para el dashboard ejecutivo?

---

**Siguiente paso al validar Fase 4:**
- FASE 5: diccionario final y script SQL definitivo para SQL Server.

---

## ✅ FASE 5: DICTAMEN FINAL, DICCIONARIO Y SCRIPT SQL

Esta fase convierte todo lo revisado en el material de entrega final para construir la base de datos en SQL Server.

### 5.1 DICCIONARIO FINAL DE DATOS

**Objetivo:** consolidar el significado técnico y funcional de cada tabla y columna.

El diccionario final debe incluir:
- nombre de la tabla
- propósito funcional
- nombre de cada campo
- tipo de dato SQL Server
- nulabilidad
- valor por defecto
- clave primaria o foránea
- reglas de negocio asociadas
- índice o restricción especial cuando aplique

**Tablas que deben quedar documentadas:**
1. roles
2. departamentos
3. usuarios
4. personas
5. tipos_solicitud
6. subtipos_modificacion
7. estados_solicitud
8. solicitudes
9. aprobaciones
10. asignaciones
11. archivos_adjuntos
12. notificaciones
13. auditoria_solicitudes
14. auditoria_acceso
15. historial_estados_solicitud

---

### 5.2 SCRIPT SQL DEFINITIVO

**Objetivo:** generar la base lista para ejecutar en SQL Server.

**Orden recomendado del script:**
1. Crear base de datos.
2. Crear tablas maestras.
3. Crear tablas transaccionales.
4. Crear tablas de auditoría.
5. Crear llaves foráneas y restricciones CHECK.
6. Crear índices.
7. Crear vistas.
8. Crear procedimientos almacenados.
9. Insertar catálogos iniciales.
10. Insertar áreas iniciales desde `Adscripciones.xlsx`.

**Importante:**
- El script debe ser idempotente en lo posible para evitar duplicados.
- Debe validar existencia de objetos antes de crearlos si se ejecuta más de una vez.

---

### 5.3 CARGA INICIAL DE CATÁLOGOS

**Incluye:**
- roles iniciales
- tipos de solicitud
- subtipos de modificación
- estados de solicitud
- departamentos / adscripciones desde Excel

**Criterio de validación:**
- no deben existir duplicados por nombre natural
- folios futuros deben generarse a partir del tipo y secuencia

---

### 5.4 VALIDACIÓN FINAL ANTES DE IMPLEMENTAR

Checklist final:
1. ¿Las tablas cubren el flujo funcional completo?
2. ¿Los estados incluyen pausa y reanudación?
3. ¿La auditoría es permanente y trazable?
4. ¿La base contiene índices y restricciones necesarias?
5. ¿Los catálogos iniciales reflejan el Excel real de áreas?
6. ¿El diagrama ER en draw.io coincide con las tablas finales?

---

### 5.5 ENTREGABLES FINALES ESPERADOS

1. [SGSPCSI_ER.drawio](SGSPCSI_ER.drawio) como diagrama principal.
2. [DISEÑO_BD_PASO_A_PASO.md](DISEÑO_BD_PASO_A_PASO.md) como guía de validación.
3. [database_final.sql](database_final.sql) como script definitivo de creación.

---

## 📋 RESUMEN GENERAL DEL MODELO

### Entidades principales
- usuarios y personas
- solicitudes
- aprobaciones
- asignaciones
- archivos_adjuntos
- notificaciones
- auditorías

### Entidades de soporte
- roles
- departamentos
- tipos_solicitud
- subtipos_modificacion
- estados_solicitud

### Enfoque arquitectónico
- flujo documental centralizado
- trazabilidad completa
- auditoría permanente
- soporte para pausa por urgencias
- consultas optimizadas con vistas e índices

---

## ✅ CONCLUSIÓN DEL DISEÑO

El modelo queda preparado para pasar a implementación porque ya define:
- estructura lógica,
- flujos de negocio,
- reglas de integridad,
- auditoría,
- rendimiento,
- y diccionario técnico.

**Siguiente paso natural:** convertir esta especificación validada en el script SQL final de SQL Server.

---

## 📦 ENTREGABLES FINALES ACTUALIZADOS

1. [SGSPCSI_ER.drawio](SGSPCSI_ER.drawio) como diagrama principal.
2. [DISEÑO_BD_PASO_A_PASO.md](DISEÑO_BD_PASO_A_PASO.md) como guía de validación por fases.
3. [database_final.sql](database_final.sql) como script definitivo de creación.

Los borradores intermedios de esquema, diccionario y script ya fueron eliminados para evitar confusión.
