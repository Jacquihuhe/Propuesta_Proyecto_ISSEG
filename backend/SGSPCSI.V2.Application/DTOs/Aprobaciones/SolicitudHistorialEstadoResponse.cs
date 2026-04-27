namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class SolicitudHistorialEstadoResponse
{
    public long SolicitudHistorialEstadoId { get; set; }
    public long SolicitudId { get; set; }
    public string? EstadoAnterior { get; set; }
    public string EstadoNuevo { get; set; } = string.Empty;
    public int CambiadoPorUsuarioId { get; set; }
    public string CambiadoPorNombre { get; set; } = string.Empty;
    public DateTime FechaCambio { get; set; }
    public string? Comentario { get; set; }
}
