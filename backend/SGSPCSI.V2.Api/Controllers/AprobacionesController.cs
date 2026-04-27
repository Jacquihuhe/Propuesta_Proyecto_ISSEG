using Microsoft.AspNetCore.Mvc;
using SGSPCSI.V2.Application.DTOs.Aprobaciones;
using SGSPCSI.V2.Application.Interfaces.Services;

namespace SGSPCSI.V2.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AprobacionesController : ControllerBase
{
    private readonly IAprobacionService _aprobacionService;

    public AprobacionesController(IAprobacionService aprobacionService)
    {
        _aprobacionService = aprobacionService;
    }

    [HttpGet("pendientes")]
    public async Task<ActionResult<IReadOnlyCollection<AprobacionPendienteResponse>>> ListPendientes(
        [FromQuery] int? tipoSolicitudId,
        [FromQuery] int? prioridadSolicitudId,
        [FromQuery] int? areaSolicitanteId,
        CancellationToken cancellationToken)
    {
        var response = await _aprobacionService.ListPendientesAsync(tipoSolicitudId, prioridadSolicitudId, areaSolicitanteId, cancellationToken);
        return Ok(response);
    }

    [HttpPost("{solicitudId:long}/aprobar")]
    public async Task<ActionResult<DecisionSolicitudResponse>> Aprobar(long solicitudId, [FromBody] DecisionSolicitudRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _aprobacionService.AprobarAsync(solicitudId, request, cancellationToken);
            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{solicitudId:long}/rechazar")]
    public async Task<ActionResult<DecisionSolicitudResponse>> Rechazar(long solicitudId, [FromBody] DecisionSolicitudRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _aprobacionService.RechazarAsync(solicitudId, request, cancellationToken);
            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{solicitudId:long}/solicitar-informacion")]
    public async Task<ActionResult<DecisionSolicitudResponse>> SolicitarInformacion(long solicitudId, [FromBody] DecisionSolicitudRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _aprobacionService.SolicitarInformacionAsync(solicitudId, request, cancellationToken);
            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{solicitudId:long}/comentarios")]
    public async Task<ActionResult<SolicitudComentarioResponse>> Comentar(long solicitudId, [FromBody] CreateSolicitudComentarioRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _aprobacionService.ComentarAsync(solicitudId, request, cancellationToken);
            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("{solicitudId:long}/comentarios")]
    public async Task<ActionResult<IReadOnlyCollection<SolicitudComentarioResponse>>> ListComentarios(long solicitudId, CancellationToken cancellationToken)
    {
        var response = await _aprobacionService.ListComentariosAsync(solicitudId, cancellationToken);
        return Ok(response);
    }

    [HttpGet("{solicitudId:long}/historial")]
    public async Task<ActionResult<IReadOnlyCollection<SolicitudHistorialEstadoResponse>>> ListHistorial(long solicitudId, CancellationToken cancellationToken)
    {
        var response = await _aprobacionService.ListHistorialAsync(solicitudId, cancellationToken);
        return Ok(response);
    }
}
