FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./TitansApp.csproj", "./"]
RUN dotnet restore "TitansApp.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "TitansApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TitansApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TitansApp.dll"]
