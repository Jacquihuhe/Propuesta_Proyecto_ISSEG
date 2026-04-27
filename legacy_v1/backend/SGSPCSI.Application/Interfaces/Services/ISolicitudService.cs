using SGSPCSI.Application.DTOs.Solicitudes;

namespace SGSPCSI.Application.Interfaces.Services;

public interface ISolicitudService
{
    Task<SolicitudResponse> CrearAsync(CreateSolicitudRequest request, CancellationToken cancellationToken = default);
    Task<SolicitudResponse?> ObtenerPorIdAsync(int solicitudId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudResponse>> ListarPorUsuarioAsync(int usuarioSolicitanteId, CancellationToken cancellationToken = default);
}