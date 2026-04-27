namespace SGSPCSI.V2.Domain.Entities;

public class Usuario
{
    public int UsuarioId { get; set; }
    public string NombrePila { get; set; } = string.Empty;
    public string ApellidoPaterno { get; set; } = string.Empty;
    public string? ApellidoMaterno { get; set; }
    public string CorreoInstitucional { get; set; } = string.Empty;
    public string? Puesto { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaCreacion { get; set; }

    public UsuarioCredencial? UsuarioCredencial { get; set; }
    public ICollection<UsuarioRol> RolesUsuario { get; set; } = new List<UsuarioRol>();
    public ICollection<SolicitudAprobacion> AprobacionesRealizadas { get; set; } = new List<SolicitudAprobacion>();
    public ICollection<SolicitudComentario> ComentariosRealizados { get; set; } = new List<SolicitudComentario>();
}