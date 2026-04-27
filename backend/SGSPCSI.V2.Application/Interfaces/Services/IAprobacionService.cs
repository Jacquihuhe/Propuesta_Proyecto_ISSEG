using SGSPCSI.V2.Application.DTOs.Aprobaciones;

namespace SGSPCSI.V2.Application.Interfaces.Services;

public interface IAprobacionService
{
    Task<IReadOnlyCollection<AprobacionPendienteResponse>> ListPendientesAsync(
        int? tipoSolicitudId,
        int? prioridadSolicitudId,
        int? areaSolicitanteId,
        CancellationToken cancellationToken = default);

    Task<DecisionSolicitudResponse> AprobarAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default);
    Task<DecisionSolicitudResponse> RechazarAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default);
    Task<DecisionSolicitudResponse> SolicitarInformacionAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default);
    Task<SolicitudComentarioResponse> ComentarAsync(long solicitudId, CreateSolicitudComentarioRequest request, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudComentarioResponse>> ListComentariosAsync(long solicitudId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudHistorialEstadoResponse>> ListHistorialAsync(long solicitudId, CancellationToken cancellationToken = default);
}
