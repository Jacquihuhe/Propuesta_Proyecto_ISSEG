using Microsoft.EntityFrameworkCore;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Domain.Entities;
using SGSPCSI.Infrastructure.Persistence;

namespace SGSPCSI.Infrastructure.Repositories;

public class TipoSolicitudRepository : ITipoSolicitudRepository
{
    private readonly ApplicationDbContext _context;

    public TipoSolicitudRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public Task<TipoSolicitud?> GetByIdAsync(int tipoId, CancellationToken cancellationToken = default)
    {
        return _context.TiposSolicitud.FirstOrDefaultAsync(x => x.TipoId == tipoId, cancellationToken);
    }
}