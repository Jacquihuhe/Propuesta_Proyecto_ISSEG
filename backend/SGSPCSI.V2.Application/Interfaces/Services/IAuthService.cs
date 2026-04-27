using SGSPCSI.V2.Application.DTOs.Auth;

namespace SGSPCSI.V2.Application.Interfaces.Services;

public interface IAuthService
{
    Task<LoginResponse?> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);
}