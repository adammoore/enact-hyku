# ENACT Hyku - Digital Ocean Deployment Guide

## Overview

This guide explains how to deploy ENACT Hyku to a Digital Ocean droplet, particularly when updating branding, assets, or other static files.

## Understanding the Deployment Architecture

ENACT Hyku uses a local Docker build strategy on the Digital Ocean server:

1. **No Pre-built Images**: Unlike some deployments, we don't pull pre-built images from a registry
2. **Local Builds**: Images are built directly on the droplet from the codebase
3. **Asset Compilation**: Assets (CSS, JS, images, favicons) are compiled during the Docker build process
4. **Volume Caching**: Compiled assets are stored in a Docker volume for performance

### Why Branding Updates May Not Appear

When you update branding files (favicons, logos, CSS), they may not appear on the server because:

1. **Docker Layer Caching**: Docker caches build layers, potentially using old assets
2. **Volume Persistence**: The `assets` volume persists between deployments, keeping old compiled assets
3. **Asset Precompilation**: Rails asset pipeline compiles and fingerprints assets, which are then cached

## Deployment Scripts

### 1. Initial Deployment: `deploy-droplet.sh`

Use this for the first deployment or when you want a clean slate:

```bash
./deploy-droplet.sh
```

This script:
- Stops existing containers
- Builds images with `--no-cache` flag
- Starts all services
- Shows initialization logs

### 2. Update & Deploy: `update-and-deploy-droplet.sh`

**Use this when updating branding, assets, or code:**

```bash
./update-and-deploy-droplet.sh
```

This enhanced script:
1. Pulls latest code from git
2. Shows you what will be updated
3. Stops existing containers
4. **Removes the assets volume** (crucial for branding updates!)
5. Rebuilds images with `--no-cache` and `--pull` flags
6. Starts services
7. Waits for health checks
8. Confirms deployment

## Step-by-Step: Updating Branding on Digital Ocean

### On Your Local Machine

1. **Make branding changes** (update favicon, logos, CSS, etc.)
2. **Commit changes**:
   ```bash
   git add public/favicon.ico
   git commit -m "Update favicon branding"
   git push origin main
   ```

### On the Digital Ocean Droplet

1. **SSH into your droplet**:
   ```bash
   ssh root@your-droplet-ip
   ```

2. **Navigate to the project directory**:
   ```bash
   cd /path/to/enact-hyku
   ```

3. **Run the update script**:
   ```bash
   ./update-and-deploy-droplet.sh
   ```

4. **Verify the update**:
   - Open your browser to your droplet's IP or domain
   - Hard refresh with Ctrl+Shift+R (or Cmd+Shift+R on Mac)
   - Check the favicon and other branding elements

### If Branding Still Doesn't Update

If you've run the script but still see old branding:

1. **Clear browser cache**:
   ```
   Ctrl+Shift+Delete (or Cmd+Shift+Delete on Mac)
   ```

2. **Check the assets were removed**:
   ```bash
   docker volume ls | grep assets
   ```
   If you see an assets volume, remove it manually:
   ```bash
   docker-compose -f docker-compose.droplet.yml down
   docker volume rm enact-hyku_assets
   ./deploy-droplet.sh
   ```

3. **Verify files in the container**:
   ```bash
   docker-compose -f docker-compose.droplet.yml exec web ls -la /app/samvera/hyrax-webapp/public/
   ```
   Check if the new favicon.ico is there and has a recent timestamp.

4. **Check compiled assets**:
   ```bash
   docker-compose -f docker-compose.droplet.yml exec web ls -la /app/samvera/hyrax-webapp/public/assets/
   ```

## Manual Asset Volume Management

### Remove Assets Volume

```bash
# Stop services first
docker-compose -f docker-compose.droplet.yml down

# Remove assets volume
docker volume rm enact-hyku_assets

# Restart
./deploy-droplet.sh
```

### Inspect Assets Volume

```bash
# List all volumes
docker volume ls

# Inspect assets volume
docker volume inspect enact-hyku_assets

# See what's in the volume
docker run --rm -v enact-hyku_assets:/assets alpine ls -la /assets
```

## Common Issues and Solutions

### Issue: "Branding still shows old version"

**Solution**: Ensure you removed the assets volume before rebuilding:
```bash
docker volume rm enact-hyku_assets
```

### Issue: "Container builds but app won't start"

**Solution**: Check initialization logs:
```bash
docker-compose -f docker-compose.droplet.yml logs initialize_app
```

### Issue: "Assets are missing or 404 errors"

**Solution**: Rebuild with asset precompilation:
```bash
docker-compose -f docker-compose.droplet.yml build --no-cache web worker
docker-compose -f docker-compose.droplet.yml up -d
```

### Issue: "Solr or Fcrepo health checks failing"

**Solution**: Recent fixes addressed health check issues. Make sure you have the latest docker-compose.droplet.yml:
- Solr health check uses hardcoded credentials
- Fcrepo health check uses correct `/rest` endpoint

## Monitoring Deployment

### View All Service Logs

```bash
docker-compose -f docker-compose.droplet.yml logs -f
```

### View Specific Service Logs

```bash
docker-compose -f docker-compose.droplet.yml logs -f web
docker-compose -f docker-compose.droplet.yml logs -f worker
docker-compose -f docker-compose.droplet.yml logs -f solr
```

### Check Service Status

```bash
docker-compose -f docker-compose.droplet.yml ps
```

### Check Service Health

```bash
docker-compose -f docker-compose.droplet.yml ps | grep healthy
```

## Production Considerations

### Before Deploying

1. **Test locally** if possible
2. **Backup database**:
   ```bash
   docker-compose -f docker-compose.droplet.yml exec db pg_dump -U postgres hyku > backup.sql
   ```
3. **Review changes**:
   ```bash
   git log --oneline -10
   ```

### After Deploying

1. **Verify all services are running**
2. **Test critical functionality** (login, search, upload)
3. **Check for errors** in logs
4. **Monitor resource usage**:
   ```bash
   docker stats
   ```

## Quick Reference Commands

```bash
# Update and deploy (recommended for updates)
./update-and-deploy-droplet.sh

# Initial deployment
./deploy-droplet.sh

# Stop all services
docker-compose -f docker-compose.droplet.yml down

# Start all services
docker-compose -f docker-compose.droplet.yml up -d

# Restart a specific service
docker-compose -f docker-compose.droplet.yml restart web

# View logs
docker-compose -f docker-compose.droplet.yml logs -f web

# Remove assets volume (for branding updates)
docker volume rm enact-hyku_assets

# Full rebuild
docker-compose -f docker-compose.droplet.yml down
docker volume rm enact-hyku_assets
docker-compose -f docker-compose.droplet.yml build --no-cache
docker-compose -f docker-compose.droplet.yml up -d
```

## Environment Configuration

The deployment uses `.env.droplet` for environment-specific configuration. Ensure this file exists and contains:

- Database credentials
- Redis configuration
- Solr settings
- Secret keys
- Mail settings
- Domain/URL configuration

Never commit `.env.droplet` to version control!

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Hyku Documentation](https://github.com/samvera/hyku)
- [Digital Ocean Docker Guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
