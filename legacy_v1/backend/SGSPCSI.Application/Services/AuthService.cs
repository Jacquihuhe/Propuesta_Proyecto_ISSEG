using SGSPCSI.Application.DTOs.Auth;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Application.Interfaces.Services;

namespace SGSPCSI.Application.Services;

public class AuthService : IAuthService
{
    private readonly IUsuarioRepository _usuarioRepository;
    private readonly IPasswordHashService _passwordHashService;

    public AuthService(IUsuarioRepository usuarioRepository, IPasswordHashService passwordHashService)
    {
        _usuarioRepository = usuarioRepository;
        _passwordHashService = passwordHashService;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default)
    {
        var correo = request.CorreoElectronico.Trim().ToLowerInvariant();
        var usuario = await _usuarioRepository.GetByCorreoElectronicoAsync(correo, cancellationToken);

        if (usuario is null || !usuario.Estado || !_passwordHashService.Verify(usuario.ContrasenaHash, request.Contrasena))
        {
            return null;
        }

        return new LoginResponse
        {
            UsuarioId = usuario.UsuarioId,
            CorreoElectronico = usuario.CorreoElectronico,
            RolId = usuario.RolId,
            Mensaje = "Acceso autorizado"
        };
    }
}