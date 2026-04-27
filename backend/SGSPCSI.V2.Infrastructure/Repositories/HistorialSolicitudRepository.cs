using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class HistorialSolicitudRepository : IHistorialSolicitudRepository
{
    private readonly ApplicationDbContext _context;

    public HistorialSolicitudRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task AddAsync(SolicitudHistorialEstado historial, CancellationToken cancellationToken = default)
    {
        await _context.SolicitudesHistorialEstado.AddAsync(historial, cancellationToken);
    }

    public async Task<IReadOnlyCollection<SolicitudHistorialEstado>> ListBySolicitudAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        return await _context.SolicitudesHistorialEstado
            .AsNoTracking()
            .Include(x => x.EstadoAnterior)
            .Include(x => x.EstadoNuevo)
            .Include(x => x.CambiadoPorUsuario)
            .Where(x => x.SolicitudId == solicitudId && x.Activo)
            .OrderByDescending(x => x.FechaCambio)
            .ToArrayAsync(cancellationToken);
    }
}
