## Tabla: rol

| Elemento       | Descripción                                                                                                                                                                                                                      |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Catálogo de roles de seguridad del sistema. Almacena los perfiles de acceso disponibles en la aplicación.                                                                                                                       |
| rol_id         | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave          | Clave corta y única del rol. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                  |
| nombre         | Nombre legible del rol mostrado en interfaces y reportes de permisos. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                           |
| descripcion    | Descripción funcional del perfil. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                          |
| activo         | Estado del rol en el catálogo: 1 significa habilitado para asignarse, 0 significa deshabilitado para nuevos usos. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                   |
| fecha_creacion | Fecha y hora en que el rol fue creado y guardado por primera vez. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                          |

## Tabla: usuario

| Elemento             | Descripción                                                                                                                                                                                                                      |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                | Sin descripción registrada.                                                                                                                                                                                                      |
| usuario_id           | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| nombre_pila          | Nombre propio principal de la persona usuaria. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                  |
| apellido_paterno     | Primer apellido del usuario para identificación completa.                                                                                                                                                                        |
| apellido_materno     | Segundo apellido del usuario cuando aplica.                                                                                                                                                                                       |
| correo_institucional | Correo institucional único.                                                                                                                                                                                                      |
| puesto               | Cargo organizacional del usuario para contexto administrativo y de autorización.                                                                                                                                                 |
| activo               | Estado del usuario: 1 permite acceso al sistema, 0 bloquea su uso operativo. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                         |
| fecha_creacion       | Fecha y hora en que el usuario fue dado de alta por primera vez. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                           |

## Tabla: usuario_rol

| Elemento       | Descripción                                                                                                                                                                                                                      |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Relación N:M entre usuarios y roles. Asigna perfiles de acceso a usuarios con control de vigencia.                                                                                                                               |
| usuario_rol_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| usuario_id     | Llave foránea al usuario correspondiente dentro del catálogo de usuarios. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                |
| rol_id         | Llave foránea al rol de seguridad que define permisos y alcances. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                         |
| activo         | Vigencia de la asignación de rol: 1 vigente, 0 finalizada o revocada. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                               |
| fecha_fin      | Fecha y hora en que termina la asignación de rol; puede quedar vacía si sigue vigente. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                   |

## Tabla: area

| Elemento       | Descripción                                                                                                                                                                                                                      |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Estructura organizacional jerárquica. Almacena direcciones, coordinaciones y departamentos con relación padre-hijo.                                                                                                             |
| area_id        | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| area_padre_id  | Área superior (jerarquía). Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                               |
| clave          | Clave operativa del área. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                     |
| nombre         | Nombre oficial del área. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                       |
| tipo_area      | Clasificación organizacional del área para ubicar su nivel de gestión.                                                                                                                                                         |
| nivel          | Nivel jerárquico numérico.                                                                                                                                                                                                      |
| activa         | Estado del área: 1 operativa en la estructura organizacional, 0 inactiva. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                           |
| fecha_creacion | Fecha y hora en que el área se registró por primera vez en el catálogo. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                 |

## Tabla: usuario_area

| Elemento        | Descripción                                                                                                                                                                                                                      |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla           | Relación N:M entre usuarios y áreas. Vincula usuarios a áreas organizacionales con control de titularidad.                                                                                                                     |
| usuario_area_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| usuario_id      | Llave foránea al usuario correspondiente dentro del catálogo de usuarios. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                |
| area_id         | Llave foránea que apunta al área organizacional relacionada con este registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                           |
| es_titular      | Titularidad del usuario en el área: 1 es responsable principal, 0 es integrante sin titularidad.                                                                                                                                 |
| activo          | Vigencia de la adscripción usuario-area: 1 activa, 0 concluida o inhabilitada. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                      |
| fecha_inicio    | Fecha y hora en que inicia la vinculación del usuario con el área. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                       |
| fecha_fin       | Fecha y hora en que concluye la vinculación del usuario con el área; vacía si sigue activa. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                             |

## Tabla: sistema

| Elemento       | Descripción                                                                                                                                                                                                                      |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Catálogo de sistemas institucionales. Almacena aplicaciones y sistemas disponibles en la institución.                                                                                                                           |
| sistema_id     | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave          | Clave única del sistema. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                      |
| nombre         | Nombre con el que usuarios y equipos identifican el sistema en la operación diaria. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                            |
| descripcion    | Descripción de funcionalidades. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                            |
| activo         | Estado del sistema en catálogo: 1 disponible para operar, 0 fuera de servicio o retirado. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                           |
| fecha_creacion | Fecha y hora en que el sistema se dio de alta en el catálogo institucional. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                               |

## Tabla: area_sistema

| Elemento        | Descripción                                                                                                                                                                                                                      |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla           | Relación N:M entre áreas y sistemas. Define qué sistemas son visibles y accesibles por cada área.                                                                                                                             |
| area_sistema_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| area_id         | Llave foránea que apunta al área organizacional relacionada con este registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                           |
| sistema_id      | Llave foránea al sistema o aplicación sobre la que aplica el registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                   |
| activo          | Vigencia de la relación area-sistema: 1 habilitada, 0 no vigente. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                                   |
| fecha_alta      | Fecha y hora exacta en que se realizo la asignación en el sistema. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                        |

## Tabla: sistema_desarrollador

| Elemento                 | Descripción                                                                                                                                                                                                                      |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                    | Relación N:M entre sistemas y usuarios (desarrolladores). Asigna técnicos responsables de cada sistema.                                                                                                                         |
| sistema_desarrollador_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| sistema_id               | Llave foránea al sistema o aplicación sobre la que aplica el registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                   |
| usuario_id               | Llave foránea al usuario técnico que participa en el desarrollo o mantenimiento del sistema. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                             |
| activo                   | Vigencia de la asignación tecnica: 1 activa, 0 inactiva o cerrada. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                                  |
| fecha_inicio             | Fecha y hora en que comienza la actividad, relación o periodo registrado. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                 |
| fecha_fin                | Fecha y hora en que finaliza formalmente la asignación o relación; puede quedar vacía si sigue vigente. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                 |

## Tabla: tipo_solicitud

| Elemento          | Descripción                                                                                                                                                                                                                      |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla             | Catálogo de tipos de solicitud. Define las categorías principales de solicitudes en el sistema.                                                                                                                                 |
| tipo_solicitud_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave             | Clave única del tipo. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                         |
| nombre            | Nombre del tipo de solicitud. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                   |
| activo            | Estado del tipo de solicitud: 1 disponible para captura, 0 no disponible. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                            |

## Tabla: estado_solicitud

| Elemento            | Descripción                                                                                                                                                                                                                      |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla               | Estados del ciclo de vida de solicitudes. Define los estados por los que puede transitar una solicitud.                                                                                                                           |
| estado_solicitud_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave               | Clave única del estado. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                       |
| nombre              | Nombre del estado. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                              |
| es_terminal         | Marca de cierre del flujo: 1 indica estado terminal, 0 indica estado intermedio.                                                                                                                                                  |
| activo              | Estado del catálogo de estados: 1 utilizable en flujo, 0 deshabilitado. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                             |

## Tabla: prioridad_solicitud

| Elemento               | Descripción                                                                                                                                                                                                                      |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                  | Catálogo de prioridades. Define los niveles de urgencia para solicitudes.                                                                                                                                                        |
| prioridad_solicitud_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave                  | BAJA, MEDIA, ALTA, CRITICA. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                    |
| nombre                 | Nombre de la prioridad. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                         |
| peso                   | Valor numérico para ordenamiento.                                                                                                                                                                                                |
| activo                 | Estado de la prioridad: 1 disponible para clasificar solicitudes, 0 fuera de uso. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                    |

## Tabla: solicitud

| Elemento               | Descripción                                                                                                                                                                                                                      |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                  | Entidad principal de negocio. Almacena todas las solicitudes (tickets) del sistema con trazabilidad completa.                                                                                                                     |
| solicitud_id           | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| folio                  | Folio único de negocio.                                                                                                                                                                                                          |
| titulo                 | Título breve de la solicitud. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                  |
| descripcion            | Explicación amplia del contexto, alcance y contenido del registro para evitar ambigüedades. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                               |
| area_solicitante_id    | Área que solicita. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                        |
| sistema_id             | Sistema impactado. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                         |
| tipo_solicitud_id      | Tipo de solicitud. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                         |
| prioridad_solicitud_id | Prioridad. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                                 |
| estado_solicitud_id    | Estado actual. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                             |
| creado_por_usuario_id  | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                             |
| fecha_solicitud        | Fecha y hora en que el registro se dio de alta por primera vez. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                            |
| fecha_compromiso       | Fecha SLA comprometida. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                    |
| fecha_resolucion       | Fecha y hora en que se concluye oficialmente la tarea o proceso. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                           |
| esfuerzo_horas         | Horas invertidas.                                                                                                                                                                                                                 |
| activo                 | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                       |

## Tabla: solicitud_desarrollador

| Elemento                   | Descripción                                                                                                                                                                                                                      |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                      | Relación N:M entre solicitudes y desarrolladores. Asigna técnicos responsables de cada solicitud.                                                                                                                               |
| solicitud_desarrollador_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id               | Llave foránea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                           |
| usuario_id                 | Llave foránea al usuario técnico que participa en el desarrollo o mantenimiento del sistema. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                             |
| activo                     | Vigencia de la asignación tecnica: 1 activa, 0 inactiva o cerrada. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                                                  |
| fecha_asignacion           | Fecha y hora exacta en que se realizo la asignación en el sistema. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                        |
| fecha_fin                  | Fecha y hora en que finaliza formalmente la asignación o relación; puede quedar vacía si sigue vigente. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                 |

## Tabla: solicitud_historial_estado

| Elemento                      | Descripción                                                                                                                                                                                                                      |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                         | Bitácora de cambios de estado. Registra el historial completo de transiciones de estado de cada solicitud.                                                                                                                       |
| solicitud_historial_estado_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id                  | Llave foránea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                           |
| estado_anterior_id            | Estado previo. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                             |
| estado_nuevo_id               | Nuevo estado. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                              |
| comentario                    | Observación del cambio. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                    |
| cambiado_por_usuario_id       | Usuario que realiza cambio. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                |
| fecha_cambio                  | Fecha del cambio. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                          |

## Tabla: solicitud_aprobacion

| Elemento                | Descripción                                                                                                                                                                                                                      |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                   | Aprobaciones y evaluaciónes. Registra las decisiones de aprobación, rechazo o solicitud de información.                                                                                                                        |
| solicitud_aprobacion_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id            | Llave foránea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                           |
| aprobado_por_usuario_id | Usuario que aprueba. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                       |
| estatus_aprobacion      | APROBADA, RECHAZADA, REQUIERE_INFO.                                                                                                                                                                                               |
| motivo                  | Motivo de la decisión. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                     |
| fecha_aprobacion        | Fecha de evaluación. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                      |

## Tabla: solicitud_comentario

| Elemento                | Descripción                                                                                                                                                                                                                      |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                   | Comentarios y anotaciones. Almacena comentarios de usuarios en solicitudes para seguimiento.                                                                                                                                      |
| solicitud_comentario_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id            | Llave foránea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                           |
| autor_usuario_id        | Autor del comentario. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                      |
| comentario              | Texto del comentario. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                       |
| es_interno              | Visibilidad del comentario: 1 sólo interno para equipo autorizado, 0 visible en flujo general.                                                                                                                                   |
| fecha_comentario        | Fecha del comentario. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                      |

## Tabla: solicitud_adjunto

| Elemento              | Descripción                                                                                                                                                                                                                      |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                 | Evidencias y archivos. Almacena archivos adjuntos que soportan solicitudes.                                                                                                                                                       |
| solicitud_adjunto_id  | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id          | Llave foránea que apunta a la solicitud relacionada; conecta este dato con el ticket principal. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                           |
| nombre_archivo        | Nombre original del archivo. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                    |
| ruta_archivo          | Ubicacion logica o fisica donde se guarda el archivo dentro de la infraestructura de almacenamiento.                                                                                                                              |
| tipo_mime             | Tipo MIME del archivo.                                                                                                                                                                                                            |
| tamanio_bytes         | Tamano exacto del archivo medido en bytes para control de almacenamiento y validaciones.                                                                                                                                          |
| subido_por_usuario_id | Usuario que sube el archivo. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                               |
| fecha_subida          | Fecha y hora en que el archivo fue subido y registrado en el sistema. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                      |

## Tabla: notificación

| Elemento       | Descripción                                                                                                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Notificaciones de usuarios. Almacena avisos y alertas enviadas a usuarios del sistema.                                                                                                      |
| usuario_id     | Usuario receptor. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                    |
| solicitud_id   | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| titulo         | Título del aviso. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                        |
| mensaje        | Contenido del mensaje.                                                                                                                                                                      |
| leida          | Lectura de notificación: 1 ya leida por el usuario, 0 pendiente de lectura.                                                                                                                |
| fecha_creacion | Fecha y hora en que el registro se dio de alta por primera vez. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                      |
| fecha_lectura  | Fecha y hora en la que el usuario abrio y marco la notificación como leida. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                         |

## Tabla: usuario_credencial

| Elemento                 | Descripción                                                                                                                                                    |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                    | Seguridad y auténticación. Almacena credenciales y datos de acceso del usuario.                                                                               |
| usuario_id               | Identificador del usuario. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                               |
| login_usuario            | Nombre de login único.                                                                                                                                         |
| password_hash            | Hash de la contraseña.                                                                                                                                         |
| password_salt            | Salt para hash.                                                                                                                                                 |
| algoritmo_hash           | Algoritmo de cifrado.                                                                                                                                           |
| iteraciones              | Iteraciones de hash.                                                                                                                                            |
| ultimo_acceso            | Fecha y hora del acceso exitoso mas reciente del usuario.                                                                                                       |
| intentos_fallidos        | Contador de intentos.                                                                                                                                           |
| bloqueado_hasta          | Fecha de desbloqueo.                                                                                                                                            |
| requiere_cambio_password | Requiere cambio obligatorio. Valor 1 = sí aplica; valor 0 = no aplica.                                                                                         |
| fecha_actualizacion      | Fecha y hora del ultimo cambio aplicado a este registro de credenciales. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso. |

## Tabla: menu_opcion

| Elemento       | Descripción                                                                                                                                                                                                                      |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla          | Menú de navegación. Define opciones y rutas del sistema con jerarquía.                                                                                                                                                         |
| menu_opcion_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave          | Clave única de la opción. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                    |
| nombre         | Nombre visible en menú. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                        |
| ruta           | Ruta de navegación.                                                                                                                                                                                                              |
| icono          | Nombre del icono UI.                                                                                                                                                                                                              |
| orden          | Posición en el menú.                                                                                                                                                                                                            |
| activa         | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                       |
| menu_padre_id  | Menú superior (jerarquía). Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                               |

## Tabla: rol_menu_opcion

| Elemento           | Descripción                                                                                                                                                                                                                      |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla              | Permisos de menú por rol. Define qué opciones puede ver y usar cada rol.                                                                                                                                                        |
| rol_menu_opcion_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| rol_id             | Llave foránea al rol de seguridad que define permisos y alcances. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                         |
| menu_opcion_id     | Referencia a la opción de menú correspondiente. Permite enlazar el permiso con la opción específica.                                                                                                                          |
| puede_ver          | Permiso de visualización. Valor 1 = sí aplica; valor 0 = no aplica.                                                                                                                                                             |
| puede_editar       | Permiso de edición. Valor 1 = sí aplica; valor 0 = no aplica.                                                                                                                                                                   |
| puede_aprobar      | Permiso de aprobación. Valor 1 = sí aplica; valor 0 = no aplica.                                                                                                                                                                |

## Tabla: tipo_modificacion

| Elemento             | Descripción                                                                                                                                                                                                                      |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                | Tipos de modificación. Clasifica las modificaciones en adaptativas, evolutivas o correctivas.                                                                                                                                    |
| tipo_modificacion_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave                | Clasificación del cambio: ADAPTATIVA por ajuste al entorno, EVOLUTIVA por mejora funcional, CORRECTIVA por corrección de fallas. Es un código corto de negocio que facilita filtros, validaciones e integraciones.             |
| nombre               | Nombre del tipo. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                                |
| activo               | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operación. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                    |

## Tabla: solicitud_modificacion

| Elemento                  | Descripción                                                                                                                                                                                                                      |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                     | Detalles de modificación. Almacena información específica de solicitudes de modificación de sistemas.                                                                                                                         |
| solicitud_modificacion_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id              | Llave foránea que enlaza este registro con la solicitud origen del proceso. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                               |
| tipo_modificacion_id      | Tipo de modificación. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                     |
| sistema_version_actual    | Versión actual del sistema.                                                                                                                                                                                                      |
| modulo_afectado           | Módulo que se modifica.                                                                                                                                                                                                          |
| impacto_tecnico           | Impacto técnico esperado.                                                                                                                                                                                                        |
| justificacion             | Justificación del cambio. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                  |
| fecha_registro            | Fecha y hora en que se capturó este registro específico en la base de datos. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                             |

## Tabla: solicitud_requerimiento_tecnico

| Elemento                           | Descripción                                                                                                                                                                                                                      |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                              | Especificaciones técnicas. Detalla requerimientos técnicos después de aprobación de solicitud.                                                                                                                                |
| solicitud_requerimiento_tecnico_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id                       | Llave foránea que enlaza este registro con la solicitud origen del proceso. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                               |
| arquitectura_propuesta             | Arquitectura de solución.                                                                                                                                                                                                        |
| alcance_tecnico                    | Alcance del desarrollo.                                                                                                                                                                                                           |
| dependencias                       | Dependencias técnicas.                                                                                                                                                                                                           |
| criterios_aceptacion               | Criterios de validación.                                                                                                                                                                                                         |
| riesgos                            | Riesgos identificados.                                                                                                                                                                                                            |
| plan_pruebas                       | Plan de pruebas.                                                                                                                                                                                                                  |
| observaciones                      | Observaciones adicionales. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                  |
| elaborado_por_usuario_id           | Usuario autor del requerimiento técnico. Identifica a la persona responsable de elaborar el documento técnico.                                                                                                                  |
| fecha_elaboracion                  | Fecha de elaboración. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                     |

## Tabla: tarea_desarrollo

| Elemento               | Descripción                                                                                                                                                                                                                      |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                  | Tareas operativas. Descompone solicitudes en tareas concretas de desarrollo.                                                                                                                                                      |
| tarea_desarrollo_id    | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id           | Llave foránea que enlaza este registro con la solicitud origen del proceso. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                               |
| titulo                 | Título de la tarea. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                            |
| descripcion            | Explicación amplia del contexto, alcance y contenido del registro para evitar ambigüedades. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                               |
| prioridad_solicitud_id | Nivel de prioridad. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                        |
| estado_tarea           | Estado de tarea: PENDIENTE sin iniciar, EN_DESARROLLO en trabajo, COMPLETADA finalizada, BLOQUEADA detenida por impedimento.                                                                                                      |
| fecha_inicio           | Fecha y hora en que comienza la actividad, relación o periodo registrado. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                 |
| fecha_compromiso       | Fecha comprometida. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                        |
| fecha_cierre           | Fecha y hora en que se concluye oficialmente la tarea o proceso. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                           |
| creado_por_usuario_id  | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                             |
| activo                 | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                       |

## Tabla: tarea_desarrollo_asignación

| Elemento            | Descripción                                                                                                                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla               | Asignaciones de tarea. Vincula usuarios a tareas con roles específicos.                                                                                                                          |
| tarea_desarrollo_id | Referencia a tarea. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                        |
| usuario_id          | Llave foránea al usuario relaciónado con este registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                  |
| activa              | Bandera de vigencia: 1 significa que el elemento esta habilitado para uso, 0 significa que no debe utilizarse. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                       |
| fecha_asignacion    | Fecha y hora exacta en que se realizo la asignación en el sistema. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                        |
| fecha_fin           | Fecha y hora en que finaliza formalmente la asignación o relación; puede quedar vacía si sigue vigente. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso. |

## Tabla: actividad_reciente

| Elemento                   | Descripción                                                                                                                                                                                                                      |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                      | Bitácora de actividades. Registra eventos recientes para paneles de seguimiento.                                                                                                                                                 |
| actividad_reciente_id      | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| solicitud_id               | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                       |
| tarea_desarrollo_id        | Tarea asociada. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                                                                            |
| usuario_id                 | Usuario actor de la actividad. Identifica a la persona que realizó la acción registrada.                                                                                                                                        |
| tipo_actividad             | Clasificación del evento realizado (por ejemplo cambio, comentario, avance o alerta).                                                                                                                                            |
| titulo                     | Título corto. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                                  |
| detalle                    | Descripcion ampliada de lo sucedido, incluyendo contexto y resultado del movimiento. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                        |
| fecha_actividad            | Fecha del evento. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                          |
| visible_para_pm            | Bandera de visibilidad para Usuario responsable de coordinar, priorizar y dar seguimiento al proyecto.: 1 se muestra, 0 se oculta.                                                                                                |
| visible_para_desarrollador | Bandera de visibilidad para desarrolladores: 1 se muestra, 0 se oculta.                                                                                                                                                           |

## Tabla: proyecto

| Elemento           | Descripción                                                                                                                                                                                                                      |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla              | Gestión de proyectos. Agrupa solicitudes, equipo y planificación en iniciativas.                                                                                                                                                |
| proyecto_id        | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| clave              | Clave única del proyecto. Es un código corto de negocio que facilita filtros, validaciones e integraciones.                                                                                                                     |
| nombre             | Nombre oficial con el que se identifica la iniciativa en reportes y seguimiento. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                |
| descripcion        | Descripción de objetivos. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                  |
| estado_proyecto    | Estado del proyecto: PLANEADO sin iniciar, EN_EJECUCION en curso, PAUSADO temporalmente detenido, CERRADO finalizado.                                                                                                             |
| fecha_inicio       | Fecha y hora en que comienza la actividad, relación o periodo registrado. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                 |
| fecha_fin_planeada | Fecha fin planeada. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                        |
| fecha_fin_real     | Fecha fin real. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                                                                            |
| pm_usuario_id      | Usuario responsable de coordinar, priorizar y dar seguimiento al proyecto. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                                 |
| activo             | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operación. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                    |

## Tabla: proyecto_solicitud

| Elemento              | Descripción                                                                                                                                                                                                                      |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                 | Relación N:M entre proyectos y solicitudes. Vincula solicitudes con iniciativas.                                                                                                                                                 |
| proyecto_solicitud_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| proyecto_id           | Llave foránea que vincula este registro con el proyecto al que pertenece. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                 |
| solicitud_id          | Llave foránea que enlaza este registro con la solicitud origen del proceso. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                               |

## Tabla: proyecto_miembro

| Elemento            | Descripción                                                                                                                                                                                                                      |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla               | Miembros de proyecto. Asigna usuarios a proyectos con roles operativos.                                                                                                                                                           |
| proyecto_miembro_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| proyecto_id         | Llave foránea que vincula este registro con el proyecto al que pertenece. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                 |
| usuario_id          | Llave foránea al usuario relaciónado con este registro. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                                  |
| rol_en_proyecto     | PM, DESARROLLADOR, ANALISTA, TESTER, LIDER_TECNICO.                                                                                                                                                                               |
| carga_estimada_pct  | Dedicación estimada (%).                                                                                                                                                                                                         |
| activo              | Bandera de vigencia: 1 significa activo y disponible, 0 significa inactivo o fuera de operación. Valor 1 = activo o vigente; valor 0 = inactivo o no vigente.                                                                    |
| fecha_inicio        | Fecha y hora en que comienza la actividad, relación o periodo registrado. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                 |
| fecha_fin           | Fecha y hora en que finaliza formalmente la asignación o relación; puede quedar vacía si sigue vigente. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                 |

## Tabla: documento_proyecto

| Elemento                   | Descripción                                                                                                                                                                                                                      |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                      | Documentos de proyecto. Almacena archivos asociados a proyectos y solicitudes.                                                                                                                                                    |
| documento_proyecto_id      | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| proyecto_id                | Llave foránea que vincula este registro con el proyecto al que pertenece. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                                 |
| solicitud_id               | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. (opcional). Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                           |
| nombre_documento           | Nombre visible. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                                 |
| tipo_documento             | ERS, DISENO, MANUAL, MINUTA, OTRO.                                                                                                                                                                                                |
| version_documento          | Versión del documento.                                                                                                                                                                                                           |
| ruta_archivo               | Ubicacion logica o fisica donde se guarda el archivo dentro de la infraestructura de almacenamiento.                                                                                                                              |
| tamanio_bytes              | Tamano exacto del archivo medido en bytes para control de almacenamiento y validaciones.                                                                                                                                          |
| subido_por_usuario_id      | Usuario que sube el archivo. Identifica a la persona responsable de cargar el documento al sistema.                                                                                                                               |
| fecha_subida               | Fecha y hora en que el archivo fue subido y registrado en el sistema. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                      |
| visible_para_participantes | Visible para participantes. Valor 1 = sí aplica; valor 0 = no aplica.                                                                                                                                                            |

## Tabla: evento_calendario

| Elemento              | Descripción                                                                                                                                                                                                                      |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                 | Eventos de calendario. Registra reuniones, entregas, revisiones y actividades.                                                                                                                                                    |
| evento_calendario_id  | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| proyecto_id           | Proyecto al que se vincula este evento para su seguimiento en planeacion y ejecucion. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                      |
| solicitud_id          | Solicitud vinculada a este registro para mantener contexto funcional y trazabilidad. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                       |
| titulo                | Título del evento. Se utiliza como etiqueta visible en pantallas, reportes y búsquedas del sistema.                                                                                                                             |
| descripcion           | Descripción. Es un campo de texto explicativo que agrega contexto funcional y técnico para la toma de decisiones.                                                                                                               |
| tipo_evento           | REUNION, ENTREGA, REVISION, DESPLIEGUE, ACTIVIDAD.                                                                                                                                                                                |
| fecha_inicio          | Momento exacto en que inicia el evento o actividad calendarizada. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                          |
| fecha_fin             | Momento exacto en que finaliza el evento o actividad calendarizada. Permite trazabilidad temporal, auditoría y seguimiento del ciclo de vida del proceso.                                                                        |
| creado_por_usuario_id | Usuario que registro originalmente este elemento en el sistema y que funge como autor inicial. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                             |

## Tabla: evento_participante

| Elemento               | Descripción                                                                                                                                                                                                                      |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tabla                  | Participantes de evento. Registra asistentes y su estado de confirmación en eventos.                                                                                                                                             |
| evento_participante_id | Clave numérica autogenerada que identifica este registro de forma única, no se captura manualmente y no puede repetirse. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro. |
| evento_calendario_id   | Llave foránea que conecta este registro con el evento de calendario correspondiente. Se usa para relacionar este registro con otra tabla y mantener la integridad referencial de los datos.                                      |
| usuario_id             | Usuario invitado o incluido en el evento, con registro de su respuesta de asistencia. Este valor lo genera automáticamente el sistema y funciona como identificador principal del registro.                                      |
| asistencia             | Estado de asistencia del invitado: PENDIENTE aun sin respuesta, CONFIRMADA asistencia aceptada, RECHAZADA asistencia declinada.                                                                                                   |
