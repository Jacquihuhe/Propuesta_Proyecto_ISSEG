using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Seeding;

public static class DevSecuritySeeder
{
    public static async Task SeedAsync(ApplicationDbContext context, IPasswordHashService passwordHashService, CancellationToken cancellationToken = default)
    {
        await context.Database.EnsureCreatedAsync(cancellationToken);
        await EnsurePhase3SchemaAsync(context, cancellationToken);

        await SeedCatalogosSolicitudAsync(context, cancellationToken);

        if (await context.Usuarios.AnyAsync(cancellationToken))
        {
            return;
        }

        var roles = new[]
        {
            new Rol { Clave = "user", Nombre = "Usuario", Descripcion = "Usuario final", Activo = true, FechaCreacion = DateTime.UtcNow },
            new Rol { Clave = "developer", Nombre = "Desarrollador", Descripcion = "Desarrollador", Activo = true, FechaCreacion = DateTime.UtcNow },
            new Rol { Clave = "product_manager", Nombre = "Product Manager", Descripcion = "PM", Activo = true, FechaCreacion = DateTime.UtcNow },
            new Rol { Clave = "admin", Nombre = "Administrador", Descripcion = "Admin", Activo = true, FechaCreacion = DateTime.UtcNow }
        };

        context.Roles.AddRange(roles);
        await context.SaveChangesAsync(cancellationToken);

        var usuarios = new[]
        {
            CreateUser("Usuario", "Final", "usuario@isseg.gob.mx", "Empleado"),
            CreateUser("Desarrollador", "ISSEG", "desarrollador@isseg.gob.mx", "Desarrollador"),
            CreateUser("PM", "ISSEG", "pm@isseg.gob.mx", "Product Manager")
        };

        context.Usuarios.AddRange(usuarios);
        await context.SaveChangesAsync(cancellationToken);

        var roleMap = roles.ToDictionary(x => x.Clave, x => x.RolId, StringComparer.OrdinalIgnoreCase);

        AssignCredentialAndRole(usuarios[0], "user");
        AssignCredentialAndRole(usuarios[1], "developer");
        AssignCredentialAndRole(usuarios[2], "product_manager");

        context.UsuariosCredenciales.AddRange(usuarios.Select(x => x.UsuarioCredencial!));
        context.UsuariosRol.AddRange(usuarios.Select(x => x.RolesUsuario.Single()));
        await context.SaveChangesAsync(cancellationToken);

        void AssignCredentialAndRole(Usuario usuario, string roleKey)
        {
            var plainPassword = usuario.CorreoInstitucional.StartsWith("usuario", StringComparison.OrdinalIgnoreCase)
                ? "user123"
                : usuario.CorreoInstitucional.StartsWith("desarrollador", StringComparison.OrdinalIgnoreCase)
                    ? "dev123"
                    : "pm123";

            var hashData = passwordHashService.HashPassword(plainPassword);

            usuario.UsuarioCredencial = new UsuarioCredencial
            {
                UsuarioId = usuario.UsuarioId,
                LoginUsuario = usuario.CorreoInstitucional,
                PasswordHash = hashData.hash,
                PasswordSalt = hashData.salt,
                AlgoritmoHash = hashData.algorithm,
                Iteraciones = hashData.iterations,
                UltimoAcceso = null,
                IntentosFallidos = 0,
                BloqueadoHasta = null,
                RequiereCambioPassword = false,
                FechaActualizacion = DateTime.UtcNow
            };

            usuario.RolesUsuario.Add(new UsuarioRol
            {
                UsuarioId = usuario.UsuarioId,
                RolId = roleMap[roleKey],
                Activo = true,
                FechaAsignacion = DateTime.UtcNow,
                FechaFin = null
            });
        }

        static Usuario CreateUser(string nombre, string apaterno, string correo, string puesto)
        {
            return new Usuario
            {
                NombrePila = nombre,
                ApellidoPaterno = apaterno,
                ApellidoMaterno = null,
                CorreoInstitucional = correo,
                Puesto = puesto,
                Activo = true,
                FechaCreacion = DateTime.UtcNow
            };
        }
    }

    private static async Task SeedCatalogosSolicitudAsync(ApplicationDbContext context, CancellationToken cancellationToken)
    {
        if (!await context.TiposSolicitud.AnyAsync(cancellationToken))
        {
            context.TiposSolicitud.AddRange(
                new TipoSolicitud { Clave = "NUEVO_SISTEMA", Nombre = "Nuevo Sistema", Activo = true },
                new TipoSolicitud { Clave = "REQUERIMIENTO", Nombre = "Requerimiento", Activo = true },
                new TipoSolicitud { Clave = "MODIFICACION", Nombre = "Modificacion", Activo = true },
                new TipoSolicitud { Clave = "URGENTE", Nombre = "Urgente", Activo = true }
            );
        }

        var estadosRequeridos = new[]
        {
            new EstadoSolicitud { Clave = "PENDIENTE", Nombre = "Pendiente", EsTerminal = false, Activo = true },
            new EstadoSolicitud { Clave = "EN_DESARROLLO", Nombre = "En Desarrollo", EsTerminal = false, Activo = true },
            new EstadoSolicitud { Clave = "COMPLETADA", Nombre = "Completada", EsTerminal = true, Activo = true },
            new EstadoSolicitud { Clave = "RECHAZADA", Nombre = "Rechazada", EsTerminal = true, Activo = true },
            new EstadoSolicitud { Clave = "APROBADA", Nombre = "Aprobada", EsTerminal = true, Activo = true },
            new EstadoSolicitud { Clave = "REQUIERE_INFO", Nombre = "Requiere Informacion", EsTerminal = false, Activo = true }
        };

        var estadosExistentes = await context.EstadosSolicitud
            .AsNoTracking()
            .Select(x => x.Clave.ToUpper())
            .ToListAsync(cancellationToken);

        var nuevosEstados = estadosRequeridos
            .Where(x => !estadosExistentes.Contains(x.Clave.ToUpper(), StringComparer.Ordinal))
            .ToArray();

        if (nuevosEstados.Length > 0)
        {
            context.EstadosSolicitud.AddRange(nuevosEstados);
        }

        if (!await context.PrioridadesSolicitud.AnyAsync(cancellationToken))
        {
            context.PrioridadesSolicitud.AddRange(
                new PrioridadSolicitud { Clave = "BAJA", Nombre = "Baja", Peso = 1, Activo = true },
                new PrioridadSolicitud { Clave = "MEDIA", Nombre = "Media", Peso = 2, Activo = true },
                new PrioridadSolicitud { Clave = "ALTA", Nombre = "Alta", Peso = 3, Activo = true },
                new PrioridadSolicitud { Clave = "CRITICA", Nombre = "Critica", Peso = 4, Activo = true }
            );
        }

        await context.SaveChangesAsync(cancellationToken);
    }

    private static async Task EnsurePhase3SchemaAsync(ApplicationDbContext context, CancellationToken cancellationToken)
    {
        var sql = @"
IF OBJECT_ID('dbo.solicitud_aprobacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitud_aprobacion
    (
        solicitud_aprobacion_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        solicitud_id BIGINT NOT NULL,
        usuario_aprobador_id INT NOT NULL,
        decision_clave VARCHAR(30) NOT NULL,
        comentario NVARCHAR(2000) NULL,
        fecha_decision DATETIME2 NOT NULL,
        activo BIT NOT NULL CONSTRAINT DF_solicitud_aprobacion_activo DEFAULT(1)
    );

    ALTER TABLE dbo.solicitud_aprobacion
        ADD CONSTRAINT FK_solicitud_aprobacion_solicitud
            FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id);

    ALTER TABLE dbo.solicitud_aprobacion
        ADD CONSTRAINT FK_solicitud_aprobacion_usuario
            FOREIGN KEY (usuario_aprobador_id) REFERENCES dbo.usuario(usuario_id);
END

IF OBJECT_ID('dbo.solicitud_comentario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitud_comentario
    (
        solicitud_comentario_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        solicitud_id BIGINT NOT NULL,
        usuario_id INT NOT NULL,
        comentario NVARCHAR(2000) NOT NULL,
        es_interno BIT NOT NULL,
        fecha_creacion DATETIME2 NOT NULL,
        activo BIT NOT NULL CONSTRAINT DF_solicitud_comentario_activo DEFAULT(1)
    );

    ALTER TABLE dbo.solicitud_comentario
        ADD CONSTRAINT FK_solicitud_comentario_solicitud
            FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id);

    ALTER TABLE dbo.solicitud_comentario
        ADD CONSTRAINT FK_solicitud_comentario_usuario
            FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id);
END

IF OBJECT_ID('dbo.solicitud_historial_estado', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.solicitud_historial_estado
    (
        solicitud_historial_estado_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        solicitud_id BIGINT NOT NULL,
        estado_anterior_id INT NULL,
        estado_nuevo_id INT NOT NULL,
        cambiado_por_usuario_id INT NOT NULL,
        fecha_cambio DATETIME2 NOT NULL,
        comentario NVARCHAR(2000) NULL,
        activo BIT NOT NULL CONSTRAINT DF_solicitud_historial_estado_activo DEFAULT(1)
    );

    ALTER TABLE dbo.solicitud_historial_estado
        ADD CONSTRAINT FK_solicitud_historial_estado_solicitud
            FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id);

    ALTER TABLE dbo.solicitud_historial_estado
        ADD CONSTRAINT FK_solicitud_historial_estado_anterior
            FOREIGN KEY (estado_anterior_id) REFERENCES dbo.estado_solicitud(estado_solicitud_id);

    ALTER TABLE dbo.solicitud_historial_estado
        ADD CONSTRAINT FK_solicitud_historial_estado_nuevo
            FOREIGN KEY (estado_nuevo_id) REFERENCES dbo.estado_solicitud(estado_solicitud_id);

    ALTER TABLE dbo.solicitud_historial_estado
        ADD CONSTRAINT FK_solicitud_historial_estado_usuario
            FOREIGN KEY (cambiado_por_usuario_id) REFERENCES dbo.usuario(usuario_id);
END

IF OBJECT_ID('dbo.notificacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.notificacion
    (
        notificacion_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        usuario_id INT NOT NULL,
        solicitud_id BIGINT NULL,
        tipo_clave VARCHAR(30) NOT NULL,
        titulo NVARCHAR(200) NOT NULL,
        mensaje NVARCHAR(2000) NOT NULL,
        url_destino NVARCHAR(300) NULL,
        leida BIT NOT NULL CONSTRAINT DF_notificacion_leida DEFAULT(0),
        fecha_creacion DATETIME2 NOT NULL,
        fecha_lectura DATETIME2 NULL,
        activa BIT NOT NULL CONSTRAINT DF_notificacion_activa DEFAULT(1)
    );

    ALTER TABLE dbo.notificacion
        ADD CONSTRAINT FK_notificacion_usuario
            FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(usuario_id);

    ALTER TABLE dbo.notificacion
        ADD CONSTRAINT FK_notificacion_solicitud
            FOREIGN KEY (solicitud_id) REFERENCES dbo.solicitud(solicitud_id);
END
";

        await context.Database.ExecuteSqlRawAsync(sql, cancellationToken);
    }
}