namespace SGSPCSI.V2.Domain.Entities;

public class SolicitudAprobacion
{
    public long SolicitudAprobacionId { get; set; }
    public long SolicitudId { get; set; }
    public int UsuarioAprobadorId { get; set; }
    public string DecisionClave { get; set; } = string.Empty;
    public string? Comentario { get; set; }
    public DateTime FechaDecision { get; set; }
    public bool Activo { get; set; }

    public Solicitud? Solicitud { get; set; }
    public Usuario? UsuarioAprobador { get; set; }
}
