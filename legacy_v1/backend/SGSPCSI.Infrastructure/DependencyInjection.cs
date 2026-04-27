using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SGSPCSI.Application.Interfaces.Repositories;
using SGSPCSI.Application.Interfaces.Services;
using SGSPCSI.Infrastructure.Persistence;
using SGSPCSI.Infrastructure.Repositories;
using SGSPCSI.Infrastructure.Services;

namespace SGSPCSI.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IUsuarioRepository, UsuarioRepository>();
        services.AddScoped<ITipoSolicitudRepository, TipoSolicitudRepository>();
        services.AddScoped<ISolicitudRepository, SolicitudRepository>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();
        services.AddScoped<IPasswordHashService, PasswordHashService>();

        return services;
    }
}