using SGSPCSI.V2.Application.DTOs.Auth;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Application.Interfaces.Services;

namespace SGSPCSI.V2.Application.Services;

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
        var login = request.CorreoElectronico.Trim().ToLowerInvariant();
        var usuario = await _usuarioRepository.GetByLoginAsync(login, cancellationToken);

        if (usuario is null || !usuario.Activo || usuario.UsuarioCredencial is null)
        {
            return null;
        }

        var credential = usuario.UsuarioCredencial;

        if (!_passwordHashService.Verify(request.Contrasena, credential))
        {
            return null;
        }

        var rolesActivos = usuario.RolesUsuario
            .Where(x => x.Activo && x.Rol is not null && x.Rol.Activo)
            .Select(x => x.Rol!.Clave)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

        return new LoginResponse
        {
            UsuarioId = usuario.UsuarioId,
            CorreoElectronico = usuario.CorreoInstitucional,
            NombreCompleto = BuildNombreCompleto(usuario),
            Roles = rolesActivos,
            Mensaje = "Acceso autorizado"
        };
    }

    private static string BuildNombreCompleto(Domain.Entities.Usuario usuario)
    {
        return string.Join(" ", new[] { usuario.NombrePila, usuario.ApellidoPaterno, usuario.ApellidoMaterno }
            .Where(x => !string.IsNullOrWhiteSpace(x)));
    }
}