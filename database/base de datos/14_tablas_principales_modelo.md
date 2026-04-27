# Tablas principales del modelo SGSPCSI

Este documento resume las tablas principales que sostienen el analisis de pantallas y el flujo del sistema.

## 1. Seguridad y acceso
- `usuario`
- `rol`
- `usuario_rol`
- `usuario_credencial`
- `menu_opcion`
- `rol_menu_opcion`

## 2. Estructura organizacional
- `area`
- `usuario_area`
- `sistema`
- `area_sistema`
- `sistema_desarrollador`

## 3. Solicitudes
- `tipo_solicitud`
- `estado_solicitud`
- `prioridad_solicitud`
- `solicitud`
- `solicitud_desarrollador`
- `solicitud_historial_estado`
- `solicitud_aprobacion`
- `solicitud_comentario`
- `solicitud_adjunto`
- `notificacion`

## 4. Formularios especializados
- `tipo_modificacion`
- `solicitud_modificacion`
- `solicitud_requerimiento_tecnico`

## 5. Operacion de desarrollo
- `tarea_desarrollo`
- `tarea_desarrollo_asignacion`
- `actividad_reciente`

## 6. Proyectos y seguimiento
- `proyecto`
- `proyecto_solicitud`
- `proyecto_miembro`
- `documento_proyecto`
- `evento_calendario`
- `evento_participante`

## Relaciones clave
- `usuario` se relaciona con `rol` mediante `usuario_rol`.
- `area` se relaciona consigo misma por `area_padre_id`.
- `solicitud` concentra el flujo principal del negocio.
- `solicitud` puede generar historial, aprobaciones, comentarios, adjuntos y notificaciones.
- `proyecto` agrupa solicitudes, miembros, documentos y eventos.

## Resumen
Estas tablas cubren:
- login y control de acceso
- estructura de areas y sistemas
- captura y seguimiento de solicitudes
- aprobaciones y trazabilidad
- extension para desarrollo, proyectos y calendario
