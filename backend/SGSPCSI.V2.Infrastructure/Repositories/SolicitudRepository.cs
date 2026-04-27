using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class SolicitudRepository : ISolicitudRepository
{
    private readonly ApplicationDbContext _context;

    public SolicitudRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task AddAsync(Solicitud solicitud, CancellationToken cancellationToken = default)
    {
        await _context.Solicitudes.AddAsync(solicitud, cancellationToken);
    }

    public Task<Solicitud?> GetByIdAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        return _context.Solicitudes
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.SolicitudId == solicitudId, cancellationToken);
    }

    public async Task<IReadOnlyCollection<Solicitud>> ListByUsuarioAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return await _context.Solicitudes
            .AsNoTracking()
            .Where(x => x.CreadoPorUsuarioId == usuarioId)
            .OrderByDescending(x => x.FechaSolicitud)
            .ToArrayAsync(cancellationToken);
    }
}
