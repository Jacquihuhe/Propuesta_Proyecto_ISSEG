using Microsoft.EntityFrameworkCore;
using SGSPCSI.Domain.Entities;

namespace SGSPCSI.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<Usuario> Usuarios => Set<Usuario>();
    public DbSet<TipoSolicitud> TiposSolicitud => Set<TipoSolicitud>();
    public DbSet<SubtipoModificacion> SubtiposModificacion => Set<SubtipoModificacion>();
    public DbSet<EstadoSolicitud> EstadosSolicitud => Set<EstadoSolicitud>();
    public DbSet<Solicitud> Solicitudes => Set<Solicitud>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.ToTable("usuarios");
            entity.HasKey(x => x.UsuarioId);
            entity.Property(x => x.UsuarioId).HasColumnName("usuario_id");
            entity.Property(x => x.CorreoElectronico).HasColumnName("correo_electronico").HasMaxLength(100).IsRequired();
            entity.Property(x => x.ContrasenaHash).HasColumnName("contrasena_hash").HasMaxLength(255).IsRequired();
            entity.Property(x => x.RolId).HasColumnName("rol_id");
            entity.Property(x => x.Estado).HasColumnName("estado");
            entity.Property(x => x.IntentosFallidos).HasColumnName("intentos_fallidos");
            entity.Property(x => x.UltimoAcceso).HasColumnName("ultimo_acceso");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            entity.Property(x => x.FechaModificacion).HasColumnName("fecha_modificacion");
        });

        modelBuilder.Entity<TipoSolicitud>(entity =>
        {
            entity.ToTable("tipos_solicitud");
            entity.HasKey(x => x.TipoId);
            entity.Property(x => x.TipoId).HasColumnName("tipo_id");
            entity.Property(x => x.NombreTipo).HasColumnName("nombre_tipo").HasMaxLength(50).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            entity.Property(x => x.PrefijoFolio).HasColumnName("prefijo_folio").HasMaxLength(5).IsRequired();
            entity.Property(x => x.RequiereAprobacion).HasColumnName("requiere_aprobacion");
            entity.Property(x => x.Estado).HasColumnName("estado");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
        });

        modelBuilder.Entity<SubtipoModificacion>(entity =>
        {
            entity.ToTable("subtipos_modificacion");
            entity.HasKey(x => x.SubtipoId);
            entity.Property(x => x.SubtipoId).HasColumnName("subtipo_id");
            entity.Property(x => x.NombreSubtipo).HasColumnName("nombre_subtipo").HasMaxLength(50).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            entity.Property(x => x.Estado).HasColumnName("estado");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
        });

        modelBuilder.Entity<EstadoSolicitud>(entity =>
        {
            entity.ToTable("estados_solicitud");
            entity.HasKey(x => x.EstadoId);
            entity.Property(x => x.EstadoId).HasColumnName("estado_id");
            entity.Property(x => x.NombreEstado).HasColumnName("nombre_estado").HasMaxLength(50).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            entity.Property(x => x.Orden).HasColumnName("orden");
            entity.Property(x => x.EsTerminal).HasColumnName("es_terminal");
            entity.Property(x => x.Estado).HasColumnName("estado");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
        });

        modelBuilder.Entity<Solicitud>(entity =>
        {
            entity.ToTable("solicitudes");
            entity.HasKey(x => x.SolicitudId);
            entity.Property(x => x.SolicitudId).HasColumnName("solicitud_id");
            entity.Property(x => x.Folio).HasColumnName("folio").HasMaxLength(20).IsRequired();
            entity.Property(x => x.TipoId).HasColumnName("tipo_id");
            entity.Property(x => x.SubtipoId).HasColumnName("subtipo_id");
            entity.Property(x => x.EstadoId).HasColumnName("estado_id");
            entity.Property(x => x.UsuarioSolicitanteId).HasColumnName("usuario_solicitante_id");
            entity.Property(x => x.SolicitudPadreId).HasColumnName("solicitud_padre_id");
            entity.Property(x => x.Titulo).HasColumnName("titulo").HasMaxLength(255).IsRequired();
            entity.Property(x => x.Descripcion).HasColumnName("descripcion").IsRequired();
            entity.Property(x => x.Prioridad).HasColumnName("prioridad").HasMaxLength(20).IsRequired();
            entity.Property(x => x.Impacto).HasColumnName("impacto").HasMaxLength(20);
            entity.Property(x => x.RiesgoTecnico).HasColumnName("riesgo_tecnico").HasMaxLength(20);
            entity.Property(x => x.ComplejidadEstimada).HasColumnName("complejidad_estimada").HasMaxLength(20);
            entity.Property(x => x.CriteriosExito).HasColumnName("criterios_exito");
            entity.Property(x => x.TiempoEstimadoHoras).HasColumnName("tiempo_estimado_horas");
            entity.Property(x => x.RequiereRequerimientos).HasColumnName("requiere_requerimientos");
            entity.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            entity.Property(x => x.FechaVencimiento).HasColumnName("fecha_vencimiento");
            entity.Property(x => x.FechaEnvio).HasColumnName("fecha_envio");
            entity.Property(x => x.FechaAprobacion).HasColumnName("fecha_aprobacion");
            entity.Property(x => x.FechaInicioDesarrollo).HasColumnName("fecha_inicio_desarrollo");
            entity.Property(x => x.FechaPausa).HasColumnName("fecha_pausa");
            entity.Property(x => x.FechaReanudacion).HasColumnName("fecha_reanudacion");
            entity.Property(x => x.FechaFinalizacion).HasColumnName("fecha_finalizacion");
            entity.Property(x => x.MotivoRechazo).HasColumnName("motivo_rechazo");
            entity.Property(x => x.MotivoPausa).HasColumnName("motivo_pausa");
            entity.Property(x => x.Observaciones).HasColumnName("observaciones");
            entity.Property(x => x.EstadoRegistro).HasColumnName("estado_registro");
            entity.Property(x => x.FechaModificacion).HasColumnName("fecha_modificacion");

            entity.HasOne(x => x.UsuarioSolicitante)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.UsuarioSolicitanteId)
                .HasConstraintName("FK_solicitudes_usuarios");

            entity.HasOne(x => x.TipoSolicitud)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.TipoId)
                .HasConstraintName("FK_solicitudes_tipos_solicitud");

            entity.HasOne(x => x.SubtipoModificacion)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.SubtipoId)
                .HasConstraintName("FK_solicitudes_subtipos_modificacion");

            entity.HasOne(x => x.EstadoSolicitud)
                .WithMany(x => x.Solicitudes)
                .HasForeignKey(x => x.EstadoId)
                .HasConstraintName("FK_solicitudes_estados_solicitud");

            entity.HasOne(x => x.SolicitudPadre)
                .WithMany(x => x.SolicitudesHijas)
                .HasForeignKey(x => x.SolicitudPadreId)
                .HasConstraintName("FK_solicitudes_padre");
        });
    }
}