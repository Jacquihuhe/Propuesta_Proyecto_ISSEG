# Trazabilidad UI -> Base de Datos (SGSPCSI)

## Resumen
Esta matriz documenta la cobertura de pantallas HTML/JS contra `database_final.sql`.

## Cobertura por modulo

| Modulo UI | Archivos principales | Cobertura BD | Objetos BD relacionados |
|---|---|---|---|
| Login/Auth | `login.html`, `login.js` | Completa | `usuarios`, `roles`, `auditoria_acceso` |
| Perfil | `perfil.html`, `perfil.js` | Completa | `usuarios`, `personas` |
| Cambiar password | `cambiar_password.html` | Completa (hash y auditoria) | `usuarios.contrasena_hash`, `auditoria_acceso` |
| Home cliente | `home_cliente.html/js` | Completa | `solicitudes`, `notificaciones` |
| Home PM | `home_pm.html/js` | Completa | `solicitudes`, `aprobaciones`, `asignaciones`, `notificaciones` |
| Home developer | `home_developer.html/js` | Completa | `asignaciones`, `solicitudes`, `notificaciones` |
| Mis solicitudes | `mis_solicitudes.html/js` | Completa | `solicitudes`, `estados_solicitud`, vistas `vw_*` |
| Mis tareas | `mis_tareas.html/js` | Completa | `asignaciones`, `solicitudes` |
| Aprobaciones PM | `aprobaciones.html` | Completa | `aprobaciones`, `solicitudes` + campos PM (`impacto`, `riesgo_tecnico`, `complejidad_estimada`, `criterios_exito`, `tiempo_estimado_horas`) |
| Equipo PM | `equipo.html` | Completa | `desarrollador_especialidades`, `disponibilidad_desarrollador`, `asignaciones`, `personas` |
| Formularios solicitud | `Formulario_*.html/js` | Completa | `solicitudes`, `tipos_solicitud`, `subtipos_modificacion`, `archivos_adjuntos` |
| Notificaciones | `notificaciones.html` | Completa | `notificaciones`, `sp_marcar_notificacion_leida` |
| Configuracion/preferencias | `configuracion.html`, `preferencias.html` | Completa | `preferencias_usuario`, `sp_guardar_preferencias_usuario` |
| Accesibilidad | `accesibilidad.html` | Soportada (persistencia opcional) | `preferencias_usuario` (tema, formato, idioma, etc.) |
| Certificados | `certificados.html` | Completa | `certificados_usuarios`, `sp_registrar_certificado_usuario` |
| Documentacion | `documentacion.html/js` | Completa | `archivos_adjuntos`, `auditoria_documentos` |

## Objetos nuevos agregados para cerrar brechas

### Tablas
- `preferencias_usuario`
- `certificados_usuarios`
- `desarrollador_especialidades`
- `disponibilidad_desarrollador`

### Ampliacion de tabla existente
- `solicitudes`:
  - `impacto`
  - `riesgo_tecnico`
  - `complejidad_estimada`
  - `criterios_exito`
  - `tiempo_estimado_horas`

### Procedimientos
- `sp_guardar_preferencias_usuario`
- `sp_registrar_certificado_usuario`
- `sp_registrar_especialidad_desarrollador`
- `sp_registrar_disponibilidad_desarrollador`
- `sp_obtener_carga_desarrollador`

### Indices
- `UX_preferencias_usuario_usuario_id`
- `IX_certificados_usuarios_usuario_id`
- `IX_certificados_usuarios_estado`
- `IX_desarrollador_especialidades_usuario_id`
- `UX_disponibilidad_desarrollador_usuario_fecha`
- `IX_disponibilidad_desarrollador_fecha`

## Nota
Para bases ya existentes, `database_final.sql` incluye bloque de compatibilidad (`COL_LENGTH`) para agregar columnas nuevas en `solicitudes` sin romper despliegues.
