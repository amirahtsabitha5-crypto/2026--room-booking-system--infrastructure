# Backend Dockerfile - .NET Room Booking API

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10-alpine AS build

WORKDIR /app

# Copy project files
COPY backend/BackendApi.csproj ./
RUN dotnet restore

# Copy source code
COPY backend/ ./

# Build application
RUN dotnet build -c Release -o /app/build

# Publish
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10-alpine AS runtime

WORKDIR /app

# Install required packages
RUN apk add --no-cache curl

# Copy from build stage
COPY --from=build /app/publish .

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Set environment
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# Start application
ENTRYPOINT ["dotnet", "BackendApi.dll"]
