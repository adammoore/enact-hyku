---
layout: default
title: NTRO Provenance Framework
---

# NTRO Provenance Framework

The NTRO (Non-Traditional Research Outputs) Provenance Framework extends the Portfolio work type with comprehensive metadata for tracking the creation process, cultural context, rights, and transformations of practice research outputs.

## What is NTRO Provenance?

Traditional repository systems focus on preserving the final research output. For practice research, understanding **how** the work came into being is equally important:

- **Creation stages**: Conception, development, iteration, performance, exhibition
- **Cultural context**: Indigenous knowledge, cultural protocols, community affiliations
- **Rights & ownership**: Complex, shared, and community-based rights structures
- **Transformations**: How works evolve through performances, exhibitions, adaptations
- **Ethical considerations**: Community consultation, cultural sensitivity, access protocols

The NTRO Provenance Framework aligns with **FAIR** (Findable, Accessible, Interoperable, Reusable) and **CARE** (Collective Benefit, Authority to Control, Responsibility, Ethics) principles.

> **For Administrators**: This document describes the Hyrax-specific implementation in Enact. For broader platform-agnostic approaches, phased implementation strategies, and practical guidance for DSpace, EPrints, Islandora, and other repository systems, see the **[Practical Provenance Implementation Guide](practical-provenance.html)**.

## Phase 1: Core NTRO Metadata (Implemented)

### Cultural Context & Origin

**Fields:**
- `cultural_origin`: Cultural or indigenous group origins (e.g., "Maori", "Yoruba", "Australian Aboriginal")
- `cultural_community`: Specific communities associated with the work
- `indigenous_affiliation`: Indigenous peoples or nations
- `cultural_sensitivity_level`: Public, Community Only, Restricted, Sacred

**Why it matters:** Practice research often emerges from specific cultural traditions and contexts. This metadata ensures appropriate attribution and respect for cultural origins.

### Traditional Knowledge (TK) Labels

**Fields:**
- `tk_labels`: Local Contexts TK Labels (e.g., TK A, TK CO, TK WG)
- `tk_label_text`: Full descriptions of applicable labels
- `tk_attribution_requirement`: Specific attribution requirements

**What are TK Labels?**
[Local Contexts](https://localcontexts.org) TK Labels are community-developed tools for managing Indigenous intellectual property and cultural heritage. Examples:
- **TK A (Attribution)**: Corrects historical omissions
- **TK CO (Community Use Only)**: Restricted to community members
- **TK WG (Women's General)**: Gender-restricted access
- **TK NC (Non-Commercial)**: Non-commercial use only

**Access Control:** TK Labels can enforce access restrictions based on community membership, gender, and initiation status.

### Rights & Ownership

**Fields:**
- `rights_holder_names`: Individuals, collectives, or communities holding rights
- `rights_type`: Copyright, Cultural Rights, Community Rights, Traditional Knowledge Rights
- `cultural_authority`: Person/body with cultural authority over the work
- `ownership_percentage`: Shared ownership percentages

**Complex nested data (JSON):**
- `rights_holders_json`: Detailed rights holder information including entity type, role, percentage, and cultural context

**Why complex rights matter:** Practice research often involves multiple contributors with different types of rights. Indigenous works may have community rights alongside individual creator rights.

### Ethical Documentation

**Fields:**
- `ethical_clearance`: Ethics approval status and reference number
- `community_consultation_status`: Completed, Ongoing, Planned, Not Required
- `research_methodology`: Methodological approaches used
- `ethical_considerations`: How ethical issues were addressed
- `process_narrative`: Narrative description of research/creative process

**Ethical provenance** demonstrates research integrity and respect for participants, communities, and cultural protocols.

### Creation Stages

**Complex nested data (JSON):**
- `creation_stages_json`: Array of creation stages, each with:
  - `stage_type`: conception, development, iteration, performance, exhibition, publication
  - `date`: When the stage occurred
  - `location`: Where it took place
  - `description`: What happened
  - `contributors`: Who was involved

**Example creation journey:**
```json
[
  {
    "stage_type": "conception",
    "date": "2022-01-15",
    "location": "Te Wānanga o Aotearoa, Hamilton",
    "description": "Initial concept development with kaumātua consultation",
    "contributors": "Jane Smith, Kaumātua Hemi Jones"
  },
  {
    "stage_type": "development",
    "date": "2022-06-01",
    "location": "Artist Studio, Auckland",
    "description": "Prototype whakairo (carving) in kauri",
    "contributors": "Jane Smith, Tohunga whakairo Robert Brown"
  },
  {
    "stage_type": "performance",
    "date": "2023-03-20",
    "location": "Ngā Taonga Sound & Vision, Wellington",
    "description": "Live whakapapa storytelling performance",
    "contributors": "Jane Smith (performer), Maria Garcia (sound design)"
  }
]
```

### Version & Transformation Tracking

**Fields:**
- `version_type`: Draft, Final, Performance, Exhibition, Adaptation, Translation
- `version_number`: Version identifier (e.g., "1.0", "Performance 2023")
- `transformation_type`: Derivative, Adaptation, Iteration, Remix
- `instantiation_type`: Performance, Exhibition, Installation, Screening, Workshop

**Relationship IDs (linking works):**
- `previous_version_id`: Earlier version(s) of this work
- `newer_version_id`: Later version(s) of this work
- `alternate_version_id`: Alternative versions (e.g., different language, medium)
- `derivative_work_id`: Works derived from this work
- `performance_id`: Performance records of this work
- `exhibition_id`: Exhibition records of this work

**Why track transformations?** A sculpture may be exhibited multiple times in different venues. A performance work may have many instantiations. An artwork may be adapted across media. These relationships capture the research trajectory.

### Extended Contributor Roles

**Fields:**
- `contributor_role_extended`: NTRO-specific roles beyond standard CRediT taxonomy
  - Performance
  - Curation
  - Installation
  - Cultural Authority
  - Traditional Knowledge Holder
  - Direction
  - Choreography
  - Sound Design
  - Lighting Design

**Standard Hyrax fields still used:**
- `creator`: Primary creators
- `contributor`: General contributors

### Temporal Documentation

**Fields:**
- `creation_date_start`: When creation/research began
- `creation_date_end`: When it ended (or blank if ongoing)
- `performance_date`: Dates of performances
- `exhibition_date`: Dates of exhibitions

**Note:** Standard `date_created` field is also available for simple date values.

### Funding Information

**Fields:**
- `funder_name`: Funding organization names
- `funder_identifier`: Persistent funder IDs (e.g., ROR, Crossref Funder ID)
- `award_number`: Grant/award numbers
- `award_title`: Grant/award titles

### Identifiers

**Fields:**
- `portfolio_identifier`: Persistent identifier (e.g., RAiD)
- `portfolio_identifier_type`: Type of identifier
- `alternate_identifier`: Additional identifiers (DOI, URL, Handle)
- `alternate_identifier_type`: Types for alternate identifiers

---

## Upcoming Phases (Roadmap)

### Phase 2: Nested Forms & Relationships

Dynamic JavaScript forms for:
- Adding/removing creation stages
- Managing complex rights holders
- Linking version relationships via autocomplete
- Editing licenses with scopes and conditions

### Phase 3: TK Label Access Control

Enforced access restrictions:
- Community-only access for works with TK CO label
- Gender-based access for TK WG/MG labels
- Initiated-member-only for TK WR/MR labels
- Seasonal access restrictions for TK S label

User profile fields:
- Gender (for gender-restricted materials)
- Cultural affiliations (for community-restricted materials)
- Initiated member status (for restricted TK materials)

### Phase 4: Display Enhancements

Rich visualizations:
- **Timeline**: Visual timeline of creation stages
- **Version graph**: Interactive network graph of version relationships
- **Rights tables**: Clear display of complex rights structures
- **Tabbed interface**: Overview, Provenance, Rights, Relationships, Files

### Phase 5: Export & Serialization

Export formats for interoperability:
- **PROV-O**: W3C Provenance Ontology (RDF/Turtle/JSON-LD)
- **DataCite 4.4**: Standard research data citation XML
- **Schema.org**: Web-friendly JSON-LD for discovery

---

## Using NTRO Metadata

### For Depositors

When creating or editing a Portfolio work:

1. **Fill in cultural context** if your work has Indigenous or community origins
2. **Add TK Labels** if working with Indigenous knowledge (consult with community)
3. **Document creation stages** to capture the research journey
4. **Record rights holders** accurately, including community rights if applicable
5. **Link related works** to show how your research evolved through versions and transformations
6. **Describe your process** in the process narrative field

### For Administrators

- Ensure users understand TK Labels before applying them
- Coordinate with cultural authorities for works requiring community oversight
- Provide training on complex rights structures
- Monitor access restrictions for culturally sensitive materials

### For Researchers

- Use NTRO metadata to demonstrate research trajectory
- Export provenance data for inclusion in research outputs
- Link across work versions to show research evolution
- Document ethical clearance and community consultation

---

## Standards Alignment

The NTRO Provenance Framework aligns with:

- **FAIR Principles**: Findable (persistent IDs), Accessible (TK labels), Interoperable (export formats), Reusable (rights metadata)
- **CARE Principles**: Collective Benefit (community rights), Authority to Control (TK labels), Responsibility (ethical documentation), Ethics (cultural protocols)
- **W3C PROV**: Creation stages modeled as Activities, contributors as Agents, works as Entities
- **DataCite 4.4**: Comprehensive citation metadata for practice research outputs
- **Local Contexts TK Labels**: Community-developed protocols for Indigenous knowledge

---

## Resources

- [Local Contexts TK Labels](https://localcontexts.org/labels/traditional-knowledge-labels/)
- [CARE Principles for Indigenous Data Governance](https://www.gida-global.org/care)
- [FAIR Principles](https://www.go-fair.org/fair-principles/)
- [W3C PROV-O Specification](https://www.w3.org/TR/prov-o/)
- [DataCite Metadata Schema](https://schema.datacite.org/)
- [PRVoices Schema Documentation](schema.html)

---

## Getting Help

- Questions about TK Labels: Consult with cultural authorities and community representatives
- Technical support: [GitHub Issues](https://github.com/adammoore/enact-hyku/issues)
- General inquiries: Contact repository administrators

