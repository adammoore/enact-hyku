#!/bin/bash
# ENACT Hyku - Digital Ocean Droplet Deployment Script

set -e

echo "=================================="
echo "ENACT Hyku Droplet Deployment"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env.droplet exists
if [ ! -f .env.droplet ]; then
    echo -e "${RED}Error: .env.droplet file not found!${NC}"
    echo "Please create .env.droplet from .env.droplet template"
    exit 1
fi

# Check if docker and docker-compose are installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker first"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    echo "Please install Docker Compose first"
    exit 1
fi

# Use docker compose (v2) if available, otherwise docker-compose (v1)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"

# Stop existing containers if running
echo -e "\n${YELLOW}Stopping existing containers...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml down

# Build images
echo -e "\n${YELLOW}Building Docker images (this may take several minutes)...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml build --no-cache

# Start services
echo -e "\n${YELLOW}Starting services...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml up -d

# Wait for services to be healthy
echo -e "\n${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Show status
echo -e "\n${GREEN}Deployment complete!${NC}"
echo -e "\nService status:"
$DOCKER_COMPOSE -f docker-compose.droplet.yml ps

# Show logs for initialize_app
echo -e "\n${YELLOW}Initialization logs:${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml logs initialize_app

echo -e "\n${GREEN}=================================="
echo "Hyku should now be accessible at:"
echo "  http://localhost (via nginx)"
echo "  http://localhost:3000 (direct to Rails)"
echo "==================================${NC}"

echo -e "\n${YELLOW}To view logs:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml logs -f web"

echo -e "\n${YELLOW}To stop all services:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml down"

echo -e "\n${YELLOW}To restart services:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml restart"
