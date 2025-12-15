---
layout: default
title: PRVoices Schema
---

# PRVoices Metadata Schema

The Practice Research Voices (PRVoices) schema is designed to capture the complexity of practice-based research outputs and their relationships.

## Schema Overview

The schema is organized around the concept of a **Portfolio** - a coherent collection of practice research outputs that together constitute a research project or investigation.

### Portfolio Structure

```
Portfolio
├── Portfolio-level Metadata
│   ├── Identifiers (RAiD, DOI, etc.)
│   ├── Titles and Descriptions
│   ├── Contributors
│   ├── Dates
│   ├── Publisher
│   ├── Subjects and Keywords
│   ├── Funding Information
│   └── Organizational Units
├── Context Statement (Rich Narrative)
│   ├── Project Framework
│   ├── Project Narrative
│   ├── Research Insights
│   └── Further Dissemination
└── Portfolio Items (Multiple Types)
    ├── Artefacts
    ├── Events
    ├── Literature
    └── Collections
```

## Core Components

### 1. Portfolio-Level Metadata

#### Portfolio Identifier
A persistent identifier for the entire portfolio, supporting various identifier types:
- **RAiD** (Research Activity Identifier): Recommended for research projects
- **DOI**: Digital Object Identifier
- **Handle**: Handle system identifiers
- **URL**: Web addresses

```xml
<portfolioIdentifier identifierType="RAiD">10.80390/180ef9c4</portfolioIdentifier>
```

#### Titles
Multiple titles with language support and subtitle variants:

```xml
<titles>
  <title xml:lang="en">Example title</title>
  <title xml:lang="en" titleType="Subtitle">Example subtitle</title>
</titles>
```

#### Contributors
Detailed contributor information with roles, identifiers, and affiliations:

```xml
<contributor contributorType="Data Collector">
  <contributorName nameType="Personal">Garcia, Sofia</contributorName>
  <givenName>Sofia</givenName>
  <familyName>Garcia</familyName>
  <nameIdentifier schemeURI="https://orcid.org/"
                  nameIdentifierScheme="ORCID">0000-0001-5727-2427</nameIdentifier>
  <affiliation affiliationIdentifier="https://ror.org/03efmqc40"
               affiliationIdentifierScheme="ROR">
    Arizona State University
  </affiliation>
</contributor>
```

Supported contributor types include: Data Collector, Curator, Illustrator, HostingInstitution, and many others.

#### Publisher
Institution responsible for publishing the portfolio:

```xml
<publisher xml:lang="en"
           publisherIdentifier="https://ror.org/04ycpbx82"
           publisherIdentifierScheme="ROR">
  University of Westminster
</publisher>
```

### 2. Context Statement

The context statement is a distinguishing feature of the PRVoices schema. It allows researchers to provide rich, structured narrative content using XHTML, including:

- Formatted text with emphasis, links, and structure
- Multiple sections with headings
- Lists and images
- Embedded hyperlinks

Standard sections include:
- **Project Framework**: The conceptual and methodological foundations
- **Project Narrative**: The story of the research development
- **Research Insights**: Key findings and discoveries
- **Further Dissemination and Recognition**: Impact and reach

```xml
<contextStatement xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:section>
    <xhtml:title>Project Framework</xhtml:title>
    <xhtml:p>Lorem ipsum dolor sit amet...</xhtml:p>
  </xhtml:section>
</contextStatement>
```

### 3. Portfolio Items

Portfolio items represent the individual outputs within a research project. Each type has specialized metadata:

#### Artefacts
Physical or digital creative works:

```xml
<portfolioItem portfolioItemType="Artefact">
  <artefact artefactType="sculpture">
    <identifier IdentifierType="URL">https://sculpture.org/example</identifier>
    <contributors>...</contributors>
    <titles>...</titles>
    <dates>...</dates>
    <geoLocation>...</geoLocation>
  </artefact>
</portfolioItem>
```

Artefact types include: sculpture, painting, installation, performance, film, sound work, and more.

#### Events
Exhibitions, performances, workshops, and other time-bound activities:

```xml
<portfolioItem portfolioItemType="Event">
  <event eventType="Exhibition">
    <contributors>...</contributors>
    <titles>...</titles>
    <dates>
      <date dateType="Duration">2024-01-01/2024-06-30</date>
    </dates>
    <geoLocation>...</geoLocation>
    <files>...</files>
  </event>
</portfolioItem>
```

Event types include: Exhibition, Performance, Workshop, Conference, Symposium, and more.

#### Literature
Written outputs associated with the practice research:

```xml
<portfolioItem portfolioItemType="Literature">
  <literature literatureType="Book">
    <contributors>...</contributors>
    <titles>...</titles>
    <dates>...</dates>
  </literature>
</portfolioItem>
```

Literature types include: Book, Article, Essay, Catalogue, Script, and more.

#### Collections
Curated collections of works or materials:

```xml
<portfolioItem portfolioItemType="Collection">
  <collection artefactType="playlist">
    <identifier IdentifierType="URL">https://example.org/playlist</identifier>
    <contributors>...</contributors>
    <titles>...</titles>
    <extent extentType="duration" extentUnit="hours">20</extent>
  </collection>
</portfolioItem>
```

### 4. Geographic Information

Events and artefacts can include precise geographic information:

```xml
<geoLocation>
  <geoLocationPlace>Kensington</geoLocationPlace>
  <geoLocationPoint>
    <pointLongitude>-52.000000</pointLongitude>
    <pointLatitude>69.000000</pointLatitude>
  </geoLocationPoint>
</geoLocation>
```

Or bounding boxes for areas:

```xml
<geoLocation>
  <geoLocationBox>
    <westBoundLongitude>-123.27</westBoundLongitude>
    <eastBoundLongitude>-123.225</eastBoundLongitude>
    <southBoundLatitude>49.24</southBoundLatitude>
    <northBoundLatitude>49.28</northBoundLatitude>
  </geoLocationBox>
</geoLocation>
```

### 5. Dates and Temporal Information

Flexible date encoding supporting:
- Single dates
- Date ranges (using ISO 8601 format: 2024-01-01/2024-06-30)
- Custom date types with information attributes

```xml
<dates>
  <date dateType="Issued">2022-08-01</date>
  <date dateType="Duration">2024-01-01/2024-06-30</date>
  <date dateType="Other" dateInformation="Conceptualized">2020-01-01</date>
</dates>
```

### 6. Related Items

Links to journals, books, datasets, or other resources:

```xml
<relatedItems>
  <relatedItem relationType="IsPublishedIn" relatedItemType="Journal">
    <relatedItemIdentifier relatedItemIdentifierType="ISSN">1234-5678</relatedItemIdentifier>
    <titles>
      <title>Journal of Metadata Examples</title>
    </titles>
  </relatedItem>
</relatedItems>
```

### 7. Organizational Units

Institutional structure information:

```xml
<organisationalUnits>
  <organisationalUnit organisationalUnitType="School"
                      organisationalUnitIdentifier="https://example.org/school"
                      organisationalUnitIdentifierType="URL">
    School of Art and Media
  </organisationalUnit>
</organisationalUnits>
```

### 8. Funding Information

Detailed funding references with Crossref Funder IDs:

```xml
<fundingReference>
  <funderName>European Commission</funderName>
  <funderIdentifier funderIdentifierType="Crossref Funder ID">
    https://doi.org/10.13039/501100000780
  </funderIdentifier>
  <awardNumber awardURI="https://cordis.europa.eu/project/example">282625</awardNumber>
  <awardTitle>Project Title</awardTitle>
</fundingReference>
```

### 9. Rights Statements

Licensing and rights information:

```xml
<rightsStatement xml:lang="en">
  The metadata associated with this portfolio is available under a CC0 license.
  Portfolio items may be available under different licenses.
</rightsStatement>
```

Individual files can specify their own rights:

```xml
<rights xml:lang="en"
        schemeURI="https://spdx.org/licenses/"
        rightsIdentifierScheme="SPDX"
        rightsIdentifier="CC-BY-4.0"
        rightsURI="https://creativecommons.org/licenses/by/4.0/">
  Creative Commons Attribution 4.0 International
</rights>
```

## Schema Files

The complete schema is available in the [prvoices_schema repository](https://github.com/research-technologies/prvoices_schema):

- **portfolio.xsd**: XML Schema Definition
- **example.xml**: Complete example portfolio
- **portfolio.svg**: Visual schema diagram

## Design Principles

1. **Flexibility**: Multiple allowed, optional fields accommodate diverse research practices
2. **Controlled Vocabularies**: Use of established identifier schemes (ORCID, ROR, LCSH, etc.)
3. **Rich Context**: Embedded XHTML for narrative complexity
4. **Relationships**: Links between items, organizations, and external resources
5. **Internationalization**: Language attributes throughout
6. **Extensibility**: "Other" types with custom information attributes

## Next Steps

- Explore how the schema reflects [research practices](research-practices.html)
- Review the [complete example XML](https://github.com/research-technologies/prvoices_schema/blob/main/example.xml)
- Learn about [installation and implementation](installation.html)
