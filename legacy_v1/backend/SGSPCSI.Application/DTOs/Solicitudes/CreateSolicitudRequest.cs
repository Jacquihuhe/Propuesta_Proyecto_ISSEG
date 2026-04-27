namespace SGSPCSI.Application.DTOs.Solicitudes;

public class CreateSolicitudRequest
{
    public int TipoId { get; set; }
    public int? SubtipoId { get; set; }
    public int UsuarioSolicitanteId { get; set; }
    public int? SolicitudPadreId { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public string Prioridad { get; set; } = "Media";
    public string? Impacto { get; set; }
    public string? RiesgoTecnico { get; set; }
    public string? ComplejidadEstimada { get; set; }
    public string? CriteriosExito { get; set; }
    public int? TiempoEstimadoHoras { get; set; }
    public bool RequiereRequerimientos { get; set; }
}