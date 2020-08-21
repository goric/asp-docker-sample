# in order to build the app within the container, we need the base SDK image
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

# create a /source/ directory and move to it
WORKDIR /source

# copy everything in the project folder into the container's /source dir 
# the destination in commands here is relative to the current WORKDIR
COPY . .

# build and publish the app, using the output folder /app/publish
RUN dotnet publish sample.csproj -c Development -o /app/publish

# to actually run the app, pull a base image for aspnet core 3.1 applications
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base

# copy from the build stage's /app/publish into the base stage's /app folder
WORKDIR /app
COPY --from=build /app/publish .

# when the container starts, run the command: dotnet sample.dll
ENTRYPOINT ["dotnet", "sample.dll"]