---
layout: default
title: Home
---

# ENACT Hyku: Practice Research Repository

Welcome to the documentation for ENACT Hyku, a Samvera Hyku instance designed for practice-based research using the PRVoices metadata schema.

## Overview

Practice-based research generates diverse outputs beyond traditional academic publications. Researchers create sculptures, performances, installations, exhibitions, and other creative works that embody research insights. This repository provides infrastructure to document, preserve, and share these multifaceted research outputs.

## What is Practice Research?

Practice research (also known as practice-based or practice-led research) is an approach where creative practice forms an essential part of the research process. The research insights emerge through and are embedded in the creative work itself.

Key characteristics:
- **Creative outputs are research**: Artworks, performances, and designs are not merely illustrations but contain research knowledge
- **Process is significant**: The journey of creation, experimentation, and reflection contributes to research understanding
- **Context matters**: Research emerges from and speaks to specific creative, cultural, and institutional contexts
- **Multiple knowledge forms**: Combines embodied knowledge, tacit understanding, and explicit documentation

## Why PRVoices Schema?

Traditional research metadata schemas focus on text-based publications and fail to capture:
- The diversity of practice research outputs
- The relationships between works in a research portfolio
- The narrative context of creative practice
- The temporal and spatial dimensions of exhibitions and performances

The [PRVoices schema](schema.html) addresses these gaps by providing:
- Portfolio-level organization for related works
- Specialized metadata for different output types (artefacts, events, literature, collections)
- Rich contextual statements using embedded XHTML
- Support for complex contributor relationships
- Geographic and temporal information for events
- Links to funding, institutions, and related works

## Documentation Structure

### For Users
- **[User Guide](user-guide.html)**: Step-by-step guide for depositing practice research portfolios
- **[NTRO Provenance Framework](ntro-provenance.html)**: Understanding provenance metadata for practice research
- **[Research Practices](research-practices.html)**: How the schema reflects research practices and processes

### For Administrators
- **[PRVoices Schema](schema.html)**: Technical overview of the metadata schema
- **[Installation](installation.html)**: Setting up your own instance
- **[Configuration](configuration.html)**: Configuring your Enact instance
- **[Digital Ocean Deployment](https://github.com/adammoore/enact-hyku/blob/main/DIGITALOCEAN_DEPLOYMENT.md)**: Production deployment guide

## Project Status

This project is in active development. We are establishing the repository structure and developing documentation to support practice researchers in understanding and using the system.

## Related Projects

- [Samvera Hyku](https://github.com/samvera/hyku) - The underlying repository platform
- [PRVoices Schema](https://github.com/research-technologies/prvoices_schema) - The metadata schema specification
- Research Technologies, University of Westminster - Schema development

## Getting Started

If you are a **researcher** wanting to understand how to represent your practice research, start with [Research Practices](research-practices.html).

If you are a **developer** wanting to install and configure the system, see [Installation](installation.html).

If you are a **metadata specialist** wanting to understand the schema structure, see [PRVoices Schema](schema.html).
