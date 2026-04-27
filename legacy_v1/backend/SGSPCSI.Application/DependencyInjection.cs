using Microsoft.Extensions.DependencyInjection;
using SGSPCSI.Application.Interfaces.Services;
using SGSPCSI.Application.Services;

namespace SGSPCSI.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ISolicitudService, SolicitudService>();
        return services;
    }
}