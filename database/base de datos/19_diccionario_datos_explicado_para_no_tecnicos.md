# Diccionario de Datos Explicado - SGSPCSI

Version: descripciones de tablas y columnas actualizadas.

Este documento muestra quÃ© guarda cada tabla del sistema con palabras simples. La idea es que se pueda leer sin conocimientos tÃ©cnicos.

Piensa en cada tabla como una lista ordenada:
- una fila = un registro
- una columna = un dato
- una tabla = un grupo de datos de la misma clase

## CÃ³mo leer los valores

- PK: llave primaria, es el identificador principal de una tabla.
- FK: llave forÃ¡nea, conecta una tabla con otra.
- UK: Ãºnico, significa que no se repite.
- NN: no se puede dejar vacÃ­o.
- N: sÃ­ se puede dejar vacÃ­o.

## CÃ³mo leer los campos BIT o BOOLEAN

- 0 = no, falso, apagado, inactivo o no permitido.
- 1 = sÃ­, verdadero, encendido, activo o permitido.

Ejemplos:
- activo o activa: 0 = desactivado, 1 = activo.
- es_terminal: 0 = no termina, 1 = sÃ­ es el final.
- es_titular: 0 = no titular, 1 = titular.
- es_interno: 0 = comentario visible para el flujo normal, 1 = comentario interno.
- leida: 0 = no leÃ­da, 1 = leÃ­da.
- requiere_cambio_password: 0 = no obliga cambio, 1 = obliga cambiar la contraseÃ±a.
- puede_ver, puede_editar, puede_aprobar: 0 = no permite, 1 = sÃ­ permite.
- visible_para_pm, visible_para_desarrollador, visible_para_participantes: 0 = no se muestra, 1 = sÃ­ se muestra.
- es_todo_dia: 0 = tiene horario, 1 = dura todo el dÃ­a.

## Resumen simple de tablas

### Seguridad y acceso
- rol: guarda los tipos de permiso del sistema.
- usuario: guarda a las personas que usan el sistema.
- usuario_rol: indica quÃ© permiso tiene cada usuario.
- usuario_credencial: guarda cÃ³mo entra cada usuario al sistema y cÃ³mo se protege su contraseÃ±a.
- menu_opcion: guarda las opciones y pantallas del menÃº.
- rol_menu_opcion: indica quÃ© menÃºs puede ver o usar cada rol.

### OrganizaciÃ³n interna
- area: guarda las Ã¡reas o departamentos de la instituciÃ³n.
- usuario_area: indica a quÃ© Ã¡rea pertenece cada usuario.
- sistema: guarda los sistemas o aplicaciones de la instituciÃ³n.
- area_sistema: indica quÃ© sistemas puede usar cada Ã¡rea.
- sistema_desarrollador: indica quÃ© desarrolladores participan en cada sistema.

### Solicitudes
- tipo_solicitud: guarda la clase o tipo de solicitud.
- estado_solicitud: guarda las etapas por las que pasa una solicitud.
- prioridad_solicitud: guarda quÃ© tan urgente es una solicitud.
- solicitud: guarda la informaciÃ³n principal de cada ticket o solicitud.
- solicitud_desarrollador: indica quÃ© desarrolladores trabajan en una solicitud.
- solicitud_historial_estado: guarda el historial de cambios de estado.
- solicitud_aprobacion: guarda si una solicitud fue aprobada, rechazada o si falta informaciÃ³n.
- solicitud_comentario: guarda los comentarios escritos sobre una solicitud.
- solicitud_adjunto: guarda los archivos que se suben con una solicitud.
- notificacion: guarda los avisos que el sistema envÃ­a a los usuarios.

### Cambios tÃ©cnicos
- tipo_modificacion: guarda el tipo de cambio pedido.
- solicitud_modificacion: guarda el detalle tÃ©cnico de una solicitud de cambio.
- solicitud_requerimiento_tecnico: guarda la explicaciÃ³n tÃ©cnica completa de lo que se harÃ¡.

### Trabajo diario
- tarea_desarrollo: guarda las tareas concretas que nacen de una solicitud.
- tarea_desarrollo_asignacion: guarda quiÃ©n trabaja en cada tarea.
- actividad_reciente: guarda las acciones recientes para mostrar movimiento en el sistema.

### Proyectos y calendario
- proyecto: guarda los proyectos de trabajo.
- proyecto_solicitud: conecta proyectos con solicitudes.
- proyecto_miembro: guarda quiÃ©n participa en cada proyecto.
- documento_proyecto: guarda los documentos relacionados con un proyecto.
- evento_calendario: guarda reuniones, entregas y otras actividades con fecha.
- evento_participante: guarda quiÃ©n participa en cada evento y si confirmÃ³ asistencia.

## Convenciones

- PK: Llave primaria
- FK: Llave forÃ¡nea
- UK: Ãšnico
- NN: NOT NULL
- N: NULL permitido

---

## Tabla: rol

**DescripciÃ³n:** CatÃ¡logo de roles de seguridad del sistema. Almacena los perfiles de acceso disponibles en la aplicaciÃ³n.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| rol_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(30) | NN | - | UK | - | Clave corta y Ãºnica del rol |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre legible del rol mostrado en interfaces y reportes de permisos. |
| descripcion | VARCHAR(500) | N | - | - | - | DescripciÃ³n funcional del perfil |
| activo | BIT | NN | 1 | - | - | Estado del rol en el catalogo: 1 significa habilitado para asignarse, 0 significa deshabilitado para nuevos usos. |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el rol fue creado y guardado por primera vez. |

---

## Tabla: usuario

**DescripciÃ³n:** Usuarios del sistema con datos personales atÃ³micos. Almacena informaciÃ³n de identidad separada en campos discretos para normalizaciÃ³n.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| nombre_pila | VARCHAR(80) | NN | - | - | - | Nombre propio principal de la persona usuaria. |
| apellido_paterno | VARCHAR(80) | NN | - | - | - | Primer apellido del usuario para identificacion completa. |
| apellido_materno | VARCHAR(80) | N | - | - | - | Segundo apellido del usuario cuando aplica. |
| correo_institucional | VARCHAR(180) | NN | - | UK | - | Correo institucional Ãºnico |
| puesto | VARCHAR(120) | N | - | - | - | Cargo organizacional del usuario para contexto administrativo y de autorizacion. |
| activo | BIT | NN | 1 | - | - | Estado del usuario: 1 permite acceso al sistema, 0 bloquea su uso operativo. |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el usuario fue dado de alta por primera vez. |

---

## Tabla: usuario_rol

**DescripciÃ³n:** RelaciÃ³n N:M entre usuarios y roles. Asigna perfiles de acceso a usuarios con control de vigencia.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_rol_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario correspondiente dentro del catalogo de usuarios. |
| rol_id | INT | NN | - | FK | rol.rol_id | Llave foranea al rol de seguridad que define permisos y alcances. |
| activo | BIT | NN | 1 | - | - | Vigencia de la asignacion de rol: 1 vigente, 0 finalizada o revocada. |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora exacta en que ese rol se asigno al usuario. |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que termina la asignacion de rol; puede quedar vacia si sigue vigente. |

**Restricciones:** UK (usuario_id, rol_id)

---

## Tabla: area

**DescripciÃ³n:** Estructura organizacional jerÃ¡rquica. Almacena direcciones, coordinaciones y departamentos con relaciÃ³n padre-hijo.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| area_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| area_padre_id | INT | N | - | FK | area.area_id | Ãrea superior (jerarquÃ­a) |
| clave | VARCHAR(50) | N | - | - | - | Clave operativa del Ã¡rea |
| nombre | VARCHAR(220) | NN | - | UK | - | Nombre oficial del Ã¡rea |
| tipo_area | VARCHAR(30) | NN | - | - | - | Clasificacion organizacional del area para ubicar su nivel de gestion. |
| nivel | TINYINT | NN | - | - | - | Nivel jerÃ¡rquico numÃ©rico |
| activa | BIT | NN | 1 | - | - | Estado del area: 1 operativa en la estructura organizacional, 0 inactiva. |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el area se registro por primera vez en el catalogo. |

---

## Tabla: usuario_area

**DescripciÃ³n:** RelaciÃ³n N:M entre usuarios y Ã¡reas. Vincula usuarios a Ã¡reas organizacionales con control de titularidad.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_area_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario correspondiente dentro del catalogo de usuarios. |
| area_id | INT | NN | - | FK | area.area_id | Llave foranea que apunta al area organizacional relacionada con este registro. |
| es_titular | BIT | NN | 0 | - | - | Titularidad del usuario en el area: 1 es responsable principal, 0 es integrante sin titularidad. |
| activo | BIT | NN | 1 | - | - | Vigencia de la adscripcion usuario-area: 1 activa, 0 concluida o inhabilitada. |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que inicia la vinculacion del usuario con el area. |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que concluye la vinculacion del usuario con el area; vacia si sigue activa. |

**Restricciones:** UK (usuario_id, area_id)

---

## Tabla: sistema

**DescripciÃ³n:** CatÃ¡logo de sistemas institucionales. Almacena aplicaciones y sistemas disponibles en la instituciÃ³n.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| sistema_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(50) | NN | - | UK | - | Clave Ãºnica del sistema |
| nombre | VARCHAR(200) | NN | - | - | - | Nombre con el que usuarios y equipos identifican el sistema en la operacion diaria. |
| descripcion | VARCHAR(500) | N | - | - | - | DescripciÃ³n de funcionalidades |
| activo | BIT | NN | 1 | - | - | Estado del sistema en catalogo: 1 disponible para operar, 0 fuera de servicio o retirado. |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el sistema se dio de alta en el catalogo institucional. |

---

## Tabla: area_sistema

**DescripciÃ³n:** RelaciÃ³n N:M entre Ã¡reas y sistemas. Define quÃ© sistemas son visibles y accesibles por cada Ã¡rea.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| area_sistema_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| area_id | INT | NN | - | FK | area.area_id | Llave foranea que apunta al area organizacional relacionada con este registro. |
| sistema_id | INT | NN | - | FK | sistema.sistema_id | Llave foranea al sistema o aplicacion sobre la que aplica el registro. |
| activo | BIT | NN | 1 | - | - | Vigencia de la relacion area-sistema: 1 habilitada, 0 no vigente. |
| fecha_alta | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora exacta en que se realizo la asignacion en el sistema. |

**Restricciones:** UK (area_id, sistema_id)

---

## Tabla: sistema_desarrollador

**DescripciÃ³n:** RelaciÃ³n N:M entre sistemas y usuarios (desarrolladores). Asigna tÃ©cnicos responsables de cada sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| sistema_desarrollador_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| sistema_id | INT | NN | - | FK | sistema.sistema_id | Llave foranea al sistema o aplicacion sobre la que aplica el registro. |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario tecnico que participa en el desarrollo o mantenimiento del sistema. |
| tipo_participacion | VARCHAR(20) | NN | - | - | - | Rol operativo de la persona en la actividad: RESPONSABLE cuando lidera y PARTICIPANTE cuando colabora. |
| activo | BIT | NN | 1 | - | - | Vigencia de la asignacion tecnica: 1 activa, 0 inactiva o cerrada. |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que comienza la actividad, relacion o periodo registrado. de participaciÃ³n |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que finaliza formalmente la asignacion o relacion; puede quedar vacia si sigue vigente. de participaciÃ³n |

**Restricciones:** UK (sistema_id, usuario_id)

---

## Tabla: tipo_solicitud

**DescripciÃ³n:** CatÃ¡logo de tipos de solicitud. Define las categorÃ­as principales de solicitudes en el sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tipo_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(30) | NN | - | UK | - | Clave Ãºnica del tipo |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre del tipo de solicitud |
| activo | BIT | NN | 1 | - | - | Estado del tipo de solicitud: 1 disponible para captura, 0 no disponible. |

---

## Tabla: estado_solicitud

**DescripciÃ³n:** Estados del ciclo de vida de solicitudes. Define los estados por los que puede transitar una solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| estado_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(30) | NN | - | UK | - | Clave Ãºnica del estado |
| nombre | VARCHAR(100) | NN | - | - | - | Nombre del estado |
| es_terminal | BIT | NN | 0 | - | - | Marca de cierre del flujo: 1 indica estado terminal, 0 indica estado intermedio. |
| activo | BIT | NN | 1 | - | - | Estado del catalogo de estados: 1 utilizable en flujo, 0 deshabilitado. |

---

## Tabla: prioridad_solicitud

**DescripciÃ³n:** CatÃ¡logo de prioridades. Define los niveles de urgencia para solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| prioridad_solicitud_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(20) | NN | - | UK | - | BAJA, MEDIA, ALTA, CRITICA |
| nombre | VARCHAR(50) | NN | - | - | - | Nombre de la prioridad |
| peso | TINYINT | NN | - | - | - | Valor numÃ©rico para ordenamiento |
| activo | BIT | NN | 1 | - | - | Estado de la prioridad: 1 disponible para clasificar solicitudes, 0 fuera de uso. |

---

## Tabla: solicitud

**DescripciÃ³n:** Entidad principal de negocio. Almacena todas las solicitudes (tickets) del sistema con trazabilidad completa.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| folio | VARCHAR(40) | NN | - | UK | - | Folio Ãºnico de negocio |
| titulo | VARCHAR(200) | NN | - | - | - | TÃ­tulo breve de la solicitud |
| descripcion | VARCHAR(MAX) | NN | - | - | - | Explicacion amplia del contexto, alcance y contenido del registro para evitar ambiguedades. |
| area_solicitante_id | INT | NN | - | FK | area.area_id | Ãrea que solicita |
| sistema_id | INT | N | - | FK | sistema.sistema_id | Sistema impactado |
| tipo_solicitud_id | INT | NN | - | FK | tipo_solicitud.tipo_solicitud_id | Tipo de solicitud |
| prioridad_solicitud_id | INT | NN | - | FK | prioridad_solicitud.prioridad_solicitud_id | Prioridad |
| estado_solicitud_id | INT | NN | - | FK | estado_solicitud.estado_solicitud_id | Estado actual |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. |
| fecha_solicitud | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el registro se dio de alta por primera vez. |
| fecha_compromiso | DATETIME2 | N | - | - | - | Fecha SLA comprometida |
| fecha_resolucion | DATETIME2 | N | - | - | - | Fecha y hora en que se concluye oficialmente la tarea o proceso. |
| esfuerzo_horas | DECIMAL(10,2) | N | - | - | - | Horas invertidas |
| activo | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. |

---

## Tabla: solicitud_desarrollador

**DescripciÃ³n:** RelaciÃ³n N:M entre solicitudes y desarrolladores. Asigna tÃ©cnicos responsables de cada solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_desarrollador_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario tecnico que participa en el desarrollo o mantenimiento del sistema. |
| tipo_participacion | VARCHAR(20) | NN | - | - | - | Rol operativo de la persona en la actividad: RESPONSABLE cuando lidera y PARTICIPANTE cuando colabora. |
| activo | BIT | NN | 1 | - | - | Vigencia de la asignacion tecnica: 1 activa, 0 inactiva o cerrada. |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora exacta en que se realizo la asignacion en el sistema. |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que finaliza formalmente la asignacion o relacion; puede quedar vacia si sigue vigente. |

**Restricciones:** UK (solicitud_id, usuario_id)

---

## Tabla: solicitud_historial_estado

**DescripciÃ³n:** BitÃ¡cora de cambios de estado. Registra el historial completo de transiciones de estado de cada solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_historial_estado_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. |
| estado_anterior_id | INT | N | - | FK | estado_solicitud.estado_solicitud_id | Estado previo |
| estado_nuevo_id | INT | NN | - | FK | estado_solicitud.estado_solicitud_id | Nuevo estado |
| comentario | VARCHAR(800) | N | - | - | - | ObservaciÃ³n del cambio |
| cambiado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que realiza cambio |
| fecha_cambio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del cambio |

---

## Tabla: solicitud_aprobacion

**DescripciÃ³n:** Aprobaciones y evaluaciones. Registra las decisiones de aprobaciÃ³n, rechazo o solicitud de informaciÃ³n.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_aprobacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. |
| aprobado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que aprueba |
| estatus_aprobacion | VARCHAR(20) | NN | - | - | - | APROBADA, RECHAZADA, REQUIERE_INFO |
| motivo | VARCHAR(1000) | N | - | - | - | Motivo de la decisiÃ³n |
| fecha_aprobacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de evaluaciÃ³n |

---

## Tabla: solicitud_comentario

**DescripciÃ³n:** Comentarios y anotaciones. Almacena comentarios de usuarios en solicitudes para seguimiento.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_comentario_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. |
| autor_usuario_id | INT | NN | - | FK | usuario.usuario_id | Autor del comentario |
| comentario | VARCHAR(2000) | NN | - | - | - | Texto del comentario |
| es_interno | BIT | NN | 0 | - | - | Visibilidad del comentario: 1 solo interno para equipo autorizado, 0 visible en flujo general. |
| fecha_comentario | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del comentario |

---

## Tabla: solicitud_adjunto

**DescripciÃ³n:** Evidencias y archivos. Almacena archivos adjuntos que soportan solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_adjunto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. |
| nombre_archivo | VARCHAR(255) | NN | - | - | - | Nombre original del archivo |
| ruta_archivo | VARCHAR(500) | NN | - | - | - | Ubicacion logica o fisica donde se guarda el archivo dentro de la infraestructura de almacenamiento. |
| tipo_mime | VARCHAR(120) | N | - | - | - | Tipo MIME del archivo |
| tamanio_bytes | BIGINT | N | - | - | - | Tamano exacto del archivo medido en bytes para control de almacenamiento y validaciones. |
| subido_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que sube el archivo |
| fecha_subida | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el archivo fue subido y registrado en el sistema. |

---

## Tabla: notificacion

**DescripciÃ³n:** Notificaciones de usuarios. Almacena avisos y alertas enviadas a usuarios del sistema.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| notificacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario receptor |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. |
| titulo | VARCHAR(180) | NN | - | - | - | TÃ­tulo del aviso |
| mensaje | VARCHAR(1000) | NN | - | - | - | Contenido del mensaje |
| leida | BIT | NN | 0 | - | - | Lectura de notificacion: 1 ya leida por el usuario, 0 pendiente de lectura. |
| fecha_creacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el registro se dio de alta por primera vez. |
| fecha_lectura | DATETIME2 | N | - | - | - | Fecha y hora en la que el usuario abrio y marco la notificacion como leida. |

---

## Tabla: usuario_credencial

**DescripciÃ³n:** Seguridad y autenticaciÃ³n. Almacena credenciales y datos de acceso del usuario.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| usuario_id | INT | NN | - | PK/FK | usuario.usuario_id | Identificador del usuario |
| login_usuario | VARCHAR(80) | NN | - | UK | - | Nombre de login Ãºnico |
| password_hash | VARBINARY(512) | NN | - | - | - | Hash de la contraseÃ±a |
| password_salt | VARBINARY(128) | NN | - | - | - | Salt para hash |
| algoritmo_hash | VARCHAR(30) | NN | PBKDF2 | - | - | Algoritmo de cifrado |
| iteraciones | INT | NN | 100000 | - | - | Iteraciones de hash |
| ultimo_acceso | DATETIME2 | N | - | - | - | Fecha y hora del acceso exitoso mas reciente del usuario. |
| intentos_fallidos | SMALLINT | NN | 0 | - | - | Contador de intentos |
| bloqueado_hasta | DATETIME2 | N | - | - | - | Fecha de desbloqueo |
| requiere_cambio_password | BIT | NN | 0 | - | - | Requiere cambio obligatorio |
| fecha_actualizacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora del ultimo cambio aplicado a este registro de credenciales. |

---

## Tabla: menu_opcion

**DescripciÃ³n:** MenÃº de navegaciÃ³n. Define opciones y rutas del sistema con jerarquÃ­a.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| menu_opcion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(60) | NN | - | UK | - | Clave Ãºnica de la opciÃ³n |
| nombre | VARCHAR(120) | NN | - | - | - | Nombre visible en menÃº |
| ruta | VARCHAR(220) | NN | - | - | - | Ruta de navegaciÃ³n |
| icono | VARCHAR(80) | N | - | - | - | Nombre del icono UI |
| orden | INT | NN | - | - | - | PosiciÃ³n en el menÃº |
| activa | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. |
| menu_padre_id | INT | N | - | FK | menu_opcion.menu_opcion_id | MenÃº superior (jerarquÃ­a) |

---

## Tabla: rol_menu_opcion

**DescripciÃ³n:** Permisos de menÃº por rol. Define quÃ© opciones puede ver y usar cada rol.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| rol_menu_opcion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| rol_id | INT | NN | - | FK | rol.rol_id | Llave foranea al rol de seguridad que define permisos y alcances. |
| menu_opcion_id | INT | NN | - | FK | menu_opcion.menu_opcion_id | Referencia a la opciÃ³n |
| puede_ver | BIT | NN | 1 | - | - | Permiso de visualizaciÃ³n |
| puede_editar | BIT | NN | 0 | - | - | Permiso de ediciÃ³n |
| puede_aprobar | BIT | NN | 0 | - | - | Permiso de aprobaciÃ³n |

**Restricciones:** UK (rol_id, menu_opcion_id)

---

## Tabla: tipo_modificacion

**DescripciÃ³n:** Tipos de modificaciÃ³n. Clasifica las modificaciones en adaptativas, evolutivas o correctivas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tipo_modificacion_id | INT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(30) | NN | - | UK | - | Clasificacion del cambio: ADAPTATIVA por ajuste al entorno, EVOLUTIVA por mejora funcional, CORRECTIVA por correccion de fallas. |
| nombre | VARCHAR(80) | NN | - | - | - | Nombre del tipo |
| activo | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operacion. |

---

## Tabla: solicitud_modificacion

**DescripciÃ³n:** Detalles de modificaciÃ³n. Almacena informaciÃ³n especÃ­fica de solicitudes de modificaciÃ³n de sistemas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_modificacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | UK/FK | solicitud.solicitud_id | Llave foranea que enlaza este registro con la solicitud origen del proceso. |
| tipo_modificacion_id | INT | NN | - | FK | tipo_modificacion.tipo_modificacion_id | Tipo de modificaciÃ³n |
| sistema_version_actual | VARCHAR(80) | N | - | - | - | VersiÃ³n actual del sistema |
| modulo_afectado | VARCHAR(200) | N | - | - | - | MÃ³dulo que se modifica |
| impacto_tecnico | VARCHAR(1500) | N | - | - | - | Impacto tÃ©cnico esperado |
| justificacion | VARCHAR(2000) | N | - | - | - | JustificaciÃ³n del cambio |
| fecha_registro | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que se capturo este registro especifico en la base de datos. |

---

## Tabla: solicitud_requerimiento_tecnico

**DescripciÃ³n:** Especificaciones tÃ©cnicas. Detalla requerimientos tÃ©cnicos despuÃ©s de aprobaciÃ³n de solicitud.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| solicitud_requerimiento_tecnico_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | UK/FK | solicitud.solicitud_id | Llave foranea que enlaza este registro con la solicitud origen del proceso. |
| arquitectura_propuesta | VARCHAR(2000) | N | - | - | - | Arquitectura de soluciÃ³n |
| alcance_tecnico | VARCHAR(2000) | N | - | - | - | Alcance del desarrollo |
| dependencias | VARCHAR(2000) | N | - | - | - | Dependencias tÃ©cnicas |
| criterios_aceptacion | VARCHAR(2000) | N | - | - | - | Criterios de validaciÃ³n |
| riesgos | VARCHAR(2000) | N | - | - | - | Riesgos identificados |
| plan_pruebas | VARCHAR(2000) | N | - | - | - | Plan de pruebas |
| observaciones | VARCHAR(2000) | N | - | - | - | Observaciones adicionales |
| elaborado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario autor |
| fecha_elaboracion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha de elaboraciÃ³n |

---

## Tabla: tarea_desarrollo

**DescripciÃ³n:** Tareas operativas. Descompone solicitudes en tareas concretas de desarrollo.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tarea_desarrollo_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que enlaza este registro con la solicitud origen del proceso. |
| titulo | VARCHAR(220) | NN | - | - | - | TÃ­tulo de la tarea |
| descripcion | VARCHAR(2000) | N | - | - | - | Explicacion amplia del contexto, alcance y contenido del registro para evitar ambiguedades. |
| prioridad_solicitud_id | INT | NN | - | FK | prioridad_solicitud.prioridad_solicitud_id | Nivel de prioridad |
| estado_tarea | VARCHAR(30) | NN | - | - | - | Estado de tarea: PENDIENTE sin iniciar, EN_DESARROLLO en trabajo, COMPLETADA finalizada, BLOQUEADA detenida por impedimento. |
| fecha_inicio | DATETIME2 | N | - | - | - | Fecha y hora en que comienza la actividad, relacion o periodo registrado. |
| fecha_compromiso | DATETIME2 | N | - | - | - | Fecha comprometida |
| fecha_cierre | DATETIME2 | N | - | - | - | Fecha y hora en que se concluye oficialmente la tarea o proceso. |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. |
| activo | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. |

---

## Tabla: tarea_desarrollo_asignacion

**DescripciÃ³n:** Asignaciones de tarea. Vincula usuarios a tareas con roles especÃ­ficos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| tarea_desarrollo_asignacion_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| tarea_desarrollo_id | BIGINT | NN | - | FK | tarea_desarrollo.tarea_desarrollo_id | Referencia a tarea |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario relacionado con este registro. |
| rol_tecnico | VARCHAR(30) | NN | - | - | - | Rol operativo de la persona en la actividad: RESPONSABLE cuando lidera y PARTICIPANTE cuando colabora. |
| activa | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. |
| fecha_asignacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora exacta en que se realizo la asignacion en el sistema. |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que finaliza formalmente la asignacion o relacion; puede quedar vacia si sigue vigente. |

**Restricciones:** UK (tarea_desarrollo_id, usuario_id)

---

## Tabla: actividad_reciente

**DescripciÃ³n:** BitÃ¡cora de actividades. Registra eventos recientes para paneles de seguimiento.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| actividad_reciente_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. |
| tarea_desarrollo_id | BIGINT | N | - | FK | tarea_desarrollo.tarea_desarrollo_id | Tarea asociada |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario actor |
| tipo_actividad | VARCHAR(40) | NN | - | - | - | Clasificacion del evento realizado (por ejemplo cambio, comentario, avance o alerta). |
| titulo | VARCHAR(220) | NN | - | - | - | TÃ­tulo corto |
| detalle | VARCHAR(2000) | N | - | - | - | Descripcion ampliada de lo sucedido, incluyendo contexto y resultado del movimiento. |
| fecha_actividad | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha del evento |
| visible_para_pm | BIT | NN | 1 | - | - | Bandera de visibilidad para Usuario responsable de coordinar, priorizar y dar seguimiento al proyecto.: 1 se muestra, 0 se oculta. |
| visible_para_desarrollador | BIT | NN | 1 | - | - | Bandera de visibilidad para desarrolladores: 1 se muestra, 0 se oculta. |

---

## Tabla: proyecto

**DescripciÃ³n:** GestiÃ³n de proyectos. Agrupa solicitudes, equipo y planificaciÃ³n en iniciativas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| clave | VARCHAR(40) | NN | - | UK | - | Clave Ãºnica del proyecto |
| nombre | VARCHAR(200) | NN | - | - | - | Nombre oficial con el que se identifica la iniciativa en reportes y seguimiento. |
| descripcion | VARCHAR(1500) | N | - | - | - | DescripciÃ³n de objetivos |
| estado_proyecto | VARCHAR(30) | NN | - | - | - | Estado del proyecto: PLANEADO sin iniciar, EN_EJECUCION en curso, PAUSADO temporalmente detenido, CERRADO finalizado. |
| fecha_inicio | DATE | N | - | - | - | Fecha y hora en que comienza la actividad, relacion o periodo registrado. |
| fecha_fin_planeada | DATE | N | - | - | - | Fecha fin planeada |
| fecha_fin_real | DATE | N | - | - | - | Fecha fin real |
| pm_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario responsable de coordinar, priorizar y dar seguimiento al proyecto. |
| activo | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operacion. |

---

## Tabla: proyecto_solicitud

**DescripciÃ³n:** RelaciÃ³n N:M entre proyectos y solicitudes. Vincula solicitudes con iniciativas.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_solicitud_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Llave foranea que vincula este registro con el proyecto al que pertenece. |
| solicitud_id | BIGINT | NN | - | FK | solicitud.solicitud_id | Llave foranea que enlaza este registro con la solicitud origen del proceso. |
| fecha_vinculacion | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que se establecio formalmente la relacion entre proyecto y solicitud. |

**Restricciones:** UK (proyecto_id, solicitud_id)

---

## Tabla: proyecto_miembro

**DescripciÃ³n:** Miembros de proyecto. Asigna usuarios a proyectos con roles operativos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| proyecto_miembro_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Llave foranea que vincula este registro con el proyecto al que pertenece. |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Llave foranea al usuario relacionado con este registro. |
| rol_en_proyecto | VARCHAR(40) | NN | - | - | - | PM, DESARROLLADOR, ANALISTA, TESTER, LIDER_TECNICO |
| carga_estimada_pct | DECIMAL(5,2) | N | - | - | - | DedicaciÃ³n estimada (%) |
| activo | BIT | NN | 1 | - | - | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operacion. |
| fecha_inicio | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que comienza la actividad, relacion o periodo registrado. |
| fecha_fin | DATETIME2 | N | - | - | - | Fecha y hora en que finaliza formalmente la asignacion o relacion; puede quedar vacia si sigue vigente. |

**Restricciones:** UK (proyecto_id, usuario_id)

---

## Tabla: documento_proyecto

**DescripciÃ³n:** Documentos de proyecto. Almacena archivos asociados a proyectos y solicitudes.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| documento_proyecto_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| proyecto_id | BIGINT | NN | - | FK | proyecto.proyecto_id | Llave foranea que vincula este registro con el proyecto al que pertenece. |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. (opcional) |
| nombre_documento | VARCHAR(255) | NN | - | - | - | Nombre visible |
| tipo_documento | VARCHAR(50) | NN | - | - | - | ERS, DISENO, MANUAL, MINUTA, OTRO |
| version_documento | VARCHAR(40) | N | - | - | - | VersiÃ³n del documento |
| ruta_archivo | VARCHAR(600) | NN | - | - | - | Ubicacion logica o fisica donde se guarda el archivo dentro de la infraestructura de almacenamiento. |
| tamanio_bytes | BIGINT | N | - | - | - | Tamano exacto del archivo medido en bytes para control de almacenamiento y validaciones. |
| subido_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que sube |
| fecha_subida | DATETIME2 | NN | SYSDATETIME() | - | - | Fecha y hora en que el archivo fue subido y registrado en el sistema. |
| visible_para_participantes | BIT | NN | 1 | - | - | Visible para participantes |

---

## Tabla: evento_calendario

**DescripciÃ³n:** Eventos de calendario. Registra reuniones, entregas, revisiones y actividades.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| evento_calendario_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| proyecto_id | BIGINT | N | - | FK | proyecto.proyecto_id | Proyecto al que se vincula este evento para su seguimiento en planeacion y ejecucion. |
| solicitud_id | BIGINT | N | - | FK | solicitud.solicitud_id | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. |
| titulo | VARCHAR(220) | NN | - | - | - | TÃ­tulo del evento |
| descripcion | VARCHAR(2000) | N | - | - | - | DescripciÃ³n |
| tipo_evento | VARCHAR(40) | NN | - | - | - | REUNION, ENTREGA, REVISION, DESPLIEGUE, ACTIVIDAD |
| fecha_inicio | DATETIME2 | NN | - | - | - | Momento exacto en que inicia el evento o actividad calendarizada. |
| fecha_fin | DATETIME2 | N | - | - | - | Momento exacto en que finaliza el evento o actividad calendarizada. |
| creado_por_usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. |
| es_todo_dia | BIT | NN | 0 | - | - | Tipo de agenda del evento: 1 cubre el dia completo, 0 tiene hora de inicio y fin. |

---

## Tabla: evento_participante

**DescripciÃ³n:** Participantes de evento. Registra asistentes y su estado de confirmaciÃ³n en eventos.

| Columna | Tipo | Null | Default | Llave | Relacion | Descripcion |
| --- | --- | --- | --- | --- | --- | --- |
| evento_participante_id | BIGINT IDENTITY(1,1) | NN | IDENTITY | PK | - | Clave numerica autogenerada que identifica este registro de forma unica, no se captura manualmente y no puede repetirse.|
| evento_calendario_id | BIGINT | NN | - | FK | evento_calendario.evento_calendario_id | Llave foranea que conecta este registro con el evento de calendario correspondiente. |
| usuario_id | INT | NN | - | FK | usuario.usuario_id | Usuario invitado o incluido en el evento, con registro de su respuesta de asistencia. |
| asistencia | VARCHAR(20) | NN | PENDIENTE | - | - | Estado de asistencia del invitado: PENDIENTE aun sin respuesta, CONFIRMADA asistencia aceptada, RECHAZADA asistencia declinada. |

**Restricciones:** UK (evento_calendario_id, usuario_id)

---

## Resumen de Relaciones (4NF)

### 1. Seguridad y AutenticaciÃ³n
- `usuario` 1:1 `usuario_credencial`
- `usuario` N:M `rol` (mediante `usuario_rol`)
- `rol` N:M `menu_opcion` (mediante `rol_menu_opcion`)

### 2. Estructura Organizacional
- `area` 1:N `area` (jerarquÃ­a padre-hijo)
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

### 6. GestiÃ³n de Proyectos
- `proyecto` N:M `solicitud` (mediante `proyecto_solicitud`)
- `proyecto` N:M `usuario` (mediante `proyecto_miembro`)
- `proyecto` 1:N `documento_proyecto`
- `proyecto` 1:N `evento_calendario`
- `evento_calendario` N:M `usuario` (mediante `evento_participante`)

---

## Notas de NormalizaciÃ³n

âœ“ **Todos los datos son atÃ³micos:** Sin campos compuestos ni repetitivos
âœ“ **Cumplimiento 1NF:** Cada atributo contiene un solo valor
âœ“ **Cumplimiento 2NF:** Todas las columnas no clave dependen completamente de la clave primaria
âœ“ **Cumplimiento 3NF:** Sin dependencias transitivas; solo atributos que describen directamente la entidad
âœ“ **Cumplimiento 4NF:** Sin dependencias multivaluadas no funcionales; relaciones N:M separadas en tablas de uniÃ³n



