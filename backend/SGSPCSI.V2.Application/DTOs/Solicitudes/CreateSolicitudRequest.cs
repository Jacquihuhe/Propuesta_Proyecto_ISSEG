namespace SGSPCSI.V2.Application.DTOs.Solicitudes;

public class CreateSolicitudRequest
{
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int AreaSolicitanteId { get; set; }
    public int? SistemaId { get; set; }
    public int TipoSolicitudId { get; set; }
    public int PrioridadSolicitudId { get; set; }
    public int CreadoPorUsuarioId { get; set; }
    public DateTime? FechaCompromiso { get; set; }
}
