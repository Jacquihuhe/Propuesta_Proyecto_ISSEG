namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class AprobacionPendienteResponse
{
    public long SolicitudId { get; set; }
    public string Folio { get; set; } = string.Empty;
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int AreaSolicitanteId { get; set; }
    public DateTime FechaSolicitud { get; set; }
    public int TipoSolicitudId { get; set; }
    public string TipoSolicitudNombre { get; set; } = string.Empty;
    public int PrioridadSolicitudId { get; set; }
    public string PrioridadClave { get; set; } = string.Empty;
    public string PrioridadNombre { get; set; } = string.Empty;
    public int EstadoSolicitudId { get; set; }
    public string EstadoClave { get; set; } = string.Empty;
    public string EstadoNombre { get; set; } = string.Empty;
    public int CreadoPorUsuarioId { get; set; }
    public string SolicitanteNombre { get; set; } = string.Empty;
}
