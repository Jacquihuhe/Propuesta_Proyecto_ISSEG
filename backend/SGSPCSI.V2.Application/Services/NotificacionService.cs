using SGSPCSI.V2.Application.DTOs.Notificaciones;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Services;

public class NotificacionService : INotificacionService
{
    private readonly INotificacionRepository _notificacionRepository;
    private readonly IUnitOfWork _unitOfWork;

    public NotificacionService(INotificacionRepository notificacionRepository, IUnitOfWork unitOfWork)
    {
        _notificacionRepository = notificacionRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task CrearAsync(NotificacionRequest request, CancellationToken cancellationToken = default)
    {
        if (request.UsuarioId <= 0)
        {
            throw new InvalidOperationException("El usuario de la notificacion es obligatorio.");
        }

        if (string.IsNullOrWhiteSpace(request.TipoClave))
        {
            throw new InvalidOperationException("El tipo de notificacion es obligatorio.");
        }

        var notificacion = new Notificacion
        {
            UsuarioId = request.UsuarioId,
            SolicitudId = request.SolicitudId,
            TipoClave = request.TipoClave.Trim(),
            Titulo = request.Titulo.Trim(),
            Mensaje = request.Mensaje.Trim(),
            UrlDestino = string.IsNullOrWhiteSpace(request.UrlDestino) ? null : request.UrlDestino.Trim(),
            Leida = false,
            FechaCreacion = DateTime.UtcNow,
            FechaLectura = null,
            Activa = true
        };

        await _notificacionRepository.AddAsync(notificacion, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task<IReadOnlyCollection<NotificacionResponse>> ListarPorUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        var notificaciones = await _notificacionRepository.ListByUsuarioAsync(usuarioId, cancellationToken);
        return notificaciones.Select(MapToResponse).ToArray();
    }

    public Task<int> ContarNoLeidasAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return _notificacionRepository.CountUnreadByUsuarioAsync(usuarioId, cancellationToken);
    }

    public async Task MarcarLeidaAsync(long notificacionId, CancellationToken cancellationToken = default)
    {
        var notificacion = await _notificacionRepository.GetByIdAsync(notificacionId, cancellationToken)
            ?? throw new KeyNotFoundException("La notificacion no existe.");

        notificacion.Leida = true;
        notificacion.FechaLectura = DateTime.UtcNow;
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task MarcarTodasLeidasAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        await _notificacionRepository.MarkAllAsReadAsync(usuarioId, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task EliminarAsync(long notificacionId, CancellationToken cancellationToken = default)
    {
        var notificacion = await _notificacionRepository.GetByIdAsync(notificacionId, cancellationToken)
            ?? throw new KeyNotFoundException("La notificacion no existe.");

        notificacion.Activa = false;
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task EliminarLeidasAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        var notificaciones = await _notificacionRepository.ListByUsuarioAsync(usuarioId, cancellationToken);
        foreach (var notificacion in notificaciones.Where(x => x.Leida))
        {
            notificacion.Activa = false;
        }

        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    private static NotificacionResponse MapToResponse(Notificacion notificacion)
    {
        return new NotificacionResponse
        {
            NotificacionId = notificacion.NotificacionId,
            UsuarioId = notificacion.UsuarioId,
            SolicitudId = notificacion.SolicitudId,
            TipoClave = notificacion.TipoClave,
            Titulo = notificacion.Titulo,
            Mensaje = notificacion.Mensaje,
            UrlDestino = notificacion.UrlDestino,
            Leida = notificacion.Leida,
            FechaCreacion = notificacion.FechaCreacion,
            FechaLectura = notificacion.FechaLectura
        };
    }
}
