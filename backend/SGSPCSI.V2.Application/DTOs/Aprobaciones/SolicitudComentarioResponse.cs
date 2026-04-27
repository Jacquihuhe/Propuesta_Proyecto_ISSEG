namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class SolicitudComentarioResponse
{
    public long SolicitudComentarioId { get; set; }
    public long SolicitudId { get; set; }
    public int UsuarioId { get; set; }
    public string UsuarioNombre { get; set; } = string.Empty;
    public string Comentario { get; set; } = string.Empty;
    public bool EsInterno { get; set; }
    public DateTime FechaCreacion { get; set; }
}
