namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class DecisionSolicitudRequest
{
    public int UsuarioAprobadorId { get; set; }
    public string? Comentario { get; set; }
}
