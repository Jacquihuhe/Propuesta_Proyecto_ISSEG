using SGSPCSI.Application.DTOs.Auth;

namespace SGSPCSI.Application.Interfaces.Services;

public interface IAuthService
{
    Task<LoginResponse?> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);
}