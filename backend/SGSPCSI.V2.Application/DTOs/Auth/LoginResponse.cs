namespace SGSPCSI.V2.Application.DTOs.Auth;

public class LoginResponse
{
    public int UsuarioId { get; set; }
    public string CorreoElectronico { get; set; } = string.Empty;
    public string NombreCompleto { get; set; } = string.Empty;
    public IReadOnlyCollection<string> Roles { get; set; } = Array.Empty<string>();
    public string Mensaje { get; set; } = "Acceso autorizado";
}