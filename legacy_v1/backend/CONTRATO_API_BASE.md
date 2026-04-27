# Contrato API Base (SGSPCSI)

Base URL de desarrollo:
- `http://localhost:5214`

## 1) Login
- Método: `POST`
- Ruta: `/api/auth/login`
- Request JSON:
```json
{
  "correoElectronico": "usuario@isseg.gob.mx",
  "contrasena": "user123"
}
```
- Response `200`:
```json
{
  "usuarioId": 1,
  "correoElectronico": "usuario@isseg.gob.mx",
  "rolId": 1,
  "mensaje": "Acceso autorizado"
}
```
- Response `401`: credenciales inválidas.

## 2) Crear Solicitud
- Método: `POST`
- Ruta: `/api/solicitudes`
- Request JSON:
```json
{
  "tipoId": 1,
  "subtipoId": null,
  "usuarioSolicitanteId": 1,
  "solicitudPadreId": null,
  "titulo": "Sistema de Control de Prestamos",
  "descripcion": "Objetivo...",
  "prioridad": "Media",
  "impacto": null,
  "riesgoTecnico": null,
  "complejidadEstimada": null,
  "criteriosExito": null,
  "tiempoEstimadoHoras": null,
  "requiereRequerimientos": true
}
```
- Response `201`:
```json
{
  "solicitudId": 123,
  "folio": "SIS-20260420183000",
  "tipoId": 1,
  "subtipoId": null,
  "estadoId": 1,
  "usuarioSolicitanteId": 1,
  "solicitudPadreId": null,
  "titulo": "Sistema de Control de Prestamos",
  "descripcion": "Objetivo...",
  "prioridad": "Media",
  "fechaCreacion": "2026-04-20T18:30:00Z"
}
```

## 3) Consultar Solicitud por ID
- Método: `GET`
- Ruta: `/api/solicitudes/{solicitudId}`
- Response `200` con estructura de `SolicitudResponse`.
- Response `404` si no existe.

## 4) Listar Solicitudes por Usuario
- Método: `GET`
- Ruta: `/api/solicitudes/por-usuario/{usuarioSolicitanteId}`
- Response `200` arreglo de `SolicitudResponse`.

## Notas de integración Frontend
- Frontend usa `localStorage.apiBaseUrl`; si no existe, usa `http://localhost:5214`.
- `sessionStorage.currentUser` debe incluir `userId` para poder crear solicitudes.
- En desarrollo está habilitado CORS abierto para facilitar pruebas locales.
