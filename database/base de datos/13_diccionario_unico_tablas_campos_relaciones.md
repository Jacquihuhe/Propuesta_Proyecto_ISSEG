# Diccionario tecnico de tablas SGSPCSI

Este documento muestra cada tabla con sus atributos y metadata tecnica:

- tipo
- nulabilidad
- valor por default
- llave
- relacion
- descripcion

## Convenciones

- PK: llave primaria.
- FK: llave foranea.
- UK: unico.
- NN: NOT NULL.
- N: NULL permitido.

## Tabla: rol

Descripcion: catalogo de roles de seguridad del sistema.

| Columna        | Tipo              | Null | Default       | Llave | Relacion | Descripcion                               |
| -------------- | ----------------- | ---- | ------------- | ----- | -------- | ----------------------------------------- |
| rol_id         | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -        | Identificador del rol                     |
| clave          | VARCHAR(30)       | NN   | -             | UK    | -        | Clave corta del rol (PM, ENCARGADO, etc.) |
| nombre         | VARCHAR(100)      | NN   | -             | -     | -        | Nombre visible del rol                    |
| descripcion    | VARCHAR(255)      | N    | -             | -     | -        | Descripcion funcional del rol             |
| activo         | BIT               | NN   | 1             | -     | -        | Estado de vigencia del rol                |
| fecha_creacion | DATETIME2         | NN   | SYSDATETIME() | -     | -        | Fecha de alta                             |

## Tabla: usuario

Descripcion: usuarios del sistema.

| Columna              | Tipo              | Null | Default       | Llave | Relacion | Descripcion                |
| -------------------- | ----------------- | ---- | ------------- | ----- | -------- | -------------------------- |
| usuario_id           | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -        | Identificador del usuario  |
| nombre               | VARCHAR(120)      | NN   | -             | -     | -        | Nombre completo            |
| correo_institucional | VARCHAR(180)      | NN   | -             | UK    | -        | Correo institucional unico |
| puesto               | VARCHAR(120)      | N    | -             | -     | -        | Puesto/cargo               |
| activo               | BIT               | NN   | 1             | -     | -        | Vigencia del usuario       |
| fecha_creacion       | DATETIME2         | NN   | SYSDATETIME() | -     | -        | Fecha de alta              |

## Tabla: usuario_rol

Descripcion: asignacion de roles a usuarios.

| Columna          | Tipo              | Null | Default       | Llave | Relacion           | Descripcion           |
| ---------------- | ----------------- | ---- | ------------- | ----- | ------------------ | --------------------- |
| usuario_rol_id   | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                  | Identificador tecnico |
| usuario_id       | INT               | NN   | -             | FK    | usuario.usuario_id | Usuario asignado      |
| rol_id           | INT               | NN   | -             | FK    | rol.rol_id         | Rol asignado          |
| activo           | BIT               | NN   | 1             | -     | -                  | Asignacion vigente    |
| fecha_asignacion | DATETIME2         | NN   | SYSDATETIME() | -     | -                  | Fecha de inicio       |
| fecha_fin        | DATETIME2         | N    | -             | -     | -                  | Fecha de termino      |

Restricciones: UK (usuario_id, rol_id).

## Tabla: area

Descripcion: catalogo jerarquico de direcciones, coordinaciones y departamentos.

| Columna        | Tipo              | Null | Default       | Llave | Relacion     | Descripcion                                 |
| -------------- | ----------------- | ---- | ------------- | ----- | ------------ | ------------------------------------------- |
| area_id        | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -            | Identificador del area                      |
| area_padre_id  | INT               | N    | -             | FK    | area.area_id | Relacion jerarquica padre-hijo              |
| clave          | VARCHAR(50)       | N    | -             | -     | -            | Clave operativa del area                    |
| nombre         | VARCHAR(220)      | NN   | -             | UK    | -            | Nombre oficial del area                     |
| tipo_area      | VARCHAR(30)       | NN   | -             | -     | -            | DIRECCION, COORDINACION, DEPARTAMENTO, OTRA |
| nivel          | TINYINT           | NN   | -             | -     | -            | Nivel jerarquico                            |
| activa         | BIT               | NN   | 1             | -     | -            | Vigencia del area                           |
| fecha_creacion | DATETIME2         | NN   | SYSDATETIME() | -     | -            | Fecha de alta                               |

Checks: nivel >= 1, tipo_area en catalogo permitido.

## Tabla: usuario_area

Descripcion: adscripcion de usuario a una sola area activa.

| Columna         | Tipo              | Null | Default       | Llave | Relacion           | Descripcion           |
| --------------- | ----------------- | ---- | ------------- | ----- | ------------------ | --------------------- |
| usuario_area_id | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                  | Identificador tecnico |
| usuario_id      | INT               | NN   | -             | FK    | usuario.usuario_id | Usuario adscrito      |
| area_id         | INT               | NN   | -             | FK    | area.area_id       | Area asignada         |
| es_titular      | BIT               | NN   | 0             | -     | -                  | Marca de titularidad  |
| activo          | BIT               | NN   | 1             | -     | -                  | Adscripcion vigente   |
| fecha_inicio    | DATETIME2         | NN   | SYSDATETIME() | -     | -                  | Inicio de adscripcion |
| fecha_fin       | DATETIME2         | N    | -             | -     | -                  | Fin de adscripcion    |

Indice: UX_usuario_area_adscripcion_activa sobre usuario_id con filtro activo=1 y fecha_fin NULL.

## Tabla: sistema

Descripcion: catalogo de sistemas institucionales.

| Columna        | Tipo              | Null | Default       | Llave | Relacion | Descripcion               |
| -------------- | ----------------- | ---- | ------------- | ----- | -------- | ------------------------- |
| sistema_id     | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -        | Identificador del sistema |
| clave          | VARCHAR(50)       | NN   | -             | UK    | -        | Clave unica del sistema   |
| nombre         | VARCHAR(200)      | NN   | -             | -     | -        | Nombre funcional          |
| descripcion    | VARCHAR(500)      | N    | -             | -     | -        | Descripcion del sistema   |
| activo         | BIT               | NN   | 1             | -     | -        | Vigencia del sistema      |
| fecha_creacion | DATETIME2         | NN   | SYSDATETIME() | -     | -        | Fecha de alta             |

## Tabla: area_sistema

Descripcion: relacion entre areas y sistemas visibles para cada area.

| Columna         | Tipo              | Null | Default       | Llave | Relacion           | Descripcion              |
| --------------- | ----------------- | ---- | ------------- | ----- | ------------------ | ------------------------ |
| area_sistema_id | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                  | Identificador tecnico    |
| area_id         | INT               | NN   | -             | FK    | area.area_id       | Area consumidora         |
| sistema_id      | INT               | NN   | -             | FK    | sistema.sistema_id | Sistema asignado al area |
| activo          | BIT               | NN   | 1             | -     | -                  | Relacion vigente         |
| fecha_alta      | DATETIME2         | NN   | SYSDATETIME() | -     | -                  | Fecha de registro        |

Restricciones: UK (area_id, sistema_id).

## Tabla: sistema_desarrollador

Descripcion: participacion de desarrolladores por sistema.

| Columna                  | Tipo              | Null | Default       | Llave | Relacion           | Descripcion                |
| ------------------------ | ----------------- | ---- | ------------- | ----- | ------------------ | -------------------------- |
| sistema_desarrollador_id | INT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                  | Identificador tecnico      |
| sistema_id               | INT               | NN   | -             | FK    | sistema.sistema_id | Sistema asignado           |
| usuario_id               | INT               | NN   | -             | FK    | usuario.usuario_id | Desarrollador              |
| tipo_participacion       | VARCHAR(20)       | NN   | -             | -     | -                  | RESPONSABLE o PARTICIPANTE |
| activo                   | BIT               | NN   | 1             | -     | -                  | Asignacion vigente         |
| fecha_inicio             | DATETIME2         | NN   | SYSDATETIME() | -     | -                  | Inicio de participacion    |
| fecha_fin                | DATETIME2         | N    | -             | -     | -                  | Fin de participacion       |

Checks: tipo_participacion en (RESPONSABLE, PARTICIPANTE).  Restriccion: UK (sistema_id, usuario_id).

## Tabla: tipo_solicitud

Descripcion: catalogo de tipo de solicitud.

| Columna           | Tipo              | Null | Default  | Llave | Relacion | Descripcion            |
| ----------------- | ----------------- | ---- | -------- | ----- | -------- | ---------------------- |
| tipo_solicitud_id | INT IDENTITY(1,1) | NN   | IDENTITY | PK    | -        | Identificador del tipo |
| clave             | VARCHAR(30)       | NN   | -        | UK    | -        | Clave del tipo         |
| nombre            | VARCHAR(100)      | NN   | -        | -     | -        | Nombre del tipo        |
| activo            | BIT               | NN   | 1        | -     | -        | Vigencia del tipo      |

## Tabla: estado_solicitud

Descripcion: estados del ciclo de vida de la solicitud.

| Columna             | Tipo              | Null | Default  | Llave | Relacion | Descripcion              |
| ------------------- | ----------------- | ---- | -------- | ----- | -------- | ------------------------ |
| estado_solicitud_id | INT IDENTITY(1,1) | NN   | IDENTITY | PK    | -        | Identificador del estado |
| clave               | VARCHAR(30)       | NN   | -        | UK    | -        | Clave del estado         |
| nombre              | VARCHAR(100)      | NN   | -        | -     | -        | Nombre del estado        |
| es_terminal         | BIT               | NN   | 0        | -     | -        | Marca si es estado final |
| activo              | BIT               | NN   | 1        | -     | -        | Vigencia del estado      |

## Tabla: prioridad_solicitud

Descripcion: prioridades operativas de solicitud.

| Columna                | Tipo              | Null | Default  | Llave | Relacion | Descripcion                |
| ---------------------- | ----------------- | ---- | -------- | ----- | -------- | -------------------------- |
| prioridad_solicitud_id | INT IDENTITY(1,1) | NN   | IDENTITY | PK    | -        | Identificador de prioridad |
| clave                  | VARCHAR(20)       | NN   | -        | UK    | -        | BAJA, MEDIA, ALTA, CRITICA |
| nombre                 | VARCHAR(50)       | NN   | -        | -     | -        | Nombre de prioridad        |
| peso                   | TINYINT           | NN   | -        | -     | -        | Peso para ordenamiento     |
| activo                 | BIT               | NN   | 1        | -     | -        | Vigencia                   |

## Tabla: solicitud

Descripcion: entidad principal de negocio para tickets/solicitudes.

| Columna                | Tipo                 | Null | Default       | Llave | Relacion                                   | Descripcion                   |
| ---------------------- | -------------------- | ---- | ------------- | ----- | ------------------------------------------ | ----------------------------- |
| solicitud_id           | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                                          | Identificador de la solicitud |
| folio                  | VARCHAR(40)          | NN   | -             | UK    | -                                          | Folio unico de negocio        |
| titulo                 | VARCHAR(200)         | NN   | -             | -     | -                                          | Titulo breve                  |
| descripcion            | VARCHAR(MAX)         | NN   | -             | -     | -                                          | Descripcion detallada         |
| area_solicitante_id    | INT                  | NN   | -             | FK    | area.area_id                               | Area que solicita             |
| sistema_id             | INT                  | N    | -             | FK    | sistema.sistema_id                         | Sistema afectado (si aplica)  |
| tipo_solicitud_id      | INT                  | NN   | -             | FK    | tipo_solicitud.tipo_solicitud_id           | Tipo de solicitud             |
| prioridad_solicitud_id | INT                  | NN   | -             | FK    | prioridad_solicitud.prioridad_solicitud_id | Prioridad                     |
| estado_solicitud_id    | INT                  | NN   | -             | FK    | estado_solicitud.estado_solicitud_id       | Estado actual                 |
| creado_por_usuario_id  | INT                  | NN   | -             | FK    | usuario.usuario_id                         | Usuario creador               |
| fecha_solicitud        | DATETIME2            | NN   | SYSDATETIME() | -     | -                                          | Fecha de registro             |
| fecha_compromiso       | DATETIME2            | N    | -             | -     | -                                          | Fecha compromiso SLA          |
| fecha_resolucion       | DATETIME2            | N    | -             | -     | -                                          | Fecha de cierre               |
| esfuerzo_horas         | DECIMAL(10,2)        | N    | -             | -     | -                                          | Horas invertidas              |
| activo                 | BIT                  | NN   | 1             | -     | -                                          | Vigencia logica               |

## Tabla: solicitud_desarrollador

Descripcion: relacion de participantes tecnicos por solicitud.

| Columna                    | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                |
| -------------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | -------------------------- |
| solicitud_desarrollador_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico      |
| solicitud_id               | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id | Solicitud asignada         |
| usuario_id                 | INT                  | NN   | -             | FK    | usuario.usuario_id     | Desarrollador              |
| tipo_participacion         | VARCHAR(20)          | NN   | -             | -     | -                      | RESPONSABLE o PARTICIPANTE |
| activo                     | BIT                  | NN   | 1             | -     | -                      | Asignacion vigente         |
| fecha_asignacion           | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de asignacion        |
| fecha_fin                  | DATETIME2            | N    | -             | -     | -                      | Fin de asignacion          |

Checks: tipo_participacion en (RESPONSABLE, PARTICIPANTE).  Restriccion: UK (solicitud_id, usuario_id).

## Tabla: solicitud_historial_estado

Descripcion: bitacora de cambios de estado de cada solicitud.

| Columna                       | Tipo                 | Null | Default       | Llave | Relacion                             | Descripcion                   |
| ----------------------------- | -------------------- | ---- | ------------- | ----- | ------------------------------------ | ----------------------------- |
| solicitud_historial_estado_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                                    | Identificador tecnico         |
| solicitud_id                  | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id               | Solicitud afectada            |
| estado_anterior_id            | INT                  | N    | -             | FK    | estado_solicitud.estado_solicitud_id | Estado previo                 |
| estado_nuevo_id               | INT                  | NN   | -             | FK    | estado_solicitud.estado_solicitud_id | Nuevo estado                  |
| comentario                    | VARCHAR(800)         | N    | -             | -     | -                                    | Observacion del cambio        |
| cambiado_por_usuario_id       | INT                  | NN   | -             | FK    | usuario.usuario_id                   | Usuario que realizo el cambio |
| fecha_cambio                  | DATETIME2            | NN   | SYSDATETIME() | -     | -                                    | Fecha del cambio              |

## Tabla: solicitud_aprobacion

Descripcion: resolucion de aprobacion/rechazo/requiere informacion.

| Columna                 | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                        |
| ----------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | ---------------------------------- |
| solicitud_aprobacion_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico              |
| solicitud_id            | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id | Solicitud evaluada                 |
| aprobado_por_usuario_id | INT                  | NN   | -             | FK    | usuario.usuario_id     | Revisor que decide                 |
| estatus_aprobacion      | VARCHAR(20)          | NN   | -             | -     | -                      | APROBADA, RECHAZADA, REQUIERE_INFO |
| motivo                  | VARCHAR(1000)        | N    | -             | -     | -                      | Motivo/comentario de decision      |
| fecha_aprobacion        | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de evaluacion                |

Checks: estatus_aprobacion en (APROBADA, RECHAZADA, REQUIERE_INFO).

## Tabla: solicitud_comentario

Descripcion: comentarios asociados a la solicitud.

| Columna                 | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                   |
| ----------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | ----------------------------- |
| solicitud_comentario_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico         |
| solicitud_id            | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id | Solicitud relacionada         |
| autor_usuario_id        | INT                  | NN   | -             | FK    | usuario.usuario_id     | Autor del comentario          |
| comentario              | VARCHAR(2000)        | NN   | -             | -     | -                      | Texto del comentario          |
| es_interno              | BIT                  | NN   | 0             | -     | -                      | Marca para comentario interno |
| fecha_comentario        | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha del comentario          |

## Tabla: solicitud_adjunto

Descripcion: evidencias y archivos de soporte por solicitud.

| Columna               | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                          |
| --------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | ------------------------------------ |
| solicitud_adjunto_id  | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico                |
| solicitud_id          | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id | Solicitud relacionada                |
| nombre_archivo        | VARCHAR(255)         | NN   | -             | -     | -                      | Nombre original del archivo          |
| ruta_archivo          | VARCHAR(500)         | NN   | -             | -     | -                      | Ruta fisica/logica de almacenamiento |
| tipo_mime             | VARCHAR(120)         | N    | -             | -     | -                      | Tipo MIME                            |
| tamanio_bytes         | BIGINT               | N    | -             | -     | -                      | Peso del archivo                     |
| subido_por_usuario_id | INT                  | NN   | -             | FK    | usuario.usuario_id     | Usuario que sube                     |
| fecha_subida          | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de carga                       |

## Tabla: notificacion

Descripcion: notificaciones enviadas a usuarios.

| Columna         | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                   |
| --------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | ----------------------------- |
| notificacion_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico         |
| usuario_id      | INT                  | NN   | -             | FK    | usuario.usuario_id     | Receptor de la notificacion   |
| solicitud_id    | BIGINT               | N    | -             | FK    | solicitud.solicitud_id | Solicitud asociada (opcional) |
| titulo          | VARCHAR(180)         | NN   | -             | -     | -                      | Titulo corto                  |
| mensaje         | VARCHAR(1000)        | NN   | -             | -     | -                      | Contenido de la notificacion  |
| leida           | BIT                  | NN   | 0             | -     | -                      | Bandera de lectura            |
| fecha_creacion  | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de creacion             |
| fecha_lectura   | DATETIME2            | N    | -             | -     | -                      | Fecha de lectura              |

## Resumen de relaciones principales

1. Seguridad

- usuario N:M rol (usuario_rol).
- usuario 1:N usuario_area.

2. Estructura

- area 1:N area (jerarquia por area_padre_id).
- area N:M sistema (area_sistema).

3. Desarrollo

- sistema N:M usuario (sistema_desarrollador).
- solicitud N:M usuario (solicitud_desarrollador).

4. Operacion de solicitudes

- solicitud N:1 area, sistema, tipo_solicitud, prioridad_solicitud, estado_solicitud, usuario creador.
- solicitud 1:N historial_estado, aprobacion, comentario, adjunto, notificacion.

## Notas de visualizacion

- Para ver el modelo grafico usar [base de datos/02_diagrama_entidad_relacion.mmd](base%20de%20datos/02_diagrama_entidad_relacion.mmd).
- Para crear todas las tablas usar [base de datos/01_esquema_bd.sql](base%20de%20datos/01_esquema_bd.sql).
- Para datos iniciales usar [base de datos/03_plantilla_carga_inicial.sql](base%20de%20datos/03_plantilla_carga_inicial.sql).

---

## Seccion adicional: tablas de extension por pantallas

Estas tablas complementan el modelo base para cubrir login avanzado, menus por rol, formularios especializados, operacion de desarrollo, proyectos, documentacion y calendario.

## Tabla: usuario_credencial

Descripcion: credenciales y seguridad de acceso del usuario.

| Columna                  | Tipo           | Null | Default       | Llave | Relacion           | Descripcion                          |
| ------------------------ | -------------- | ---- | ------------- | ----- | ------------------ | ------------------------------------ |
| usuario_id               | INT            | NN   | -             | PK/FK | usuario.usuario_id | Identificador del usuario            |
| login_usuario            | VARCHAR(80)    | NN   | -             | UK    | -                  | Nombre de login unico                |
| password_hash            | VARBINARY(512) | NN   | -             | -     | -                  | Hash de contrasena                   |
| password_salt            | VARBINARY(128) | NN   | -             | -     | -                  | Salt para hash                       |
| algoritmo_hash           | VARCHAR(30)    | NN   | PBKDF2        | -     | -                  | Algoritmo de cifrado                 |
| iteraciones              | INT            | NN   | 100000        | -     | -                  | Iteraciones de hash                  |
| ultimo_acceso            | DATETIME2      | N    | -             | -     | -                  | Ultimo acceso exitoso                |
| intentos_fallidos        | SMALLINT       | NN   | 0             | -     | -                  | Intentos fallidos acumulados         |
| bloqueado_hasta          | DATETIME2      | N    | -             | -     | -                  | Fecha de desbloqueo temporal         |
| requiere_cambio_password | BIT            | NN   | 0             | -     | -                  | Bandera de cambio obligatorio        |
| fecha_actualizacion      | DATETIME2      | NN   | SYSDATETIME() | -     | -                  | Fecha de actualizacion de credencial |

## Tabla: menu_opcion

Descripcion: catalogo de menus y opciones navegables del sistema.

| Columna       | Tipo              | Null | Default | Llave | Relacion                 | Descripcion                     |
| ------------- | ----------------- | ---- | ------- | ----- | ------------------------ | ------------------------------- |
| menu_opcion_id| INT IDENTITY(1,1) | NN   | IDENTITY| PK    | -                        | Identificador de opcion         |
| clave         | VARCHAR(60)       | NN   | -       | UK    | -                        | Clave unica del menu            |
| nombre        | VARCHAR(120)      | NN   | -       | -     | -                        | Nombre visible                  |
| ruta          | VARCHAR(220)      | NN   | -       | -     | -                        | Ruta de navegacion              |
| icono         | VARCHAR(80)       | N    | -       | -     | -                        | Icono UI                        |
| orden         | INT               | NN   | -       | -     | -                        | Orden de despliegue             |
| activa        | BIT               | NN   | 1       | -     | -                        | Vigencia de opcion              |
| menu_padre_id | INT               | N    | -       | FK    | menu_opcion.menu_opcion_id | Relacion jerarquica de menus  |

## Tabla: rol_menu_opcion

Descripcion: permisos de menu por rol.

| Columna           | Tipo              | Null | Default | Llave | Relacion                   | Descripcion                      |
| ----------------- | ----------------- | ---- | ------- | ----- | -------------------------- | -------------------------------- |
| rol_menu_opcion_id| INT IDENTITY(1,1) | NN   | IDENTITY| PK    | -                          | Identificador tecnico            |
| rol_id            | INT               | NN   | -       | FK    | rol.rol_id                 | Rol autorizado                   |
| menu_opcion_id    | INT               | NN   | -       | FK    | menu_opcion.menu_opcion_id | Opcion de menu                   |
| puede_ver         | BIT               | NN   | 1       | -     | -                          | Permiso de visualizacion         |
| puede_editar      | BIT               | NN   | 0       | -     | -                          | Permiso de edicion               |
| puede_aprobar     | BIT               | NN   | 0       | -     | -                          | Permiso de aprobacion            |

Restricciones: UK (rol_id, menu_opcion_id).

## Tabla: tipo_modificacion

Descripcion: catalogo de subtipos de modificacion del sistema.

| Columna             | Tipo              | Null | Default  | Llave | Relacion | Descripcion                    |
| ------------------- | ----------------- | ---- | -------- | ----- | -------- | ------------------------------ |
| tipo_modificacion_id| INT IDENTITY(1,1) | NN   | IDENTITY | PK    | -        | Identificador del subtipo      |
| clave               | VARCHAR(30)       | NN   | -        | UK    | -        | ADAPTATIVA, EVOLUTIVA, CORRECTIVA |
| nombre              | VARCHAR(80)       | NN   | -        | -     | -        | Nombre del subtipo             |
| activa              | BIT               | NN   | 1        | -     | -        | Vigencia                       |

## Tabla: solicitud_modificacion

Descripcion: detalle especializado para solicitudes de modificacion.

| Columna                  | Tipo                 | Null | Default       | Llave | Relacion                          | Descripcion                     |
| ------------------------ | -------------------- | ---- | ------------- | ----- | --------------------------------- | ------------------------------- |
| solicitud_modificacion_id| BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                                 | Identificador tecnico           |
| solicitud_id             | BIGINT               | NN   | -             | UK/FK | solicitud.solicitud_id            | Solicitud base                  |
| tipo_modificacion_id     | INT                  | NN   | -             | FK    | tipo_modificacion.tipo_modificacion_id | Subtipo de modificacion   |
| sistema_version_actual   | VARCHAR(80)          | N    | -             | -     | -                                 | Version actual                  |
| modulo_afectado          | VARCHAR(200)         | N    | -             | -     | -                                 | Modulo afectado                 |
| impacto_tecnico          | VARCHAR(1500)        | N    | -             | -     | -                                 | Impacto tecnico esperado        |
| justificacion            | VARCHAR(2000)        | N    | -             | -     | -                                 | Justificacion funcional         |
| fecha_registro           | DATETIME2            | NN   | SYSDATETIME() | -     | -                                 | Fecha de registro               |

## Tabla: solicitud_requerimiento_tecnico

Descripcion: especificacion tecnica detallada posterior a aprobacion.

| Columna                             | Tipo                 | Null | Default       | Llave | Relacion                | Descripcion                       |
| ----------------------------------- | -------------------- | ---- | ------------- | ----- | ----------------------- | --------------------------------- |
| solicitud_requerimiento_tecnico_id  | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                       | Identificador tecnico             |
| solicitud_id                        | BIGINT               | NN   | -             | UK/FK | solicitud.solicitud_id  | Solicitud base                    |
| arquitectura_propuesta              | VARCHAR(2000)        | N    | -             | -     | -                       | Arquitectura propuesta            |
| alcance_tecnico                     | VARCHAR(2000)        | N    | -             | -     | -                       | Alcance tecnico                   |
| dependencias                        | VARCHAR(2000)        | N    | -             | -     | -                       | Dependencias tecnicas             |
| criterios_aceptacion                | VARCHAR(2000)        | N    | -             | -     | -                       | Criterios de aceptacion           |
| riesgos                             | VARCHAR(2000)        | N    | -             | -     | -                       | Riesgos identificados             |
| plan_pruebas                        | VARCHAR(2000)        | N    | -             | -     | -                       | Plan de pruebas                   |
| observaciones                       | VARCHAR(2000)        | N    | -             | -     | -                       | Observaciones                     |
| elaborado_por_usuario_id            | INT                  | NN   | -             | FK    | usuario.usuario_id      | Usuario autor                     |
| fecha_elaboracion                   | DATETIME2            | NN   | SYSDATETIME() | -     | -                       | Fecha de elaboracion              |

## Tabla: tarea_desarrollo

Descripcion: tareas operativas derivadas de una solicitud.

| Columna               | Tipo                 | Null | Default       | Llave | Relacion                                   | Descripcion                   |
| --------------------- | -------------------- | ---- | ------------- | ----- | ------------------------------------------ | ----------------------------- |
| tarea_desarrollo_id   | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                                          | Identificador de tarea        |
| solicitud_id          | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id                     | Solicitud origen              |
| titulo                | VARCHAR(220)         | NN   | -             | -     | -                                          | Titulo de tarea               |
| descripcion           | VARCHAR(2000)        | N    | -             | -     | -                                          | Descripcion                   |
| prioridad_solicitud_id| INT                  | NN   | -             | FK    | prioridad_solicitud.prioridad_solicitud_id | Prioridad                     |
| estado_tarea          | VARCHAR(30)          | NN   | -             | -     | -                                          | PENDIENTE, EN_DESARROLLO, COMPLETADA, BLOQUEADA |
| fecha_inicio          | DATETIME2            | N    | -             | -     | -                                          | Fecha de inicio               |
| fecha_compromiso      | DATETIME2            | N    | -             | -     | -                                          | Fecha compromiso              |
| fecha_cierre          | DATETIME2            | N    | -             | -     | -                                          | Fecha de cierre               |
| creado_por_usuario_id | INT                  | NN   | -             | FK    | usuario.usuario_id                         | Usuario creador               |
| activo                | BIT                  | NN   | 1             | -     | -                                          | Vigencia                      |

## Tabla: tarea_desarrollo_asignacion

Descripcion: asignaciones de usuarios a tareas de desarrollo.

| Columna                      | Tipo                 | Null | Default       | Llave | Relacion                          | Descripcion                   |
| ---------------------------- | -------------------- | ---- | ------------- | ----- | --------------------------------- | ----------------------------- |
| tarea_desarrollo_asignacion_id | BIGINT IDENTITY(1,1)| NN   | IDENTITY      | PK    | -                                 | Identificador tecnico         |
| tarea_desarrollo_id          | BIGINT               | NN   | -             | FK    | tarea_desarrollo.tarea_desarrollo_id | Tarea asignada            |
| usuario_id                   | INT                  | NN   | -             | FK    | usuario.usuario_id                | Usuario asignado              |
| rol_tecnico                  | VARCHAR(30)          | NN   | -             | -     | -                                 | RESPONSABLE o PARTICIPANTE    |
| activa                       | BIT                  | NN   | 1             | -     | -                                 | Asignacion vigente            |
| fecha_asignacion             | DATETIME2            | NN   | SYSDATETIME() | -     | -                                 | Fecha de asignacion           |
| fecha_fin                    | DATETIME2            | N    | -             | -     | -                                 | Fecha de termino              |

## Tabla: actividad_reciente

Descripcion: bitacora de actividades recientes para paneles de trabajo.

| Columna                     | Tipo                 | Null | Default       | Llave | Relacion                              | Descripcion                      |
| --------------------------- | -------------------- | ---- | ------------- | ----- | ------------------------------------- | -------------------------------- |
| actividad_reciente_id       | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                                     | Identificador tecnico            |
| solicitud_id                | BIGINT               | N    | -             | FK    | solicitud.solicitud_id                | Solicitud relacionada            |
| tarea_desarrollo_id         | BIGINT               | N    | -             | FK    | tarea_desarrollo.tarea_desarrollo_id  | Tarea relacionada                |
| usuario_id                  | INT                  | NN   | -             | FK    | usuario.usuario_id                    | Usuario actor                    |
| tipo_actividad              | VARCHAR(40)          | NN   | -             | -     | -                                     | Tipo de actividad                |
| titulo                      | VARCHAR(220)         | NN   | -             | -     | -                                     | Titulo corto                     |
| detalle                     | VARCHAR(2000)        | N    | -             | -     | -                                     | Detalle                          |
| fecha_actividad             | DATETIME2            | NN   | SYSDATETIME() | -     | -                                     | Fecha del evento                 |
| visible_para_pm             | BIT                  | NN   | 1             | -     | -                                     | Visibilidad para PM              |
| visible_para_desarrollador  | BIT                  | NN   | 1             | -     | -                                     | Visibilidad para desarrollador   |

## Tabla: proyecto

Descripcion: entidad de gestion para agrupar solicitudes, equipo y planeacion.

| Columna          | Tipo                 | Null | Default  | Llave | Relacion          | Descripcion                         |
| ---------------- | -------------------- | ---- | -------- | ----- | ----------------- | ----------------------------------- |
| proyecto_id      | BIGINT IDENTITY(1,1) | NN   | IDENTITY | PK    | -                 | Identificador del proyecto          |
| clave            | VARCHAR(40)          | NN   | -        | UK    | -                 | Clave unica                         |
| nombre           | VARCHAR(200)         | NN   | -        | -     | -                 | Nombre del proyecto                 |
| descripcion      | VARCHAR(1500)        | N    | -        | -     | -                 | Descripcion                         |
| estado_proyecto  | VARCHAR(30)          | NN   | -        | -     | -                 | PLANEADO, EN_EJECUCION, PAUSADO, CERRADO |
| fecha_inicio     | DATE                 | N    | -        | -     | -                 | Inicio                              |
| fecha_fin_planeada| DATE                | N    | -        | -     | -                 | Fin planeado                        |
| fecha_fin_real   | DATE                 | N    | -        | -     | -                 | Fin real                            |
| pm_usuario_id    | INT                  | NN   | -        | FK    | usuario.usuario_id| PM responsable                      |
| activo           | BIT                  | NN   | 1        | -     | -                 | Vigencia                            |

## Tabla: proyecto_solicitud

Descripcion: relacion entre proyectos y solicitudes.

| Columna             | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion               |
| ------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | ------------------------- |
| proyecto_solicitud_id| BIGINT IDENTITY(1,1)| NN   | IDENTITY      | PK    | -                      | Identificador tecnico     |
| proyecto_id         | BIGINT               | NN   | -             | FK    | proyecto.proyecto_id   | Proyecto                  |
| solicitud_id        | BIGINT               | NN   | -             | FK    | solicitud.solicitud_id | Solicitud                 |
| fecha_vinculacion   | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de vinculo          |

Restricciones: UK (proyecto_id, solicitud_id).

## Tabla: proyecto_miembro

Descripcion: miembros y rol operativo de usuarios en proyectos.

| Columna             | Tipo                 | Null | Default       | Llave | Relacion             | Descripcion                   |
| ------------------- | -------------------- | ---- | ------------- | ----- | -------------------- | ----------------------------- |
| proyecto_miembro_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                    | Identificador tecnico         |
| proyecto_id         | BIGINT               | NN   | -             | FK    | proyecto.proyecto_id | Proyecto                      |
| usuario_id          | INT                  | NN   | -             | FK    | usuario.usuario_id   | Usuario                       |
| rol_en_proyecto     | VARCHAR(40)          | NN   | -             | -     | -                    | PM, DESARROLLADOR, ANALISTA, TESTER, LIDER_TECNICO |
| carga_estimada_pct  | DECIMAL(5,2)         | N    | -             | -     | -                    | Carga estimada porcentual     |
| activo              | BIT                  | NN   | 1             | -     | -                    | Vigencia                      |
| fecha_inicio        | DATETIME2            | NN   | SYSDATETIME() | -     | -                    | Inicio                        |
| fecha_fin           | DATETIME2            | N    | -             | -     | -                    | Fin                           |

Restricciones: UK (proyecto_id, usuario_id).

## Tabla: documento_proyecto

Descripcion: documentos asociados a proyecto y opcionalmente a una solicitud.

| Columna                    | Tipo                 | Null | Default       | Llave | Relacion               | Descripcion                       |
| -------------------------- | -------------------- | ---- | ------------- | ----- | ---------------------- | --------------------------------- |
| documento_proyecto_id      | BIGINT IDENTITY(1,1) | NN   | IDENTITY      | PK    | -                      | Identificador tecnico             |
| proyecto_id                | BIGINT               | NN   | -             | FK    | proyecto.proyecto_id   | Proyecto asociado                 |
| solicitud_id               | BIGINT               | N    | -             | FK    | solicitud.solicitud_id | Solicitud asociada (opcional)     |
| nombre_documento           | VARCHAR(255)         | NN   | -             | -     | -                      | Nombre visible                    |
| tipo_documento             | VARCHAR(50)          | NN   | -             | -     | -                      | ERS, DISENO, MANUAL, MINUTA, OTRO |
| version_documento          | VARCHAR(40)          | N    | -             | -     | -                      | Version                           |
| ruta_archivo               | VARCHAR(600)         | NN   | -             | -     | -                      | Ruta de almacenamiento            |
| tamanio_bytes              | BIGINT               | N    | -             | -     | -                      | Tamano del archivo                |
| subido_por_usuario_id      | INT                  | NN   | -             | FK    | usuario.usuario_id     | Usuario que sube                  |
| fecha_subida               | DATETIME2            | NN   | SYSDATETIME() | -     | -                      | Fecha de carga                    |
| visible_para_participantes | BIT                  | NN   | 1             | -     | -                      | Bandera de visibilidad            |

## Tabla: evento_calendario

Descripcion: eventos de calendario para actividades, revisiones y reuniones.

| Columna              | Tipo                 | Null | Default | Llave | Relacion               | Descripcion                         |
| -------------------- | -------------------- | ---- | ------- | ----- | ---------------------- | ----------------------------------- |
| evento_calendario_id | BIGINT IDENTITY(1,1) | NN   | IDENTITY| PK    | -                      | Identificador de evento             |
| proyecto_id          | BIGINT               | N    | -       | FK    | proyecto.proyecto_id   | Proyecto asociado                   |
| solicitud_id         | BIGINT               | N    | -       | FK    | solicitud.solicitud_id | Solicitud asociada                  |
| titulo               | VARCHAR(220)         | NN   | -       | -     | -                      | Titulo                              |
| descripcion          | VARCHAR(2000)        | N    | -       | -     | -                      | Descripcion                         |
| tipo_evento          | VARCHAR(40)          | NN   | -       | -     | -                      | REUNION, ENTREGA, REVISION, DESPLIEGUE, ACTIVIDAD |
| fecha_inicio         | DATETIME2            | NN   | -       | -     | -                      | Inicio                              |
| fecha_fin            | DATETIME2            | N    | -       | -     | -                      | Fin                                 |
| creado_por_usuario_id| INT                  | NN   | -       | FK    | usuario.usuario_id     | Usuario creador                     |
| es_todo_dia          | BIT                  | NN   | 0       | -     | -                      | Indicador de evento todo el dia     |

## Tabla: evento_participante

Descripcion: invitados/participantes de cada evento de calendario.

| Columna               | Tipo                 | Null | Default   | Llave | Relacion                                | Descripcion            |
| --------------------- | -------------------- | ---- | --------- | ----- | --------------------------------------- | ---------------------- |
| evento_participante_id| BIGINT IDENTITY(1,1) | NN   | IDENTITY  | PK    | -                                       | Identificador tecnico  |
| evento_calendario_id  | BIGINT               | NN   | -         | FK    | evento_calendario.evento_calendario_id  | Evento                 |
| usuario_id            | INT                  | NN   | -         | FK    | usuario.usuario_id                      | Participante           |
| asistencia            | VARCHAR(20)          | NN   | PENDIENTE | -     | -                                       | PENDIENTE, CONFIRMADA, RECHAZADA |

Restricciones: UK (evento_calendario_id, usuario_id).

## Resumen de relaciones principales (completo)

1. Seguridad
- usuario N:M rol (usuario_rol).
- usuario 1:1 usuario_credencial.
- rol N:M menu_opcion (rol_menu_opcion).

2. Estructura
- area 1:N area (jerarquia por area_padre_id).
- usuario 1:N usuario_area.
- area N:M sistema (area_sistema).

3. Operacion base de solicitudes
- solicitud N:1 area, sistema, tipo_solicitud, prioridad_solicitud, estado_solicitud, usuario creador.
- solicitud N:M usuario (solicitud_desarrollador).
- solicitud 1:N historial_estado, aprobacion, comentario, adjunto, notificacion.

4. Formularios especializados
- solicitud 1:1 solicitud_modificacion.
- tipo_modificacion 1:N solicitud_modificacion.
- solicitud 1:1 solicitud_requerimiento_tecnico.

5. Desarrollo y actividades
- solicitud 1:N tarea_desarrollo.
- tarea_desarrollo N:M usuario (tarea_desarrollo_asignacion).
- actividad_reciente puede referenciar solicitud y/o tarea_desarrollo.

6. Proyectos, documentos y calendario
- proyecto N:M solicitud (proyecto_solicitud).
- proyecto N:M usuario (proyecto_miembro).
- proyecto 1:N documento_proyecto.
- proyecto 1:N evento_calendario.
- evento_calendario N:M usuario (evento_participante).
