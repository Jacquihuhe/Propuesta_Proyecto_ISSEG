# Diccionario de Datos Normalizado a 4NF - SGSPCSI

Este documento presenta todas las tablas normalizadas hasta la 4ª Forma Normal (4NF) con datos completamente atómicos.

## Convenciones

- PK: Llave primaria
- FK: Llave foránea
- UK: Único
- NN: NOT NULL
- N: NULL permitido

---

## Tabla: rol

**Descripción:** Catálogo de roles de seguridad del sistema. Almacena los perfiles de acceso disponibles en la aplicación.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| rol_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del rol |
| clave | VARCHAR(30) | NN | - | UK | - | Clave corta y única del rol |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre visible del rol |
| descripcion | VARCHAR(500) | N | - | - | - | Descripción funcional del perfil |
| activo | BIT | NN | 1 | - | - | Indica si el rol está activo |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación del rol |

---

## Tabla: usuario

**Descripción:** Usuarios del sistema con datos personales atómicos. Almacena información de identidad separada en campos discretos para normalización.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del usuario |
| nombre_pila | VARCHAR(80) | NN | - | - | - | Primer nombre del usuario |
| apellido_paterno | VARCHAR(80) | NN | - | - | - | Apellido paterno del usuario |
| apellido_materno | VARCHAR(80) | N | - | - | - | Apellido materno del usuario |
| correo_institucional | VARCHAR(180) | NN | - | UK | - | Correo institucional único |
| puesto | VARCHAR(120) | N | - | - | - | Puesto o cargo del usuario |
| activo | BIT | NN | 1 | - | - | Indica si el usuario está activo |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación del usuario |

---

## Tabla: usuario_rol

**Descripción:** Relación N:M entre usuarios y roles. Asigna perfiles de acceso a usuarios con control de vigencia.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_rol_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la asignación |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia al usuario |
| rol_id | INT | NN | - | FK | rol.rol_id | Referencia al rol |
| activo | BIT | NN | 1 | - | - | Indica si la asignación está vigente |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de asignación del rol |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término de la asignación |

**Restricciones:** UK (usuario_id, rol_id)

---

## Tabla: area

**Descripción:** Estructura organizacional jerárquica. Almacena direcciones, coordinaciones y departamentos con relación padre-hijo.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| area_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del área |
| area_padre_id | INT | N | - | FK | area.area_id | Área superior (jerarquía) |
| clave | VARCHAR(50) | N | - | - | - | Clave operativa del área |
| nombre | VARCHAR(220) | NN | - | UK | - | Nombre oficial del área |
| tipo_area | VARCHAR(30) | NN | - | - | - | Tipo: DIRECCION, COORDINACION, DEPARTAMENTO |
| nivel | TINYINT | NN | - | - | - | Nivel jerárquico numérico |
| activa | BIT | NN | 1 | - | - | Indica si el área está activa |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación del área |

---

## Tabla: usuario_area

**Descripción:** Relación N:M entre usuarios y áreas. Vincula usuarios a áreas organizacionales con control de titularidad.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_area_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la vinculación |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia al usuario |
| area_id | INT | NN | - | FK | area.area_id | Referencia al área |
| es_titular | BIT | NN | 0 | - | - | Indica si es titular del área |
| activo | BIT | NN | 1 | - | - | Indica si la vinculación está activa |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de inicio de la vinculación |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término de la vinculación |

**Restricciones:** UK (usuario_id, area_id)

---

## Tabla: sistema

**Descripción:** Catálogo de sistemas institucionales. Almacena aplicaciones y sistemas disponibles en la institución.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| sistema_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del sistema |
| clave | VARCHAR(50) | NN | - | UK | - | Clave única del sistema |
| nombre | VARCHAR(200) | NN | - | - | - | Nombre funcional del sistema |
| descripcion | VARCHAR(500) | N | - | - | - | Descripción de funcionalidades |
| activo | BIT | NN | 1 | - | - | Indica si el sistema está activo |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación del sistema |

---

## Tabla: area_sistema

**Descripción:** Relación N:M entre áreas y sistemas. Define qué sistemas son visibles y accesibles por cada área.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| area_sistema_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la relación |
| area_id | INT | NN | - | FK | area.area_id | Referencia al área |
| sistema_id | INT | NN | - | FK | sistema.sistema_id | Referencia al sistema |
| activo | BIT | NN | 1 | - | - | Indica si la relación está activa |
| fecha_alta | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de asignación |

**Restricciones:** UK (area_id, sistema_id)

---

## Tabla: sistema_desarrollador

**Descripción:** Relación N:M entre sistemas y usuarios (desarrolladores). Asigna técnicos responsables de cada sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| sistema_desarrollador_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la asignación |
| sistema_id | INT | NN | - | FK | sistema.sistema_id | Referencia al sistema |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia al desarrollador |
| tipo_participacion | VARCHAR(20) | NN | - | - | - | RESPONSABLE o PARTICIPANTE |
| activo | BIT | NN | 1 | - | - | Indica si la asignación está activa |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de inicio de participación |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término de participación |

**Restricciones:** UK (sistema_id, usuario_id)

---

## Tabla: tipo_solicitud

**Descripción:** Catálogo de tipos de solicitud. Define las categorías principales de solicitudes en el sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tipo_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del tipo |
| clave | VARCHAR(30) | NN | - | UK | - | Clave única del tipo |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre del tipo de solicitud |
| activo | BIT | NN | 1 | - | - | Indica si el tipo está activo |

---

## Tabla: estado_solicitud

**Descripción:** Estados del ciclo de vida de solicitudes. Define los estados por los que puede transitar una solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| estado_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del estado |
| clave | VARCHAR(30) | NN | - | UK | - | Clave única del estado |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre del estado |
| es_terminal | BIT | NN | 0 | - | - | Indica si es estado final |
| activo | BIT | NN | 1 | - | - | Indica si el estado está activo |

---

## Tabla: prioridad_solicitud

**Descripción:** Catálogo de prioridades. Define los niveles de urgencia para solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| prioridad_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la prioridad |
| clave | VARCHAR(20) | NN | - | UK | - | BAJA, MEDIA, ALTA, CRITICA |
| nombre | VARCHAR(50) | NN | - | - | - | Nombre de la prioridad |
| peso | TINYINT | NN | - | - | - | Valor numérico para ordenamiento |
| activo | BIT | NN | 1 | - | - | Indica si la prioridad está activa |

---

## Tabla: solicitud

**Descripción:** Entidad principal de negocio. Almacena todas las solicitudes (tickets) del sistema con trazabilidad completa.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la solicitud |
| folio | VARCHAR(40) | NN | - | UK | - | Folio único de negocio |
| titulo | VARCHAR(200) | NN | - | - | - | Título breve de la solicitud |
| descripcion | VARCHAR(MAX) | NN | - | - | - | Descripción detallada |
| area_solicitante_id | INT | NN | - | FK | area.area_id | Área que solicita |
| sistema_id | INT | N | - | FK | sistema.sistema_id | Sistema impactado |
| tipo_solicitud_id | INT | NN | - | FK | tipo_solicitud.tipo_solicitud_id | Tipo de solicitud |
| prioridad_solicitud_id | INT | NN | - | FK | prioridad_solicitud.prioridad_solicitud_id | Prioridad |
| estado_solicitud_id | INT | NN | - | FK | estado_solicitud.estado_solicitud_id | Estado actual |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario creador |
| fecha_solicitud | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación |
| fecha_compromiso | DATETIME2 | N | - | - | - | Fecha SLA comprometida |
| fecha_resolucion | DATETIME2 | N | - | - | - | Fecha de cierre |
| esfuerzo_horas | DECIMAL(10,2) | N | - | - | - | Horas invertidas |
| activo | BIT | NN | 1 | - | - | Indica si está activa |

---

## Tabla: solicitud_desarrollador

**Descripción:** Relación N:M entre solicitudes y desarrolladores. Asigna técnicos responsables de cada solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_desarrollador_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la asignación |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a la solicitud |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia al desarrollador |
| tipo_participacion | VARCHAR(20) | NN | - | - | - | RESPONSABLE o PARTICIPANTE |
| activo | BIT | NN | 1 | - | - | Indica si la asignación está activa |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de asignación |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término |

**Restricciones:** UK (solicitud_id, usuario_id)

---

## Tabla: solicitud_historial_estado

**Descripción:** Bitácora de cambios de estado. Registra el historial completo de transiciones de estado de cada solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_historial_estado_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del registro |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a la solicitud |
| estado_anterior_id | INT | N | - | FK | estado_solicitud.estado_solicitud_id | Estado previo |
| estado_nuevo_id | INT | NN | - | FK | estado_solicitud.estado_solicitud_id | Nuevo estado |
| comentario | VARCHAR(800) | N | - | - | - | Observación del cambio |
| cambiado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que realiza cambio |
| fecha_cambio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del cambio |

---

## Tabla: solicitud_aprobacion

**Descripción:** Aprobaciones y evaluaciones. Registra las decisiones de aprobación, rechazo o solicitud de información.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_aprobacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la aprobación |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a la solicitud |
| aprobado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que aprueba |
| estatus_aprobacion | VARCHAR(20) | NN | - | - | - | APROBADA, RECHAZADA, REQUIERE_INFO |
| motivo | VARCHAR(1000) | N | - | - | - | Motivo de la decisión |
| fecha_aprobacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de evaluación |

---

## Tabla: solicitud_comentario

**Descripción:** Comentarios y anotaciones. Almacena comentarios de usuarios en solicitudes para seguimiento.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_comentario_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del comentario |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a la solicitud |
| autor_usuario_id | INT | NN | - | FK | usuario.usuario_id | Autor del comentario |
| comentario | VARCHAR(2000) | NN | - | - | - | Texto del comentario |
| es_interno | BIT | NN | 0 | - | - | Indica si es comentario interno |
| fecha_comentario | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del comentario |

---

## Tabla: solicitud_adjunto

**Descripción:** Evidencias y archivos. Almacena archivos adjuntos que soportan solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_adjunto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del adjunto |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a la solicitud |
| nombre_archivo | VARCHAR(255) | NN | - | - | - | Nombre original del archivo |
| ruta_archivo | VARCHAR(500) | NN | - | - | - | Ruta de almacenamiento |
| tipo_mime | VARCHAR(120) | N | - | - | - | Tipo MIME del archivo |
| tamanio_bytes | BIGINT | N | - | - | - | Tamaño en bytes |
| subido_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que sube el archivo |
| fecha_subida | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de carga |

---

## Tabla: notificacion

**Descripción:** Notificaciones de usuarios. Almacena avisos y alertas enviadas a usuarios del sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| notificacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de notificación |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario receptor |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud asociada |
| titulo | VARCHAR(180) | NN | - | - | - | Título del aviso |
| mensaje | VARCHAR(1000) | NN | - | - | - | Contenido del mensaje |
| leida | BIT | NN | 0 | - | - | Indica si fue leída |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de creación |
| fecha_lectura | DATETIME2 | N | - | - | - | Fecha de lectura |

---

## Tabla: usuario_credencial

**Descripción:** Seguridad y autenticación. Almacena credenciales y datos de acceso del usuario.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_id | INT | NN | - | PK/FK | usuario.usuario_id | Identificador del usuario |
| login_usuario | VARCHAR(80) | NN | - | UK | - | Nombre de login único |
| password_hash | VARBINARY(512) | NN | - | - | - | Hash de la contraseña |
| password_salt | VARBINARY(128) | NN | - | - | - | Salt para hash |
| algoritmo_hash | VARCHAR(30) | NN | PBKDF2 | - | - | Algoritmo de cifrado |
| iteraciones | INT | NN | 100000 | - | - | Iteraciones de hash |
| ultimo_acceso | DATETIME2 | N | - | - | - | Fecha de último acceso |
| intentos_fallidos | SMALLINT | NN | 0 | - | - | Contador de intentos |
| bloqueado_hasta | DATETIME2 | N | - | - | - | Fecha de desbloqueo |
| requiere_cambio_password | BIT | NN | 0 | - | - | Requiere cambio obligatorio |
| fecha_actualizacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de última actualización |

---

## Tabla: menu_opcion

**Descripción:** Menú de navegación. Define opciones y rutas del sistema con jerarquía.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| menu_opcion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la opción |
| clave | VARCHAR(60) | NN | - | UK | - | Clave única de la opción |
| nombre | VARCHAR(120) | NN | - | - | - | Nombre visible en menú |
| ruta | VARCHAR(220) | NN | - | - | - | Ruta de navegación |
| icono | VARCHAR(80) | N | - | - | - | Nombre del icono UI |
| orden | INT | NN | - | - | - | Posición en el menú |
| activa | BIT | NN | 1 | - | - | Indica si está activa |
| menu_padre_id | INT | N | - | FK | menu_opcion.menu_opcion_id | Menú superior (jerarquía) |

---

## Tabla: rol_menu_opcion

**Descripción:** Permisos de menú por rol. Define qué opciones puede ver y usar cada rol.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| rol_menu_opcion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del permiso |
| rol_id | INT | NN | - | FK | rol.rol_id | Referencia al rol |
| menu_opcion_id | INT | NN | - | FK | menu_opcion.menu_opcion_id | Referencia a la opción |
| puede_ver | BIT | NN | 1 | - | - | Permiso de visualización |
| puede_editar | BIT | NN | 0 | - | - | Permiso de edición |
| puede_aprobar | BIT | NN | 0 | - | - | Permiso de aprobación |

**Restricciones:** UK (rol_id, menu_opcion_id)

---

## Tabla: tipo_modificacion

**Descripción:** Tipos de modificación. Clasifica las modificaciones en adaptativas, evolutivas o correctivas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tipo_modificacion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del tipo |
| clave | VARCHAR(30) | NN | - | UK | - | ADAPTATIVA, EVOLUTIVA, CORRECTIVA |
| nombre | VARCHAR(80) | NN | - | - | - | Nombre del tipo |
| activo | BIT | NN | 1 | - | - | Indica si está activo |

---

## Tabla: solicitud_modificacion

**Descripción:** Detalles de modificación. Almacena información específica de solicitudes de modificación de sistemas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_modificacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| solicitud_id | BIGINT | NN | - | UK/FK | solicitud.solicitud_id | Referencia a solicitud |
| tipo_modificacion_id | INT | NN | - | FK | tipo_modificacion.tipo_modificacion_id | Tipo de modificación |
| sistema_version_actual | VARCHAR(80) | N | - | - | - | Versión actual del sistema |
| modulo_afectado | VARCHAR(200) | N | - | - | - | Módulo que se modifica |
| impacto_tecnico | VARCHAR(1500) | N | - | - | - | Impacto técnico esperado |
| justificacion | VARCHAR(2000) | N | - | - | - | Justificación del cambio |
| fecha_registro | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de registro |

---

## Tabla: solicitud_requerimiento_tecnico

**Descripción:** Especificaciones técnicas. Detalla requerimientos técnicos después de aprobación de solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_requerimiento_tecnico_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| solicitud_id | BIGINT | NN | - | UK/FK | solicitud.solicitud_id | Referencia a solicitud |
| arquitectura_propuesta | VARCHAR(2000) | N | - | - | - | Arquitectura de solución |
| alcance_tecnico | VARCHAR(2000) | N | - | - | - | Alcance del desarrollo |
| dependencias | VARCHAR(2000) | N | - | - | - | Dependencias técnicas |
| criterios_aceptacion | VARCHAR(2000) | N | - | - | - | Criterios de validación |
| riesgos | VARCHAR(2000) | N | - | - | - | Riesgos identificados |
| plan_pruebas | VARCHAR(2000) | N | - | - | - | Plan de pruebas |
| observaciones | VARCHAR(2000) | N | - | - | - | Observaciones adicionales |
| elaborado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario autor |
| fecha_elaboracion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de elaboración |

---

## Tabla: tarea_desarrollo

**Descripción:** Tareas operativas. Descompone solicitudes en tareas concretas de desarrollo.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tarea_desarrollo_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único de la tarea |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a solicitud |
| titulo | VARCHAR(220) | NN | - | - | - | Título de la tarea |
| descripcion | VARCHAR(2000) | N | - | - | - | Descripción detallada |
| prioridad_solicitud_id | INT | NN | - | FK | prioridad_solicitud.prioridad_solicitud_id | Nivel de prioridad |
| estado_tarea | VARCHAR(30) | NN | - | - | - | PENDIENTE, EN_DESARROLLO, COMPLETADA, BLOQUEADA |
| fecha_inicio | DATETIME2 | N | - | - | - | Fecha de inicio |
| fecha_compromiso | DATETIME2 | N | - | - | - | Fecha comprometida |
| fecha_cierre | DATETIME2 | N | - | - | - | Fecha de cierre |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario creador |
| activo | BIT | NN | 1 | - | - | Indica si está activa |

---

## Tabla: tarea_desarrollo_asignacion

**Descripción:** Asignaciones de tarea. Vincula usuarios a tareas con roles específicos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tarea_desarrollo_asignacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| tarea_desarrollo_id | BIGINT | NN | - | FK | tarea_desarrollo.tarea_desarrollo_id | Referencia a tarea |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia a usuario |
| rol_tecnico | VARCHAR(30) | NN | - | - | - | RESPONSABLE o PARTICIPANTE |
| activa | BIT | NN | 1 | - | - | Indica si está activa |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de asignación |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término |

**Restricciones:** UK (tarea_desarrollo_id, usuario_id)

---

## Tabla: actividad_reciente

**Descripción:** Bitácora de actividades. Registra eventos recientes para paneles de seguimiento.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| actividad_reciente_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud asociada |
| tarea_desarrollo_id | BIGINT | N | - | FK | tarea_desarrollo.tarea_desarrollo_id | Tarea asociada |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario actor |
| tipo_actividad | VARCHAR(40) | NN | - | - | - | Tipo de actividad |
| titulo | VARCHAR(220) | NN | - | - | - | Título corto |
| detalle | VARCHAR(2000) | N | - | - | - | Detalle de la actividad |
| fecha_actividad | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del evento |
| visible_para_pm | BIT | NN | 1 | - | - | Visible para PM |
| visible_para_desarrollador | BIT | NN | 1 | - | - | Visible para desarrollador |

---

## Tabla: proyecto

**Descripción:** Gestión de proyectos. Agrupa solicitudes, equipo y planificación en iniciativas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único del proyecto |
| clave | VARCHAR(40) | NN | - | UK | - | Clave única del proyecto |
| nombre | VARCHAR(200) | NN | - | - | - | Nombre del proyecto |
| descripcion | VARCHAR(1500) | N | - | - | - | Descripción de objetivos |
| estado_proyecto | VARCHAR(30) | NN | - | - | - | PLANEADO, EN_EJECUCION, PAUSADO, CERRADO |
| fecha_inicio | DATE | N | - | - | - | Fecha de inicio |
| fecha_fin_planeada | DATE | N | - | - | - | Fecha fin planeada |
| fecha_fin_real | DATE | N | - | - | - | Fecha fin real |
| pm_usuario_id | INT | NN | - | FK | usuario.usuario_id | Project Manager |
| activo | BIT | NN | 1 | - | - | Indica si está activo |

---

## Tabla: proyecto_solicitud

**Descripción:** Relación N:M entre proyectos y solicitudes. Vincula solicitudes con iniciativas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_solicitud_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Referencia a proyecto |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Referencia a solicitud |
| fecha_vinculacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de vinculación |

**Restricciones:** UK (proyecto_id, solicitud_id)

---

## Tabla: proyecto_miembro

**Descripción:** Miembros de proyecto. Asigna usuarios a proyectos con roles operativos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_miembro_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Referencia a proyecto |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Referencia a usuario |
| rol_en_proyecto | VARCHAR(40) | NN | - | - | - | PM, DESARROLLADOR, ANALISTA, TESTER, LIDER_TECNICO |
| carga_estimada_pct | DECIMAL(5,2) | N | - | - | - | Dedicación estimada (%) |
| activo | BIT | NN | 1 | - | - | Indica si está activo |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de inicio |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha de término |

**Restricciones:** UK (proyecto_id, usuario_id)

---

## Tabla: documento_proyecto

**Descripción:** Documentos de proyecto. Almacena archivos asociados a proyectos y solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| documento_proyecto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Referencia a proyecto |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud asociada (opcional) |
| nombre_documento | VARCHAR(255) | NN | - | - | - | Nombre visible |
| tipo_documento | VARCHAR(50) | NN | - | - | - | ERS, DISENO, MANUAL, MINUTA, OTRO |
| version_documento | VARCHAR(40) | N | - | - | - | Versión del documento |
| ruta_archivo | VARCHAR(600) | NN | - | - | - | Ruta de almacenamiento |
| tamanio_bytes | BIGINT | N | - | - | - | Tamaño en bytes |
| subido_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que sube |
| fecha_subida | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de carga |
| visible_para_participantes | BIT | NN | 1 | - | - | Visible para participantes |

---

## Tabla: evento_calendario

**Descripción:** Eventos de calendario. Registra reuniones, entregas, revisiones y actividades.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| evento_calendario_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| proyecto_id | BIGINT | N | - | FK | proyecto.proyecto_id | Proyecto asociado |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud asociada |
| titulo | VARCHAR(220) | NN | - | - | - | Título del evento |
| descripcion | VARCHAR(2000) | N | - | - | - | Descripción |
| tipo_evento | VARCHAR(40) | NN | - | - | - | REUNION, ENTREGA, REVISION, DESPLIEGUE, ACTIVIDAD |
| fecha_inicio | DATETIME2 | NN | - | - | - | Fecha y hora de inicio |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora de fin |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario creador |
| es_todo_dia | BIT | NN | 0 | - | - | Indica si es evento todo el día |

---

## Tabla: evento_participante

**Descripción:** Participantes de evento. Registra asistentes y su estado de confirmación en eventos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| evento_participante_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Identificador único |
| evento_calendario_id | BIGINT | NN | - | FK | evento_calendario.evento_calendario_id | Referencia a evento |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario participante |
| asistencia | VARCHAR(20) | NN | PENDIENTE | - | - | PENDIENTE, CONFIRMADA, RECHAZADA |

**Restricciones:** UK (evento_calendario_id, usuario_id)

---

## Resumen de Relaciones (4NF)

### 1. Seguridad y Autenticación
- `usuario` 1:1 `usuario_credencial`
- `usuario` N:M `rol` (mediante `usuario_rol`)
- `rol` N:M `menu_opcion` (mediante `rol_menu_opcion`)

### 2. Estructura Organizacional
- `area` 1:N `area` (jerarquía padre-hijo)
- `usuario` N:M `area` (mediante `usuario_area`)
- `area` N:M `sistema` (mediante `area_sistema`)
- `sistema` N:M `usuario` (mediante `sistema_desarrollador`)

### 3. Solicitudes y Tickets
- `solicitud` N:1 `area`, `sistema`, `tipo_solicitud`, `prioridad_solicitud`, `estado_solicitud`, `usuario`
- `solicitud` N:M `usuario` (mediante `solicitud_desarrollador`)
- `solicitud` 1:N `solicitud_historial_estado`, `solicitud_aprobacion`, `solicitud_comentario`, `solicitud_adjunto`, `notificacion`

### 4. Especializaciones de Solicitud
- `solicitud` 1:1 `solicitud_modificacion`
- `tipo_modificacion` 1:N `solicitud_modificacion`
- `solicitud` 1:1 `solicitud_requerimiento_tecnico`

### 5. Desarrollo y Tareas
- `solicitud` 1:N `tarea_desarrollo`
- `tarea_desarrollo` N:M `usuario` (mediante `tarea_desarrollo_asignacion`)
- `solicitud` 1:N `actividad_reciente`
- `tarea_desarrollo` 1:N `actividad_reciente`

### 6. Gestión de Proyectos
- `proyecto` N:M `solicitud` (mediante `proyecto_solicitud`)
- `proyecto` N:M `usuario` (mediante `proyecto_miembro`)
- `proyecto` 1:N `documento_proyecto`
- `proyecto` 1:N `evento_calendario`
- `evento_calendario` N:M `usuario` (mediante `evento_participante`)

---

## Notas de Normalización

✓ **Todos los datos son atómicos:** Sin campos compuestos ni repetitivos
✓ **Cumplimiento 1NF:** Cada atributo contiene un solo valor
✓ **Cumplimiento 2NF:** Todas las columnas no clave dependen completamente de la clave primaria
✓ **Cumplimiento 3NF:** Sin dependencias transitivas; solo atributos que describen directamente la entidad
✓ **Cumplimiento 4NF:** Sin dependencias multivaluadas no funcionales; relaciones N:M separadas en tablas de unión
