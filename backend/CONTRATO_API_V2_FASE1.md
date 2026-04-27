# Contrato API V2 - Fase 1 (Seguridad)

Base URL desarrollo:
- `http://localhost:5214`

## Endpoint Login
- Metodo: `POST`
- Ruta: `/api/auth/login`
- Request:
```json
{
  "correoElectronico": "usuario@isseg.gob.mx",
  "contrasena": "user123"
}
```
- Response 200:
```json
{
  "usuarioId": 1,
  "correoElectronico": "usuario@isseg.gob.mx",
  "nombreCompleto": "Usuario Final",
  "roles": ["user"],
  "mensaje": "Acceso autorizado"
}
```
- Response 401:
```json
{
  "mensaje": "Credenciales invalidas."
}
```

## Seeder de desarrollo
Al iniciar la API por primera vez, si no hay usuarios, se crean:
- `usuario@isseg.gob.mx` / `user123`
- `desarrollador@isseg.gob.mx` / `dev123`
- `pm@isseg.gob.mx` / `pm123`

Tambien se crean roles:
- `user`, `developer`, `product_manager`, `admin`
