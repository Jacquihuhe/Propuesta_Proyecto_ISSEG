namespace SGSPCSI.V2.Domain.Entities;

public class UsuarioCredencial
{
    public int UsuarioId { get; set; }
    public string LoginUsuario { get; set; } = string.Empty;
    public byte[] PasswordHash { get; set; } = Array.Empty<byte>();
    public byte[] PasswordSalt { get; set; } = Array.Empty<byte>();
    public string AlgoritmoHash { get; set; } = "PBKDF2";
    public int Iteraciones { get; set; } = 100000;
    public DateTime? UltimoAcceso { get; set; }
    public short IntentosFallidos { get; set; }
    public DateTime? BloqueadoHasta { get; set; }
    public bool RequiereCambioPassword { get; set; }
    public DateTime FechaActualizacion { get; set; }

    public Usuario? Usuario { get; set; }
}