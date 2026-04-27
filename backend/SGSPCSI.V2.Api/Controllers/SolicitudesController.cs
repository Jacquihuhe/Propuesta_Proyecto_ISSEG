using Microsoft.AspNetCore.Mvc;
using SGSPCSI.V2.Application.DTOs.Solicitudes;
using SGSPCSI.V2.Application.Interfaces.Services;

namespace SGSPCSI.V2.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SolicitudesController : ControllerBase
{
    private readonly ISolicitudService _solicitudService;

    public SolicitudesController(ISolicitudService solicitudService)
    {
        _solicitudService = solicitudService;
    }

    [HttpPost]
    public async Task<ActionResult<SolicitudResponse>> Crear([FromBody] CreateSolicitudRequest request, CancellationToken cancellationToken)
    {
        var response = await _solicitudService.CrearAsync(request, cancellationToken);
        return CreatedAtAction(nameof(ObtenerPorId), new { solicitudId = response.SolicitudId }, response);
    }

    [HttpGet("{solicitudId:long}")]
    public async Task<ActionResult<SolicitudResponse>> ObtenerPorId(long solicitudId, CancellationToken cancellationToken)
    {
        var response = await _solicitudService.ObtenerPorIdAsync(solicitudId, cancellationToken);
        return response is null ? NotFound() : Ok(response);
    }

    [HttpGet("por-usuario/{usuarioId:int}")]
    public async Task<ActionResult<IReadOnlyCollection<SolicitudResponse>>> ListarPorUsuario(int usuarioId, CancellationToken cancellationToken)
    {
        var response = await _solicitudService.ListarPorUsuarioAsync(usuarioId, cancellationToken);
        return Ok(response);
    }
}
