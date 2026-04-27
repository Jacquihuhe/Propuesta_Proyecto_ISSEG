using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface INotificacionRepository
{
    Task AddAsync(Notificacion notificacion, CancellationToken cancellationToken = default);
    Task<Notificacion?> GetByIdAsync(long notificacionId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<Notificacion>> ListByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task<int> CountUnreadByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task MarkAllAsReadAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<Notificacion>> ListUnreadByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
}
