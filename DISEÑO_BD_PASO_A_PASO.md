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
- Registros detectados: `111` áreas únicas (columna única, sin encabezado formal)

---

### 1.3 TABLA: `usuarios`
**Propósito:** Autenticación y autorización del sistema.

```
Columnas:
├── usuario_id (INT, PK, Identity)
├── email (NVARCHAR(100), UNIQUE)           → usuario@isseg.gob.mx
├── contraseña (NVARCHAR(255))              → Hash bcrypt (no plano)
├── rol_id (INT, FK roles, NOT NULL)        → Relación con roles
├── estado (BIT, DEFAULT 1)                 → 1=Activo, 0=Bloqueado
├── intentos_fallidos (INT, DEFAULT 0)      → Para bloqueo temporal
├── ultimo_acceso (DATETIME)                → Tracking de login
├── fecha_creacion (DATETIME)
└── fecha_modificacion (DATETIME)
```

**Usuarios de prueba iniciales propuestos:**
| email | rol | contraseña_plaintext (para inicialización) |
|-------|-----|---------------------------------------------|
| usuario@isseg.gob.mx | user | user123 |
| desarrollador@isseg.gob.mx | developer | dev123 |
| pm@isseg.gob.mx | product_manager | pm123 |
| admin@isseg.gob.mx | admin | admin123 |

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
departamentos (4 registros)
    ↓
usuarios (4 registros) → roles
    ↓
personas (4 registros) → usuarios + departamentos
    ↓
tipos_solicitud (4 registros)
    ↓
subtipos_modificacion (3 registros)
    ↓
estados_solicitud (5 registros)
```

**Relaciones fase 1:**
```
roles (1) ──────── (N) usuarios
departamentos (1) ──── (N) personas
usuarios (1) ────── (1) personas
usuarios (1) ────── (N) departamentos (jefe_departamento_id)
```

---

## ❓ PREGUNTAS PARA VALIDACIÓN FASE 1

Antes de continuamos, por favor confirma o ajusta:

1. **Roles:** ¿Necesitas agregar/quitar roles? (user, developer, product_manager, admin)

2. **Departamentos:** ¿Te parece correcto manejarlo como catálogo abierto para cargar todos los departamentos oficiales?

3. **Tipos de solicitud:** ¿Son suficientes estos 4?
   - nuevo_sistema
   - requerimientos
   - modificacion
   - urgente

4. **Subtipos de modificación:** ¿Se cubre con estos 3?
   - correctiva
   - evolutiva
   - adaptativa

5. **Estados:** ¿El flujo base con pausa te parece correcto?
    - pendiente → aprobada → en_desarrollo ↔ pausada → completada/rechazada

6. **Usuarios de prueba:** ¿Los emails propuestos son correctos?

---

**Cuando hayas revisado y validado la FASE 1, continuamos con:**
- ✋ FASE 2: TABLAS TRANSACCIONALES (solicitudes, aprobaciones, asignaciones)
- FASE 3: TABLAS DE AUDITORÍA
- FASE 4: ÍNDICES Y VISTAS
- FASE 5: PROCEDIMIENTOS ALMACENADOS
