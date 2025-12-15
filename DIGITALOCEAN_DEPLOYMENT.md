# ENACT Hyku - Digital Ocean Deployment Guide

This guide covers deploying ENACT Hyku to Digital Ocean with automatic deployment from GitHub.

## Why Digital Ocean for Hyku?

Digital Ocean is an **excellent fit** for Hyku because:

✅ **Native Docker support** - Hyku is designed for Docker
✅ **All services in one place** - Fedora, Solr, PostgreSQL, Redis
✅ **Cost-effective** - Predictable pricing, no addon markup
✅ **Easy scaling** - Simple vertical and horizontal scaling
✅ **Spaces (S3-compatible)** - Built-in object storage
✅ **Container Registry** - Host your custom Docker images
✅ **Managed databases** - PostgreSQL and Redis as managed services

## Deployment Options

### Option 1: App Platform (Recommended - PaaS)
- Similar to Heroku but Docker-native
- Automatic deployments from GitHub
- Managed services (PostgreSQL, Redis)
- Built-in monitoring and logging
- SSL certificates included
- **Cost**: ~$70-150/month

### Option 2: Kubernetes (DOKS)
- Production-grade orchestration
- Maximum scalability
- More complex to manage
- **Cost**: ~$120+/month

### Option 3: Droplets (VMs)
- Full control over infrastructure
- Manual management required
- Most cost-effective for small deployments
- **Cost**: ~$40-80/month

This guide focuses on **Option 1: App Platform** as the best balance of simplicity and features.

## Prerequisites

1. **Digital Ocean Account** - Sign up at https://cloud.digitalocean.com/
2. **GitHub Repository** - Fork or clone enact-hyku
3. **Domain Name** (optional but recommended)
4. **Spaces Access** - For file storage (can be created during setup)

## Quick Start (App Platform)

### Step 1: Merge Hyku Codebase

First, get the Hyku application code:

```bash
cd /path/to/enact-hyku
./scripts/merge_hyku.sh
git push origin main
```

This merges Samvera Hyku while preserving ENACT documentation and configuration.

### Step 2: Create Digital Ocean Spaces (Object Storage)

1. Go to **Spaces** in DO dashboard
2. Click **Create a Space**
3. Settings:
   - Region: Same as your app (e.g., LON1 - London)
   - Name: `enact-hyku-prod`
   - CDN: Enable (recommended)
4. Create **API Key** for Spaces:
   - Go to **API** → **Spaces Keys**
   - Generate New Key
   - Save the Access Key and Secret Key

### Step 3: Deploy via App Platform

#### Method A: Via doctl CLI (Recommended)

Install doctl:
```bash
# macOS
brew install doctl

# Linux
cd ~ && wget https://github.com/digitalocean/doctl/releases/download/v1.98.1/doctl-1.98.1-linux-amd64.tar.gz
tar xf ~/doctl-1.98.1-linux-amd64.tar.gz
sudo mv ~/doctl /usr/local/bin
```

Authenticate:
```bash
doctl auth init
# Enter your DO API token
```

Create app from spec:
```bash
cd /path/to/enact-hyku

# Deploy using the app spec
doctl apps create --spec .digitalocean/app.yaml
```

#### Method B: Via Digital Ocean Dashboard

1. Go to **Apps** in DO dashboard
2. Click **Create App**
3. **Choose Source**:
   - Select **GitHub**
   - Authorize Digital Ocean
   - Choose `adammoore/enact-hyku` repository
   - Branch: `main`
   - Autodeploy: ✅ Enable
4. **Configure Resources**:
   - Upload the `.digitalocean/app.yaml` spec file
   - OR manually configure services (see Manual Configuration below)
5. Click **Next** through remaining steps
6. Review and **Create Resources**

### Step 4: Configure Environment Variables

After app creation, set required secrets:

#### Via doctl:
```bash
# Get your app ID
doctl apps list

# Set environment variables
APP_ID=your-app-id

doctl apps update $APP_ID --env SECRET_KEY_BASE=$(openssl rand -hex 64)
doctl apps update $APP_ID --env AWS_ACCESS_KEY_ID=your_spaces_key
doctl apps update $APP_ID --env AWS_SECRET_ACCESS_KEY=your_spaces_secret
doctl apps update $APP_ID --env AWS_REGION=lon1
doctl apps update $APP_ID --env AWS_BUCKET=enact-hyku-prod
doctl apps update $APP_ID --env S3_ENDPOINT=https://lon1.digitaloceanspaces.com
```

#### Via Dashboard:
1. Go to your app in DO dashboard
2. Navigate to **Settings** → **App-Level Environment Variables**
3. Add variables from `.env.digitalocean.sample`

**Required Variables**:
```
SECRET_KEY_BASE=<generate with: openssl rand -hex 64>
AWS_ACCESS_KEY_ID=<your Spaces access key>
AWS_SECRET_ACCESS_KEY=<your Spaces secret key>
AWS_REGION=lon1
AWS_BUCKET=enact-hyku-prod
S3_ENDPOINT=https://lon1.digitaloceanspaces.com
```

**Optional but Recommended**:
```
SMTP_ADDRESS=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER_NAME=apikey
SMTP_PASSWORD=<your sendgrid api key>
GOOGLE_ANALYTICS_ID=UA-XXXXXXXXX-X
GEONAMES_USERNAME=<your geonames username>
```

### Step 5: Configure Custom Domain (Optional)

1. In your app, go to **Settings** → **Domains**
2. Click **Add Domain**
3. Enter your domain (e.g., `enact-hyku.yourdomain.com`)
4. Follow DNS configuration instructions
5. SSL certificate will be automatically provisioned

Update Hyku environment variables:
```bash
doctl apps update $APP_ID --env HYKU_ADMIN_HOST=enact-hyku.yourdomain.com
doctl apps update $APP_ID --env HYKU_ROOT_HOST=enact-hyku.yourdomain.com
```

### Step 6: Initialize Database

After first deployment completes:

```bash
# Get app ID
APP_ID=$(doctl apps list --format ID --no-header)

# Run migrations
doctl apps run $APP_ID --component web -- bundle exec rails db:migrate

# Seed initial data
doctl apps run $APP_ID --component web -- bundle exec rails db:seed

# Create admin user (if not in seeds)
doctl apps run $APP_ID --component web -- bundle exec rails hyku:create_admin_user
```

### Step 7: Create First Tenant

```bash
# Open Rails console
doctl apps run $APP_ID --component web -- bundle exec rails console

# In console (will open interactive session):
Account.create!(
  name: 'ENACT Practice Research',
  cname: 'practice.enact-hyku.yourdomain.com',
  tenant: 'practice'
)
```

## Manual Configuration (If Not Using app.yaml)

If configuring manually in DO dashboard instead of using the spec file:

### Resources to Add:

**Web Service (web)**:
- Name: `web`
- Source: GitHub `adammoore/enact-hyku`, branch `main`
- Dockerfile path: `Dockerfile`
- HTTP port: `3000`
- Health check: `/`
- Instance size: Professional-S ($24/month)
- Instance count: 1

**Worker Service (worker)**:
- Name: `worker`
- Source: Same as web
- Run command: `bundle exec sidekiq`
- Instance size: Basic-XS ($6/month)
- Instance count: 1

**Solr Service (solr)**:
- Image: `solr:8`
- Internal port: `8983`
- Instance size: Basic-S ($12/month)
- Run command: `solr-precreate hyku /opt/solr/server/solr/configsets/_default`

**Fedora Service (fcrepo)**:
- Image: `samvera/fcrepo4:4.7.6`
- Internal port: `8080`
- Instance size: Basic-S ($12/month)

**PostgreSQL Database (db)**:
- Engine: PostgreSQL 15
- Plan: Basic ($15/month minimum)
- Production cluster recommended ($30/month)

**Redis Cache (redis)**:
- Engine: Redis 7
- Plan: Basic ($15/month minimum)

**Pre-Deploy Job (db-migrate)**:
- Run before each deployment
- Command: `bundle exec rails db:migrate`

## Monitoring and Management

### View Logs

```bash
# All components
doctl apps logs $APP_ID --type run

# Specific component
doctl apps logs $APP_ID --type run --component web
doctl apps logs $APP_ID --type run --component worker

# Follow logs
doctl apps logs $APP_ID --type run --follow
```

Or via Dashboard: **Apps** → Your App → **Runtime Logs**

### Scale Resources

```bash
# Via doctl
doctl apps update $APP_ID --spec .digitalocean/app.yaml

# Edit instance counts or sizes in app.yaml first
```

Or via Dashboard: **Apps** → Your App → **Settings** → Component → **Edit**

### Database Backups

Digital Ocean automatically backs up managed databases daily. To configure:

1. Go to **Databases** in dashboard
2. Select your database
3. **Settings** → **Backups**
4. Configure retention period

Manual backup:
```bash
# Get database connection info
doctl databases connection $DB_ID

# Create backup
pg_dump -h host -U user -d database > backup-$(date +%Y%m%d).sql
```

### Restart Services

```bash
# Restart entire app
doctl apps create-deployment $APP_ID

# Restart specific component (rebuild from GitHub)
# Push a commit or use dashboard
```

### Rails Console Access

```bash
doctl apps run $APP_ID --component web -- bundle exec rails console
```

### Run Rake Tasks

```bash
# Reindex collections
doctl apps run $APP_ID --component web -- bundle exec rails hyrax:reindex_collections

# Reindex works
doctl apps run $APP_ID --component web -- bundle exec rails hyrax:reindex_works
```

## Container Registry (Advanced)

If you want to use Digital Ocean Container Registry for custom images:

### Create Registry

```bash
# Create registry
doctl registry create enact-hyku

# Login to registry
doctl registry login
```

### Build and Push Custom Image

```bash
cd /path/to/enact-hyku

# Build image
docker build -t registry.digitalocean.com/enact-hyku/web:latest .

# Push to registry
docker push registry.digitalocean.com/enact-hyku/web:latest
```

### Update App to Use Custom Image

Edit `.digitalocean/app.yaml`:

```yaml
services:
  - name: web
    image:
      registry_type: DOCR
      registry: enact-hyku
      repository: web
      tag: latest
```

Deploy update:
```bash
doctl apps update $APP_ID --spec .digitalocean/app.yaml
```

## Cost Breakdown

### App Platform (Recommended Configuration)

**Compute**:
- Web service (Professional-S): $24/month
- Worker service (Basic-XS): $6/month
- Solr service (Basic-S): $12/month
- Fedora service (Basic-S): $12/month

**Databases**:
- PostgreSQL (Basic): $15/month
- Redis (Basic): $15/month

**Storage**:
- Spaces (250GB): $5/month
- Spaces bandwidth: $0.01/GB after 1TB

**Total**: ~$90/month for basic production setup

### Scaling Options

**Growing Usage**:
- Web: Professional-M ($48/month)
- PostgreSQL: Production cluster ($30/month)
- Redis: Production cluster ($30/month)
- Total: ~$160/month

**High Traffic**:
- Multiple web instances
- Larger database plans
- CDN for assets
- Total: $300-500/month

## Performance Optimization

### Enable CDN for Spaces

1. When creating Space, enable CDN
2. Use CDN endpoint for assets: `https://enact-hyku-prod.lon1.cdn.digitaloceanspaces.com`

### Database Connection Pooling

Add to environment:
```
DB_POOL=25
```

### Redis Caching

Hyku uses Redis for caching and background jobs. For high traffic:
- Upgrade to Production Redis plan
- Configure separate Redis instances for cache vs jobs

### Horizontal Scaling

Scale web instances:

```yaml
# In app.yaml
services:
  - name: web
    instance_count: 3  # Run 3 web instances
```

## Security Best Practices

### 1. Environment Variables
Never commit secrets to Git. Use DO App Platform environment variables.

### 2. Database Security
- Use managed database (automatic security patches)
- Enable trusted sources (firewall)
- Regular backups enabled

### 3. SSL/TLS
Automatic with custom domains. Force HTTPS:
```
FORCE_SSL=true
```

### 4. Secrets Rotation
Regularly rotate:
- SECRET_KEY_BASE
- Database passwords (via DO dashboard)
- API keys (Spaces, SMTP, etc.)

### 5. Network Security
DO App Platform includes:
- DDoS protection
- Automatic OS security patches
- Isolated networking between services

## Troubleshooting

### Build Failures

Check build logs:
```bash
doctl apps logs $APP_ID --type build
```

Common issues:
- Missing Dockerfile (ensure Hyku merge completed)
- Build timeout (increase resources)
- Dependency errors (check Gemfile.lock)

### Runtime Errors

Check runtime logs:
```bash
doctl apps logs $APP_ID --type run --follow
```

Common issues:
- Missing environment variables
- Database connection failures
- Fedora/Solr connectivity issues

### Database Connection Issues

Test connection:
```bash
# Get database connection string
doctl databases connection $DB_ID

# Test from web component
doctl apps run $APP_ID --component web -- bundle exec rails db:migrate:status
```

### Solr/Fedora Not Responding

Check if services are running:
```bash
# Via logs
doctl apps logs $APP_ID --type run --component solr
doctl apps logs $APP_ID --type run --component fcrepo

# Test connectivity
doctl apps run $APP_ID --component web -- curl http://solr:8983/solr/admin/ping
doctl apps run $APP_ID --component web -- curl http://fcrepo:8080/fcrepo/rest
```

### Out of Memory Errors

Upgrade component size:
```yaml
# In app.yaml
services:
  - name: web
    instance_size_slug: professional-m  # More memory
```

## Deployment Workflow

### Development → Production

1. **Develop locally** with Docker Compose
2. **Push to GitHub** feature branch
3. **Create pull request** to main
4. **Merge to main** → automatic deployment to DO
5. **Monitor deployment** via logs
6. **Verify** application health

### Rollback

If deployment fails:

```bash
# List deployments
doctl apps list-deployments $APP_ID

# Rollback to previous
doctl apps rollback $APP_ID --deployment-id <previous-deployment-id>
```

Or via Dashboard: **Deployments** → Select previous → **Rollback**

## Continuous Integration

### GitHub Actions

Create `.github/workflows/ci.yml`:

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
      redis:
        image: redis:7
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rails test
```

Configure App Platform to wait for CI:
- Dashboard → Settings → App-Level Settings
- Wait for CI to pass before deploying

## Backup Strategy

### Automated Backups

**Database**:
- Automatic daily backups by DO (7-day retention)
- Upgrade to 14+ day retention on higher plans

**Spaces**:
- Enable versioning
- Configure lifecycle policies

### Manual Backups

**Database**:
```bash
# Backup
doctl databases backup $DB_ID

# Download backup
pg_dump $(doctl databases connection $DB_ID --format ConnectionString) > backup.sql
```

**Fedora Repository**:
```bash
# Export all objects
doctl apps run $APP_ID --component web -- bundle exec rails hyku:export_fedora
```

**Full Application Backup**:
1. Database backup
2. Spaces sync: `aws s3 sync s3://bucket local-backup/ --endpoint-url=https://lon1.digitaloceanspaces.com`
3. Fedora export
4. Configuration backup (environment variables)

## Support and Resources

### Digital Ocean
- **Documentation**: https://docs.digitalocean.com/products/app-platform/
- **Community**: https://www.digitalocean.com/community
- **Support**: https://cloud.digitalocean.com/support

### Samvera Hyku
- **GitHub**: https://github.com/samvera/hyku
- **Documentation**: https://samvera.atlassian.net/wiki/spaces/hyku/
- **Slack**: https://samvera.slack.com/

### ENACT Hyku
- **Documentation**: https://adammoore.github.io/enact-hyku/
- **GitHub Issues**: https://github.com/adammoore/enact-hyku/issues

## Next Steps After Deployment

1. **Configure Solr Schema**
   - Upload Hyku's Solr configuration
   - Optimize for PRVoices metadata

2. **Customize for PRVoices Schema**
   - Create Portfolio work type
   - Add PRVoices metadata fields
   - Implement context statement editor

3. **Set Up Monitoring**
   - Configure alerting
   - Set up external monitoring (UptimeRobot, etc.)

4. **Performance Testing**
   - Load testing
   - Optimize database queries
   - Configure caching

5. **User Training**
   - Create user documentation
   - Training materials for depositors
   - Admin guides

---

**Note**: This deployment configuration provides a production-ready Hyku instance. The PRVoices schema customizations will be added on top of this base Hyku installation.
