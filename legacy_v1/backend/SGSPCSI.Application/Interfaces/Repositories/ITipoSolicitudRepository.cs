using SGSPCSI.Domain.Entities;

namespace SGSPCSI.Application.Interfaces.Repositories;

public interface ITipoSolicitudRepository
{
    Task<TipoSolicitud?> GetByIdAsync(int tipoId, CancellationToken cancellationToken = default);
}