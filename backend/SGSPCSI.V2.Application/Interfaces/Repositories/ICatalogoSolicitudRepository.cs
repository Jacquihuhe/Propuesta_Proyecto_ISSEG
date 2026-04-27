using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface ICatalogoSolicitudRepository
{
    Task<TipoSolicitud?> GetTipoByIdAsync(int tipoSolicitudId, CancellationToken cancellationToken = default);
    Task<PrioridadSolicitud?> GetPrioridadByIdAsync(int prioridadSolicitudId, CancellationToken cancellationToken = default);
    Task<EstadoSolicitud?> GetEstadoByClaveAsync(string clave, CancellationToken cancellationToken = default);
}
