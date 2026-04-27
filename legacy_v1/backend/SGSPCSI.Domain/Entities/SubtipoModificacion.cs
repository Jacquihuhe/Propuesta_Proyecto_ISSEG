namespace SGSPCSI.Domain.Entities;

public class SubtipoModificacion
{
    public int SubtipoId { get; set; }
    public string NombreSubtipo { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public bool Estado { get; set; }
    public DateTime FechaCreacion { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}