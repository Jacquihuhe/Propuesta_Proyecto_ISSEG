# Matriz de Pantallas -> Tablas (Usuario, Desarrollador, PM)

Este documento valida si tu modelo cubre lo que describiste en pantallas y marca que tablas se derivan de cuales.

## 1) Login y control por rol

Estado: **Parcial en modelo actual**, **completo con extension**.

Tablas base:
1. `usuario`
2. `rol`
3. `usuario_rol`
4. `usuario_area`

Tablas nuevas recomendadas:
1. `usuario_credencial` (login + password hash + seguridad)
2. `menu_opcion` (menus del sistema)
3. `rol_menu_opcion` (que menu ve cada rol)

Derivacion:
1. `usuario` -> `usuario_credencial`
2. `rol` -> `rol_menu_opcion`
3. `menu_opcion` -> `rol_menu_opcion`

## 2) Perfil Usuario (Solicitante)

### 2.1 Inicio (totales por estado)

Estado: **Correcto con tablas existentes**.

Se obtiene de:
1. `solicitud`
2. `estado_solicitud`
3. vista `vw_usuario_resumen_inicio`

### 2.2 Formularios

Lo que describiste:
1. Nuevo sistema.
2. Modificacion de sistema existente.
3. Requerimiento tecnico (solo despues de aprobada).
4. Subtipo de modificacion: adaptativa/evolutiva/correctiva.
5. Prioridad.

Estado: **Parcial en modelo actual**, **completo con extension**.

Tablas existentes:
1. `solicitud`
2. `tipo_solicitud`
3. `prioridad_solicitud`
4. `solicitud_adjunto`
5. `solicitud_comentario`

Tablas nuevas recomendadas:
1. `tipo_modificacion`
2. `solicitud_modificacion` (1:1 con solicitud)
3. `solicitud_requerimiento_tecnico` (1:1 con solicitud)

Derivacion:
1. `solicitud` -> `solicitud_modificacion`
2. `tipo_modificacion` -> `solicitud_modificacion`
3. `solicitud` -> `solicitud_requerimiento_tecnico`

### 2.3 Mi solicitudes (historial y detalle)

Estado: **Correcto en modelo actual**.

Tablas:
1. `solicitud`
2. `solicitud_historial_estado`
3. `solicitud_aprobacion`
4. `solicitud_comentario`
5. `solicitud_adjunto`
6. `solicitud_desarrollador`

### 2.4 Notificaciones

Estado: **Correcto en modelo actual**.

Tabla:
1. `notificacion`

### 2.5 Perfil de usuario

Estado: **Correcto en modelo actual** (datos basicos), **mejor con extension** para seguridad.

Tablas:
1. `usuario`
2. `usuario_credencial` (nueva)
3. `usuario_area`

## 3) Perfil Desarrollador

### 3.1 Inicio del desarrollador

Lo que describiste:
1. Pendientes.
2. En desarrollo.
3. Completadas.
4. Urgencias.
5. Actividades recientes y mensajes de asignacion.

Estado: **Parcial en modelo actual**, **completo con extension**.

Tablas existentes:
1. `solicitud_desarrollador`
2. `solicitud`
3. `estado_solicitud`
4. `prioridad_solicitud`

Tablas nuevas recomendadas:
1. `tarea_desarrollo`
2. `tarea_desarrollo_asignacion`
3. `actividad_reciente`
4. vista `vw_desarrollador_resumen`

### 3.2 Tabla de solicitudes asignadas (con estados, prioridades, fechas, areas, tipo, ids)

Estado: **Correcto con modelo actual**.

Tablas:
1. `solicitud`
2. `estado_solicitud`
3. `prioridad_solicitud`
4. `tipo_solicitud`
5. `area`
6. `solicitud_desarrollador`

### 3.3 Documentacion visible por proyecto/participacion

Estado: **Falta en modelo actual**, **completo con extension**.

Tablas nuevas:
1. `proyecto`
2. `proyecto_miembro`
3. `documento_proyecto`
4. `proyecto_solicitud`

Derivacion:
1. `proyecto` -> `proyecto_miembro`
2. `proyecto` -> `documento_proyecto`
3. `proyecto` -> `proyecto_solicitud` -> `solicitud`

## 4) Perfil PM

### 4.1 Pantalla principal PM

Lo que describiste:
1. Pendientes revision.
2. Aprobadas.
3. Rechazadas.
4. Todas las solicitudes.
5. Analisis de rendimiento (tiempo promedio, tasa aprobacion, solicitudes por mes).

Estado: **Correcto con modelo actual para operacion**, **mejor con vistas de extension**.

Tablas:
1. `solicitud`
2. `estado_solicitud`
3. `solicitud_aprobacion`
4. vistas `vw_pm_resumen_general`, `vw_pm_solicitudes_por_mes`

### 4.2 Dashboard ejecutivo

Estado: **Parcial en actual**, **completo con extension**.

Tablas/vistas:
1. `actividad_reciente` (nueva)
2. `vw_pm_resumen_general`
3. `vw_pm_solicitudes_por_mes`
4. `vw_pm_carga_desarrollador`

### 4.3 Aprobaciones

Estado: **Correcto en modelo actual**.

Tablas:
1. `solicitud`
2. `solicitud_aprobacion`
3. `estado_solicitud`

### 4.4 Gestion del equipo

Lo que describiste:
1. Desarrolladores y su carga.
2. Asignar sistema/tarea.
3. Calendario de actividades y reuniones futuras.
4. Totales de miembros activos, carga promedio, rendimiento promedio.

Estado: **Parcial en actual**, **completo con extension**.

Tablas existentes:
1. `sistema_desarrollador`
2. `solicitud_desarrollador`

Tablas nuevas:
1. `tarea_desarrollo`
2. `tarea_desarrollo_asignacion`
3. `evento_calendario`
4. `evento_participante`
5. `proyecto_miembro`

## 5) Respuesta puntual a tu duda: "falta informacion o tablas?"

Si, para tus pantallas **si faltaban** estas piezas clave:
1. Credenciales y seguridad de login (`usuario_credencial`).
2. Menus por rol (`menu_opcion`, `rol_menu_opcion`).
3. Subtipo de modificacion (`tipo_modificacion`, `solicitud_modificacion`).
4. Requerimiento tecnico posterior a aprobacion (`solicitud_requerimiento_tecnico`).
5. Gestion operativa de tareas para desarrollador (`tarea_desarrollo`, `tarea_desarrollo_asignacion`, `actividad_reciente`).
6. Documentacion por proyecto/participantes (`proyecto`, `proyecto_miembro`, `documento_proyecto`, `proyecto_solicitud`).
7. Calendario y reuniones (`evento_calendario`, `evento_participante`).

## 6) Nota sobre CI/CD pipeline (lo que preguntaste)

CI/CD significa:
1. CI (Integracion continua): compilar/probar automaticamente cada cambio.
2. CD (Entrega o despliegue continuo): publicar cambios a ambientes (qa/prod) con control.

Si por ahora no lo necesitan, puedes **no modelarlo en BD**.
Si luego lo valoran, bastaria agregar tablas de ejecucion de pipeline y trazas de despliegue.

## 7) Archivos creados para este ajuste

1. `10_extension_modelo_pantallas.sql` (tablas nuevas + vistas de dashboard)
2. `11_matriz_pantallas_tablas.md` (validacion pantalla por pantalla)
