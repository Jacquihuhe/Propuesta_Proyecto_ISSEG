using Microsoft.EntityFrameworkCore;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Domain.Entities;
using SGSPCSI.Infrastructure.Persistence;

namespace SGSPCSI.Infrastructure.Repositories;

public class UsuarioRepository : IUsuarioRepository
{
    private readonly ApplicationDbContext _context;

    public UsuarioRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public Task<Usuario?> GetByIdAsync(int usuarioId, CancellationToken cancellationToken = default)
    {
        return _context.Usuarios.FirstOrDefaultAsync(x => x.UsuarioId == usuarioId, cancellationToken);
    }

    public Task<Usuario?> GetByCorreoElectronicoAsync(string correoElectronico, CancellationToken cancellationToken = default)
    {
        return _context.Usuarios.FirstOrDefaultAsync(x => x.CorreoElectronico == correoElectronico, cancellationToken);
    }
}