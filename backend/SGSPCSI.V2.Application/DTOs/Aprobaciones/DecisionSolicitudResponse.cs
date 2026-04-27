namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class DecisionSolicitudResponse
{
    public long SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public string EstadoClave { get; set; } = string.Empty;
    public string EstadoNombre { get; set; } = string.Empty;
    public DateTime FechaActualizacion { get; set; }
}
