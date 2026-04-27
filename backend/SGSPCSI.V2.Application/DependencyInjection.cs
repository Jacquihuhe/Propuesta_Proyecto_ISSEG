using Microsoft.Extensions.DependencyInjection;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Application.Services;

namespace SGSPCSI.V2.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ISolicitudService, SolicitudService>();
        services.AddScoped<IAprobacionService, AprobacionService>();
        services.AddScoped<INotificacionService, NotificacionService>();
        return services;
    }
}