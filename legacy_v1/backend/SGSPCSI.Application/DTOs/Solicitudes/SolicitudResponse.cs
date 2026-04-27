namespace SGSPCSI.Application.DTOs.Solicitudes;

public class SolicitudResponse
{
    public int SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public int TipoId { get; set; }
    public int? SubtipoId { get; set; }
    public int EstadoId { get; set; }
    public int UsuarioSolicitanteId { get; set; }
    public int? SolicitudPadreId { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public string Prioridad { get; set; } = string.Empty;
    public DateTime FechaCreacion { get; set; }
}