FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["cicd2apiservice.csproj", ""]
RUN dotnet restore "cicd2apiservice.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "cicd2apiservice.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "cicd2apiservice.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "cicd2apiservice.dll"]