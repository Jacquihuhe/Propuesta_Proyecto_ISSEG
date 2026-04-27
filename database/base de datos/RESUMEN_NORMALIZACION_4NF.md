# RESUMEN: NORMALIZACIÓN A 4NF CON DATOS ATÓMICOS

## ✓ CAMBIOS REALIZADOS

### 1. **Normalización de la Tabla USUARIO**
La tabla usuario ha sido completamente reestructurada para cumplir con atomicidad:

#### ANTES (No normalizado):
```sql
| usuario_id | nombre | correo_institucional | puesto | activo | fecha_creacion |
```

#### AHORA (Normalizado 4NF):
```sql
| usuario_id | nombre_pila | apellido_paterno | apellido_materno | correo_institucional | puesto | activo | fecha_creacion |
```

**Ventajas:**
- ✓ Datos completamente atómicos (un valor por campo)
- ✓ Facilita búsquedas por apellido
- ✓ Permite ordenamiento por apellido paterno/materno
- ✓ Soporta reportes por nombre específico
- ✓ Cumple estrictos requisitos de normalización

---

### 2. **Revisión de Todas las Tablas**
Se revisaron las 34 tablas del modelo para asegurar:

✓ **Atomicidad:** Cada columna contiene un único valor, sin datos compuestos
✓ **1NF:** Eliminados campos repetitivos
✓ **2NF:** Dependencia completa de clave primaria
✓ **3NF:** Sin dependencias transitivas
✓ **4NF:** Relaciones N:M separadas en tablas de unión

---

### 3. **Relaciones N:M Normalizadas**
Todas las relaciones muchos-a-muchos están en tablas separadas:

| Relación | Tabla de Unión | Campos |
| --- | --- | --- |
| usuario N:M rol | usuario_rol | usuario_id, rol_id |
| usuario N:M area | usuario_area | usuario_id, area_id |
| usuario N:M sistema | sistema_desarrollador | sistema_id, usuario_id |
| area N:M sistema | area_sistema | area_id, sistema_id |
| solicitud N:M usuario | solicitud_desarrollador | solicitud_id, usuario_id |
| proyecto N:M solicitud | proyecto_solicitud | proyecto_id, solicitud_id |
| proyecto N:M usuario | proyecto_miembro | proyecto_id, usuario_id |
| evento N:M usuario | evento_participante | evento_calendario_id, usuario_id |
| tarea N:M usuario | tarea_desarrollo_asignacion | tarea_desarrollo_id, usuario_id |

---

### 4. **Especializaciones 1:1 Normalizadas**
Cada especialización está en tabla separada:

| Tabla Base | Especialización | Columna FK |
| --- | --- | --- |
| solicitud | solicitud_modificacion | solicitud_id (UK) |
| solicitud | solicitud_requerimiento_tecnico | solicitud_id (UK) |
| usuario | usuario_credencial | usuario_id (PK/FK) |

---

## 📋 ARCHIVOS GENERADOS

### 1. **17_diccionario_normalizado_4NF.md**
- Documento Markdown completo con todas las tablas normalizadas
- 34 tablas con estructura atómica
- Cada tabla tiene:
  - Nombre y descripción clara
  - 7 columnas de metadatos por campo
  - Restricciones de unicidad
  - Referencias de claves foráneas

### 2. **17_diccionario_normalizado_4NF.xlsx**
- Libro Excel profesional con:
  - **Hoja INDICE:** Lista todas las tablas con descripción y número de columnas
  - **33 hojas por tabla:** Una para cada tabla (rol, usuario, area, sistema, solicitud, etc.)
  - Cada hoja contiene:
    - Nombre de tabla (A1)
    - Descripción completa (A2-A3)
    - Encabezados: Columna, Tipo, Null, Default, Llave, Relación, Descripción
    - Todas las columnas con metadata
    - Formatos profesionales (colores, bordes, alineación)

### 3. **15_diccionario_datos_modelo_consolidado.md**
- Actualizado con versión normalizada (reemplaza archivo anterior)
- Contiene la descripción completa de todas las tablas 4NF

---

## 🔍 DETALLES TÉCNICOS DE NORMALIZACIÓN

### Tabla: usuario (ANTES vs AHORA)

**ANTES (No Normalizado):**
```
| usuario_id | nombre             | correo_institucional | puesto | activo | fecha_creacion |
|            | Juan Garcia López  | juan@isseg.gob      | Jefe   | 1      | 2024-01-15     |
```

**AHORA (Normalizado 4NF):**
```
| usuario_id | nombre_pila | apellido_paterno | apellido_materno | correo_institucional | puesto | activo | fecha_creacion |
|            | Juan        | García           | López            | juan@isseg.gob       | Jefe   | 1      | 2024-01-15     |
```

**Beneficios:**
- Búsquedas por "García" en apellido_paterno (índice eficiente)
- Búsquedas por "Juan" en nombre_pila (específico)
- Ordenamiento alfabético por apellido_paterno, apellido_materno
- Sin datos redundantes ni compuestos
- Cumple BCNF (Boyce-Codd Normal Form)

---

## 📊 ESTADÍSTICAS DEL MODELO

| Métrica | Cantidad |
| --- | --- |
| **Total de Tablas** | 34 |
| **Total de Columnas** | 245+ |
| **Relaciones N:M** | 9 |
| **Relaciones 1:1** | 3 |
| **Forma Normal Máxima** | 4NF |
| **Datos Atómicos** | 100% |

---

## ✅ VALIDACIÓN DE NORMALIZACIÓN

### Tabla: usuario
- ✓ Cada columna contiene UN SOLO tipo de dato
- ✓ Sin campos compuestos (nombre_pila, apellido_paterno, apellido_materno)
- ✓ Sin repetición de grupos
- ✓ Todas las columnas dependen completamente de usuario_id
- ✓ Sin dependencias transitivas
- ✓ Sin dependencias multivaluadas

### Todas las Tablas
- ✓ Datos completamente descompuestos
- ✓ Relaciones N:M en tablas separadas
- ✓ Especializaciones en tablas independientes
- ✓ Campos calculados eliminados
- ✓ Redundancia minimizada

---

## 📝 CÓMO USAR EL DICCIONARIO NORMALIZADO

### En Markdown (15_diccionario_datos_modelo_consolidado.md):
1. Leer descripción de cada tabla
2. Revisar campos y tipos de datos
3. Entender relaciones (FK) con otras tablas
4. Consultar restricciones y valores por defecto

### En Excel (17_diccionario_normalizado_4NF.xlsx):
1. Inicio en hoja INDICE
2. Hacer clic en el nombre de tabla para ir a su hoja específica
3. Cada hoja muestra:
   - Nombre y descripción en la parte superior
   - Tabla completa con metadata de columnas
   - Formato profesional para impresión y presentación

---

## 🔗 RELACIONES PRINCIPALES (4NF)

### Seguridad
- usuario (1) → (M) usuario_rol ← (1) rol
- usuario_credencial 1:1 usuario
- rol (1) → (M) rol_menu_opcion ← (1) menu_opcion

### Estructura
- area (1) → (M) area (jerarquía)
- usuario (M) ← usuario_area → (M) area
- area (M) ← area_sistema → (M) sistema
- usuario (M) ← sistema_desarrollador → (M) sistema

### Solicitudes
- solicitud ← solicitud_desarrollador → usuario
- solicitud ← solicitud_historial_estado → estado_solicitud
- solicitud → solicitud_aprobacion, solicitud_comentario, solicitud_adjunto

### Proyectos
- proyecto (1) → (M) proyecto_solicitud ← (1) solicitud
- usuario (M) ← proyecto_miembro → (M) proyecto

---

## 💾 PRÓXIMOS PASOS

1. ✓ Usar el Markdown para documentación técnica
2. ✓ Compartir el Excel con stakeholders
3. ✓ Usar estos esquemas para:
   - Creación de bases de datos
   - Generación de modelos ORM (Entity Framework, Hibernate)
   - Documentación de API REST
   - Scripts SQL (CREATE TABLE)

---

**Generado:** 20 de abril de 2026  
**Versión:** Normalizada a 4NF con datos atómicos  
**Estado:** Listo para implementación
