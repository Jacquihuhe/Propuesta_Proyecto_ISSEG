using Microsoft.AspNetCore.Mvc;
using SGSPCSI.Application.DTOs.Solicitudes;
using SGSPCSI.Application.Interfaces.Services;

namespace SGSPCSI.Api.Controllers;

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

    [HttpGet("{solicitudId:int}")]
    public async Task<ActionResult<SolicitudResponse>> ObtenerPorId(int solicitudId, CancellationToken cancellationToken)
    {
        var response = await _solicitudService.ObtenerPorIdAsync(solicitudId, cancellationToken);

        if (response is null)
        {
            return NotFound();
        }

        return Ok(response);
    }

    [HttpGet("por-usuario/{usuarioSolicitanteId:int}")]
    public async Task<ActionResult<IReadOnlyCollection<SolicitudResponse>>> ListarPorUsuario(int usuarioSolicitanteId, CancellationToken cancellationToken)
    {
        var response = await _solicitudService.ListarPorUsuarioAsync(usuarioSolicitanteId, cancellationToken);
        return Ok(response);
    }
}