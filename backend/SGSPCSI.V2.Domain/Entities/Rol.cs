namespace SGSPCSI.V2.Domain.Entities;

public class Rol
{
    public int RolId { get; set; }
    public string Clave { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaCreacion { get; set; }

    public ICollection<UsuarioRol> UsuariosRol { get; set; } = new List<UsuarioRol>();
}