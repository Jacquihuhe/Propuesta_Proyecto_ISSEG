using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class AprobacionRepository : IAprobacionRepository
{
    private readonly ApplicationDbContext _context;

    public AprobacionRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IReadOnlyCollection<Solicitud>> ListPendientesAsync(
        int? tipoSolicitudId,
        int? prioridadSolicitudId,
        int? areaSolicitanteId,
        CancellationToken cancellationToken = default)
    {
        var query = _context.Solicitudes
            .AsNoTracking()
            .Include(x => x.TipoSolicitud)
            .Include(x => x.PrioridadSolicitud)
            .Include(x => x.EstadoSolicitud)
            .Include(x => x.CreadoPorUsuario)
            .Where(x => x.Activo &&
                (x.EstadoSolicitud != null &&
                (x.EstadoSolicitud.Clave == "PENDIENTE" || x.EstadoSolicitud.Clave == "REQUIERE_INFO")));

        if (tipoSolicitudId.HasValue)
        {
            query = query.Where(x => x.TipoSolicitudId == tipoSolicitudId.Value);
        }

        if (prioridadSolicitudId.HasValue)
        {
            query = query.Where(x => x.PrioridadSolicitudId == prioridadSolicitudId.Value);
        }

        if (areaSolicitanteId.HasValue)
        {
            query = query.Where(x => x.AreaSolicitanteId == areaSolicitanteId.Value);
        }

        return await query
            .OrderByDescending(x => x.PrioridadSolicitud != null ? x.PrioridadSolicitud.Peso : (byte)0)
            .ThenBy(x => x.FechaSolicitud)
            .ToArrayAsync(cancellationToken);
    }

    public Task<Solicitud?> GetSolicitudByIdForUpdateAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        return _context.Solicitudes
            .Include(x => x.EstadoSolicitud)
            .FirstOrDefaultAsync(x => x.SolicitudId == solicitudId && x.Activo, cancellationToken);
    }

    public async Task AddAprobacionAsync(SolicitudAprobacion aprobacion, CancellationToken cancellationToken = default)
    {
        await _context.SolicitudesAprobaciones.AddAsync(aprobacion, cancellationToken);
    }

    public async Task AddComentarioAsync(SolicitudComentario comentario, CancellationToken cancellationToken = default)
    {
        await _context.SolicitudesComentarios.AddAsync(comentario, cancellationToken);
    }

    public async Task<IReadOnlyCollection<SolicitudComentario>> ListComentariosBySolicitudAsync(long solicitudId, CancellationToken cancellationToken = default)
    {
        return await _context.SolicitudesComentarios
            .AsNoTracking()
            .Include(x => x.Usuario)
            .Where(x => x.SolicitudId == solicitudId && x.Activo)
            .OrderByDescending(x => x.FechaCreacion)
            .ToArrayAsync(cancellationToken);
    }
}
