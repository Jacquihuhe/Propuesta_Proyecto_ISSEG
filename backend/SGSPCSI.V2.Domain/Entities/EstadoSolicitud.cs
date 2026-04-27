namespace SGSPCSI.V2.Domain.Entities;

public class EstadoSolicitud
{
    public int EstadoSolicitudId { get; set; }
    public string Clave { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public bool EsTerminal { get; set; }
    public bool Activo { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}
