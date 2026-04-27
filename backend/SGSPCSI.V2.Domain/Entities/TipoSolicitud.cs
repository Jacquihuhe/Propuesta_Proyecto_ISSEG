namespace SGSPCSI.V2.Domain.Entities;

public class TipoSolicitud
{
    public int TipoSolicitudId { get; set; }
    public string Clave { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public bool Activo { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}
