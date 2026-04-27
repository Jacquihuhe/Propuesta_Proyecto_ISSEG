using SGSPCSI.V2.Application.DTOs.Notificaciones;

namespace SGSPCSI.V2.Application.Interfaces.Services;

public interface INotificacionService
{
    Task CrearAsync(NotificacionRequest request, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<NotificacionResponse>> ListarPorUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task<int> ContarNoLeidasAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task MarcarLeidaAsync(long notificacionId, CancellationToken cancellationToken = default);
    Task MarcarTodasLeidasAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task EliminarAsync(long notificacionId, CancellationToken cancellationToken = default);
    Task EliminarLeidasAsync(int usuarioId, CancellationToken cancellationToken = default);
}
