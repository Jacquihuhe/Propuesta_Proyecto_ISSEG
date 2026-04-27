-- ============================================
-- SGSPCSI - MIGRACION V2_001
-- Objetivo:
--   1) Introducir modelo de seguridad V2: usuario_credencial y usuario_rol.
--   2) Mantener compatibilidad con V1 sin romper login actual.
-- Requisitos:
--   - SQL Server 2019+
--   - Base: SGSPCSI
-- ============================================

USE SGSPCSI;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -------------------------------------------------
    -- 0) Tabla de control de migraciones (si no existe)
    -------------------------------------------------
    IF OBJECT_ID(N'dbo.schema_migrations', N'U') IS NULL
    BEGIN
        CREATE TABLE dbo.schema_migrations (
            migration_id NVARCHAR(100) NOT NULL CONSTRAINT PK_schema_migrations PRIMARY KEY,
            description NVARCHAR(400) NULL,
            executed_at DATETIME2 NOT NULL CONSTRAINT DF_schema_migrations_executed_at DEFAULT SYSUTCDATETIME()
        );
    END;

    IF EXISTS (SELECT 1 FROM dbo.schema_migrations WHERE migration_id = N'V2_001')
    BEGIN
        PRINT N'V2_001 ya fue aplicada. No se realizan cambios.';
        COMMIT TRANSACTION;
        RETURN;
    END;

    -------------------------------------------------
    -- 1) Tabla V2: usuario_rol (N:M)
    -------------------------------------------------
    IF OBJECT_ID(N'dbo.usuario_rol', N'U') IS NULL
    BEGIN
        CREATE TABLE dbo.usuario_rol (
            usuario_rol_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_usuario_rol PRIMARY KEY,
            usuario_id INT NOT NULL,
            rol_id INT NOT NULL,
            activo BIT NOT NULL CONSTRAINT DF_usuario_rol_activo DEFAULT (1),
            fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_usuario_rol_fecha_asignacion DEFAULT SYSUTCDATETIME(),
            fecha_fin DATETIME2 NULL,
            CONSTRAINT FK_usuario_rol_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
            CONSTRAINT FK_usuario_rol_roles FOREIGN KEY (rol_id) REFERENCES dbo.roles(rol_id),
            CONSTRAINT UQ_usuario_rol_usuario_rol UNIQUE (usuario_id, rol_id),
            CONSTRAINT CK_usuario_rol_activo CHECK (activo IN (0,1)),
            CONSTRAINT CK_usuario_rol_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_asignacion)
        );
    END;

    -------------------------------------------------
    -- 2) Tabla V2: usuario_credencial (1:1)
    --    Nota: se incluye password_hash_legacy para convivencia V1/V2
    -------------------------------------------------
    IF OBJECT_ID(N'dbo.usuario_credencial', N'U') IS NULL
    BEGIN
        CREATE TABLE dbo.usuario_credencial (
            usuario_id INT NOT NULL CONSTRAINT PK_usuario_credencial PRIMARY KEY,
            login_usuario NVARCHAR(100) NOT NULL,
            password_hash VARBINARY(512) NOT NULL,
            password_salt VARBINARY(128) NULL,
            algoritmo_hash NVARCHAR(40) NOT NULL CONSTRAINT DF_usuario_credencial_algoritmo_hash DEFAULT (N'LEGACY_TEXT'),
            iteraciones INT NOT NULL CONSTRAINT DF_usuario_credencial_iteraciones DEFAULT (1),
            password_hash_legacy NVARCHAR(255) NULL,
            ultimo_acceso DATETIME2 NULL,
            intentos_fallidos SMALLINT NOT NULL CONSTRAINT DF_usuario_credencial_intentos_fallidos DEFAULT (0),
            bloqueado_hasta DATETIME2 NULL,
            requiere_cambio_password BIT NOT NULL CONSTRAINT DF_usuario_credencial_requiere_cambio DEFAULT (0),
            fecha_actualizacion DATETIME2 NOT NULL CONSTRAINT DF_usuario_credencial_fecha_actualizacion DEFAULT SYSUTCDATETIME(),
            CONSTRAINT FK_usuario_credencial_usuarios FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(usuario_id),
            CONSTRAINT UQ_usuario_credencial_login_usuario UNIQUE (login_usuario),
            CONSTRAINT CK_usuario_credencial_intentos CHECK (intentos_fallidos >= 0),
            CONSTRAINT CK_usuario_credencial_requiere_cambio CHECK (requiere_cambio_password IN (0,1))
        );
    END;

    -------------------------------------------------
    -- 3) Backfill usuario_rol desde usuarios.rol_id (V1)
    -------------------------------------------------
    INSERT INTO dbo.usuario_rol (usuario_id, rol_id, activo, fecha_asignacion)
    SELECT u.usuario_id, u.rol_id, 1, SYSUTCDATETIME()
    FROM dbo.usuarios u
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.usuario_rol ur
        WHERE ur.usuario_id = u.usuario_id
          AND ur.rol_id = u.rol_id
    );

    -------------------------------------------------
    -- 4) Backfill usuario_credencial desde usuarios (V1)
    --    - SHA2_256_HEX: hex de 64 chars
    --    - BCRYPT: hashes que inician con $2a$, $2b$ o $2y$
    --    - LEGACY_TEXT: cualquier otro formato
    -------------------------------------------------
    INSERT INTO dbo.usuario_credencial (
        usuario_id,
        login_usuario,
        password_hash,
        password_salt,
        algoritmo_hash,
        iteraciones,
        password_hash_legacy,
        ultimo_acceso,
        intentos_fallidos,
        bloqueado_hasta,
        requiere_cambio_password,
        fecha_actualizacion
    )
    SELECT
        u.usuario_id,
        u.correo_electronico,
        CASE
            WHEN LEN(u.contrasena_hash) = 64
                 AND u.contrasena_hash NOT LIKE '%[^0-9A-Fa-f]%' THEN CONVERT(VARBINARY(512), N'0x' + u.contrasena_hash, 1)
            ELSE CONVERT(VARBINARY(512), u.contrasena_hash)
        END AS password_hash,
        NULL AS password_salt,
        CASE
            WHEN LEN(u.contrasena_hash) = 64
                 AND u.contrasena_hash NOT LIKE '%[^0-9A-Fa-f]%' THEN N'SHA2_256_HEX'
            WHEN u.contrasena_hash LIKE N'$2a$%' OR u.contrasena_hash LIKE N'$2b$%' OR u.contrasena_hash LIKE N'$2y$%' THEN N'BCRYPT'
            ELSE N'LEGACY_TEXT'
        END AS algoritmo_hash,
        CASE
            WHEN LEN(u.contrasena_hash) = 64
                 AND u.contrasena_hash NOT LIKE '%[^0-9A-Fa-f]%' THEN 1
            WHEN u.contrasena_hash LIKE N'$2a$%' OR u.contrasena_hash LIKE N'$2b$%' OR u.contrasena_hash LIKE N'$2y$%' THEN 10
            ELSE 1
        END AS iteraciones,
        u.contrasena_hash AS password_hash_legacy,
        u.ultimo_acceso,
        CAST(u.intentos_fallidos AS SMALLINT),
        NULL,
        0,
        SYSUTCDATETIME()
    FROM dbo.usuarios u
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.usuario_credencial uc
        WHERE uc.usuario_id = u.usuario_id
    );

    -------------------------------------------------
    -- 5) Trigger de sincronizacion V1 -> V2
    --    Mantiene actualizadas usuario_rol y usuario_credencial
    --    cuando usuarios cambie por procesos legacy.
    -------------------------------------------------
    IF OBJECT_ID(N'dbo.TR_usuarios_sync_v2', N'TR') IS NOT NULL
    BEGIN
        DROP TRIGGER dbo.TR_usuarios_sync_v2;
    END;

    EXEC(N'
    CREATE TRIGGER dbo.TR_usuarios_sync_v2
    ON dbo.usuarios
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Upsert de credenciales
        MERGE dbo.usuario_credencial AS target
        USING (
            SELECT
                i.usuario_id,
                i.correo_electronico,
                i.contrasena_hash,
                i.ultimo_acceso,
                i.intentos_fallidos
            FROM inserted i
        ) AS source
        ON target.usuario_id = source.usuario_id
        WHEN MATCHED THEN
            UPDATE SET
                login_usuario = source.correo_electronico,
                password_hash = CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN CONVERT(VARBINARY(512), N''0x'' + source.contrasena_hash, 1)
                    ELSE CONVERT(VARBINARY(512), source.contrasena_hash)
                END,
                algoritmo_hash = CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN N''SHA2_256_HEX''
                    WHEN source.contrasena_hash LIKE N''$2a$%'' OR source.contrasena_hash LIKE N''$2b$%'' OR source.contrasena_hash LIKE N''$2y$%'' THEN N''BCRYPT''
                    ELSE N''LEGACY_TEXT''
                END,
                iteraciones = CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN 1
                    WHEN source.contrasena_hash LIKE N''$2a$%'' OR source.contrasena_hash LIKE N''$2b$%'' OR source.contrasena_hash LIKE N''$2y$%'' THEN 10
                    ELSE 1
                END,
                password_hash_legacy = source.contrasena_hash,
                ultimo_acceso = source.ultimo_acceso,
                intentos_fallidos = CAST(source.intentos_fallidos AS SMALLINT),
                fecha_actualizacion = SYSUTCDATETIME()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                usuario_id,
                login_usuario,
                password_hash,
                password_salt,
                algoritmo_hash,
                iteraciones,
                password_hash_legacy,
                ultimo_acceso,
                intentos_fallidos,
                bloqueado_hasta,
                requiere_cambio_password,
                fecha_actualizacion
            )
            VALUES (
                source.usuario_id,
                source.correo_electronico,
                CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN CONVERT(VARBINARY(512), N''0x'' + source.contrasena_hash, 1)
                    ELSE CONVERT(VARBINARY(512), source.contrasena_hash)
                END,
                NULL,
                CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN N''SHA2_256_HEX''
                    WHEN source.contrasena_hash LIKE N''$2a$%'' OR source.contrasena_hash LIKE N''$2b$%'' OR source.contrasena_hash LIKE N''$2y$%'' THEN N''BCRYPT''
                    ELSE N''LEGACY_TEXT''
                END,
                CASE
                    WHEN LEN(source.contrasena_hash) = 64
                         AND source.contrasena_hash NOT LIKE ''%[^0-9A-Fa-f]%'' THEN 1
                    WHEN source.contrasena_hash LIKE N''$2a$%'' OR source.contrasena_hash LIKE N''$2b$%'' OR source.contrasena_hash LIKE N''$2y$%'' THEN 10
                    ELSE 1
                END,
                source.contrasena_hash,
                source.ultimo_acceso,
                CAST(source.intentos_fallidos AS SMALLINT),
                NULL,
                0,
                SYSUTCDATETIME()
            );

        -- Sincronizacion de roles
        MERGE dbo.usuario_rol AS target
        USING (
            SELECT i.usuario_id, i.rol_id
            FROM inserted i
        ) AS source
        ON target.usuario_id = source.usuario_id
           AND target.rol_id = source.rol_id
        WHEN MATCHED THEN
            UPDATE SET
                activo = 1,
                fecha_fin = NULL
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (usuario_id, rol_id, activo, fecha_asignacion, fecha_fin)
            VALUES (source.usuario_id, source.rol_id, 1, SYSUTCDATETIME(), NULL);

        -- Para mantener la semantica V1 (1 rol actual),
        -- se inactivan otros roles de ese usuario.
        UPDATE ur
        SET
            ur.activo = 0,
            ur.fecha_fin = COALESCE(ur.fecha_fin, SYSUTCDATETIME())
        FROM dbo.usuario_rol ur
        INNER JOIN inserted i ON i.usuario_id = ur.usuario_id
        WHERE ur.rol_id <> i.rol_id
          AND ur.activo = 1;
    END;
    ');

    -------------------------------------------------
    -- 6) Vista de compatibilidad de login
    --    Permite inspeccionar credenciales V1/V2 en paralelo.
    -------------------------------------------------
    EXEC(N'
    CREATE OR ALTER VIEW dbo.vw_login_compat
    AS
    SELECT
        u.usuario_id,
        u.correo_electronico,
        u.rol_id,
        u.estado,
        u.intentos_fallidos,
        u.ultimo_acceso,
        u.contrasena_hash AS contrasena_hash_v1,
        uc.algoritmo_hash AS algoritmo_hash_v2,
        uc.password_hash_legacy AS contrasena_hash_v2_legacy,
        uc.login_usuario
    FROM dbo.usuarios u
    LEFT JOIN dbo.usuario_credencial uc ON uc.usuario_id = u.usuario_id;
    ');

    -------------------------------------------------
    -- 7) Marcar migracion aplicada
    -------------------------------------------------
    INSERT INTO dbo.schema_migrations (migration_id, description)
    VALUES (N'V2_001', N'Introduccion de usuario_credencial y usuario_rol con compatibilidad V1.');

    COMMIT TRANSACTION;

    PRINT N'V2_001 aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @line INT = ERROR_LINE();
    DECLARE @num INT = ERROR_NUMBER();

    RAISERROR(N'Error en V2_001 (%d, linea %d): %s', 16, 1, @num, @line, @msg);
END CATCH;
GO

-- Verificaciones rapidas sugeridas post-ejecucion:
-- SELECT COUNT(*) AS usuarios_v1 FROM dbo.usuarios;
-- SELECT COUNT(*) AS usuario_rol_rows FROM dbo.usuario_rol;
-- SELECT COUNT(*) AS usuario_credencial_rows FROM dbo.usuario_credencial;
-- SELECT TOP 20 * FROM dbo.vw_login_compat ORDER BY usuario_id;
