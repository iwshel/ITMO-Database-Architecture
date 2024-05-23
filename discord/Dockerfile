FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /discord

COPY . ./  


RUN dotnet restore

RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /discord
COPY --from=build-env /discord/out .
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "dotnet discord.dll"]