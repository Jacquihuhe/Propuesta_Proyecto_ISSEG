namespace SGSPCSI.V2.Domain.Entities;

public class UsuarioRol
{
    public long UsuarioRolId { get; set; }
    public int UsuarioId { get; set; }
    public int RolId { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaAsignacion { get; set; }
    public DateTime? FechaFin { get; set; }

    public Usuario? Usuario { get; set; }
    public Rol? Rol { get; set; }
}