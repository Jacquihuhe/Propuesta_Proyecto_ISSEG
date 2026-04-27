using Microsoft.AspNetCore.Mvc;
using SGSPCSI.V2.Application.DTOs.Notificaciones;
using SGSPCSI.V2.Application.Interfaces.Services;

namespace SGSPCSI.V2.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificacionesController : ControllerBase
{
    private readonly INotificacionService _notificacionService;

    public NotificacionesController(INotificacionService notificacionService)
    {
        _notificacionService = notificacionService;
    }

    [HttpGet("usuario/{usuarioId:int}")]
    public async Task<ActionResult<IReadOnlyCollection<NotificacionResponse>>> ListarPorUsuario(int usuarioId, CancellationToken cancellationToken)
    {
        var response = await _notificacionService.ListarPorUsuarioAsync(usuarioId, cancellationToken);
        return Ok(response);
    }

    [HttpGet("usuario/{usuarioId:int}/no-leidas")]
    public async Task<ActionResult<int>> ContarNoLeidas(int usuarioId, CancellationToken cancellationToken)
    {
        var response = await _notificacionService.ContarNoLeidasAsync(usuarioId, cancellationToken);
        return Ok(response);
    }

    [HttpPost("{notificacionId:long}/leer")]
    public async Task<IActionResult> MarcarLeida(long notificacionId, CancellationToken cancellationToken)
    {
        await _notificacionService.MarcarLeidaAsync(notificacionId, cancellationToken);
        return NoContent();
    }

    [HttpPost("usuario/{usuarioId:int}/leer-todas")]
    public async Task<IActionResult> MarcarTodasLeidas(int usuarioId, CancellationToken cancellationToken)
    {
        await _notificacionService.MarcarTodasLeidasAsync(usuarioId, cancellationToken);
        return NoContent();
    }

    [HttpDelete("{notificacionId:long}")]
    public async Task<IActionResult> Eliminar(long notificacionId, CancellationToken cancellationToken)
    {
        await _notificacionService.EliminarAsync(notificacionId, cancellationToken);
        return NoContent();
    }

    [HttpDelete("usuario/{usuarioId:int}/leidas")]
    public async Task<IActionResult> EliminarLeidas(int usuarioId, CancellationToken cancellationToken)
    {
        await _notificacionService.EliminarLeidasAsync(usuarioId, cancellationToken);
        return NoContent();
    }
}
