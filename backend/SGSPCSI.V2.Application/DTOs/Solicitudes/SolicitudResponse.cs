namespace SGSPCSI.V2.Application.DTOs.Solicitudes;

public class SolicitudResponse
{
    public long SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int AreaSolicitanteId { get; set; }
    public int? SistemaId { get; set; }
    public int TipoSolicitudId { get; set; }
    public int PrioridadSolicitudId { get; set; }
    public int EstadoSolicitudId { get; set; }
    public int CreadoPorUsuarioId { get; set; }
    public DateTime FechaSolicitud { get; set; }
    public DateTime? FechaCompromiso { get; set; }
    public DateTime? FechaResolucion { get; set; }
    public decimal? EsfuerzoHoras { get; set; }
    public bool Activo { get; set; }
}
