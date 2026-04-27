using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface IAprobacionRepository
{
    Task<IReadOnlyCollection<Solicitud>> ListPendientesAsync(
        int? tipoSolicitudId,
        int? prioridadSolicitudId,
        int? areaSolicitanteId,
        CancellationToken cancellationToken = default);

    Task<Solicitud?> GetSolicitudByIdForUpdateAsync(long solicitudId, CancellationToken cancellationToken = default);
    Task AddAprobacionAsync(SolicitudAprobacion aprobacion, CancellationToken cancellationToken = default);
    Task AddComentarioAsync(SolicitudComentario comentario, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudComentario>> ListComentariosBySolicitudAsync(long solicitudId, CancellationToken cancellationToken = default);
}
