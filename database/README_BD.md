# Script de Creación de Base de Datos ISSEG
## SQL Server 2022

### 📋 Contenido

Este conjunto de scripts crea la base de datos **ISSEG_DB** para el sistema de gestión de solicitudes y proyectos.

#### Archivos incluidos:

1. **01_crear_base_datos.sql** (35 KB)
   - Script principal de DDL (Data Definition Language)
   - Crea 33 tablas normalizadas a 4NF
   - Define claves primarias, índices únicos y relaciones
   - Incluye comentarios descriptivos para cada tabla

2. **02_datos_iniciales.sql**
   - Datos iniciales para catálogos
   - Roles base del sistema
   - Estados de solicitud
   - Tipos de solicitud
   - Prioridades

### 🗂️ Estructura de Tablas

El modelo incluye los siguientes módulos:

#### Seguridad y Usuarios (5 tablas)
- `rol` - Roles de seguridad
- `usuario` - Datos normalizados de usuarios (nombre_pila, apellido_paterno, apellido_materno)
- `usuario_rol` - Asignación de roles a usuarios
- `usuario_credencial` - Credenciales de autenticación
- `usuario_area` - Asignación de usuarios a áreas

#### Organización (2 tablas)
- `area` - Estructura jerárquica de áreas
- `area_sistema` - Asignación de sistemas a áreas

#### Sistemas (2 tablas)
- `sistema` - Catálogo de sistemas
- `sistema_desarrollador` - Asignación de desarrolladores a sistemas

#### Solicitudes (10 tablas)
- `solicitud` - Solicitud principal
- `tipo_solicitud` - Catálogo de tipos
- `estado_solicitud` - Catálogo de estados
- `prioridad_solicitud` - Catálogo de prioridades
- `solicitud_desarrollador` - Asignación de desarrolladores
- `solicitud_historial_estado` - Historial de cambios de estado
- `solicitud_aprobacion` - Aprobaciones
- `solicitud_comentario` - Comentarios y notas
- `solicitud_adjunto` - Archivos adjuntos
- `solicitud_modificacion` - Historial de modificaciones

#### Requerimientos Técnicos (2 tablas)
- `solicitud_requerimiento_tecnico` - Especificaciones técnicas
- `tipo_modificacion` - Tipos de modificación

#### Tareas de Desarrollo (3 tablas)
- `tarea_desarrollo` - Tareas de desarrollo
- `tarea_desarrollo_asignacion` - Asignación de tareas
- `notificacion` - Notificaciones

#### Proyectos (4 tablas)
- `proyecto` - Proyectos principales
- `proyecto_solicitud` - Relación proyecto-solicitud
- `proyecto_miembro` - Miembros del proyecto
- `documento_proyecto` - Documentación

#### Calendario y Eventos (2 tablas)
- `evento_calendario` - Eventos de calendario
- `evento_participante` - Participantes en eventos

#### Menú y Permisos (2 tablas)
- `menu_opcion` - Opciones de menú
- `rol_menu_opcion` - Permisos por rol

#### Actividad (1 tabla)
- `actividad_reciente` - Registro de actividades

### 🚀 Instalación

#### Paso 1: Ejecutar script principal
```sql
-- En SQL Server Management Studio (SSMS)
-- 1. Abre el archivo: 01_crear_base_datos.sql
-- 2. Selecciona "Master" en la lista de bases de datos
-- 3. Presiona F5 o click en "Execute"
```

#### Paso 2: Insertar datos iniciales (opcional)
```sql
-- Después de crear la base de datos:
-- 1. Abre: 02_datos_iniciales.sql
-- 2. Asegúrate de estar en la BD ISSEG_DB
-- 3. Ejecuta el script
```

### 📊 Características del Diseño

✅ **Normalización 4NF**
- Datos atómicos sin redundancia
- Nombres de usuario divididos en campos discretos (nombre_pila, apellido_paterno, apellido_materno)
- Campos separados para atributos multivaluados

✅ **Integridad Referencial**
- Claves primarias definidas
- Claves foráneas con ON DELETE SET NULL
- ON UPDATE CASCADE para cambios en referencias

✅ **Auditoría**
- Campos `fecha_creacion` en tablas principales
- Campos `fecha_inicio`, `fecha_fin` para tracking temporal
- Tabla `actividad_reciente` para auditoría

✅ **Seguridad**
- Claves únicas para evitar duplicados
- Contraseña en formato VARBINARY (hash)
- Campos `activo`/`activa` para soft-delete lógico

### 🔧 Consideraciones

- **Base de datos**: ISSEG_DB (creada automáticamente)
- **Collation**: Por defecto del servidor SQL Server
- **Compatibility Level**: SQL Server 2022
- **Recovery Model**: FULL (recomendado para producción)

### 📝 Notas

- Los campos de `apellido_materno` son opcionales (nullable)
- Las relaciones N:M se modelan con tablas de unión
- Las descripciones detalladas están en cada columna como comentarios
- Se incluyen índices únicos (UK) para campos que deben ser únicos

### 💾 Respaldo del Esquema

Para generar el esquema nuevamente desde el diccionario Excel:
```bash
python extract_schema.py      # Extrae del Excel
python generate_sql.py         # Genera el SQL
```

---

**Generado el**: 2026-04-24
**Versión**: 1.0
**Normalización**: 4NF
