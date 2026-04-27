namespace SGSPCSI.Application.DTOs.Auth;

public class LoginRequest
{
    public string CorreoElectronico { get; set; } = string.Empty;
    public string Contrasena { get; set; } = string.Empty;
}