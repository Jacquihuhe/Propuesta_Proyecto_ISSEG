namespace SGSPCSI.Application.Interfaces.Services;

public interface IPasswordHashService
{
    bool Verify(string storedHash, string providedPassword);
    string Hash(string password);
}