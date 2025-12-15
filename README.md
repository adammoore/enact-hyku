# ENACT Hyku - Practice Research Repository

A Samvera Hyku instance configured for practice research, implementing the [PRVoices metadata schema](https://github.com/research-technologies/prvoices_schema).

## About

This repository implements a practice research repository based on Samvera Hyku, customized to support the diverse outputs of practice-based research including:

- Creative artefacts (sculptures, performances, installations, etc.)
- Events (exhibitions, performances, workshops)
- Literature and publications
- Collections (playlists, archives, compilations)
- Rich contextual narratives documenting research processes

## PRVoices Schema

The repository implements the PRVoices metadata schema, which extends traditional research metadata to capture:

- **Portfolio-level metadata**: Comprehensive project information with RAiD identifiers
- **Context Statements**: Rich narrative sections describing:
  - Project Framework
  - Project Narrative
  - Research Insights
  - Further Dissemination and Recognition
- **Portfolio Items**: Different types of research outputs with specialized metadata
- **Relationships**: Links between works, publications, and institutional structures

## Quick Start

### Digital Ocean Deployment (Recommended)

Deploy to Digital Ocean App Platform with automatic deployment from GitHub:

1. **Merge Hyku codebase**:
   ```bash
   ./scripts/merge_hyku.sh
   ```

2. **Deploy to Digital Ocean**:
   ```bash
   # Install doctl (Digital Ocean CLI)
   brew install doctl  # macOS

   # Authenticate
   doctl auth init

   # Create app from spec
   doctl apps create --spec .digitalocean/app.yaml
   ```

3. **Configure environment variables and domain** - See [DIGITALOCEAN_DEPLOYMENT.md](DIGITALOCEAN_DEPLOYMENT.md)

**Why Digital Ocean?**
- Native Docker support (Hyku is Docker-native)
- All services included (Fedora, Solr, PostgreSQL, Redis)
- Automatic GitHub deployment
- Cost-effective (~$90/month vs $200-400 on Heroku)
- S3-compatible Spaces for file storage

### Local Development

Prerequisites:
- Docker (tested with version 28.5.2)
- Docker Compose (tested with version 2.40.3)
- macOS or Linux

After merging Hyku codebase:
```bash
docker compose build
docker compose up
```

## Documentation

Comprehensive documentation is available at: https://adammoore.github.io/enact-hyku/

Topics covered:
- Understanding the PRVoices schema
- Heroku deployment guide
- Installation and configuration
- Creating practice research portfolios
- Mapping research practices to metadata

## Project Status

This project is in initial development. The repository structure and configuration are being established.

## License

See [LICENSE](LICENSE) for details.

## Acknowledgments

- Built on [Samvera Hyku](https://github.com/samvera/hyku)
- PRVoices schema developed by [Research Technologies, University of Westminster](https://github.com/research-technologies/prvoices_schema)
