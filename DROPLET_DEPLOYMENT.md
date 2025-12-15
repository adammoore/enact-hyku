# ENACT Hyku - Digital Ocean Droplet Deployment Guide

This guide walks you through deploying Hyku on a Digital Ocean Droplet using Docker Compose.

## Why Droplet Instead of App Platform?

After extensive testing with App Platform, we encountered persistent health check failures. A Droplet provides:
- **Full SSH access** to view logs and troubleshoot
- **Complete control** over all services
- **Proven docker-compose deployment** that Hyku is designed for
- **Cost-effective** for development and testing

## Prerequisites

- Digital Ocean account
- Domain name (optional, for production)
- Basic command line knowledge

## Step 1: Provision a Digital Ocean Droplet

### Option A: Using Digital Ocean Control Panel

1. Log in to [Digital Ocean](https://cloud.digitalocean.com)
2. Click **Create** > **Droplets**
3. Choose configuration:
   - **Distribution**: Ubuntu 22.04 LTS
   - **Plan**: Basic (Regular)
   - **CPU Options**: Regular with SSD (minimum 4GB RAM / 2 vCPUs recommended)
   - **Datacenter**: London (LON1) - or your preferred region
   - **Additional Options**:
     - ✓ IPv6
     - ✓ User data (optional - see below)
   - **Authentication**: SSH Key (recommended) or Password
   - **Hostname**: enact-hyku

4. Click **Create Droplet**

### Option B: Using doctl CLI

```bash
# Create a Droplet with Docker pre-installed
doctl compute droplet create enact-hyku \
  --region lon1 \
  --size s-2vcpu-4gb \
  --image ubuntu-22-04-x64 \
  --ssh-keys YOUR_SSH_KEY_ID \
  --enable-ipv6 \
  --tag-name hyku
```

### User Data Script (Optional - Auto-installs Docker)

If you selected "User data" during Droplet creation, paste this script:

```bash
#!/bin/bash
# Auto-install Docker and Docker Compose on Ubuntu 22.04

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose V2
apt-get install -y docker-compose-plugin

# Add docker group and set permissions
groupadd docker || true
usermod -aG docker root

# Start Docker
systemctl enable docker
systemctl start docker

# Install useful tools
apt-get install -y git curl wget vim htop

echo "Docker installation complete!"
docker --version
docker compose version
```

## Step 2: Connect to Your Droplet

```bash
# Get your Droplet's IP address from Digital Ocean control panel
ssh root@YOUR_DROPLET_IP
```

## Step 3: Install Docker (if not using User Data script)

```bash
# Update system
apt-get update && apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt-get install -y docker-compose-plugin

# Verify installation
docker --version
docker compose version
```

## Step 4: Clone and Configure the Repository

```bash
# Clone the repository
git clone https://github.com/adammoore/enact-hyku.git
cd enact-hyku

# Review and customize the environment file
nano .env.droplet
```

### Key Environment Variables to Update

At minimum, update these in `.env.droplet`:

```bash
# Set to your domain name (or Droplet IP for testing)
HYKU_ADMIN_HOST=your-droplet-ip
HYKU_ROOT_HOST=your-droplet-ip

# For production with a real domain:
# HYKU_ADMIN_HOST=hyku.yourdomain.com
# HYKU_ROOT_HOST=hyku.yourdomain.com
# FORCE_SSL=true

# Configure Spaces for file storage (recommended for production)
# AWS_ACCESS_KEY_ID=your_spaces_access_key
# AWS_SECRET_ACCESS_KEY=your_spaces_secret_key
# AWS_REGION=lon1
# AWS_BUCKET=enact-hyku-prod
# S3_ENDPOINT=https://lon1.digitaloceanspaces.com
```

## Step 5: Deploy Hyku

```bash
# Make deployment script executable
chmod +x deploy-droplet.sh

# Run deployment
./deploy-droplet.sh
```

This script will:
1. Build all Docker images (Solr, Fedora, Web, Worker)
2. Start all services
3. Run database migrations
4. Configure Solr
5. Start the web application

**Note**: Initial deployment takes 5-10 minutes to build all images.

## Step 6: Verify Deployment

### Check Service Status

```bash
docker compose -f docker-compose.droplet.yml ps
```

All services should show as "running" or "Up".

### View Logs

```bash
# View all logs
docker compose -f docker-compose.droplet.yml logs

# Follow web application logs
docker compose -f docker-compose.droplet.yml logs -f web

# View initialization logs
docker compose -f docker-compose.droplet.yml logs initialize_app
```

### Access Hyku

Open your browser to:
- `http://YOUR_DROPLET_IP` (via nginx)
- `http://YOUR_DROPLET_IP:3000` (direct to Rails)

You should see the Hyku homepage!

## Step 7: Create Your First Admin User

```bash
# Access the Rails console
docker compose -f docker-compose.droplet.yml exec web bash
bundle exec rails console

# In the Rails console, create an admin user:
User.create!(
  email: 'admin@example.com',
  password: 'ChangeMeNow123!',
  password_confirmation: 'ChangeMeNow123!'
).add_role(:superadmin)

exit
```

Then log in at `http://YOUR_DROPLET_IP/users/sign_in`

## Common Issues and Solutions

### Services Not Starting

```bash
# Check logs for specific service
docker compose -f docker-compose.droplet.yml logs [service_name]

# Restart a service
docker compose -f docker-compose.droplet.yml restart web

# Rebuild and restart everything
docker compose -f docker-compose.droplet.yml down
docker compose -f docker-compose.droplet.yml up -d --build
```

### Database Connection Errors

```bash
# Check database is running
docker compose -f docker-compose.droplet.yml ps db

# Run migrations manually
docker compose -f docker-compose.droplet.yml exec web bash
bundle exec rails db:migrate
```

### Solr Connection Errors

```bash
# Check Solr is accessible
curl -u admin:admin http://localhost:8983/solr/admin/cores?action=STATUS

# Rerun Solr configuration
docker compose -f docker-compose.droplet.yml restart initialize_app
```

## Production Configuration

### Set Up SSL with Let's Encrypt

```bash
# Install Certbot
apt-get install -y certbot

# Get SSL certificate (requires domain pointing to Droplet)
certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Certificates will be at:
# /etc/letsencrypt/live/yourdomain.com/fullchain.pem
# /etc/letsencrypt/live/yourdomain.com/privkey.pem

# Update nginx.conf to use these certificates
# Then restart nginx
docker compose -f docker-compose.droplet.yml restart nginx
```

### Configure Digital Ocean Spaces

1. Create a Space in Digital Ocean control panel (London region)
2. Generate API keys (Spaces access key)
3. Update `.env.droplet` with credentials:

```bash
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=lon1
AWS_BUCKET=enact-hyku-prod
S3_ENDPOINT=https://lon1.digitaloceanspaces.com
S3_HOSTNAME=lon1.digitaloceanspaces.com
```

4. Restart services:
```bash
docker compose -f docker-compose.droplet.yml restart web worker
```

### Set Up Backups

```bash
# Database backup
docker compose -f docker-compose.droplet.yml exec db pg_dump -U postgres hyku > backup-$(date +%Y%m%d).sql

# Volume backup (Fedora data, uploads, etc.)
docker run --rm -v enact-hyku_fcrepo:/data -v $(pwd):/backup ubuntu tar czf /backup/fcrepo-backup-$(date +%Y%m%d).tar.gz /data
```

## Monitoring and Maintenance

### View Resource Usage

```bash
# Container resource usage
docker stats

# Disk usage
df -h
docker system df
```

### Clean Up Docker Resources

```bash
# Remove old images and containers
docker system prune -a

# Remove unused volumes (CAUTION: This deletes data!)
# docker volume prune
```

### Update Hyku

```bash
cd enact-hyku
git pull origin main
./deploy-droplet.sh
```

## Useful Commands

```bash
# Stop all services
docker compose -f docker-compose.droplet.yml down

# Stop and remove volumes (CAUTION: Deletes all data!)
docker compose -f docker-compose.droplet.yml down -v

# Restart specific service
docker compose -f docker-compose.droplet.yml restart web

# Access Rails console
docker compose -f docker-compose.droplet.yml exec web bundle exec rails console

# Access database
docker compose -f docker-compose.droplet.yml exec db psql -U postgres -d hyku

# View real-time logs
docker compose -f docker-compose.droplet.yml logs -f --tail=100
```

## Support and Troubleshooting

If you encounter issues:

1. **Check logs**: `docker compose -f docker-compose.droplet.yml logs`
2. **Verify all services are running**: `docker compose -f docker-compose.droplet.yml ps`
3. **Check Hyku documentation**: https://github.com/samvera/hyku
4. **Samvera community**: https://samvera.org/

## Cost Estimation

Recommended Droplet size: **$24/month** (4GB RAM / 2 vCPUs)
- Suitable for development and small production deployments
- For larger deployments, consider 8GB RAM ($48/month)

Additional costs:
- Spaces storage: ~$5/month for 250GB
- Bandwidth: Usually included in Droplet plan
- Backups (optional): 20% of Droplet cost

## Next Steps

After successful deployment:

1. **Configure authentication** (LDAP, Shibboleth, or SAML)
2. **Customize theme** and branding
3. **Set up email** notifications
4. **Import PRVoices schema** customizations
5. **Configure backups** and monitoring
6. **Set up SSL** for production
7. **Create tenant** accounts for institutions

Congratulations! Your Hyku instance is now running on Digital Ocean! 🎉
