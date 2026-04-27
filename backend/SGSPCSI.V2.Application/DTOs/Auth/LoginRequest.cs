namespace SGSPCSI.V2.Application.DTOs.Auth;

public class LoginRequest
{
    public string CorreoElectronico { get; set; } = string.Empty;
    public string Contrasena { get; set; } = string.Empty;
}