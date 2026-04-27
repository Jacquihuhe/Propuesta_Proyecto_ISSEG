namespace SGSPCSI.V2.Domain.Entities;

public class Notificacion
{
    public long NotificacionId { get; set; }
    public int UsuarioId { get; set; }
    public long? SolicitudId { get; set; }
    public string TipoClave { get; set; } = string.Empty;
    public string Titulo { get; set; } = string.Empty;
    public string Mensaje { get; set; } = string.Empty;
    public string? UrlDestino { get; set; }
    public bool Leida { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime? FechaLectura { get; set; }
    public bool Activa { get; set; }

    public Usuario? Usuario { get; set; }
    public Solicitud? Solicitud { get; set; }
}
