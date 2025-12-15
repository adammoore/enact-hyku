---
layout: default
title: Research Practices and the PRVoices Schema
---

# Reflecting Research Practices in Metadata

The PRVoices schema is designed to mirror how practice researchers actually work, think, and document their research. This page explores how the schema's structure reflects the realities of practice-based research.

## Understanding Practice Research Portfolios

Practice researchers don't produce isolated outputs. Instead, they develop **portfolios** - interconnected collections of works, events, documentation, and reflections that together constitute a research investigation.

### The Portfolio Concept

A portfolio in practice research might include:
- The primary creative work (sculpture, performance, film)
- Exhibitions or presentations of the work
- Documentation (photographs, videos, scores)
- Reflective writing (artist statements, essays)
- Critical responses (reviews, catalogue essays)
- Related publications (journal articles, book chapters)

The schema's portfolio structure acknowledges this reality by:
- Providing a container for multiple related items
- Allowing narrative context that explains relationships
- Supporting different types of outputs within one record
- Linking to related works and publications

## Research as Process: The Context Statement

Traditional metadata focuses on describing objects. Practice research metadata must also describe **process** - the journey of making, experimenting, reflecting, and discovering.

### Narrative Sections Reflect Research Phases

The Context Statement's standard sections map to research phases:

#### Project Framework
**Research Practice**: Establishing conceptual foundations
- Initial research questions
- Methodological approaches
- Theoretical frameworks
- Creative techniques and processes

**Schema Support**: Rich text with embedded links allows researchers to reference:
- Theoretical sources
- Precedent works
- Methodological literature
- Technical resources

**Example**: A sculptor might describe their exploration of material properties, linking to scientific literature on ceramic chemistry while also discussing phenomenological approaches to material engagement.

#### Project Narrative
**Research Practice**: Documenting the research journey
- Experiments and iterations
- Discoveries and dead ends
- Pivotal moments and decisions
- Evolution of understanding

**Schema Support**: Embedded XHTML allows:
- Chronological or thematic organization
- Images showing process
- Links to intermediate works or documentation
- Formatted text conveying complexity

**Example**: A choreographer might narrate how movement improvisations led to unexpected insights about embodied memory, including photos from rehearsals and links to video documentation.

#### Research Insights
**Research Practice**: Articulating what was discovered
- Knowledge produced through practice
- Theoretical contributions
- Technical innovations
- Conceptual developments

**Schema Support**: Structured narrative space for:
- Claims and arguments
- Evidence from the work
- Connections to existing knowledge
- Implications for the field

**Example**: A sound artist might explain how their installation revealed new understandings of acoustic perception in urban spaces, with references to both artistic and scientific literature.

#### Further Dissemination and Recognition
**Research Practice**: Demonstrating impact and reach
- Exhibitions and performances
- Awards and recognition
- Reviews and critical reception
- Influence on other practitioners

**Schema Support**: Lists, links, and images for:
- Exhibition venues and dates
- Press coverage
- Awards and nominations
- Subsequent invitations or commissions

**Example**: A photographer might list gallery shows, include reviews from art magazines, and note how their work influenced public policy discussions.

## Multiple Output Types: Reflecting Creative Diversity

Practice researchers produce diverse outputs. The schema doesn't force everything into one category but recognizes distinct types:

### Artefacts
**What they are**: Physical or digital creative works
**Research significance**: Embody research insights
**Schema captures**:
- Physical properties (materials, dimensions)
- Creation process (dates, locations)
- Current location (institutions, collections)
- Geographic dimensions when relevant

**Examples**:
- Sculpture housed in a museum collection
- Digital artwork with specific technical requirements
- Installation that exists in multiple iterations

### Events
**What they are**: Time-bound happenings
**Research significance**: Performance, exhibition, and public engagement are often integral to the research
**Schema captures**:
- Duration and temporal structure
- Location and geographic extent
- Contributors and roles
- Associated documentation (photos, videos, programs)

**Examples**:
- Gallery exhibition showing the research
- Performance that constitutes the primary output
- Workshop testing participatory methodologies
- Conference presentation sharing findings

### Literature
**What they are**: Written outputs
**Research significance**: Critical reflection and theoretical articulation
**Schema captures**:
- Publication details
- Relationship to the broader portfolio
- Contributors and their roles

**Examples**:
- Exhibition catalogue with interpretive essay
- Journal article theorizing the practice
- Artist book as creative output
- Script for a performance work

### Collections
**What they are**: Curated assemblages
**Research significance**: Selection and organization as research methodology
**Schema captures**:
- Collection type and purpose
- Extent and scope
- Curation rationale (in context statement)

**Examples**:
- Archive of source materials
- Playlist of musical influences
- Collection of reference images
- Bibliography of theoretical resources

## Contributors: Recognizing Collaborative Practice

Practice research is often collaborative, involving:
- Artists and designers
- Curators and producers
- Technical specialists
- Community participants
- Institutional partners

### Contributor Types Reflect Practice Roles

The schema includes specific contributor types for practice research:

- **Creators**: Sculptor, Choreographer, Composer, etc.
- **Presenters**: Curator, Director, Producer
- **Facilitators**: Workshop Leader, Community Coordinator
- **Technical**: Lighting Designer, Sound Engineer
- **Institutional**: Hosting Institution, Gallery, Museum
- **Documentation**: Photographer, Videographer
- **Critical**: Critic, Respondent, Interlocutor

Each contributor can have:
- ORCID for individuals
- ROR identifier for organizations
- Institutional affiliations
- Specific roles in relation to each output

This recognizes that:
- Different people contribute to different portfolio items
- Roles vary across outputs
- Institutional relationships matter
- Credit should be specific and accurate

## Time and Space: Situating Practice

Practice research happens in specific times and places. This isn't incidental metadata - it's often central to the research.

### Temporal Complexity

The schema accommodates multiple temporal dimensions:

**Creation dates**: When was the work made?
```xml
<date dateType="Created">2022-08-01</date>
```

**Duration**: How long did an event last?
```xml
<date dateType="Duration">2024-01-01/2024-06-30</date>
```

**Conceptualization**: When did the research begin?
```xml
<date dateType="Other" dateInformation="Conceptualized">2020-01-01</date>
```

This matters because:
- Ideas may develop over years
- Making may be quick or extended
- Exhibition may be long after creation
- Research may span multiple phases

### Geographic Specificity

Location can be captured as:
- Place names (contextual, cultural)
- Precise coordinates (for site-specific work)
- Bounding boxes (for distributed projects)

**Example Use Cases**:
- Site-specific installation: exact coordinates matter
- Touring exhibition: multiple locations over time
- Landscape-based research: geographic extent of study
- Community project: neighborhood or district

## Funding and Institutional Context

Practice research operates within:
- Funding frameworks
- Institutional structures
- Organizational hierarchies

### Funding Information

The schema captures:
- Funder names and identifiers (Crossref Funder ID)
- Award numbers and URIs
- Project titles
- Multiple funders for complex projects

This recognizes:
- Research often has multiple funding sources
- Funders require accurate attribution
- Grant information aids discoverability
- Project relationships matter

### Organizational Units

Practice researchers are situated in:
- Schools and departments
- Research centers and groups
- Studios and workshops
- Cross-institutional collaborations

The schema allows multiple organizational units with:
- Different levels (school, department, center, group)
- Identifiers (ROR, institutional URLs)
- Names in multiple languages

## Files and Documentation

Practice outputs often require documentation. The schema allows files to be attached to portfolio items with:

- URIs and filenames
- Format specifications (MIME types)
- Rights information specific to each file
- Contributors to the documentation

This recognizes:
- Original work and documentation are distinct
- Different files may have different licenses
- Documentation creators deserve credit
- Technical specifications matter for access

## Relationships and Networks

Research doesn't exist in isolation. The schema captures:

### Related Items
- Publications about the work
- Datasets generated through practice
- Performances of compositions
- Exhibitions of artworks

Relationship types include:
- IsPublishedIn
- IsCitedBy
- IsPartOf
- HasPart
- IsDerivedFrom

### Projects
Links to broader project records (using Handle or other identifiers)

### Alternate Identifiers
Multiple identifiers for the same portfolio:
- DOI for citation
- URL for access
- Handle for persistence

## Rights and Access

The schema separates:
- Metadata rights (often CC0 for discoverability)
- Portfolio item rights (may vary by item)
- File rights (may differ from the items they document)

This recognizes:
- Complex rights landscapes in creative practice
- Different rights for different outputs
- Need for clear, specific rights statements
- Use of standard licenses (Creative Commons, SPDX)

## From Research Practice to Metadata

The PRVoices schema succeeds by:

1. **Reflecting actual practice**: Structure mirrors how researchers work
2. **Valuing process**: Not just outputs but the journey of discovery
3. **Accommodating diversity**: Multiple output types, each with appropriate metadata
4. **Recognizing collaboration**: Detailed contributor roles and relationships
5. **Situating work**: Time, place, funding, and institutional context
6. **Supporting narrative**: Rich text for complexity and nuance
7. **Enabling discovery**: Controlled vocabularies and identifiers
8. **Respecting rights**: Granular, specific licensing information

## Using the Schema as a Researcher

When documenting your practice research:

1. **Think portfolio**: What items belong together as one investigation?
2. **Tell the story**: Use context statements to narrate your research process
3. **Be specific**: Use precise dates, locations, and identifiers
4. **Credit everyone**: List all contributors with their specific roles
5. **Link widely**: Connect to publications, funders, institutions
6. **Specify rights**: Clear licensing helps your work reach appropriate audiences
7. **Document thoroughly**: Include files that support understanding
8. **Use controlled vocabularies**: ORCID, ROR, LCSH for discoverability

## Next Steps

- Review the [complete schema specification](schema.html)
- See the [example XML file](https://github.com/research-technologies/prvoices_schema/blob/main/example.xml)
- Explore [installation instructions](installation.html)
