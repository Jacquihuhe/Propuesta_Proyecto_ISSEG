# Ejecucion V2_001

## Scripts
- V2_001: migraciones_v2/V2_001_usuario_credencial_usuario_rol.sql
- Rollback: migraciones_v2/V2_001_rollback.sql

## Orden recomendado
1. Respaldar base SGSPCSI.
2. Ejecutar V2_001 en ambiente de pruebas.
3. Validar consultas de verificacion incluidas al final del script.
4. Probar login actual y alta de usuario (si aplica).
5. Ejecutar en ambiente destino.

## Chequeos funcionales
1. Login existente sigue funcionando con usuarios actuales.
2. Existen filas en usuario_rol y usuario_credencial para cada usuario.
3. Trigger TR_usuarios_sync_v2 sincroniza cambios en usuarios.
4. Vista vw_login_compat devuelve datos V1 y V2.

## Rollback
Si algo falla, ejecutar migraciones_v2/V2_001_rollback.sql y reintentar despues de corregir.
