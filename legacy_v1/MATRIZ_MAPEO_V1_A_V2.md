# Matriz de Mapeo V1 -> V2 (SGSPCSI)

## Criterios
- Conservar: se mantiene igual en V2.
- Extender: se mantiene pero se amplian campos/relaciones.
- Reemplazar: cambia a nuevo modelo, con puente temporal.
- Nuevo: no existe en V1, se crea en V2.

| V1 actual | V2 objetivo | Accion | Nota de transicion |
|---|---|---|---|
| roles | rol | Extender | Ajustar estructura y permisos por menu si aplica |
| usuarios (rol_id directo) | usuario + usuario_rol | Reemplazar | Mantener rol_id temporal hasta completar migracion |
| usuarios.contrasena_hash | usuario_credencial | Reemplazar | Doble validacion temporal para no romper login |
| personas | usuario (datos atomicos) o usuario + perfil | Extender | Decidir si se conserva separacion actual por contexto UI |
| departamentos | area | Reemplazar | Mapear jerarquia y claves de area |
| tipos_solicitud | tipo_solicitud | Conservar | Homologar nombres y claves |
| subtipos_modificacion | tipo_modificacion | Extender | Unificar catalogo y referencias |
| estados_solicitud | estado_solicitud | Conservar | Homologar claves y orden de flujo |
| solicitudes (prioridad texto) | solicitud (prioridad_solicitud_id) | Extender | Migrar prioridad texto a FK |
| aprobaciones | solicitud_aprobacion | Conservar | Cambiar nomenclatura de campos |
| asignaciones | solicitud_desarrollador | Reemplazar | Mantener vista puente para endpoints v1 |
| historial_estados_solicitud | solicitud_historial_estado | Conservar | Mapear estados anterior/nuevo |
| archivos_adjuntos | solicitud_adjunto | Conservar | Homologar nombres de columnas |
| notificaciones | notificacion | Conservar | Homologar nombres de columnas |
| preferencias_usuario | (definir: usuario_preferencia o conservar) | Extender | Mantener tabla actual por UI existente |
| certificados_usuarios | (definir: certificado_usuario o conservar) | Extender | Mantener tabla actual por UI existente |
| desarrollador_especialidades | sistema_desarrollador / catalogos tecnicos | Extender | Revisar semantica y evitar perdida funcional |
| disponibilidad_desarrollador | (nuevo modulo capacidad) | Extender | Puede coexistir con proyecto_miembro |
| auditoria_solicitudes | (auditoria transversal) | Conservar | No eliminar; soporte de cumplimiento |
| - | prioridad_solicitud | Nuevo | Catalogo formal |
| - | solicitud_comentario | Nuevo | Comentarios de seguimiento |
| - | tarea_desarrollo | Nuevo | Descomposicion operativa |
| - | tarea_desarrollo_asignacion | Nuevo | Asignaciones por tarea |
| - | actividad_reciente | Nuevo | Feed para dashboard |
| - | proyecto | Nuevo | Gestion colaborativa |
| - | proyecto_solicitud | Nuevo | Relacion N:M |
| - | proyecto_miembro | Nuevo | Equipo por proyecto |
| - | documento_proyecto | Nuevo | Documentacion de proyecto |
| - | evento_calendario | Nuevo | Agenda colaborativa |
| - | evento_participante | Nuevo | Participantes y confirmacion |

## Orden recomendado de implementacion tecnica
1. Seguridad: usuario_credencial + usuario_rol.
2. Prioridad catalogada y ajuste de solicitud.
3. Comentarios + historial + alineacion de aprobaciones/asignaciones.
4. Tareas y actividad reciente.
5. Proyectos y calendario.

## Criterio de corte a V2
- 0 errores en smoke tests funcionales.
- 0 diferencias de conteo en entidades migradas.
- Endpoints v2 cubren los casos criticos de negocio.
