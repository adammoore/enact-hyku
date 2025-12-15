# ENACT Hyku - Heroku Deployment Guide

This guide covers deploying ENACT Hyku to Heroku with automatic deployment from the GitHub main branch.

## Important Notes

**Heroku Deployment Considerations**: Samvera Hyku is typically deployed using Docker/Kubernetes or AWS. Heroku deployment requires additional external services (Fedora, Solr) that are not available as Heroku addons. This guide provides a path forward, but expect additional configuration complexity.

## Prerequisites

1. **Heroku Account** with credit card on file (required for production addons)
2. **Heroku CLI** installed: https://devcenter.heroku.com/articles/heroku-cli
3. **Git** installed and configured
4. **External Services** set up (see below)

## External Services Required

Hyku requires these services that are NOT available as Heroku addons:

### 1. Fedora Repository
Fedora is the preservation repository backend. Options:

**Option A: DuraCloud** (Recommended for managed solution)
- Sign up at https://duraspace.org/duracloud/
- Provides managed Fedora hosting
- Pricing varies by storage needs

**Option B: Self-hosted Fedora**
- Deploy Fedora on AWS EC2, Digital Ocean, or similar
- Use Docker: `docker run -p 8080:8080 samvera/fcrepo4:4.7`
- See: https://wiki.duraspace.org/display/FEDORA

**Option C: Amazon S3 with Valkyrie**
- Hyku 6.x supports Valkyrie which can use S3 directly
- Configure Valkyrie to use S3 instead of Fedora
- More cost-effective but different architecture

### 2. Solr Search Index
Solr provides search functionality. Options:

**Option A: Websolr Heroku Addon** (Recommended)
```bash
heroku addons:create websolr:starter
```
- Managed Solr service
- Integrates directly with Heroku
- Configure Solr core for Hyku schema

**Option B: Self-hosted Solr**
- Deploy on AWS EC2, Digital Ocean, or similar
- Use Docker: `docker run -p 8983:8983 solr:8`
- Configure with Hyku's Solr config files

**Option C: AWS CloudSearch or OpenSearch**
- Alternative search services
- Requires adapter configuration

## Step 1: Merge Hyku Codebase

First, you need to add the Samvera Hyku application code to this repository:

```bash
# Navigate to your repository
cd enact-hyku

# Add Hyku as a remote
git remote add hyku https://github.com/samvera/hyku.git

# Fetch Hyku code
git fetch hyku

# Merge Hyku main branch (this will merge the Hyku codebase)
# NOTE: You may need to resolve conflicts with README.md and docs/
git merge hyku/main --allow-unrelated-histories

# Keep your README and docs, but take Hyku's code
# If conflicts occur:
git checkout --ours README.md
git checkout --ours docs/
git checkout --ours LICENSE
git add .

# Complete the merge
git commit -m "Merge Samvera Hyku codebase for ENACT customization"

# Push to GitHub
git push origin main
```

Alternatively, use the provided script:
```bash
./scripts/merge_hyku.sh
```

## Step 2: Create Heroku Application

```bash
# Login to Heroku
heroku login

# Create Heroku app
heroku create enact-hyku

# Or with a specific name
heroku create your-app-name

# Add to your git remote (if not automatic)
heroku git:remote -a enact-hyku
```

## Step 3: Add Heroku Addons

```bash
# PostgreSQL database (required)
heroku addons:create heroku-postgresql:standard-0

# Redis for background jobs (required)
heroku addons:create heroku-redis:premium-0

# Websolr for search (if using this option)
heroku addons:create websolr:starter

# SendGrid for email (recommended)
heroku addons:create sendgrid:starter

# Optional: Papertrail for logging
heroku addons:create papertrail:choklad

# Optional: New Relic for monitoring
heroku addons:create newrelic:wayne
```

## Step 4: Configure Environment Variables

Set required environment variables:

```bash
# Generate secret key
SECRET_KEY=$(bundle exec rails secret)
heroku config:set SECRET_KEY_BASE=$SECRET_KEY

# Set Hyku hosts (replace with your actual domains)
heroku config:set HYKU_ADMIN_HOST=admin-enact.herokuapp.com
heroku config:set HYKU_ROOT_HOST=enact.herokuapp.com
heroku config:set HYKU_MULTITENANT=true

# External Fedora repository
heroku config:set FEDORA_URL=https://your-fedora-instance.com/fcrepo/rest

# External Solr (if not using Websolr addon)
heroku config:set SOLR_URL=https://your-solr-instance.com/solr/hyku

# AWS S3 for file storage
heroku config:set AWS_ACCESS_KEY_ID=your_key
heroku config:set AWS_SECRET_ACCESS_KEY=your_secret
heroku config:set AWS_REGION=us-east-1
heroku config:set AWS_BUCKET=enact-hyku-production

# Email configuration (if using SendGrid)
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=$(heroku config:get SENDGRID_PASSWORD)

# Rails configuration
heroku config:set RAILS_ENV=production
heroku config:set RAILS_LOG_TO_STDOUT=true
heroku config:set RAILS_SERVE_STATIC_FILES=true
heroku config:set FORCE_SSL=true

# Worker configuration
heroku config:set WEB_CONCURRENCY=2
heroku config:set RAILS_MAX_THREADS=5
heroku config:set SIDEKIQ_CONCURRENCY=5
```

See `.env.heroku.sample` for complete list of configuration options.

## Step 5: Scale Dynos

```bash
# Scale web dynos (at least standard-2x recommended for Hyku)
heroku ps:scale web=1:standard-2x

# Scale worker dynos for background jobs
heroku ps:scale worker=1:standard-1x
```

## Step 6: Connect GitHub for Automatic Deployment

### Via Heroku Dashboard (Recommended):

1. Go to https://dashboard.heroku.com/apps/enact-hyku
2. Navigate to the "Deploy" tab
3. Under "Deployment method", select "GitHub"
4. Click "Connect to GitHub" and authorize
5. Search for "adammoore/enact-hyku" and click "Connect"
6. Under "Automatic deploys":
   - Select branch: `main`
   - Check "Wait for CI to pass before deploy" (if you have CI)
   - Click "Enable Automatic Deploys"

Now every push to the main branch will automatically deploy to Heroku!

### Via Heroku CLI:

```bash
# Link GitHub repository
heroku plugins:install heroku-repo
heroku repo:purge_cache -a enact-hyku
```

## Step 7: Deploy Application

If not using automatic deployment yet, manual deploy:

```bash
# Push to Heroku
git push heroku main

# Or if using a different branch
git push heroku your-branch:main
```

The release phase (defined in Procfile) will run database migrations automatically.

## Step 8: Initialize Database

```bash
# Create database (first time only)
heroku run bundle exec rails db:create

# Run migrations
heroku run bundle exec rails db:migrate

# Seed initial data
heroku run bundle exec rails db:seed

# Create admin user
heroku run bundle exec rails hyku:create_admin_user
```

## Step 9: Configure Solr

If using Websolr:

```bash
# Get Websolr URL
heroku config:get WEBSOLR_URL

# Configure Solr core with Hyku schema
# You may need to upload Hyku's solr config files to Websolr
# See: https://websolr.com/documentation
```

If using external Solr:
- Upload Hyku's Solr configuration from `solr/config/`
- Create a core named `hyku`
- Ensure SOLR_URL points to your instance

## Step 10: Create First Tenant

```bash
# Open Rails console
heroku run bundle exec rails console

# In the console:
Account.create!(
  name: 'ENACT Practice Research',
  cname: 'practice.enact.herokuapp.com',
  tenant: 'practice'
)

# Exit console
exit
```

## Step 11: Configure Custom Domain (Optional)

If using a custom domain:

```bash
# Add domain to Heroku
heroku domains:add enact.yourdomain.com
heroku domains:add admin-enact.yourdomain.com
heroku domains:add practice.enact.yourdomain.com

# Heroku will provide DNS targets
# Configure your DNS provider to point to these targets

# Add SSL certificate (automatic with ACM)
heroku certs:auto:enable
```

Update environment variables:
```bash
heroku config:set HYKU_ADMIN_HOST=admin-enact.yourdomain.com
heroku config:set HYKU_ROOT_HOST=enact.yourdomain.com
```

## Monitoring and Maintenance

### View Logs
```bash
# Stream logs
heroku logs --tail

# View specific process logs
heroku logs --ps web
heroku logs --ps worker

# Search logs
heroku logs --tail | grep ERROR
```

### Database Backups
```bash
# Manual backup
heroku pg:backups:capture

# Schedule automatic backups
heroku pg:backups:schedule DATABASE_URL --at '02:00 America/New_York'

# Download backup
heroku pg:backups:download
```

### Restart Application
```bash
# Restart all dynos
heroku restart

# Restart specific dyno type
heroku restart web
heroku restart worker
```

### Rails Console Access
```bash
heroku run bundle exec rails console
```

### Run Rake Tasks
```bash
heroku run bundle exec rails <task_name>

# Examples:
heroku run bundle exec rails hyrax:reindex_collections
heroku run bundle exec rails hyrax:reindex_works
```

## Troubleshooting

### Application Won't Start

Check logs:
```bash
heroku logs --tail
```

Common issues:
- Missing environment variables
- Database migration failures
- External service (Fedora/Solr) connectivity issues

### External Service Connection Issues

Test connectivity:
```bash
heroku run curl $FEDORA_URL
heroku run curl $SOLR_URL
```

Ensure:
- URLs are correct and accessible from Heroku
- Firewalls allow Heroku IP ranges
- Authentication credentials are correct

### Performance Issues

Monitor dyno metrics:
```bash
heroku ps
heroku logs --ps web --tail
```

Consider:
- Scaling up dyno size or count
- Optimizing database queries
- Adding Redis caching
- Using CDN for assets

### Database Issues

```bash
# Check database info
heroku pg:info

# Reset database (WARNING: destroys all data)
heroku pg:reset DATABASE_URL
heroku run bundle exec rails db:migrate
heroku run bundle exec rails db:seed
```

## Cost Optimization

### Development/Staging Environment
```bash
# Use cheaper addons for non-production
heroku addons:create heroku-postgresql:hobby-dev
heroku addons:create heroku-redis:hobby-dev
heroku ps:scale web=1:basic
heroku ps:scale worker=1:basic
```

### Production Environment Estimates

Monthly costs (approximate):
- **Dynos**:
  - Web (standard-2x): $50/dyno
  - Worker (standard-1x): $25/dyno
- **PostgreSQL** (standard-0): $50
- **Redis** (premium-0): $15
- **Websolr** (starter): $20-80
- **External Fedora**: $50-200 (varies by provider)
- **S3 Storage**: Variable based on usage

**Total estimated**: $200-400/month minimum

### Scaling Considerations

As usage grows, consider:
- Multiple web dynos for redundancy
- Larger dyno sizes for performance
- Database connection pooling (PgBouncer)
- CDN for asset delivery
- Caching strategies (Redis, Memcached)

## Security Best Practices

1. **Never commit secrets**: Use environment variables
2. **Enable SSL**: `heroku config:set FORCE_SSL=true`
3. **Regular backups**: Schedule automated database backups
4. **Monitor logs**: Watch for suspicious activity
5. **Keep dependencies updated**: Regular `bundle update`
6. **Use strong secrets**: Generate with `rails secret`

## Updating Application

With automatic deployment enabled:

```bash
# Make changes locally
git add .
git commit -m "Your changes"
git push origin main

# Heroku will automatically deploy!
```

Monitor deployment:
```bash
heroku releases
heroku logs --tail
```

## PRVoices Schema Customization

After basic Hyku deployment works, you'll need to:

1. **Create custom work types** for Portfolio, Artefact, Event, Literature, Collection
2. **Add PRVoices metadata fields** to models and forms
3. **Implement context statement editor** with XHTML support
4. **Configure controlled vocabularies** (ORCID, ROR, LCSH)
5. **Customize display templates** for practice research outputs

See main documentation at https://adammoore.github.io/enact-hyku/ for schema details.

## Support Resources

- **Heroku Documentation**: https://devcenter.heroku.com/
- **Samvera Hyku**: https://github.com/samvera/hyku
- **Samvera Community**: https://samvera.org/
- **Hyku Documentation**: https://samvera.atlassian.net/wiki/spaces/hyku/

## Getting Help

- **Heroku Support**: https://help.heroku.com/
- **Samvera Slack**: https://samvera.slack.com/
- **GitHub Issues**: https://github.com/adammoore/enact-hyku/issues

---

**Note**: This deployment approach is experimental. Hyku is designed for Docker/K8s deployment. Be prepared for additional configuration and troubleshooting beyond a typical Rails app on Heroku.
