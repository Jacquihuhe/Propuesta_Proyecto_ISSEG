using Microsoft.EntityFrameworkCore;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Domain.Entities;
using SGSPCSI.Infrastructure.Persistence;

namespace SGSPCSI.Infrastructure.Repositories;

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

    public Task<Solicitud?> GetByIdAsync(int solicitudId, CancellationToken cancellationToken = default)
    {
        return _context.Solicitudes.AsNoTracking().FirstOrDefaultAsync(x => x.SolicitudId == solicitudId, cancellationToken);
    }

    public async Task<IReadOnlyCollection<Solicitud>> GetByUsuarioSolicitanteIdAsync(int usuarioSolicitanteId, CancellationToken cancellationToken = default)
    {
        return await _context.Solicitudes.AsNoTracking()
            .Where(x => x.UsuarioSolicitanteId == usuarioSolicitanteId)
            .OrderByDescending(x => x.FechaCreacion)
            .ToArrayAsync(cancellationToken);
    }
}