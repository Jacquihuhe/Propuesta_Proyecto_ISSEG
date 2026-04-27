# Contrato API V2 - Fase 2 (Solicitudes Base)

Base URL desarrollo:
- http://localhost:5214

## Crear solicitud
- Metodo: POST
- Ruta: /api/solicitudes
- Request JSON:
{
  "titulo": "Nuevo sistema de inventario",
  "descripcion": "Se requiere automatizar el control de inventario...",
  "areaSolicitanteId": 1,
  "sistemaId": null,
  "tipoSolicitudId": 1,
  "prioridadSolicitudId": 2,
  "creadoPorUsuarioId": 1,
  "fechaCompromiso": null
}
- Response 201: SolicitudResponse

## Obtener solicitud por ID
- Metodo: GET
- Ruta: /api/solicitudes/{solicitudId}
- Response 200: SolicitudResponse
- Response 404: no encontrada

## Listar solicitudes por usuario
- Metodo: GET
- Ruta: /api/solicitudes/por-usuario/{usuarioId}
- Response 200: arreglo de SolicitudResponse

## Catalogos seed de desarrollo
Se crean automaticamente si no existen:
- tipo_solicitud: NUEVO_SISTEMA, REQUERIMIENTO, MODIFICACION, URGENTE
- estado_solicitud: PENDIENTE, EN_DESARROLLO, COMPLETADA, RECHAZADA
- prioridad_solicitud: BAJA, MEDIA, ALTA, CRITICA
