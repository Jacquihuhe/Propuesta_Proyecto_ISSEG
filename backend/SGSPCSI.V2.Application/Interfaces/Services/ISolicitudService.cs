using SGSPCSI.V2.Application.DTOs.Solicitudes;

namespace SGSPCSI.V2.Application.Interfaces.Services;

public interface ISolicitudService
{
    Task<SolicitudResponse> CrearAsync(CreateSolicitudRequest request, CancellationToken cancellationToken = default);
    Task<SolicitudResponse?> ObtenerPorIdAsync(long solicitudId, CancellationToken cancellationToken = default);
    Task<IReadOnlyCollection<SolicitudResponse>> ListarPorUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default);
}
