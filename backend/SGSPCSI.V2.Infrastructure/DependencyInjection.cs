using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SGSPCSI.V2.Application.Interfaces.Repositories;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Infrastructure.Persistence;
using SGSPCSI.V2.Infrastructure.Repositories;
using SGSPCSI.V2.Infrastructure.Seeding;
using SGSPCSI.V2.Infrastructure.Services;

namespace SGSPCSI.V2.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IUsuarioRepository, UsuarioRepository>();
        services.AddScoped<ISolicitudRepository, SolicitudRepository>();
        services.AddScoped<IAprobacionRepository, AprobacionRepository>();
        services.AddScoped<IHistorialSolicitudRepository, HistorialSolicitudRepository>();
        services.AddScoped<INotificacionRepository, NotificacionRepository>();
        services.AddScoped<ICatalogoSolicitudRepository, CatalogoSolicitudRepository>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();
        services.AddScoped<IPasswordHashService, PasswordHashService>();

        return services;
    }
}