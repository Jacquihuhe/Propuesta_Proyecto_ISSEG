using SGSPCSI.V2.Application.DTOs.Aprobaciones;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Services;

public class AprobacionService : IAprobacionService
{
    private readonly IAprobacionRepository _aprobacionRepository;
    private readonly ICatalogoSolicitudRepository _catalogoSolicitudRepository;
    private readonly IHistorialSolicitudRepository _historialSolicitudRepository;
    private readonly INotificacionRepository _notificacionRepository;
    private readonly IUnitOfWork _unitOfWork;

    public AprobacionService(
        IAprobacionRepository aprobacionRepository,
        ICatalogoSolicitudRepository catalogoSolicitudRepository,
        IHistorialSolicitudRepository historialSolicitudRepository,
        INotificacionRepository notificacionRepository,
        IUnitOfWork unitOfWork)
    {
        _aprobacionRepository = aprobacionRepository;
        _catalogoSolicitudRepository = catalogoSolicitudRepository;
        _historialSolicitudRepository = historialSolicitudRepository;
        _notificacionRepository = notificacionRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<IReadOnlyCollection<AprobacionPendienteResponse>> ListPendientesAsync(
        int? tipoSolicitudId,
        int? prioridadSolicitudId,
        int? areaSolicitanteId,
        CancellationToken cancellationToken = default)
    {
        var solicitudes = await _aprobacionRepository.ListPendientesAsync(
            tipoSolicitudId,
            prioridadSolicitudId,
            areaSolicitanteId,
            cancellationToken);

        return solicitudes.Select(MapPendiente).ToArray();
    }

    public Task<DecisionSolicitudResponse> AprobarAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default)
    {
        return EjecutarDecisionAsync(solicitudId, request, "APROBADA", requiereComentario: false, cancellationToken);
    }

    public Task<DecisionSolicitudResponse> RechazarAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default)
    {
        return EjecutarDecisionAsync(solicitudId, request, "RECHAZADA", requiereComentario: true, cancellationToken);
    }

    public Task<DecisionSolicitudResponse> SolicitarInformacionAsync(long solicitudId, DecisionSolicitudRequest request, CancellationToken cancellationToken = default)
    {
        return EjecutarDecisionAsync(solicitudId, request, "REQUIERE_INFO", requiereComentario: true, cancellationToken);
    }

    public async Task<SolicitudComentarioResponse> ComentarAsync(long solicitudId, CreateSolicitudComentarioRequest request, CancellationToken cancellationToken = default)
    {
        var solicitud = await _aprobacionRepository.GetSolicitudByIdForUpdateAsync(solicitudId, cancellationToken)
            ?? throw new KeyNotFoundException("La solicitud no existe.");

        if (request.UsuarioId <= 0)
        {
            throw new InvalidOperationException("El usuario que comenta es obligatorio.");
        }

        if (string.IsNullOrWhiteSpace(request.Comentario))
        {
            throw new InvalidOperationException("El comentario no puede ir vacio.");
        }

        var comentario = new SolicitudComentario
        {
            SolicitudId = solicitud.SolicitudId,
            UsuarioId = request.UsuarioId,
            Comentario = request.Comentario.Trim(),
            EsInterno = request.EsInterno,
            FechaCreacion = DateTime.UtcNow,
            Activo = true
        };

        await _aprobacionRepository.AddComentarioAsync(comentario, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new SolicitudComentarioResponse
        {
            SolicitudComentarioId = comentario.SolicitudComentarioId,
            SolicitudId = comentario.SolicitudId,
            UsuarioId = comentario.UsuarioId,
            UsuarioNombre = string.Empty,
            Comentario = comentario.Comentario,
            EsInterno = comentario.EsInterno,
            FechaCreacion = comentario.FechaCreacion
        };
    }

    public async Task<IReadOnlyCollection<SolicitudComentarioResponse>> ListComentariosAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        var comentarios = await _aprobacionRepository.ListComentariosBySolicitudAsync(solicitudId, cancellationToken);
        return comentarios.Select(x => new SolicitudComentarioResponse
        {
            SolicitudComentarioId = x.SolicitudComentarioId,
            SolicitudId = x.SolicitudId,
            UsuarioId = x.UsuarioId,
            UsuarioNombre = BuildNombreCompleto(x.Usuario),
            Comentario = x.Comentario,
            EsInterno = x.EsInterno,
            FechaCreacion = x.FechaCreacion
        }).ToArray();
    }

    private async Task<DecisionSolicitudResponse> EjecutarDecisionAsync(
        long solicitudId,
        DecisionSolicitudRequest request,
        string estadoDestinoClave,
        bool requiereComentario,
        CancellationToken cancellationToken)
    {
        var solicitud = await _aprobacionRepository.GetSolicitudByIdForUpdateAsync(solicitudId, cancellationToken)
            ?? throw new KeyNotFoundException("La solicitud no existe.");

        if (request.UsuarioAprobadorId <= 0)
        {
            throw new InvalidOperationException("El usuario aprobador es obligatorio.");
        }

        var comentario = request.Comentario?.Trim();

        if (requiereComentario && string.IsNullOrWhiteSpace(comentario))
        {
            throw new InvalidOperationException("Debe capturar un comentario para esta accion.");
        }

        var estadoDestino = await _catalogoSolicitudRepository.GetEstadoByClaveAsync(estadoDestinoClave, cancellationToken)
            ?? throw new InvalidOperationException($"No existe estado {estadoDestinoClave}.");

        var estadoAnteriorId = solicitud.EstadoSolicitudId;

        solicitud.EstadoSolicitudId = estadoDestino.EstadoSolicitudId;

        if (estadoDestinoClave == "APROBADA" || estadoDestinoClave == "RECHAZADA")
        {
            solicitud.FechaResolucion = DateTime.UtcNow;
        }
        else
        {
            solicitud.FechaResolucion = null;
        }

        var aprobacion = new SolicitudAprobacion
        {
            SolicitudId = solicitud.SolicitudId,
            UsuarioAprobadorId = request.UsuarioAprobadorId,
            DecisionClave = estadoDestinoClave,
            Comentario = comentario,
            FechaDecision = DateTime.UtcNow,
            Activo = true
        };

        await _aprobacionRepository.AddAprobacionAsync(aprobacion, cancellationToken);

        await _historialSolicitudRepository.AddAsync(new SolicitudHistorialEstado
        {
            SolicitudId = solicitud.SolicitudId,
            EstadoAnteriorId = estadoAnteriorId,
            EstadoNuevoId = estadoDestino.EstadoSolicitudId,
            CambiadoPorUsuarioId = request.UsuarioAprobadorId,
            FechaCambio = DateTime.UtcNow,
            Comentario = comentario,
            Activo = true
        }, cancellationToken);

        await _notificacionRepository.AddAsync(new Notificacion
        {
            UsuarioId = solicitud.CreadoPorUsuarioId,
            SolicitudId = solicitud.SolicitudId,
            TipoClave = estadoDestinoClave,
            Titulo = BuildTituloNotificacion(estadoDestinoClave),
            Mensaje = BuildMensajeNotificacion(estadoDestinoClave, solicitud.Folio, comentario),
            UrlDestino = solicitudId > 0 ? $"notificaciones.html?solicitudId={solicitud.SolicitudId}" : null,
            Leida = false,
            FechaCreacion = DateTime.UtcNow,
            FechaLectura = null,
            Activa = true
        }, cancellationToken);

        if (!string.IsNullOrWhiteSpace(comentario))
        {
            await _aprobacionRepository.AddComentarioAsync(new SolicitudComentario
            {
                SolicitudId = solicitud.SolicitudId,
                UsuarioId = request.UsuarioAprobadorId,
                Comentario = comentario,
                EsInterno = false,
                FechaCreacion = DateTime.UtcNow,
                Activo = true
            }, cancellationToken);
        }

        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new DecisionSolicitudResponse
        {
            SolicitudId = solicitud.SolicitudId,
            Folio = solicitud.Folio,
            EstadoClave = estadoDestino.Clave,
            EstadoNombre = estadoDestino.Nombre,
            FechaActualizacion = DateTime.UtcNow
        };
    }

    public async Task<IReadOnlyCollection<SolicitudHistorialEstadoResponse>> ListHistorialAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        var historial = await _historialSolicitudRepository.ListBySolicitudAsync(solicitudId, cancellationToken);

        return historial.Select(item => new SolicitudHistorialEstadoResponse
        {
            SolicitudHistorialEstadoId = item.SolicitudHistorialEstadoId,
            SolicitudId = item.SolicitudId,
            EstadoAnterior = item.EstadoAnterior?.Nombre,
            EstadoNuevo = item.EstadoNuevo?.Nombre ?? string.Empty,
            CambiadoPorUsuarioId = item.CambiadoPorUsuarioId,
            CambiadoPorNombre = BuildNombreCompleto(item.CambiadoPorUsuario),
            FechaCambio = item.FechaCambio,
            Comentario = item.Comentario
        }).ToArray();
    }

    private static AprobacionPendienteResponse MapPendiente(Solicitud solicitud)
    {
        return new AprobacionPendienteResponse
        {
            SolicitudId = solicitud.SolicitudId,
            Folio = solicitud.Folio,
            Titulo = solicitud.Titulo,
            Descripcion = solicitud.Descripcion,
            AreaSolicitanteId = solicitud.AreaSolicitanteId,
            FechaSolicitud = solicitud.FechaSolicitud,
            TipoSolicitudId = solicitud.TipoSolicitudId,
            TipoSolicitudNombre = solicitud.TipoSolicitud?.Nombre ?? "N/D",
            PrioridadSolicitudId = solicitud.PrioridadSolicitudId,
            PrioridadClave = solicitud.PrioridadSolicitud?.Clave ?? "N/D",
            PrioridadNombre = solicitud.PrioridadSolicitud?.Nombre ?? "N/D",
            EstadoSolicitudId = solicitud.EstadoSolicitudId,
            EstadoClave = solicitud.EstadoSolicitud?.Clave ?? "N/D",
            EstadoNombre = solicitud.EstadoSolicitud?.Nombre ?? "N/D",
            CreadoPorUsuarioId = solicitud.CreadoPorUsuarioId,
            SolicitanteNombre = BuildNombreCompleto(solicitud.CreadoPorUsuario)
        };
    }

    private static string BuildNombreCompleto(Usuario? usuario)
    {
        if (usuario is null)
        {
            return "N/D";
        }

        return string.Join(" ", new[]
        {
            usuario.NombrePila,
            usuario.ApellidoPaterno,
            usuario.ApellidoMaterno
        }.Where(x => !string.IsNullOrWhiteSpace(x)));
    }

    private static string BuildTituloNotificacion(string estadoDestinoClave)
    {
        return estadoDestinoClave switch
        {
            "APROBADA" => "Solicitud aprobada",
            "RECHAZADA" => "Solicitud rechazada",
            "REQUIERE_INFO" => "Información adicional requerida",
            _ => "Actualización de solicitud"
        };
    }

    private static string BuildMensajeNotificacion(string estadoDestinoClave, string folio, string? comentario)
    {
        var detalleComentario = string.IsNullOrWhiteSpace(comentario) ? string.Empty : $" Detalle: {comentario.Trim()}";

        return estadoDestinoClave switch
        {
            "APROBADA" => $"Tu solicitud {folio} fue aprobada.{detalleComentario}",
            "RECHAZADA" => $"Tu solicitud {folio} fue rechazada.{detalleComentario}",
            "REQUIERE_INFO" => $"Tu solicitud {folio} requiere información adicional.{detalleComentario}",
            _ => $"Tu solicitud {folio} tuvo una actualización.{detalleComentario}"
        };
    }
}
