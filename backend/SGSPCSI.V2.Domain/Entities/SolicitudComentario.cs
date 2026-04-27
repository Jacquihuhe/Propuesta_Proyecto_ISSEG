namespace SGSPCSI.V2.Domain.Entities;

public class SolicitudComentario
{
    public long SolicitudComentarioId { get; set; }
    public long SolicitudId { get; set; }
    public int UsuarioId { get; set; }
    public string Comentario { get; set; } = string.Empty;
    public bool EsInterno { get; set; }
    public DateTime FechaCreacion { get; set; }
    public bool Activo { get; set; }

    public Solicitud? Solicitud { get; set; }
    public Usuario? Usuario { get; set; }
}
