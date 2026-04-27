-- ============================================
-- SGSPCSI - ROLLBACK V2_001
-- Revierte objetos creados por V2_001
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

    IF OBJECT_ID(N'dbo.TR_usuarios_sync_v2', N'TR') IS NOT NULL
        DROP TRIGGER dbo.TR_usuarios_sync_v2;

    IF OBJECT_ID(N'dbo.vw_login_compat', N'V') IS NOT NULL
        DROP VIEW dbo.vw_login_compat;

    IF OBJECT_ID(N'dbo.usuario_credencial', N'U') IS NOT NULL
        DROP TABLE dbo.usuario_credencial;

    IF OBJECT_ID(N'dbo.usuario_rol', N'U') IS NOT NULL
        DROP TABLE dbo.usuario_rol;

    IF OBJECT_ID(N'dbo.schema_migrations', N'U') IS NOT NULL
    BEGIN
        DELETE FROM dbo.schema_migrations WHERE migration_id = N'V2_001';
    END;

    COMMIT TRANSACTION;

    PRINT N'Rollback V2_001 completado.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @line INT = ERROR_LINE();
    DECLARE @num INT = ERROR_NUMBER();

    RAISERROR(N'Error en rollback V2_001 (%d, linea %d): %s', 16, 1, @num, @line, @msg);
END CATCH;
GO
