using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface IHistorialSolicitudRepository
{
    Task AddAsync(SolicitudHistorialEstado historial, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudHistorialEstado>> ListBySolicitudAsync(long solicitudId, CancellationToken cancellationToken = default);
}
