using SGSPCSI.Application.DTOs.Solicitudes;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Application.Interfaces.Services;
using SGSPCSI.Domain.Entities;

namespace SGSPCSI.Application.Services;

public class SolicitudService : ISolicitudService
{
    private readonly ISolicitudRepository _solicitudRepository;
    private readonly ITipoSolicitudRepository _tipoSolicitudRepository;
    private readonly IUnitOfWork _unitOfWork;

    public SolicitudService(ISolicitudRepository solicitudRepository, ITipoSolicitudRepository tipoSolicitudRepository, IUnitOfWork unitOfWork)
    {
        _solicitudRepository = solicitudRepository;
        _tipoSolicitudRepository = tipoSolicitudRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<SolicitudResponse> CrearAsync(CreateSolicitudRequest request, CancellationToken cancellationToken = default)
    {
        var tipoSolicitud = await _tipoSolicitudRepository.GetByIdAsync(request.TipoId, cancellationToken)
            ?? throw new InvalidOperationException("El tipo de solicitud no existe.");

        var solicitud = new Solicitud
        {
            TipoId = request.TipoId,
            SubtipoId = request.SubtipoId,
            EstadoId = 1,
            UsuarioSolicitanteId = request.UsuarioSolicitanteId,
            SolicitudPadreId = request.SolicitudPadreId,
            Titulo = request.Titulo.Trim(),
            Descripcion = request.Descripcion.Trim(),
            Prioridad = request.Prioridad.Trim(),
            Impacto = request.Impacto,
            RiesgoTecnico = request.RiesgoTecnico,
            ComplejidadEstimada = request.ComplejidadEstimada,
            CriteriosExito = request.CriteriosExito,
            TiempoEstimadoHoras = request.TiempoEstimadoHoras,
            RequiereRequerimientos = request.RequiereRequerimientos,
            FechaCreacion = DateTime.UtcNow,
            EstadoRegistro = true,
            FechaModificacion = DateTime.UtcNow,
            Folio = GenerarFolio(tipoSolicitud.PrefijoFolio)
        };

        await _solicitudRepository.AddAsync(solicitud, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return MapToResponse(solicitud);
    }

    public async Task<SolicitudResponse?> ObtenerPorIdAsync(int solicitudId, CancellationToken cancellationToken = default)
    {
        var solicitud = await _solicitudRepository.GetByIdAsync(solicitudId, cancellationToken);
        return solicitud is null ? null : MapToResponse(solicitud);
    }

    public async Task<IReadOnlyCollection<SolicitudResponse>> ListarPorUsuarioAsync(int usuarioSolicitanteId, CancellationToken cancellationToken = default)
    {
        var solicitudes = await _solicitudRepository.GetByUsuarioSolicitanteIdAsync(usuarioSolicitanteId, cancellationToken);
        return solicitudes.Select(MapToResponse).ToArray();
    }

    private static string GenerarFolio(string prefijo)
    {
        var timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");
        return $"{prefijo}-{timestamp}";
    }

    private static SolicitudResponse MapToResponse(Solicitud solicitud)
    {
        return new SolicitudResponse
        {
            SolicitudId = solicitud.SolicitudId,
            Folio = solicitud.Folio,
            TipoId = solicitud.TipoId,
            SubtipoId = solicitud.SubtipoId,
            EstadoId = solicitud.EstadoId,
            UsuarioSolicitanteId = solicitud.UsuarioSolicitanteId,
            SolicitudPadreId = solicitud.SolicitudPadreId,
            Titulo = solicitud.Titulo,
            Descripcion = solicitud.Descripcion,
            Prioridad = solicitud.Prioridad,
            FechaCreacion = solicitud.FechaCreacion
        };
    }
}