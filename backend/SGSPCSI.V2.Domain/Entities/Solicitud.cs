namespace SGSPCSI.V2.Domain.Entities;

public class Solicitud
{
    public long SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int AreaSolicitanteId { get; set; }
    public int? SistemaId { get; set; }
    public int TipoSolicitudId { get; set; }
    public int PrioridadSolicitudId { get; set; }
    public int EstadoSolicitudId { get; set; }
    public int CreadoPorUsuarioId { get; set; }
    public DateTime FechaSolicitud { get; set; }
    public DateTime? FechaCompromiso { get; set; }
    public DateTime? FechaResolucion { get; set; }
    public decimal? EsfuerzoHoras { get; set; }
    public bool Activo { get; set; }

    public TipoSolicitud? TipoSolicitud { get; set; }
    public PrioridadSolicitud? PrioridadSolicitud { get; set; }
    public EstadoSolicitud? EstadoSolicitud { get; set; }
    public Usuario? CreadoPorUsuario { get; set; }
    public ICollection<SolicitudAprobacion> Aprobaciones { get; set; } = new List<SolicitudAprobacion>();
    public ICollection<SolicitudComentario> Comentarios { get; set; } = new List<SolicitudComentario>();
    public ICollection<SolicitudHistorialEstado> HistorialEstados { get; set; } = new List<SolicitudHistorialEstado>();
}
