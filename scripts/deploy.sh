#!/bin/bash

# Room Booking System - Deployment Script
# This script handles deployment to various environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-development}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main deployment function
deploy() {
    log_info "Starting deployment for environment: $ENVIRONMENT"

    case $ENVIRONMENT in
        development)
            deploy_development
            ;;
        staging)
            deploy_staging
            ;;
        production)
            deploy_production
            ;;
        *)
            log_error "Unknown environment: $ENVIRONMENT"
            exit 1
            ;;
    esac
}

# Development deployment (Docker Compose)
deploy_development() {
    log_info "Deploying to development environment..."

    cd "$PROJECT_ROOT/infrastructure/docker"

    # Build images
    log_info "Building Docker images..."
    docker-compose build

    # Start containers
    log_info "Starting containers..."
    docker-compose up -d

    log_info "Development environment deployed successfully"
    log_info "Frontend: http://localhost:5173"
    log_info "Backend: http://localhost:5000"
}

# Staging deployment (Kubernetes)
deploy_staging() {
    log_info "Deploying to staging environment..."

    # Check kubectl availability
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl not found. Please install kubectl."
        exit 1
    fi

    # Set kubectl context (adjust based on your setup)
    # kubectl config use-context staging-cluster

    cd "$PROJECT_ROOT/infrastructure/kubernetes"

    # Apply manifests
    log_info "Applying Kubernetes manifests..."
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml

    log_info "Staging environment deployed successfully"
    log_info "Running: kubectl get pods -n default"
    kubectl get pods -n default
}

# Production deployment (Terraform + Kubernetes)
deploy_production() {
    log_info "Deploying to production environment..."

    # Check dependencies
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform not found. Please install Terraform."
        exit 1
    fi

    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl not found. Please install kubectl."
        exit 1
    fi

    # Confirmation
    log_warning "This will deploy to PRODUCTION environment!"
    read -p "Are you sure? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deployment cancelled."
        exit 0
    fi

    # Terraform
    cd "$PROJECT_ROOT/infrastructure/terraform"

    log_info "Initializing Terraform..."
    terraform init

    log_info "Planning Terraform changes..."
    terraform plan -out=tfplan

    log_info "Applying Terraform changes..."
    terraform apply tfplan

    # Kubernetes
    cd "$PROJECT_ROOT/infrastructure/kubernetes"

    log_info "Applying Kubernetes manifests to production..."
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml

    log_info "Production environment deployed successfully"
}

# Pre-deployment checks
pre_deployment_checks() {
    log_info "Running pre-deployment checks..."

    # Check Docker
    if command -v docker &> /dev/null; then
        log_info "Docker found: $(docker --version)"
    fi

    # Check if backend code exists
    if [ ! -d "$PROJECT_ROOT/backend" ]; then
        log_error "Backend directory not found"
        exit 1
    fi

    log_info "Pre-deployment checks completed"
}

# Show usage
usage() {
    echo "Usage: $0 [development|staging|production]"
    echo ""
    echo "Examples:"
    echo "  $0 development   # Deploy to development using Docker Compose"
    echo "  $0 staging       # Deploy to staging using Kubernetes"
    echo "  $0 production    # Deploy to production using Terraform + Kubernetes"
}

# Main
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

pre_deployment_checks
deploy

log_info "Deployment completed!"
