using Microsoft.EntityFrameworkCore;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Domain.Entities;
using SGSPCSI.V2.Infrastructure.Persistence;

namespace SGSPCSI.V2.Infrastructure.Repositories;

public class UsuarioRepository : IUsuarioRepository
{
    private readonly ApplicationDbContext _context;

    public UsuarioRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public Task<Usuario?> GetByLoginAsync(string loginUsuario, CancellationToken cancellationToken = default)
    {
        return _context.Usuarios
            .Include(x => x.UsuarioCredencial)
            .Include(x => x.RolesUsuario)
                .ThenInclude(x => x.Rol)
            .FirstOrDefaultAsync(x => x.CorreoInstitucional == loginUsuario, cancellationToken);
    }
}