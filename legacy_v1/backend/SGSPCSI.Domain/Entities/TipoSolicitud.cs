namespace SGSPCSI.Domain.Entities;

public class TipoSolicitud
{
    public int TipoId { get; set; }
    public string NombreTipo { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public string PrefijoFolio { get; set; } = string.Empty;
    public bool RequiereAprobacion { get; set; }
    public bool Estado { get; set; }
    public DateTime FechaCreacion { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}