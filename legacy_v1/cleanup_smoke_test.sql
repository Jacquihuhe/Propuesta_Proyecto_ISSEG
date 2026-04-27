USE SGSPCSI;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @dev_id INT = (
        SELECT TOP 1 usuario_id
        FROM dbo.usuarios
        WHERE correo_electronico = N'desarrollador@isseg.gob.mx'
    );

    DECLARE @usuario_id INT = (
        SELECT TOP 1 usuario_id
        FROM dbo.usuarios
        WHERE correo_electronico = N'usuario@isseg.gob.mx'
    );

    DECLARE @SolicitudesPrueba TABLE (solicitud_id INT PRIMARY KEY);

    INSERT INTO @SolicitudesPrueba (solicitud_id)
    SELECT s.solicitud_id
    FROM dbo.solicitudes s
    WHERE s.titulo = N'Prueba despliegue'
      AND s.descripcion = N'Validacion automatica de script';

    DELETE n
    FROM dbo.notificaciones n
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = n.solicitud_id;

    DELETE a
    FROM dbo.aprobaciones a
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = a.solicitud_id;

    DELETE asg
    FROM dbo.asignaciones asg
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = asg.solicitud_id;

    DELETE h
    FROM dbo.historial_estados_solicitud h
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = h.solicitud_id;

    DELETE au
    FROM dbo.auditoria_solicitudes au
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = au.solicitud_id;

    DELETE aa
    FROM dbo.archivos_adjuntos aa
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = aa.solicitud_id;

    DELETE s
    FROM dbo.solicitudes s
    INNER JOIN @SolicitudesPrueba p ON p.solicitud_id = s.solicitud_id;

    -- Limpieza de datos de apoyo insertados en el smoke test
    DELETE FROM dbo.certificados_usuarios
    WHERE usuario_id = @dev_id
      AND nombre_certificado = N'Scrum Master'
      AND institucion_emisora = N'Scrum.org';

    DELETE FROM dbo.desarrollador_especialidades
    WHERE usuario_id = @dev_id
      AND especialidad = N'Backend .NET'
      AND nivel_experiencia = 4;

    DELETE FROM dbo.disponibilidad_desarrollador
    WHERE usuario_id = @dev_id
      AND horas_disponibles = 6
      AND motivo_ausencia IS NULL
      AND fecha = CONVERT(date, SYSUTCDATETIME());

    -- Restablece preferencia a valor por defecto de paginacion si existe
    UPDATE dbo.preferencias_usuario
    SET items_por_pagina = 10,
        fecha_actualizacion = SYSUTCDATETIME()
    WHERE usuario_id = @usuario_id
      AND items_por_pagina = 20;

    COMMIT TRANSACTION;

    PRINT N'Limpieza de smoke test completada.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
