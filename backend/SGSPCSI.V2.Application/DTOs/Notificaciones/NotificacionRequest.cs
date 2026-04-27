namespace SGSPCSI.V2.Application.DTOs.Notificaciones;

public class NotificacionRequest
{
    public int UsuarioId { get; set; }
    public long? SolicitudId { get; set; }
    public string TipoClave { get; set; } = string.Empty;
    public string Titulo { get; set; } = string.Empty;
    public string Mensaje { get; set; } = string.Empty;
    public string? UrlDestino { get; set; }
}
