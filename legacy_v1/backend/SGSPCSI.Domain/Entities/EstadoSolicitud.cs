namespace SGSPCSI.Domain.Entities;

public class EstadoSolicitud
{
    public int EstadoId { get; set; }
    public string NombreEstado { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public int? Orden { get; set; }
    public bool EsTerminal { get; set; }
    public bool Estado { get; set; }
    public DateTime FechaCreacion { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}