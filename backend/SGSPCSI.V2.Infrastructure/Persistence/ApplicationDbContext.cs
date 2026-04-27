using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<Usuario> Usuarios => Set<Usuario>();
    public DbSet<UsuarioCredencial> UsuariosCredenciales => Set<UsuarioCredencial>();
    public DbSet<Rol> Roles => Set<Rol>();
    public DbSet<UsuarioRol> UsuariosRol => Set<UsuarioRol>();
    public DbSet<TipoSolicitud> TiposSolicitud => Set<TipoSolicitud>();
    public DbSet<EstadoSolicitud> EstadosSolicitud => Set<EstadoSolicitud>();
    public DbSet<PrioridadSolicitud> PrioridadesSolicitud => Set<PrioridadSolicitud>();
    public DbSet<Solicitud> Solicitudes => Set<Solicitud>();
    public DbSet<SolicitudAprobacion> SolicitudesAprobaciones => Set<SolicitudAprobacion>();
    public DbSet<SolicitudComentario> SolicitudesComentarios => Set<SolicitudComentario>();
    public DbSet<SolicitudHistorialEstado> SolicitudesHistorialEstado => Set<SolicitudHistorialEstado>();
    public DbSet<Notificacion> Notificaciones => Set<Notificacion>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.ToTable("usuario");
            entity.HasKey(x => x.UsuarioId);
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.NombrePila).HasColumnName("nombre_pila").HasMaxLength(80).IsRequired();
            entity.Property(x => x.ApellidoPaterno).HasColumnName("apellido_paterno").HasMaxLength(80).IsRequired();
            entity.Property(x => x.ApellidoMaterno).HasColumnName("apellido_materno").HasMaxLength(80);
            entity.Property(x => x.CorreoInstitucional).HasColumnName("correo_institucional").HasMaxLength(180).IsRequired();
            entity.Property(x => x.Puesto).HasColumnName("puesto").HasMaxLength(120);
            entity.Property(x => x.Activo).HasColumnName("activo");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
        });

        modelBuilder.Entity<Rol>(entity =>
        {
            entity.ToTable("rol");
            entity.HasKey(x => x.RolId);
            entity.Property(x => x.RolId).HasColumnName("rol_id");
            entity.Property(x => x.Clave).HasColumnName("clave").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(100).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(500);
            entity.Property(x => x.Activo).HasColumnName("activo");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
        });

        modelBuilder.Entity<UsuarioCredencial>(entity =>
        {
            entity.ToTable("usuario_credencial");
            entity.HasKey(x => x.UsuarioId);
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.LoginUsuario).HasColumnName("login_usuario").HasMaxLength(80).IsRequired();
            entity.Property(x => x.PasswordHash).HasColumnName("password_hash").IsRequired();
            entity.Property(x => x.PasswordSalt).HasColumnName("password_salt").IsRequired();
            entity.Property(x => x.AlgoritmoHash).HasColumnName("algoritmo_hash").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Iteraciones).HasColumnName("iteraciones");
            entity.Property(x => x.UltimoAcceso).HasColumnName("ultimo_acceso");
            entity.Property(x => x.IntentosFallidos).HasColumnName("intentos_fallidos");
            entity.Property(x => x.BloqueadoHasta).HasColumnName("bloqueado_hasta");
            entity.Property(x => x.RequiereCambioPassword).HasColumnName("requiere_cambio_password");
            entity.Property(x => x.FechaActualizacion).HasColumnName("fecha_actualizacion");

            entity.HasOne(x => x.Usuario)
                .WithOne(x => x.UsuarioCredencial)
                .HasForeignKey<UsuarioCredencial>(x => x.UsuarioId)
                .HasConstraintName("FK_usuario_credencial_usuario");
        });

        modelBuilder.Entity<UsuarioRol>(entity =>
        {
            entity.ToTable("usuario_rol");
            entity.HasKey(x => x.UsuarioRolId);
            entity.Property(x => x.UsuarioRolId).HasColumnName("usuario_rol_id");
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.RolId).HasColumnName("rol_id");
            entity.Property(x => x.Activo).HasColumnName("activo");
            entity.Property(x => x.FechaAsignacion).HasColumnName("fecha_asignacion");
            entity.Property(x => x.FechaFin).HasColumnName("fecha_fin");

            entity.HasOne(x => x.Usuario)
                .WithMany(x => x.RolesUsuario)
                .HasForeignKey(x => x.UsuarioId)
                .HasConstraintName("FK_usuario_rol_usuario");

            entity.HasOne(x => x.Rol)
                .WithMany(x => x.UsuariosRol)
                .HasForeignKey(x => x.RolId)
                .HasConstraintName("FK_usuario_rol_rol");
        });

        modelBuilder.Entity<TipoSolicitud>(entity =>
        {
            entity.ToTable("tipo_solicitud");
            entity.HasKey(x => x.TipoSolicitudId);
            entity.Property(x => x.TipoSolicitudId).HasColumnName("tipo_solicitud_id");
            entity.Property(x => x.Clave).HasColumnName("clave").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(100).IsRequired();
            entity.Property(x => x.Activo).HasColumnName("activo");
        });

        modelBuilder.Entity<EstadoSolicitud>(entity =>
        {
            entity.ToTable("estado_solicitud");
            entity.HasKey(x => x.EstadoSolicitudId);
            entity.Property(x => x.EstadoSolicitudId).HasColumnName("estado_solicitud_id");
            entity.Property(x => x.Clave).HasColumnName("clave").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(100).IsRequired();
            entity.Property(x => x.EsTerminal).HasColumnName("es_terminal");
            entity.Property(x => x.Activo).HasColumnName("activo");
        });

        modelBuilder.Entity<PrioridadSolicitud>(entity =>
        {
            entity.ToTable("prioridad_solicitud");
            entity.HasKey(x => x.PrioridadSolicitudId);
            entity.Property(x => x.PrioridadSolicitudId).HasColumnName("prioridad_solicitud_id");
            entity.Property(x => x.Clave).HasColumnName("clave").HasMaxLength(20).IsRequired();
            entity.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(50).IsRequired();
            entity.Property(x => x.Peso).HasColumnName("peso");
            entity.Property(x => x.Activo).HasColumnName("activo");
        });

        modelBuilder.Entity<Solicitud>(entity =>
        {
            entity.ToTable("solicitud");
            entity.HasKey(x => x.SolicitudId);
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.Folio).HasColumnName("folio").HasMaxLength(40).IsRequired();
            entity.Property(x => x.Titulo).HasColumnName("titulo").HasMaxLength(200).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").IsRequired();
            entity.Property(x => x.AreaSolicitanteId).HasColumnName("area_solicitante_id");
            entity.Property(x => x.SistemaId).HasColumnName("sistema_id");
            entity.Property(x => x.TipoSolicitudId).HasColumnName("tipo_solicitud_id");
            entity.Property(x => x.PrioridadSolicitudId).HasColumnName("prioridad_solicitud_id");
            entity.Property(x => x.EstadoSolicitudId).HasColumnName("estado_solicitud_id");
            entity.Property(x => x.CreadoPorUsuarioId).HasColumnName("creado_por_usuario_id");
            entity.Property(x => x.FechaSolicitud).HasColumnName("fecha_solicitud");
            entity.Property(x => x.FechaCompromiso).HasColumnName("fecha_compromiso");
            entity.Property(x => x.FechaResolucion).HasColumnName("fecha_resolucion");
            entity.Property(x => x.EsfuerzoHoras).HasColumnName("esfuerzo_horas").HasPrecision(10, 2);
            entity.Property(x => x.Activo).HasColumnName("activo");

            entity.HasOne(x => x.TipoSolicitud)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.TipoSolicitudId)
                .HasConstraintName("FK_solicitud_tipo_solicitud");

            entity.HasOne(x => x.PrioridadSolicitud)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.PrioridadSolicitudId)
                .HasConstraintName("FK_solicitud_prioridad_solicitud");

            entity.HasOne(x => x.EstadoSolicitud)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.EstadoSolicitudId)
                .HasConstraintName("FK_solicitud_estado_solicitud");

            entity.HasOne(x => x.CreadoPorUsuario)
                .WithMany()
                .HasForeignKey(x => x.CreadoPorUsuarioId)
                .HasConstraintName("FK_solicitud_usuario");
        });

        modelBuilder.Entity<SolicitudAprobacion>(entity =>
        {
            entity.ToTable("solicitud_aprobacion");
            entity.HasKey(x => x.SolicitudAprobacionId);
            entity.Property(x => x.SolicitudAprobacionId).HasColumnName("solicitud_aprobacion_id");
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.UsuarioAprobadorId).HasColumnName("usuario_aprobador_id");
            entity.Property(x => x.DecisionClave).HasColumnName("decision_clave").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Comentario).HasColumnName("comentario").HasMaxLength(2000);
            entity.Property(x => x.FechaDecision).HasColumnName("fecha_decision");
            entity.Property(x => x.Activo).HasColumnName("activo");

            entity.HasOne(x => x.Solicitud)
                .WithMany(x => x.Aprobaciones)
                .HasForeignKey(x => x.SolicitudId)
                .HasConstraintName("FK_solicitud_aprobacion_solicitud");

            entity.HasOne(x => x.UsuarioAprobador)
                .WithMany(x => x.AprobacionesRealizadas)
                .HasForeignKey(x => x.UsuarioAprobadorId)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_solicitud_aprobacion_usuario");
        });

        modelBuilder.Entity<SolicitudComentario>(entity =>
        {
            entity.ToTable("solicitud_comentario");
            entity.HasKey(x => x.SolicitudComentarioId);
            entity.Property(x => x.SolicitudComentarioId).HasColumnName("solicitud_comentario_id");
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.Comentario).HasColumnName("comentario").HasMaxLength(2000).IsRequired();
            entity.Property(x => x.EsInterno).HasColumnName("es_interno");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            entity.Property(x => x.Activo).HasColumnName("activo");

            entity.HasOne(x => x.Solicitud)
                .WithMany(x => x.Comentarios)
                .HasForeignKey(x => x.SolicitudId)
                .HasConstraintName("FK_solicitud_comentario_solicitud");

            entity.HasOne(x => x.Usuario)
                .WithMany(x => x.ComentariosRealizados)
                .HasForeignKey(x => x.UsuarioId)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_solicitud_comentario_usuario");
        });

        modelBuilder.Entity<SolicitudHistorialEstado>(entity =>
        {
            entity.ToTable("solicitud_historial_estado");
            entity.HasKey(x => x.SolicitudHistorialEstadoId);
            entity.Property(x => x.SolicitudHistorialEstadoId).HasColumnName("solicitud_historial_estado_id");
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.EstadoAnteriorId).HasColumnName("estado_anterior_id");
            entity.Property(x => x.EstadoNuevoId).HasColumnName("estado_nuevo_id");
            entity.Property(x => x.CambiadoPorUsuarioId).HasColumnName("cambiado_por_usuario_id");
            entity.Property(x => x.FechaCambio).HasColumnName("fecha_cambio");
            entity.Property(x => x.Comentario).HasColumnName("comentario").HasMaxLength(2000);
            entity.Property(x => x.Activo).HasColumnName("activo");

            entity.HasOne(x => x.Solicitud)
                .WithMany(x => x.HistorialEstados)
                .HasForeignKey(x => x.SolicitudId)
                .HasConstraintName("FK_solicitud_historial_estado_solicitud");

            entity.HasOne(x => x.EstadoAnterior)
                .WithMany()
                .HasForeignKey(x => x.EstadoAnteriorId)
                .HasConstraintName("FK_solicitud_historial_estado_anterior");

            entity.HasOne(x => x.EstadoNuevo)
                .WithMany()
                .HasForeignKey(x => x.EstadoNuevoId)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_solicitud_historial_estado_nuevo");

            entity.HasOne(x => x.CambiadoPorUsuario)
                .WithMany()
                .HasForeignKey(x => x.CambiadoPorUsuarioId)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_solicitud_historial_estado_usuario");
        });

        modelBuilder.Entity<Notificacion>(entity =>
        {
            entity.ToTable("notificacion");
            entity.HasKey(x => x.NotificacionId);
            entity.Property(x => x.NotificacionId).HasColumnName("notificacion_id");
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.TipoClave).HasColumnName("tipo_clave").HasMaxLength(30).IsRequired();
            entity.Property(x => x.Titulo).HasColumnName("titulo").HasMaxLength(200).IsRequired();
            entity.Property(x => x.Mensaje).HasColumnName("mensaje").HasMaxLength(2000).IsRequired();
            entity.Property(x => x.UrlDestino).HasColumnName("url_destino").HasMaxLength(300);
            entity.Property(x => x.Leida).HasColumnName("leida");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            entity.Property(x => x.FechaLectura).HasColumnName("fecha_lectura");
            entity.Property(x => x.Activa).HasColumnName("activa");

            entity.HasOne(x => x.Usuario)
                .WithMany()
                .HasForeignKey(x => x.UsuarioId)
                .OnDelete(DeleteBehavior.NoAction)
                .HasConstraintName("FK_notificacion_usuario");

            entity.HasOne(x => x.Solicitud)
                .WithMany()
                .HasForeignKey(x => x.SolicitudId)
                .HasConstraintName("FK_notificacion_solicitud");
        });
    }
}