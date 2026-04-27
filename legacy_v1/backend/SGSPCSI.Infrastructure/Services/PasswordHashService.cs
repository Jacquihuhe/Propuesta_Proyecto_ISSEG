using SGSPCSI.Application.Interfaces.Services;
using System.Security.Cryptography;
using System.Text;

namespace SGSPCSI.Infrastructure.Services;

public class PasswordHashService : IPasswordHashService
{
    public string Hash(string password)
    {
        return BCrypt.Net.BCrypt.HashPassword(password);
    }

    public bool Verify(string storedHash, string providedPassword)
    {
        if (string.IsNullOrWhiteSpace(storedHash) || string.IsNullOrEmpty(providedPassword))
        {
            return false;
        }

        if (IsSha256Hex(storedHash))
        {
            var computedHash = ComputeSha256Hex(providedPassword);
            return string.Equals(storedHash, computedHash, StringComparison.OrdinalIgnoreCase);
        }

        return BCrypt.Net.BCrypt.Verify(providedPassword, storedHash);
    }

    private static bool IsSha256Hex(string value)
    {
        if (value.Length != 64)
        {
            return false;
        }

        return value.All(Uri.IsHexDigit);
    }

    private static string ComputeSha256Hex(string value)
    {
        var bytes = Encoding.UTF8.GetBytes(value);
        var hash = SHA256.HashData(bytes);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }
}