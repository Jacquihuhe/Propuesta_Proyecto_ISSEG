# Cierre de base de datos V2

## Estado actual
- La línea oficial de trabajo ya es V2.
- El backend activo está organizado por capas: Api, Application, Domain e Infrastructure.
- El modelo funcional ya cubre seguridad, solicitudes base, aprobaciones, comentarios, historial y notificaciones.
- `legacy_v1/` se conserva como respaldo histórico y de referencia.

## Validación realizada
- La API V2 arrancó correctamente contra `localhost\\SQLEXPRESS`.
- Se creó la base física `SGSPCSI_V2_FASE2`.
- Las tablas núcleo V2 quedaron creadas: usuario, credencial, rol, solicitud, aprobaciones, comentarios, historial, notificaciones y catálogos.
- El seeder inicializó catálogos y usuarios de desarrollo.

## Lo que debe quedar validado antes de borrar legacy
1. Login funcionando contra la base real V2.
2. Creación de solicitud funcionando contra la base real V2.
3. Aprobación, rechazo y solicitud de información dejando historial y notificación persistidos.
4. Consulta de solicitudes por usuario mostrando datos reales.
5. Catálogos V2 consistentes: tipo, prioridad, estado, rol y credencial.
6. Integridad referencial sin registros huérfanos en las tablas nuevas.
7. Smoke test completo de frontend + API sin depender de datos simulados.

## Smoke test API ejecutado (2026-04-21)
- Login OK con usuarios semilla: `usuario@isseg.gob.mx` y `pm@isseg.gob.mx`.
- Se crearon 3 solicitudes reales en `SGSPCSI_V2_FASE2`.
- Flujo de decisiones OK: `APROBADA`, `RECHAZADA`, `REQUIERE_INFO`.
- Historial persistido (1 registro por decisión en las 3 solicitudes).
- Notificaciones persistidas para el solicitante (3 no leídas).
- Consulta por usuario OK (las 3 solicitudes visibles para el creador).

## Verificación de integridad referencial (2026-04-24)
- `DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS` ejecutado sin violaciones.
- Barrido de huérfanos por relaciones núcleo ejecutado con conteo 0 en todas las relaciones revisadas.

## Smoke test frontend + API (avance 2026-04-24)
- Login web validado contra API real (`file://.../login.html` -> `POST /api/auth/login`) con `pm@isseg.gob.mx`.
- Navegación validada en `aprobaciones.html` con datos reales provenientes de `GET /api/aprobaciones/pendientes`.
- Navegación validada en `notificaciones.html` con carga real de `GET /api/notificaciones/usuario/{id}`.
- Se corrigió un error de ejecución en frontend: `updateStats is not defined` en `notificaciones.html` (cambio a `updateNotificationCount()`).
- Persisten dependencias mock/local en pantallas clave no PM (por ejemplo `home_cliente.js`, `mis_solicitudes.js`, `home_developer.js`, `mis_tareas.js`, `perfil.js`) y en módulos PM legacy duplicados dentro de `pantallas de pm/`.

## Estado de cierre al 2026-04-24
- Cumplido: puntos 1, 2, 3, 4, 5 y 6.
- Pendiente: punto 7 (falta retirar/aislar dependencias mock residuales para declarar frontend end-to-end sin simulados).

## Lo que todavía no conviene eliminar
- `legacy_v1/database_final.sql`
- `legacy_v1/TRAZABILIDAD_UI_BD.md`
- `legacy_v1/DISEÑO_BD_PASO_A_PASO.md`
- `legacy_v1/PLAN_MIGRACION_BD_V2_FASES.md`
- Cualquier script o documento que siga sirviendo como respaldo de migración

## Criterio para retirar legacy
Borrar o archivar definitivamente solo cuando se cumpla todo esto:
- V2 esté validada con datos reales.
- Las pantallas principales ya no dependan de mocks.
- La base vieja no sea necesaria para rollback ni auditoría.
- El equipo confirme que los scripts históricos ya no se usan en despliegues.

## Orden recomendado de cierre
1. Validar la BD física actual.
2. Correr smoke tests de login, solicitud y aprobación.
3. Confirmar que notificaciones e historial se persisten.
4. Revisar dependencias residuales hacia V1.
5. Marcar legacy como solo lectura.
6. Eliminar únicamente cuando no haya uso operativo ni de rollback.
