using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class CatalogoSolicitudRepository : ICatalogoSolicitudRepository
{
    private readonly ApplicationDbContext _context;

    public CatalogoSolicitudRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public Task<TipoSolicitud?> GetTipoByIdAsync(int tipoSolicitudId, CancellationToken cancellationToken = default)
    {
        return _context.TiposSolicitud
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.TipoSolicitudId == tipoSolicitudId && x.Activo, cancellationToken);
    }

    public Task<PrioridadSolicitud?> GetPrioridadByIdAsync(int prioridadSolicitudId, CancellationToken cancellationToken = default)
    {
        return _context.PrioridadesSolicitud
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.PrioridadSolicitudId == prioridadSolicitudId && x.Activo, cancellationToken);
    }

    public Task<EstadoSolicitud?> GetEstadoByClaveAsync(string clave, CancellationToken cancellationToken = default)
    {
        var normalized = clave.Trim().ToUpperInvariant();
        return _context.EstadosSolicitud
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Clave.ToUpper() == normalized && x.Activo, cancellationToken);
    }
}
