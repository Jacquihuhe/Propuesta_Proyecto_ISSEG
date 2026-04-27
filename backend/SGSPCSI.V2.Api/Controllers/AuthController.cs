using Microsoft.AspNetCore.Mvc;
using SGSPCSI.V2.Application.DTOs.Auth;
using SGSPCSI.V2.Application.Interfaces.Services;

namespace SGSPCSI.V2.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("login")]
    public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
    {
        var response = await _authService.LoginAsync(request, cancellationToken);

        if (response is null)
        {
            return Unauthorized(new { mensaje = "Credenciales invalidas." });
        }

        return Ok(response);
    }
}