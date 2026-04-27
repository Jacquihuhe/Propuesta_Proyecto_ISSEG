using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class NotificacionRepository : INotificacionRepository
{
    private readonly ApplicationDbContext _context;

    public NotificacionRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task AddAsync(Notificacion notificacion, CancellationToken cancellationToken = default)
    {
        await _context.Notificaciones.AddAsync(notificacion, cancellationToken);
    }

    public Task<Notificacion?> GetByIdAsync(long notificacionId, CancellationToken cancellationToken = default)
    {
        return _context.Notificaciones.FirstOrDefaultAsync(x => x.NotificacionId == notificacionId && x.Activa, cancellationToken);
    }

    public async Task<IReadOnlyCollection<Notificacion>> ListByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return await _context.Notificaciones
            .AsNoTracking()
            .Where(x => x.UsuarioId == usuarioId && x.Activa)
            .OrderByDescending(x => x.FechaCreacion)
            .ToArrayAsync(cancellationToken);
    }

    public Task<int> CountUnreadByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return _context.Notificaciones.CountAsync(x => x.UsuarioId == usuarioId && x.Activa && !x.Leida, cancellationToken);
    }

    public async Task MarkAllAsReadAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        var notifications = await _context.Notificaciones
            .Where(x => x.UsuarioId == usuarioId && x.Activa && !x.Leida)
            .ToListAsync(cancellationToken);

        var now = DateTime.UtcNow;
        foreach (var notification in notifications)
        {
            notification.Leida = true;
            notification.FechaLectura = now;
        }
    }

    public async Task<IReadOnlyCollection<Notificacion>> ListUnreadByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return await _context.Notificaciones
            .AsNoTracking()
            .Where(x => x.UsuarioId == usuarioId && x.Activa && !x.Leida)
            .OrderByDescending(x => x.FechaCreacion)
            .ToArrayAsync(cancellationToken);
    }
}
