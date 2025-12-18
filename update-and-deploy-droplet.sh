#!/bin/bash
# ENACT Hyku - Update and Deploy to Digital Ocean Droplet
# This script handles pulling updates and redeploying with fresh assets

set -e

echo "=========================================="
echo "ENACT Hyku Update & Deployment"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Use docker compose (v2) if available, otherwise docker-compose (v1)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo -e "${BLUE}Step 1: Pulling latest code from git...${NC}"
git fetch origin
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${YELLOW}Current branch: $CURRENT_BRANCH${NC}"

# Show what will be updated
BEHIND_COUNT=$(git rev-list HEAD..origin/$CURRENT_BRANCH --count)
if [ "$BEHIND_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ Already up to date!${NC}"
else
    echo -e "${YELLOW}$BEHIND_COUNT commits behind origin/$CURRENT_BRANCH${NC}"
    git log HEAD..origin/$CURRENT_BRANCH --oneline --max-count=5
fi

read -p "Pull latest changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git pull origin $CURRENT_BRANCH
    echo -e "${GREEN}✓ Code updated${NC}"
else
    echo -e "${YELLOW}Skipping git pull${NC}"
fi

echo -e "\n${BLUE}Step 2: Stopping existing containers...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml down

echo -e "\n${BLUE}Step 3: Removing cached assets volume...${NC}"
echo -e "${YELLOW}This ensures new branding/assets are used${NC}"
docker volume rm enact-hyku_assets 2>/dev/null && echo -e "${GREEN}✓ Assets volume removed${NC}" || echo -e "${YELLOW}No assets volume to remove${NC}"

echo -e "\n${BLUE}Step 4: Building fresh Docker images...${NC}"
echo -e "${YELLOW}This may take several minutes...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml build --no-cache --pull

echo -e "\n${BLUE}Step 5: Starting services...${NC}"
$DOCKER_COMPOSE -f docker-compose.droplet.yml up -d

echo -e "\n${YELLOW}Waiting for services to initialize...${NC}"
sleep 15

# Wait for web service to be healthy
echo -e "${YELLOW}Checking web service health...${NC}"
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if $DOCKER_COMPOSE -f docker-compose.droplet.yml ps | grep -q "web.*healthy"; then
        echo -e "${GREEN}✓ Web service is healthy${NC}"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo -e "${YELLOW}Waiting... ($ATTEMPT/$MAX_ATTEMPTS)${NC}"
    sleep 10
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo -e "${RED}Warning: Web service health check timed out${NC}"
    echo -e "${YELLOW}Check logs with: $DOCKER_COMPOSE -f docker-compose.droplet.yml logs web${NC}"
fi

# Show service status
echo -e "\n${GREEN}=========================================="
echo "Deployment Complete!"
echo "==========================================${NC}"
echo -e "\nService status:"
$DOCKER_COMPOSE -f docker-compose.droplet.yml ps

echo -e "\n${GREEN}Hyku should now be accessible at:${NC}"
echo "  http://localhost (via nginx)"
echo "  http://localhost:3000 (direct to Rails)"

echo -e "\n${BLUE}Useful commands:${NC}"
echo -e "${YELLOW}View logs:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml logs -f web"
echo -e "${YELLOW}Stop services:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml down"
echo -e "${YELLOW}Restart a service:${NC}"
echo "  $DOCKER_COMPOSE -f docker-compose.droplet.yml restart web"

echo -e "\n${GREEN}✓ Branding and asset updates should now be visible!${NC}"
