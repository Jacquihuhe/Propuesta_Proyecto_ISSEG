# SGSPCSI V2 - Linea de trabajo oficial

## Fuente de verdad funcional
1. ER: ER-SGSPCSI-legible-por-modulos.mmd
2. Diccionario: 17_diccionario_normalizado_4NF.md

## Regla operativa
- Todo cambio de backend se diseña con base en V2.
- No se agregan nuevos documentos de arquitectura fuera de este README salvo necesidad critica.
- Si hay cambios de modelo, se actualiza primero el diccionario y luego el codigo.

## Estructura backend V2
- SGSPCSI.V2.Api: Controllers y configuracion.
- SGSPCSI.V2.Application: casos de uso, servicios, contratos.
- SGSPCSI.V2.Domain: entidades del modelo V2.
- SGSPCSI.V2.Infrastructure: EF Core, repositorios, persistencia.

## Orden de implementacion sugerido
1. Seguridad: usuario, usuario_credencial, usuario_rol, rol.
2. Solicitudes base: solicitud + catalogos (tipo, estado, prioridad).
3. Operacion: aprobaciones, comentarios, adjuntos, notificaciones, historial.
4. Colaboracion: tareas, asignaciones, actividad reciente.
5. Gestion de proyectos: proyecto, miembros, calendario, documentos.

## Legacy
- Todo lo anterior se resguardo en legacy_v1/.
- No borrar legacy hasta que V2 cierre login + solicitud + aprobacion en pruebas.
