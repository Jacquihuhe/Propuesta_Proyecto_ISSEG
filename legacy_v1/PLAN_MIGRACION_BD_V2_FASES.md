# Plan de Migracion BD V2 por Fases (sin Big Bang)

## Objetivo
Adoptar el modelo nuevo (4NF) como arquitectura objetivo, manteniendo operativa la version actual hasta completar la transicion.

## Principio clave
No se rompe lo existente: se agrega una capa de compatibilidad para que frontend y API actuales sigan funcionando mientras migramos.

## Versionado de base de datos
- Version actual: V1 (esquema de database_final.sql)
- Version objetivo: V2 (modelo ER-SGSPCSI-legible-por-modulos + diccionario 4NF)
- Estrategia: migraciones incrementales numeradas (V2_001, V2_002, ...)
- Regla de despliegue: cada migracion debe ser reversible o tener script de rollback.

## Fase 0 - Baseline y gobierno (1 sprint)
1. Congelar V1 como baseline productivo.
2. Definir convencion de nombres V2 y reglas de compatibilidad.
3. Crear tabla de control de migraciones y bitacora tecnica.
4. Acordar politica de versionado semantico API + BD.

Entregables:
- Documento de mapeo V1->V2.
- Backlog de migraciones priorizadas.

## Fase 1 - Seguridad y acceso (alto valor, bajo impacto)
1. Introducir usuario_credencial (hash robusto, salt, iteraciones).
2. Mantener usuarios.rol_id vigente temporalmente.
3. Agregar usuario_rol para transicion a roles N:M.
4. Exponer vistas de compatibilidad para login actual.

Compatibilidad:
- API actual puede seguir leyendo usuarios mientras se llena usuario_credencial.
- Se habilita doble lectura temporal (V1 y V2).

## Fase 2 - Catalogos y normalizacion de solicitud
1. Introducir prioridad_solicitud catalogada.
2. Migrar solicitudes.prioridad (texto) a FK prioridad_solicitud_id.
3. Mantener prioridad texto como campo derivado temporal (vista o columna calculada/logica en API).

Compatibilidad:
- Endpoints actuales no cambian contrato en esta fase.

## Fase 3 - Modulos operativos de solicitud
1. Crear solicitud_comentario y solicitud_historial_estado en esquema V2 (o mapear los actuales).
2. Consolidar aprobaciones/asignaciones hacia estructura objetivo (sin perder historial).
3. Migrar adjuntos/notificaciones a nomenclatura V2 manteniendo equivalencias.

Compatibilidad:
- Vistas de puente para que consultas actuales sigan respondiendo.

## Fase 4 - Trabajo colaborativo (equipo)
1. Introducir tarea_desarrollo y tarea_desarrollo_asignacion.
2. Introducir actividad_reciente para dashboards.
3. Agregar proyecto, proyecto_solicitud, proyecto_miembro, evento_calendario, evento_participante.

Compatibilidad:
- Nuevos modulos pueden salir primero en API v2 sin romper API v1.

## Fase 5 - Corte controlado y retiro de legado
1. Cambiar API para leer/escribir solo V2.
2. Monitorear y validar KPIs funcionales.
3. Retirar columnas/tablas legacy cuando no tengan uso.

## Politica API durante migracion
- Mantener /api v1 estable.
- Agregar /api/v2 para modulos nuevos.
- Cuando v2 este madura, deprecacion progresiva de v1 con fecha objetivo.

## Pruebas minimas por fase
- Pruebas de integridad referencial.
- Pruebas de regresion de endpoints existentes.
- Smoke test de login, alta solicitud, consulta por usuario, cambio de estado.
- Verificacion de migracion de datos (conteos y checksums por modulo).

## Riesgos y mitigacion
- Riesgo: divergencia de datos entre V1 y V2.
  Mitigacion: doble escritura temporal controlada + reconciliacion diaria.
- Riesgo: friccion del equipo por cambios de modelo.
  Mitigacion: mapeo V1->V2 y lineamientos de desarrollo compartidos.
- Riesgo: retraso por alcance muy amplio.
  Mitigacion: priorizar fases 1 y 2 antes de proyectos/calendario.

## Recomendacion ejecutiva
Adoptar V2 desde ahora como direccion oficial, migrando por fases con compatibilidad para proteger el avance actual y habilitar mejor trabajo en equipo.
