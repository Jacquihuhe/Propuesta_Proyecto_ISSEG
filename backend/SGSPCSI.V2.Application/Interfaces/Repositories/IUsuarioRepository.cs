using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Repositories;

public interface IUsuarioRepository
{
    Task<Usuario?> GetByLoginAsync(string loginUsuario, CancellationToken cancellationToken = default);
}