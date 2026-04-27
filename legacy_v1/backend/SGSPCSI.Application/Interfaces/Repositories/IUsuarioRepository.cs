using SGSPCSI.Domain.Entities;

namespace SGSPCSI.Application.Interfaces.Repositories;

public interface IUsuarioRepository
{
    Task<Usuario?> GetByIdAsync(int usuarioId, CancellationToken cancellationToken = default);
    Task<Usuario?> GetByCorreoElectronicoAsync(string correoElectronico, CancellationToken cancellationToken = default);
}