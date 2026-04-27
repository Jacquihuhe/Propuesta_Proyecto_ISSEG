using SGSPCSI.V2.Application.DTOs.Solicitudes;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Services;

public class SolicitudService : ISolicitudService
{
    private readonly ISolicitudRepository _solicitudRepository;
    private readonly ICatalogoSolicitudRepository _catalogoSolicitudRepository;
    private readonly IUnitOfWork _unitOfWork;

    public SolicitudService(
        ISolicitudRepository solicitudRepository,
        ICatalogoSolicitudRepository catalogoSolicitudRepository,
        IUnitOfWork unitOfWork)
    {
        _solicitudRepository = solicitudRepository;
        _catalogoSolicitudRepository = catalogoSolicitudRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<SolicitudResponse> CrearAsync(CreateSolicitudRequest request, CancellationToken cancellationToken = default)
    {
        var tipo = await _catalogoSolicitudRepository.GetTipoByIdAsync(request.TipoSolicitudId, cancellationToken)
            ?? throw new InvalidOperationException("El tipo de solicitud no existe.");

        var prioridad = await _catalogoSolicitudRepository.GetPrioridadByIdAsync(request.PrioridadSolicitudId, cancellationToken)
            ?? throw new InvalidOperationException("La prioridad no existe.");

        var estadoInicial = await _catalogoSolicitudRepository.GetEstadoByClaveAsync("PENDIENTE", cancellationToken)
            ?? throw new InvalidOperationException("No existe estado inicial PENDIENTE.");

        var solicitud = new Solicitud
        {
            Folio = BuildFolio(tipo.Clave),
            Titulo = request.Titulo.Trim(),
            Descripcion = request.Descripcion.Trim(),
            AreaSolicitanteId = request.AreaSolicitanteId,
            SistemaId = request.SistemaId,
            TipoSolicitudId = tipo.TipoSolicitudId,
            PrioridadSolicitudId = prioridad.PrioridadSolicitudId,
            EstadoSolicitudId = estadoInicial.EstadoSolicitudId,
            CreadoPorUsuarioId = request.CreadoPorUsuarioId,
            FechaSolicitud = DateTime.UtcNow,
            FechaCompromiso = request.FechaCompromiso,
            FechaResolucion = null,
            EsfuerzoHoras = null,
            Activo = true
        };

        await _solicitudRepository.AddAsync(solicitud, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return MapToResponse(solicitud);
    }

    public async Task<SolicitudResponse?> ObtenerPorIdAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        var solicitud = await _solicitudRepository.GetByIdAsync(solicitudId, cancellationToken);
        return solicitud is null ? null : MapToResponse(solicitud);
    }

    public async Task<IReadOnlyCollection<SolicitudResponse>> ListarPorUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        var solicitudes = await _solicitudRepository.ListByUsuarioAsync(usuarioId, cancellationToken);
        return solicitudes.Select(MapToResponse).ToArray();
    }

    private static string BuildFolio(string tipoClave)
    {
        var prefix = string.IsNullOrWhiteSpace(tipoClave) ? "SOL" : tipoClave.Trim().ToUpperInvariant();
        return $"{prefix}-{DateTime.UtcNow:yyyyMMddHHmmss}";
    }

    private static SolicitudResponse MapToResponse(Solicitud solicitud)
    {
        return new SolicitudResponse
        {
            SolicitudId = solicitud.SolicitudId,
            Folio = solicitud.Folio,
            Titulo = solicitud.Titulo,
            Descripcion = solicitud.Descripcion,
            AreaSolicitanteId = solicitud.AreaSolicitanteId,
            SistemaId = solicitud.SistemaId,
            TipoSolicitudId = solicitud.TipoSolicitudId,
            PrioridadSolicitudId = solicitud.PrioridadSolicitudId,
            EstadoSolicitudId = solicitud.EstadoSolicitudId,
            CreadoPorUsuarioId = solicitud.CreadoPorUsuarioId,
            FechaSolicitud = solicitud.FechaSolicitud,
            FechaCompromiso = solicitud.FechaCompromiso,
            FechaResolucion = solicitud.FechaResolucion,
            EsfuerzoHoras = solicitud.EsfuerzoHoras,
            Activo = solicitud.Activo
        };
    }
}
