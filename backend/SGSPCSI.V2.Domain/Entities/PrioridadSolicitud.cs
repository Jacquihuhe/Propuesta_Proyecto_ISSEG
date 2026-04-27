namespace SGSPCSI.V2.Domain.Entities;

public class PrioridadSolicitud
{
    public int PrioridadSolicitudId { get; set; }
    public string Clave { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public byte Peso { get; set; }
    public bool Activo { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}
