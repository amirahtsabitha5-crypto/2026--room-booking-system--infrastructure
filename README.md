# Room Booking System - Infrastructure

Infrastructure dan deployment configuration untuk Room Booking System.

## Folder Structure

```
infrastructure/
├── docker/          # Docker configurations
│   ├── backend.dockerfile
│   ├── frontend.dockerfile
│   └── docker-compose.yml
├── kubernetes/      # Kubernetes manifests (if using K8s)
├── terraform/       # Infrastructure as Code (if using Terraform)
├── nginx/           # Nginx reverse proxy configs
├── ci-cd/           # CI/CD pipeline configs
│   ├── .github/workflows/
│   └── pipeline.yml
└── database/        # Database initialization scripts
    ├── init.sql
    └── backups/
```

## Setup

### Docker Compose (Development)

```bash
docker-compose up -d
```

### Deployment (Production)

Documentation coming soon...

## Status

🚧 Work in Progress - Infrastructure setup in progress

## Contributors

Amirah Tsabitha
