using SGSPCSI.V2.Application;
using SGSPCSI.V2.Application.Interfaces.Services;
using SGSPCSI.V2.Infrastructure;
using SGSPCSI.V2.Infrastructure.Persistence;
using SGSPCSI.V2.Infrastructure.Seeding;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddCors(options =>
{
    options.AddPolicy("DevCors", policy =>
    {
        policy
            .SetIsOriginAllowed(_ => true)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

builder.Services.AddApplicationServices();
builder.Services.AddInfrastructure(builder.Configuration);

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    var passwordHashService = scope.ServiceProvider.GetRequiredService<IPasswordHashService>();
    await DevSecuritySeeder.SeedAsync(dbContext, passwordHashService);
}

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseCors("DevCors");
app.UseAuthorization();
app.MapControllers();

await app.RunAsync();
