using SGSPCSI.Domain.Entities;

namespace SGSPCSI.Application.Interfaces.Repositories;

public interface ISolicitudRepository
{
    Task<Solicitud?> GetByIdAsync(int solicitudId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<Solicitud>> GetByUsuarioSolicitanteIdAsync(int usuarioSolicitanteId, CancellationToken cancellationToken = default);
    Task AddAsync(Solicitud solicitud, CancellationToken cancellationToken = default);
}