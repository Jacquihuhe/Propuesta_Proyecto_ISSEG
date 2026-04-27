namespace SGSPCSI.Application.DTOs.Auth;

public class LoginResponse
{
    public int UsuarioId { get; set; }
    public string CorreoElectronico { get; set; } = string.Empty;
    public int RolId { get; set; }
    public string? Mensaje { get; set; }
}