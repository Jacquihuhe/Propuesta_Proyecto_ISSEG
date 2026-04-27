using System.Security.Cryptography;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Domain.Entities;

namespace SGSPCSI.V2.Infrastructure.Services;

public class PasswordHashService : IPasswordHashService
{
    public (byte[] hash, byte[] salt, int iterations, string algorithm) HashPassword(string password, int iterations = 100000)
    {
        var salt = RandomNumberGenerator.GetBytes(16);
        var hash = Rfc2898DeriveBytes.Pbkdf2(password, salt, iterations, HashAlgorithmName.SHA256, 32);
        return (hash, salt, iterations, "PBKDF2");
    }

    public bool Verify(string providedPassword, UsuarioCredencial credential)
    {
        if (!string.Equals(credential.AlgoritmoHash, "PBKDF2", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (credential.PasswordSalt.Length == 0 || credential.PasswordHash.Length == 0 || credential.Iteraciones <= 0)
        {
            return false;
        }

        var computed = Rfc2898DeriveBytes.Pbkdf2(
            providedPassword,
            credential.PasswordSalt,
            credential.Iteraciones,
            HashAlgorithmName.SHA256,
            credential.PasswordHash.Length);

        return CryptographicOperations.FixedTimeEquals(computed, credential.PasswordHash);
    }
}