using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface ISolicitudRepository
{
    Task AddAsync(Solicitud solicitud, CancellationToken cancellationToken = default);
    Task<Solicitud?> GetByIdAsync(long solicitudId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<Solicitud>> ListByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
}
