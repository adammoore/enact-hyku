---
layout: default
title: Installation
---

# Installation Guide

This guide covers installing and configuring ENACT Hyku for practice research using the PRVoices schema.

## Prerequisites

Before beginning, ensure you have:

- **Docker** (version 28.5.2 or later)
- **Docker Compose** (version 2.40.3 or later)
- **macOS or Linux** (recommended)
- **10+ GB free disk space** for Docker images
- **Internet connection** (initial build takes 10+ minutes on 100Mbit connection)
- **Git** for repository management

### Check Prerequisites

```bash
docker --version
docker-compose --version
git --version
```

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/adammoore/enact-hyku.git
cd enact-hyku
```

### 2. Understanding Hyku

ENACT Hyku is built on [Samvera Hyku](https://github.com/samvera/hyku), a multi-tenant repository application. Key features:

- **Multi-tenancy**: Support multiple institutions or projects
- **Hyrax-based**: Uses the Samvera Hyrax framework
- **Fedora Repository**: Preservation-focused object store
- **Solr**: Full-text search and faceting
- **PostgreSQL**: Application database
- **Redis**: Background job processing

### 3. Initial Setup (Coming Soon)

Detailed setup instructions will be provided once the Hyku configuration is complete. The setup will include:

1. Docker image building
2. Database initialization
3. Fedora repository configuration
4. Solr core creation
5. Initial admin account setup

## PRVoices Schema Integration

The key customization for ENACT Hyku is implementing the PRVoices metadata schema. This involves:

### Metadata Model Extensions

The PRVoices schema requires extending Hyku's default metadata model to support:

#### Portfolio Work Type
A new work type representing a complete practice research portfolio with:
- Portfolio identifiers (RAiD, DOI, Handle)
- Multiple titles with language support
- Comprehensive contributor information
- Rich context statements
- Subject and keyword taxonomies
- Funding references
- Organizational unit affiliations

#### Portfolio Item Types
Specialized work types for different outputs:

**Artefact**
- Artefact type (sculpture, painting, installation, etc.)
- Physical dimensions and materials
- Geographic location information
- Creation and collection dates

**Event**
- Event type (exhibition, performance, workshop, etc.)
- Duration dates
- Geographic locations (points or bounding boxes)
- Associated files and documentation
- Multiple contributors with event-specific roles

**Literature**
- Literature type (book, article, catalogue, etc.)
- Publication information
- Contributor roles

**Collection**
- Collection type (archive, playlist, etc.)
- Extent information (duration, item count)
- Curation rationale

### Context Statement Implementation

The context statement is a key feature requiring:

**Rich Text Editor Integration**
- XHTML support for formatted content
- Section structure (Project Framework, Narrative, Insights, Dissemination)
- Embedded images and links
- Formatting (emphasis, lists, etc.)

**Possible Approaches**:
1. TinyMCE or CKEditor integration for XHTML editing
2. Markdown with HTML conversion
3. Custom React-based structured editor

### Geographic Data Support

Events and artefacts require geographic metadata:

- **Place names**: Text fields with autocomplete
- **Point coordinates**: Latitude/longitude pairs
- **Bounding boxes**: Geographic extent for distributed works

**Implementation Options**:
1. GeoNames integration for place name lookup
2. Map-based coordinate selection
3. Manual coordinate entry with validation

### Identifier Support

Multiple identifier types need integration:

- **RAiD**: Research Activity Identifier (recommended for portfolios)
- **ORCID**: For contributor identification
- **ROR**: Research Organization Registry for institutions
- **Crossref Funder ID**: For funding organizations
- **DOI, Handle, URL**: Alternative identifiers

### Controlled Vocabularies

The schema uses established vocabularies:

- **LCSH**: Library of Congress Subject Headings
- **ANZSRC**: Australian and New Zealand Standard Research Classification
- **SPDX**: Software Package Data Exchange (for licenses)
- **Custom**: Institution-specific taxonomies

**Implementation Approach**:
1. Questioning Authority gem for vocabulary lookup
2. Local authority files for custom terms
3. API integration for external vocabularies

## Development Workflow

### Local Development

```bash
# Build Docker images (first time)
docker compose build

# Start services
docker compose up web

# Access application
# https://admin-hyku.localhost.direct (default configuration)
```

### Customization Workflow

1. **Model Changes**: Edit `app/models/` for new work types
2. **Form Customization**: Modify `app/forms/` for metadata entry
3. **Indexing**: Update `app/indexers/` for Solr integration
4. **Views**: Customize `app/views/` for display
5. **Tests**: Add specs in `spec/` for new functionality

### Testing

```bash
# Run test suite
docker compose exec web bundle exec rspec

# Run specific tests
docker compose exec web bundle exec rspec spec/models/portfolio_spec.rb
```

## Configuration

### Environment Variables

Key configuration in `.env` file:

```bash
# Application
RAILS_ENV=development
HYKU_ADMIN_HOST=admin-hyku.localhost.direct
HYKU_ADMIN_ONLY_TENANT_CREATION=true

# Database
DATABASE_URL=postgresql://postgres:password@db:5432/hyku

# Fedora
FEDORA_URL=http://fcrepo:8080/fcrepo/rest

# Solr
SOLR_URL=http://solr:8983/solr/hyku

# Redis
REDIS_URL=redis://redis:6379/0
```

### Tenant Configuration

Hyku supports multiple tenants. Each tenant can have:
- Custom branding
- Specific metadata profiles
- Independent collections
- Separate user management

Creating a tenant for practice research:

```bash
docker compose exec web bundle exec rails console

# In Rails console:
Account.create!(
  name: 'Practice Research Repository',
  cname: 'practice.localhost.direct',
  tenant: 'practice'
)
```

## Production Deployment

### Requirements

Production deployment requires:
- Persistent storage for Fedora and uploads
- Database backups
- SSL certificates
- Monitoring and logging
- Regular maintenance windows

### Docker Compose Production

```bash
# Use production compose file
docker compose -f docker-compose.production.yml up -d
```

### Kubernetes Deployment

Samvera community provides Helm charts for Kubernetes deployment:
- Scalable architecture
- High availability
- Resource management
- Rolling updates

## Maintenance

### Regular Tasks

**Database Maintenance**
```bash
docker compose exec web bundle exec rails db:migrate
docker compose exec db pg_dump hyku > backup.sql
```

**Solr Reindexing**
```bash
docker compose exec web bundle exec rails hyrax:reindex_collections
docker compose exec web bundle exec rails hyrax:reindex_works
```

**Log Management**
```bash
docker compose logs --tail=100 web
docker compose logs -f web  # Follow logs
```

### Backup Strategy

Essential backups:
1. **PostgreSQL database**: Application data and user accounts
2. **Fedora repository**: Preservation storage
3. **Uploaded files**: Direct uploads and derivatives
4. **Configuration**: `.env` and custom settings

## Troubleshooting

### Common Issues

**Services won't start**
```bash
docker compose down -v  # Remove volumes
docker compose up --build  # Rebuild images
```

**Database connection errors**
```bash
docker compose exec db psql -U postgres -l  # Check database
docker compose restart db  # Restart database
```

**Solr indexing problems**
```bash
docker compose exec web bundle exec rails hyrax:solr:reload_collections
```

## Support and Resources

### Documentation
- [Samvera Hyku Documentation](https://github.com/samvera/hyku/wiki)
- [Hyrax Documentation](https://samvera.github.io/hyrax/)
- [PRVoices Schema](https://github.com/research-technologies/prvoices_schema)

### Community
- [Samvera Community](https://samvera.org/)
- [Samvera Slack](https://samvera.slack.com/)
- [Developer Community Calls](https://samvera.atlassian.net/wiki/)

### Getting Help
- GitHub Issues: [Report issues](https://github.com/adammoore/enact-hyku/issues)
- Samvera Community: Engage with experienced developers
- Local Support: Consult your institution's repository team

## Next Steps

After installation:
1. Configure your tenant
2. Set up user accounts and roles
3. Create test portfolios
4. Customize the interface
5. Configure backup procedures
6. Plan your metadata migration strategy

## Project Status Note

This installation guide reflects the planned architecture. Specific implementation details will be added as development progresses. Check the [GitHub repository](https://github.com/adammoore/enact-hyku) for the latest updates.
