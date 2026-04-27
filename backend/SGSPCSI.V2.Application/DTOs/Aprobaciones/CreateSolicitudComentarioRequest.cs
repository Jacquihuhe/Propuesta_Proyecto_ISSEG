namespace SGSPCSI.V2.Application.DTOs.Aprobaciones;

public class CreateSolicitudComentarioRequest
{
    public int UsuarioId { get; set; }
    public string Comentario { get; set; } = string.Empty;
    public bool EsInterno { get; set; } = true;
}
