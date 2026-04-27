namespace SGSPCSI.Domain.Entities;

public class Solicitud
{
    public int SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public int TipoId { get; set; }
    public int? SubtipoId { get; set; }
    public int EstadoId { get; set; }
    public int UsuarioSolicitanteId { get; set; }
    public int? SolicitudPadreId { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public string Prioridad { get; set; } = "Media";
    public string? Impacto { get; set; }
    public string? RiesgoTecnico { get; set; }
    public string? ComplejidadEstimada { get; set; }
    public string? CriteriosExito { get; set; }
    public int? TiempoEstimadoHoras { get; set; }
    public bool RequiereRequerimientos { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime? FechaVencimiento { get; set; }
    public DateTime? FechaEnvio { get; set; }
    public DateTime? FechaAprobacion { get; set; }
    public DateTime? FechaInicioDesarrollo { get; set; }
    public DateTime? FechaPausa { get; set; }
    public DateTime? FechaReanudacion { get; set; }
    public DateTime? FechaFinalizacion { get; set; }
    public string? MotivoRechazo { get; set; }
    public string? MotivoPausa { get; set; }
    public string? Observaciones { get; set; }
    public bool EstadoRegistro { get; set; }
    public DateTime FechaModificacion { get; set; }

    public Usuario? UsuarioSolicitante { get; set; }
    public TipoSolicitud? TipoSolicitud { get; set; }
    public SubtipoModificacion? SubtipoModificacion { get; set; }
    public EstadoSolicitud? EstadoSolicitud { get; set; }
    public Solicitud? SolicitudPadre { get; set; }
    public ICollection<Solicitud> SolicitudesHijas { get; set; } = new List<Solicitud>();
}