namespace SGSPCSI.Domain.Entities;

public class Usuario
{
    public int UsuarioId { get; set; }
    public string CorreoElectronico { get; set; } = string.Empty;
    public string ContrasenaHash { get; set; } = string.Empty;
    public int RolId { get; set; }
    public bool Estado { get; set; }
    public int IntentosFallidos { get; set; }
    public DateTime? UltimoAcceso { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime FechaModificacion { get; set; }

    public ICollection<Solicitud> Solicitudes { get; set; } = new List<Solicitud>();
}