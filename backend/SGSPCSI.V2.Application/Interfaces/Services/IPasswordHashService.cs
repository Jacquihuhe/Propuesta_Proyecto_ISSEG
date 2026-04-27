using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Application.Interfaces.Services;

public interface IPasswordHashService
{
    (byte[] hash, byte[] salt, int iterations, string algorithm) HashPassword(string password, int iterations = 100000);
    bool Verify(string providedPassword, UsuarioCredencial credential);
}