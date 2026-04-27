namespace SGSPCSI.V2.Domain.Entities;

public class SolicitudHistorialEstado
{
    public long SolicitudHistorialEstadoId { get; set; }
    public long SolicitudId { get; set; }
    public int? EstadoAnteriorId { get; set; }
    public int EstadoNuevoId { get; set; }
    public int CambiadoPorUsuarioId { get; set; }
    public DateTime FechaCambio { get; set; }
    public string? Comentario { get; set; }
    public bool Activo { get; set; }

    public Solicitud? Solicitud { get; set; }
    public EstadoSolicitud? EstadoAnterior { get; set; }
    public EstadoSolicitud? EstadoNuevo { get; set; }
    public Usuario? CambiadoPorUsuario { get; set; }
}
