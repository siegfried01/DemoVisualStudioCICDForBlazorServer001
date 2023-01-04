using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using DemoVisualStudioCICDForBlazorServer.Data;
using System;
using static System.Console;
using System.Text.RegularExpressions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddSingleton<WeatherForecastService>();
var appinsconn = builder.Configuration["APPLICATIONINSIGHTS_CONNECTION_STRING"];
if (string.IsNullOrEmpty(appinsconn))
{
    WriteLine("Missing Connection string APPLICATIONINSIGHTS_CONNECTION_STRING");
}
else
{
    var m = new Regex("^(InstrumentationKey=)([^;]+)(.*)$").Match(appinsconn);
    if (m.Success)
    {
        WriteLine($"found connection string={m.Groups[1]}xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx{m.Groups[3]}");
    }
    else
    {
        WriteLine($"found connection string");
    }
    builder.Services.AddApplicationInsightsTelemetry(appinsconn);
}
//builder.Services.AddLogging(builder => builder.AddConsole().SetMinimumLevel(LogLevel.Debug));
//builder.Logging.ClearProviders().AddConsole();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
