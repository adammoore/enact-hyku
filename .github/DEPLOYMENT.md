# Continuous Deployment Setup

This repository uses GitHub Actions to automatically deploy to the Digital Ocean Droplet whenever code is pushed to the `main` branch.

## How It Works

1. **Push to main** → Triggers GitHub Actions workflow
2. **GitHub connects to Droplet** → Via SSH using stored secrets
3. **Pulls latest code** → `git pull origin main`
4. **Precompiles assets** → `rails assets:precompile`
5. **Restarts services** → `docker compose restart web worker`
6. **Health check** → Verifies deployment succeeded

## Setup Instructions

### 1. Add GitHub Secrets

Go to your repository settings on GitHub:
- Navigate to: **Settings** → **Secrets and variables** → **Actions**
- Click **New repository secret** for each of the following:

#### Required Secrets:

**DROPLET_HOST**
```
165.232.101.191
```

**DROPLET_USER**
```
root
```

**DROPLET_SSH_KEY**
- The private SSH key content from `/Users/adamvialsmoore/.ssh/id_ed25519`
- Copy the ENTIRE private key including the BEGIN and END lines
- Should look like:
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtz...
(many lines of key data)
...AAAAEnJvb3RAYWRhbW1vb3JlLW1icAAAABVlbmFjdC1oeWt1LWRyb3BsZXQ=
-----END OPENSSH PRIVATE KEY-----
```

### 2. Verify SSH Key on Droplet

The public key should already be in `/root/.ssh/authorized_keys` on the Droplet:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILaPXd1jMkRFOJtsZSYLlY3HDIvKhuTeTXkQ4RXszMf9 enact-hyku-droplet
```

### 3. Test Deployment

#### Automatic Deployment
Push any change to the `main` branch and GitHub Actions will automatically deploy.

#### Manual Deployment
1. Go to **Actions** tab on GitHub
2. Select **Deploy to Digital Ocean Droplet** workflow
3. Click **Run workflow** → **Run workflow**

### 4. Monitor Deployments

View deployment progress:
- Go to **Actions** tab on GitHub
- Click on the latest workflow run
- Expand the **Deploy to Droplet** step to see live output

## Deployment Logs

Each deployment shows:
- ✅ Git pull status
- ✅ Asset compilation output
- ✅ Service restart confirmation
- ✅ Health check results

## Rollback

If a deployment fails or causes issues:

```bash
# SSH to Droplet
ssh root@165.232.101.191

cd /root/enact-hyku

# View recent commits
git log --oneline -5

# Rollback to previous commit
git reset --hard <commit-hash>

# Restart services
docker compose -f docker-compose.droplet.yml restart web worker
```

## Security Notes

- **Never commit** the private SSH key to the repository
- SSH key is stored securely in GitHub Secrets (encrypted)
- Only repository admins can view/edit secrets
- Secrets are not exposed in workflow logs

## Troubleshooting

### Deployment Fails with SSH Error
- Verify DROPLET_SSH_KEY secret contains the complete private key
- Check that the public key is in `/root/.ssh/authorized_keys` on Droplet

### Assets Not Updating
- Clear browser cache
- Check asset precompilation logs in GitHub Actions output
- SSH to Droplet and manually run: `docker compose -f docker-compose.droplet.yml exec web rails assets:clean assets:precompile`

### Services Don't Restart
- Check Docker container status: `docker compose -f docker-compose.droplet.yml ps`
- View logs: `docker compose -f docker-compose.droplet.yml logs web --tail=50`

## Disable Auto-Deployment

To temporarily disable automatic deployments:

1. Go to **Settings** → **Actions** → **General**
2. Under **Actions permissions**, select **Disable actions**

Or comment out the `push:` trigger in `.github/workflows/deploy.yml`:

```yaml
on:
  # push:
  #   branches:
  #     - main
  workflow_dispatch: # Manual trigger only
```

## Future Enhancements

Consider adding:
- **Staging environment**: Deploy `develop` branch to staging server
- **Slack notifications**: Alert team when deployments complete
- **Database migrations**: Run `rails db:migrate` automatically
- **Health checks**: More comprehensive post-deployment testing
- **Rollback automation**: Automatic rollback if health checks fail
