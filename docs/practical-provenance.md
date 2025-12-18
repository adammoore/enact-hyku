---
layout: default
title: Practical Provenance Implementation
---

# Practical Provenance Implementation for Repository and Scholarly Infrastructure

This guide provides practical, actionable strategies for implementing provenance tracking in repository systems, with emphasis on Non-Traditional Research Outputs (NTRO) and practice-based research.

## Overview

Provenance metadata documents the origin, creation process, ownership, and transformations of research outputs over time. For practice research, provenance is essential for:

- **Attribution**: Recognizing all contributors across the creative process
- **Cultural respect**: Honoring Indigenous knowledge systems and protocols
- **Reproducibility**: Understanding how research insights emerged
- **Rights management**: Managing complex, shared, and community-based rights
- **Version tracking**: Following works through performances, exhibitions, adaptations

## Implementation Philosophy

This guide follows a **phased, standards-based approach**:

1. **Start with what exists**: Leverage existing standards (Dublin Core, DataCite, Schema.org)
2. **Enhance progressively**: Add structured provenance fields as capacity grows
3. **Maintain interoperability**: Use established ontologies (PROV-O, FOAF, RDA vocabularies)
4. **Align with principles**: Follow FAIR and CARE principles throughout

---

## Phase 1: Foundation - Leverage Existing Standards

### What You Already Have

Most repository platforms support core Dublin Core and DataCite metadata. These provide foundational provenance elements:

#### Dublin Core Elements

| Field | Provenance Value | Example |
|-------|------------------|---------|
| `dc.creator` | Primary creator(s) | "Smith, Jane" |
| `dc.contributor` | Additional contributors | "Jones, Robert (Performance); Lee, Maria (Curation)" |
| `dc.date.created` | Creation date | "2023-05-15" |
| `dc.publisher` | Publishing institution | "University of Westminster" |
| `dc.relation.isVersionOf` | Previous versions | Handle or DOI of earlier work |
| `dc.relation.hasVersion` | Later versions | Handle or DOI of updated work |
| `dc.rights` | Rights statement | "© 2023 Jane Smith. CC BY-NC 4.0" |
| `dc.provenance` | Provenance statement | "Created during Arts Council England funded residency..." |

#### DataCite Schema 4.4

DataCite extends Dublin Core with richer contributor and rights metadata:

| Field | Provenance Value | Example |
|-------|------------------|---------|
| `creators.creatorName` | Creator names | "Smith, Jane" |
| `creators.nameIdentifier` | Creator ORCID | "0000-0002-1825-0097" |
| `creators.affiliation` | Institution | "University of Westminster" |
| `contributors.contributorType` | Role vocabulary | "ProjectLeader", "DataCollector", "Editor" |
| `dates.dateType` | Date vocabulary | "Created", "Issued", "Updated", "Available" |
| `relatedIdentifiers.relationType` | Relationship vocabulary | "IsVersionOf", "IsDerivedFrom", "IsSourceOf" |
| `rightsList.rights` | License URI | "https://creativecommons.org/licenses/by/4.0/" |

### Quick Wins

**Action 1: Use ORCID identifiers**
- Register creators and contributors with ORCID
- Add ORCID iDs to creator/contributor fields
- Benefit: Persistent identification, disambiguation, automated updates

**Action 2: Apply controlled vocabularies**
- Use DataCite `contributorType` values (see Appendix A)
- Use DataCite `dateType` values for temporal tracking
- Use DataCite `relationType` values for version relationships
- Benefit: Machine-readable relationships, interoperability

**Action 3: Adopt standard licenses**
- Use Creative Commons licenses (CC BY, CC BY-NC, CC BY-SA)
- Include license URI, not just text
- Add Local Contexts TK Labels where appropriate
- Benefit: Clear reuse permissions, cultural protocols enforced

**Action 4: Document creation context**
- Use `dc.provenance` or `dc.description.provenance` for narrative
- Include funding acknowledgments
- Document community consultation
- Benefit: Rich contextual information for future users

### Platform-Specific Quick Start

#### DSpace 7.x
```xml
<!-- dspace/config/registries/dublin-core.xml -->
<dc-type>
  <schema>dc</schema>
  <element>provenance</element>
  <qualifier>creation</qualifier>
  <scope_note>Creation process and context</scope_note>
</dc-type>
```

#### EPrints
```perl
# eprints/cfg/cfg.d/z_provenance.pl
$c->{fields}->{eprint}->{provenance_statement} = {
    type => 'longtext',
    render_input => 'text_area',
};
```

#### Fedora/Hyrax (this repository)
```ruby
# app/models/portfolio.rb
property :provenance_statement, predicate: ::RDF::Vocab::DC.provenance do |index|
  index.as :stored_searchable
end
```

---

## Phase 2: Enhancement - Structured Provenance Fields

### Creation Process Tracking

Document the multi-stage creative/research process:

#### Structured Creation Stages

| Field | Description | Example |
|-------|-------------|---------|
| `stage_type` | Type of stage | "Conception", "Development", "Performance", "Exhibition" |
| `stage_date` | When stage occurred | "2023-03-15" to "2023-04-20" |
| `stage_location` | Where stage occurred | "Tate Modern, London" |
| `stage_description` | Narrative description | "Initial sculptural prototypes developed..." |
| `stage_contributors` | Who contributed | "Jane Smith (lead), Robert Jones (assistant)" |
| `stage_funding` | Funding for this stage | "Arts Council England, ref: ACE-2023-001" |

**Implementation Approach:**
- Store as JSON array in single field (flexible, schema-agnostic)
- Or create repeatable field group (structured, queryable)

**Example JSON Storage:**
```json
{
  "creation_stages": [
    {
      "stage_type": "conception",
      "stage_date": "2023-01-10",
      "stage_location": "University Studio",
      "description": "Initial concept development through sketching and material experiments",
      "contributors": ["Smith, Jane", "Lee, Maria (mentor)"],
      "funding": "University Research Fund"
    },
    {
      "stage_type": "performance",
      "stage_date": "2023-06-15",
      "stage_location": "Barbican Centre, London",
      "description": "First public performance with live audience feedback",
      "contributors": ["Smith, Jane (performer)", "Jones, Robert (sound design)"],
      "documentation": ["video-001.mp4", "audience-feedback.pdf"]
    }
  ]
}
```

### Extended Contributor Metadata

Beyond basic name and role, capture:

#### CRediT Taxonomy Extended for Practice Research

| Role | Description | NTRO Examples |
|------|-------------|---------------|
| Conceptualization | Ideas, formulation of research questions | Lead artist, curator |
| Methodology | Development of methodology | Performance methodology designer |
| Investigation | Research activity, data gathering | Field researcher, archivist |
| Resources | Provision of materials, equipment, access | Studio provider, community liaison |
| Data Curation | Management and annotation of research data | Digital archivist, collection manager |
| Writing - Original Draft | Creation of published work | Exhibition text author |
| Writing - Review & Editing | Critical review, commentary | Peer reviewer, cultural advisor |
| Visualization | Preparation of visualizations | Exhibition designer, photographer |
| Supervision | Oversight and mentorship | PhD supervisor, community elder |
| Project Administration | Management and coordination | Producer, project manager |
| Funding Acquisition | Acquisition of financial support | Grant writer, fundraiser |
| **Performance** | Live presentation of work | Performer, musician, dancer |
| **Curation** | Selection and organization of works | Curator, exhibition designer |
| **Installation** | Physical installation of work | Installation artist, fabricator |
| **Cultural Authority** | Cultural protocol oversight | Community elder, traditional owner |
| **Traditional Knowledge Holder** | Bearer of traditional knowledge | Knowledge keeper, cultural practitioner |

**Implementation:**
```json
{
  "contributors": [
    {
      "name": "Smith, Jane",
      "orcid": "0000-0002-1825-0097",
      "affiliation": "University of Westminster",
      "roles": ["Conceptualization", "Performance", "Writing - Original Draft"],
      "contribution_statement": "Lead artist responsible for concept development and primary performance."
    },
    {
      "name": "Aunty Mary Williams",
      "affiliation": "Wiradjuri Nation",
      "roles": ["Cultural Authority", "Traditional Knowledge Holder"],
      "contribution_statement": "Provided cultural guidance and approval for use of traditional stories."
    }
  ]
}
```

### Complex Rights and Ownership

Practice research often involves shared, community, and cultural rights:

#### Rights Holder Structure

| Field | Description | Example |
|-------|-------------|---------|
| `entity_name` | Rights holder name | "Wiradjuri Cultural Council" |
| `entity_type` | Type of entity | "Community", "Individual", "Collective", "Estate" |
| `entity_role` | Role in work | "Cultural Authority", "Co-Creator", "Rights Holder" |
| `rights_percentage` | Ownership percentage | "50%" (if applicable) |
| `rights_type` | Type of rights | "Copyright", "Cultural Rights", "Moral Rights" |
| `cultural_context` | Cultural authority | "Traditional Owner of stories depicted" |

**Example:**
```json
{
  "rights_holders": [
    {
      "entity_name": "Smith, Jane",
      "entity_type": "individual",
      "entity_role": "creator",
      "rights_percentage": "60",
      "rights_type": "copyright"
    },
    {
      "entity_name": "Wiradjuri Cultural Council",
      "entity_type": "community",
      "entity_role": "cultural_authority",
      "rights_percentage": "40",
      "rights_type": "cultural_rights",
      "cultural_context": "Traditional owners of cultural content"
    }
  ]
}
```

### Version and Derivative Tracking

Track transformations and manifestations:

#### Relationship Types

| Relationship | Description | Example |
|--------------|-------------|---------|
| `isVersionOf` | Earlier version | Draft → Final |
| `hasVersion` | Later version | Final → Exhibition version |
| `isVariantFormOf` | Alternative manifestation | Score → Performance |
| `isPerformanceOf` | Performance of work | Music score → Concert recording |
| `isExhibitionOf` | Exhibition of work | Artwork → Gallery exhibition |
| `isDerivedFrom` | Derived from earlier work | Original → Adaptation |
| `isSourceOf` | Source for derivative | Novel → Film adaptation |

**Implementation:**
```json
{
  "version_relationships": [
    {
      "related_work_id": "hdl:10369/12345",
      "related_work_title": "Sculptural Installation (Studio Version)",
      "relationship_type": "isVersionOf",
      "transformation_description": "Gallery version with site-specific modifications"
    },
    {
      "related_work_id": "hdl:10369/67890",
      "related_work_title": "Performance Documentation Video",
      "relationship_type": "isPerformanceOf",
      "performance_date": "2023-06-15",
      "performance_location": "Barbican Centre, London"
    }
  ]
}
```

---

## Phase 3: Integration - External Systems and Standards

### Local Contexts Integration

**What:** Traditional Knowledge (TK) Labels and Biocultural (BC) Labels for Indigenous cultural heritage

**Why:** Enables communities to express cultural protocols, attribution requirements, and access restrictions

#### TK Label Implementation

**Manual Entry (Phase 3A):**
1. Add `tk_labels` field (multi-valued)
2. Add `tk_label_text` field for descriptions
3. Add `tk_attribution_requirement` field
4. Display labels prominently on work pages
5. Link to Local Contexts for label definitions

**Example:**
```json
{
  "tk_labels": ["TK_A", "TK_CO", "TK_NC"],
  "tk_label_text": [
    "TK Attribution: This material must be attributed to the Wiradjuri community.",
    "TK Community Use Only: This material is for Wiradjuri community use only.",
    "TK Non-Commercial: This material is available for non-commercial use only."
  ],
  "tk_attribution_requirement": "Please cite as: 'Wiradjuri Cultural Council and Jane Smith (2023)'",
  "cultural_sensitivity_level": "community_only"
}
```

**API Integration (Phase 3B - Future):**
- Use Local Contexts Hub API to sync labels
- Validate label codes against official registry
- Pull label descriptions automatically
- Update when labels change

### ORCID Integration

**Benefits:**
- Persistent researcher identification
- Automatic profile updates
- Publication tracking
- Affiliation history

**Implementation:**
```ruby
# app/services/orcid_enrichment_service.rb
class OrcidEnrichmentService
  def enrich_contributor(orcid_id)
    response = HTTParty.get("https://pub.orcid.org/v3.0/#{orcid_id}/person",
                            headers: { 'Accept' => 'application/json' })

    {
      name: response['name']['given-names']['value'] + ' ' + response['name']['family-name']['value'],
      affiliation: response['employments']['employment-summary'].first['organization']['name'],
      orcid: orcid_id
    }
  end
end
```

### ROR (Research Organization Registry)

**Benefits:**
- Persistent institution identification
- Hierarchical organization structure
- Name variants and aliases

**Implementation:**
```ruby
def lookup_institution(query)
  response = HTTParty.get("https://api.ror.org/organizations?query=#{query}")
  response['items'].map do |org|
    {
      name: org['name'],
      ror_id: org['id'],
      country: org['country']['country_name']
    }
  end
end
```

### RAiD (Research Activity Identifier)

**What:** Persistent identifier for research activities (projects, collaborations)

**Use Case:** Link portfolio to research project/activity

**Implementation:**
```json
{
  "portfolio_identifier": "raid:20.5555.1/abc123",
  "portfolio_identifier_type": "RAiD",
  "project_title": "Embodied Knowledge in Indigenous Performance Practice",
  "project_dates": "2022-01-01/2025-12-31"
}
```

### OAI-PMH Provenance Export

**Benefit:** Machine-harvestable provenance metadata

**Implementation:**
```xml
<!-- OAI-PMH provenance format -->
<oai_prov:provenance xmlns:oai_prov="http://www.openarchives.org/OAI/2.0/provenance">
  <oai_prov:originDescription harvestDate="2023-11-15T10:30:00Z">
    <oai_prov:baseURL>https://repository.example.org/oai</oai_prov:baseURL>
    <oai_prov:identifier>oai:repo.example.org:12345</oai_prov:identifier>
    <oai_prov:datestamp>2023-06-20</oai_prov:datestamp>
  </oai_prov:originDescription>
</oai_prov:provenance>
```

---

## Phase 4: Advanced - Workflow and Automation

### Community Consultation Workflow

**Status Tracking:**
- Not Required
- Planned
- In Progress
- Completed
- Approved

**Implementation:**
```json
{
  "community_consultation": {
    "status": "completed",
    "communities_consulted": ["Wiradjuri Cultural Council"],
    "consultation_date": "2023-02-15",
    "approval_reference": "WCC-2023-045",
    "cultural_advisor": "Aunty Mary Williams",
    "consultation_notes": "Approved for public exhibition with TK labels applied."
  }
}
```

### FAIR and CARE Assessment

**Automated Assessment:**
- Check for PIDs (DOIs, ORCIDs, RORs)
- Validate license URIs
- Check TK labels for CARE compliance
- Assess metadata completeness

**Example Implementation:**
```ruby
class FairCareAssessmentService
  def assess(work)
    score = {
      findable: assess_findable(work),
      accessible: assess_accessible(work),
      interoperable: assess_interoperable(work),
      reusable: assess_reusable(work),
      collective_benefit: assess_collective_benefit(work),
      authority_to_control: assess_authority(work),
      responsibility: assess_responsibility(work),
      ethics: assess_ethics(work)
    }

    {
      fair_score: (score[:findable] + score[:accessible] + score[:interoperable] + score[:reusable]) / 4.0,
      care_score: (score[:collective_benefit] + score[:authority_to_control] + score[:responsibility] + score[:ethics]) / 4.0,
      details: score
    }
  end

  private

  def assess_findable(work)
    score = 0
    score += 25 if work.doi.present?
    score += 25 if work.creator.any? { |c| c.match?(/\d{4}-\d{4}-\d{4}-\d{3}[0-9X]/) } # ORCID
    score += 25 if work.keyword.present?
    score += 25 if work.abstract.present?
    score
  end

  def assess_authority(work)
    score = 0
    score += 25 if work.tk_labels.present?
    score += 25 if work.cultural_authority.present?
    score += 25 if work.community_consultation_status == 'completed'
    score += 25 if work.rights_holders.any? { |h| h['entity_type'] == 'community' }
    score
  end
end
```

### Provenance Change Tracking

**Audit Trail:**
- Track all metadata changes
- Record who made changes
- Timestamp all modifications
- Provide change history view

**Example:**
```ruby
# app/models/concerns/provenance_versioning.rb
module ProvenanceVersioning
  extend ActiveSupport::Concern

  included do
    has_paper_trail on: [:update], only: [
      :cultural_origin,
      :tk_labels,
      :rights_holders_json,
      :creation_stages_json
    ]
  end

  def provenance_change_history
    versions.map do |v|
      {
        changed_at: v.created_at,
        changed_by: v.whodunnit,
        changes: v.changeset,
        event: v.event
      }
    end
  end
end
```

---

## Controlled Vocabularies

### Contributor Role Taxonomy

**CRediT Roles (original 14):**
- Conceptualization
- Data curation
- Formal analysis
- Funding acquisition
- Investigation
- Methodology
- Project administration
- Resources
- Software
- Supervision
- Validation
- Visualization
- Writing – original draft
- Writing – review & editing

**NTRO Extensions:**
- Performance
- Curation
- Installation
- Direction
- Choreography
- Sound Design
- Lighting Design
- Costume Design
- Set Design
- Fabrication
- Cultural Authority
- Traditional Knowledge Holder
- Community Liaison
- Elder Consultation

### Creation Stage Types

- Conception
- Research
- Development
- Prototyping
- Iteration
- Rehearsal
- Performance
- Exhibition
- Installation
- Publication
- Documentation
- Reflection

### Version/Transformation Types

- Draft
- Final
- Performance
- Exhibition
- Adaptation
- Translation
- Remediation
- Iteration
- Derivative
- Variant

### Cultural Sensitivity Levels

- Public (no restrictions)
- Community Only (restricted to community members)
- Gender Restricted (male/female/initiated only)
- Seasonal (temporal restrictions)
- Sacred (highly restricted)

### Rights Types

- Copyright
- Moral Rights
- Cultural Rights
- Community Rights
- Traditional Knowledge Rights
- Database Rights
- Performer's Rights

---

## Platform-Specific Implementation Guides

### DSpace 7.x

**1. Add Custom Metadata Fields:**

Edit `dspace/config/registries/ntro-provenance.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<dspace-dc-types>
  <dc-schema>
    <name>ntro</name>
    <namespace>http://ntro.example.org/terms/</namespace>
  </dc-schema>

  <dc-type>
    <schema>ntro</schema>
    <element>cultural</element>
    <qualifier>origin</qualifier>
    <scope_note>Cultural or indigenous group origins</scope_note>
  </dc-type>

  <dc-type>
    <schema>ntro</schema>
    <element>tk</element>
    <qualifier>label</qualifier>
    <scope_note>Local Contexts TK Label codes</scope_note>
  </dc-type>

  <dc-type>
    <schema>ntro</schema>
    <element>creation</element>
    <qualifier>stages</qualifier>
    <scope_note>JSON array of creation stages</scope_note>
  </dc-type>
</dspace-dc-types>
```

**2. Configure Input Forms:**

Edit `dspace/config/submission-forms.xml`:
```xml
<field>
  <dc-schema>ntro</dc-schema>
  <dc-element>cultural</dc-element>
  <dc-qualifier>origin</dc-qualifier>
  <repeatable>true</repeatable>
  <label>Cultural Origin</label>
  <input-type>onebox</input-type>
  <hint>Cultural, community, or indigenous group origins</hint>
  <required></required>
</field>

<field>
  <dc-schema>ntro</dc-schema>
  <dc-element>tk</dc-element>
  <dc-qualifier>label</dc-qualifier>
  <repeatable>true</repeatable>
  <label>Traditional Knowledge Labels</label>
  <input-type value-pairs-name="tklabels">dropdown</input-type>
  <hint>Select applicable Local Contexts TK Labels</hint>
  <required></required>
</field>
```

**3. Add Value Pairs for Controlled Vocabularies:**

```xml
<value-pairs value-pairs-name="tklabels" dc-term="ntro.tk.label">
  <pair>
    <displayed-value>TK A - Attribution</displayed-value>
    <stored-value>TK_A</stored-value>
  </pair>
  <pair>
    <displayed-value>TK CO - Community Use Only</displayed-value>
    <stored-value>TK_CO</stored-value>
  </pair>
  <!-- Add more TK labels -->
</value-pairs>
```

### EPrints

**1. Add Metadata Fields:**

Edit `eprints/cfg/cfg.d/z_ntro.pl`:
```perl
$c->add_dataset_field(
  "eprint",
  {
    name => "cultural_origin",
    type => "text",
    multiple => 1,
    input_rows => 1,
  }
);

$c->add_dataset_field(
  "eprint",
  {
    name => "tk_labels",
    type => "set",
    options => [
      "TK_A",
      "TK_CO",
      "TK_NC",
      "TK_WG",
      "TK_MG",
    ],
    input_style => "medium",
  }
);

$c->add_dataset_field(
  "eprint",
  {
    name => "creation_stages",
    type => "longtext",
    input_rows => 10,
    render_input => "text_area",
  }
);
```

**2. Configure Phrases:**

Edit `eprints/cfg/lang/en/phrases/z_ntro.xml`:
```xml
<epp:phrase id="eprint_fieldname_cultural_origin">Cultural Origin</epp:phrase>
<epp:phrase id="eprint_fieldhelp_cultural_origin">
  Cultural, community, or indigenous group origins
</epp:phrase>

<epp:phrase id="eprint_fieldname_tk_labels">Traditional Knowledge Labels</epp:phrase>
<epp:phrase id="eprint_fieldopt_tk_labels_TK_A">TK A - Attribution</epp:phrase>
<epp:phrase id="eprint_fieldopt_tk_labels_TK_CO">TK CO - Community Use Only</epp:phrase>
```

### Islandora

**1. Add Taxonomy Terms:**

Create vocabulary "NTRO Provenance":
- Navigate to Structure > Taxonomy
- Add vocabulary: "NTRO Provenance"
- Add terms: Creation stage types, TK labels, contributor roles

**2. Add Fields to Content Type:**

```php
// Custom module: ntro_provenance/ntro_provenance.install

function ntro_provenance_install() {
  // Cultural Origin field
  $field_storage = FieldStorageConfig::create([
    'field_name' => 'field_cultural_origin',
    'entity_type' => 'node',
    'type' => 'string',
    'cardinality' => FieldStorageDefinitionInterface::CARDINALITY_UNLIMITED,
  ]);
  $field_storage->save();

  $field = FieldConfig::create([
    'field_storage' => $field_storage,
    'bundle' => 'islandora_object',
    'label' => 'Cultural Origin',
    'description' => 'Cultural, community, or indigenous group origins',
  ]);
  $field->save();

  // TK Labels field
  $field_storage = FieldStorageConfig::create([
    'field_name' => 'field_tk_labels',
    'entity_type' => 'node',
    'type' => 'entity_reference',
    'cardinality' => FieldStorageDefinitionInterface::CARDINALITY_UNLIMITED,
    'settings' => [
      'target_type' => 'taxonomy_term',
    ],
  ]);
  $field_storage->save();

  $field = FieldConfig::create([
    'field_storage' => $field_storage,
    'bundle' => 'islandora_object',
    'label' => 'Traditional Knowledge Labels',
    'settings' => [
      'handler' => 'default:taxonomy_term',
      'handler_settings' => [
        'target_bundles' => ['tk_labels'],
      ],
    ],
  ]);
  $field->save();
}
```

---

## Quality Assurance

### Minimum Provenance Requirements

**Level 1 (Basic):**
- ✅ Creator name(s) with ORCID
- ✅ Creation date
- ✅ Institution/affiliation
- ✅ License/rights statement
- ✅ Provenance statement (narrative)

**Level 2 (Enhanced):**
- All Level 1 fields
- ✅ Contributors with roles (using CRediT taxonomy)
- ✅ Cultural origin (if applicable)
- ✅ Version relationships (if applicable)
- ✅ TK Labels (if Indigenous content)

**Level 3 (Comprehensive):**
- All Level 2 fields
- ✅ Structured creation stages
- ✅ Complex rights holders
- ✅ Community consultation documentation
- ✅ FAIR/CARE compliance assessment

### Validation Rules

**Automated Checks:**
1. If `cultural_origin` contains Indigenous terms → Require `tk_labels`
2. If `tk_labels` includes restrictive labels → Require `cultural_authority`
3. If `contributor_role` = "Cultural Authority" → Require `cultural_community`
4. If `version_relationship` exists → Require `related_work_id` and `transformation_description`
5. If `community_consultation_status` = "Completed" → Require `approval_reference`

**Example Implementation:**
```ruby
class ProvenanceValidator < ActiveModel::Validator
  def validate(record)
    validate_tk_requirements(record)
    validate_cultural_authority(record)
    validate_version_relationships(record)
  end

  private

  def validate_tk_requirements(record)
    if indigenous_content?(record) && record.tk_labels.blank?
      record.errors.add(:tk_labels,
        "Traditional Knowledge labels are required for Indigenous cultural content")
    end
  end

  def validate_cultural_authority(record)
    restrictive_labels = ['TK_CO', 'TK_F', 'TK_WG', 'TK_MG', 'TK_WR', 'TK_MR']
    if (record.tk_labels & restrictive_labels).any? && record.cultural_authority.blank?
      record.errors.add(:cultural_authority,
        "Cultural authority is required for restrictive TK labels")
    end
  end

  def indigenous_content?(record)
    indigenous_terms = ['indigenous', 'aboriginal', 'first nations', 'maori',
                       'torres strait islander', 'native', 'tribal']
    content = [record.cultural_origin, record.cultural_community].flatten.compact.join(' ').downcase
    indigenous_terms.any? { |term| content.include?(term) }
  end
end
```

---

## Example Metadata Records

### Example 1: Performance Work with Cultural Context

```json
{
  "title": "Ngarra: Saltwater Stories",
  "work_type": "Performance",
  "abstract": "A contemporary dance performance exploring connections between land, sea, and Indigenous knowledge systems through movement and oral storytelling.",

  "creators": [
    {
      "name": "Williams, Sarah",
      "orcid": "0000-0001-2345-6789",
      "affiliation": "Wiradjuri Nation",
      "affiliation_ror": "https://ror.org/example",
      "roles": ["Conceptualization", "Performance", "Choreography"]
    }
  ],

  "contributors": [
    {
      "name": "Aunty Mary Williams",
      "affiliation": "Wiradjuri Cultural Council",
      "roles": ["Cultural Authority", "Traditional Knowledge Holder"],
      "contribution_statement": "Provided cultural guidance and approval for use of traditional stories and dance movements."
    },
    {
      "name": "Chen, Lisa",
      "orcid": "0000-0002-3456-7890",
      "affiliation": "Sydney Conservatorium of Music",
      "roles": ["Sound Design", "Resources"]
    }
  ],

  "dates": {
    "created": "2023-01-15",
    "first_performance": "2023-06-20",
    "submitted": "2023-07-10"
  },

  "cultural_context": {
    "cultural_origin": ["Wiradjuri"],
    "indigenous_affiliation": ["Wiradjuri Nation"],
    "cultural_community": ["Wiradjuri Cultural Council"],
    "cultural_sensitivity_level": "community_review_required"
  },

  "tk_labels": ["TK_A", "TK_NC", "TK_V"],
  "tk_label_text": [
    "TK Attribution: This work must be attributed to Sarah Williams and the Wiradjuri community.",
    "TK Non-Commercial: This work is available for non-commercial use only.",
    "TK Verified: This work has been verified by the Wiradjuri Cultural Council."
  ],
  "tk_attribution_requirement": "Please cite as: Williams, S. (2023) Ngarra: Saltwater Stories. Created with guidance from the Wiradjuri Cultural Council.",

  "rights_holders": [
    {
      "entity_name": "Williams, Sarah",
      "entity_type": "individual",
      "entity_role": "creator",
      "rights_type": "copyright",
      "rights_percentage": "60"
    },
    {
      "entity_name": "Wiradjuri Cultural Council",
      "entity_type": "community",
      "entity_role": "cultural_authority",
      "rights_type": "cultural_rights",
      "rights_percentage": "40",
      "cultural_context": "Traditional owners of stories and cultural knowledge"
    }
  ],

  "licenses": [
    {
      "license": "CC BY-NC 4.0",
      "license_uri": "https://creativecommons.org/licenses/by-nc/4.0/"
    }
  ],

  "community_consultation": {
    "status": "completed",
    "communities_consulted": ["Wiradjuri Cultural Council"],
    "consultation_date": "2023-02-15",
    "approval_reference": "WCC-2023-089",
    "cultural_advisor": "Aunty Mary Williams",
    "ethical_clearance": "University Ethics Approval #2023-HUM-001"
  },

  "creation_stages": [
    {
      "stage_type": "conception",
      "stage_date": "2023-01-15",
      "stage_location": "Wiradjuri Country, NSW",
      "description": "Initial concept development through community consultation and cultural guidance",
      "contributors": ["Williams, Sarah", "Aunty Mary Williams"],
      "funding": "Australia Council for the Arts"
    },
    {
      "stage_type": "development",
      "stage_date_start": "2023-02-01",
      "stage_date_end": "2023-05-30",
      "stage_location": "University Studio",
      "description": "Choreography development, rehearsals, and refinement with cultural advisory oversight",
      "contributors": ["Williams, Sarah", "Chen, Lisa", "Aunty Mary Williams"],
      "documentation": ["rehearsal-notes.pdf", "cultural-advisory-meetings.pdf"]
    },
    {
      "stage_type": "performance",
      "stage_date": "2023-06-20",
      "stage_location": "Sydney Opera House",
      "description": "First public performance with live audience",
      "contributors": ["Williams, Sarah (performer)", "Chen, Lisa (sound design)", "Jones, Michael (lighting design)"],
      "documentation": ["performance-video-001.mp4", "audience-feedback.pdf"],
      "audience_size": 250
    }
  ],

  "research_methodology": "Practice-led research methodology combining Indigenous knowledge systems with contemporary dance practice. Research insights emerged through embodied exploration, community consultation, and iterative development process.",

  "ethical_considerations": "All cultural content was approved by the Wiradjuri Cultural Council. Community consultation was conducted throughout the project. Traditional knowledge holders were involved in all stages of development.",

  "funding": [
    {
      "funder_name": "Australia Council for the Arts",
      "funder_ror": "https://ror.org/05mmh0f86",
      "award_number": "ACA-2023-001",
      "award_title": "Indigenous Performance Practice Research"
    }
  ],

  "related_works": [
    {
      "relationship": "isDocumentedBy",
      "related_id": "hdl:10453/145678",
      "title": "Ngarra: Performance Documentation Video"
    }
  ],

  "keywords": ["Indigenous dance", "Wiradjuri", "contemporary performance", "practice-led research", "cultural protocols"],

  "fair_care_assessment": {
    "fair_score": 92,
    "care_score": 95,
    "assessment_date": "2023-07-10"
  }
}
```

### Example 2: Exhibition with Multiple Venues

```json
{
  "title": "Traces: Material Memory in Sculpture",
  "work_type": "Exhibition",
  "abstract": "A sculptural installation exploring themes of memory, displacement, and cultural identity through found objects and traditional materials.",

  "creators": [
    {
      "name": "Patel, Anjali",
      "orcid": "0000-0003-4567-8901",
      "affiliation": "Royal College of Art",
      "affiliation_ror": "https://ror.org/041kmwe10",
      "roles": ["Conceptualization", "Investigation", "Visualization"]
    }
  ],

  "contributors": [
    {
      "name": "Thompson, James",
      "orcid": "0000-0004-5678-9012",
      "affiliation": "Tate Modern",
      "roles": ["Curation", "Resources"]
    },
    {
      "name": "Martinez, Carlos",
      "affiliation": "Independent",
      "roles": ["Installation", "Fabrication"]
    }
  ],

  "dates": {
    "created_start": "2022-06-01",
    "created_end": "2023-04-15",
    "first_exhibition": "2023-05-10",
    "submitted": "2023-08-20"
  },

  "creation_stages": [
    {
      "stage_type": "research",
      "stage_date_start": "2022-06-01",
      "stage_date_end": "2022-09-30",
      "stage_location": "Multiple archival sites, UK",
      "description": "Archival research into immigrant communities and material culture",
      "contributors": ["Patel, Anjali"],
      "funding": "Arts and Humanities Research Council"
    },
    {
      "stage_type": "development",
      "stage_date_start": "2022-10-01",
      "stage_date_end": "2023-03-31",
      "stage_location": "RCA Sculpture Studio",
      "description": "Sculptural prototyping and material experimentation",
      "contributors": ["Patel, Anjali", "Martinez, Carlos"],
      "documentation": ["studio-process-photos/", "material-tests.pdf"]
    },
    {
      "stage_type": "exhibition",
      "stage_date_start": "2023-05-10",
      "stage_date_end": "2023-07-30",
      "stage_location": "Tate Modern, London",
      "description": "First exhibition: large-scale installation in gallery space",
      "contributors": ["Patel, Anjali", "Thompson, James (curator)", "Martinez, Carlos (installation)"],
      "documentation": ["exhibition-photos/", "visitor-feedback.pdf"],
      "visitor_count": 12500
    },
    {
      "stage_type": "exhibition",
      "stage_date_start": "2023-10-15",
      "stage_date_end": "2024-01-15",
      "stage_location": "Museum of Contemporary Art, Sydney",
      "description": "Second exhibition: adapted for different gallery context",
      "contributors": ["Patel, Anjali", "Chen, Wei (curator)", "Local installation team"],
      "transformation_description": "Reconfigured for smaller gallery space with additional wall-mounted pieces"
    }
  ],

  "version_relationships": [
    {
      "related_work_id": "hdl:10453/234567",
      "related_work_title": "Traces: Studio Prototypes",
      "relationship_type": "isVersionOf",
      "transformation_description": "Gallery version developed from studio prototypes"
    },
    {
      "related_work_id": "hdl:10453/234569",
      "related_work_title": "Traces: Sydney Variant",
      "relationship_type": "hasVersion",
      "transformation_description": "Adapted configuration for Sydney exhibition venue"
    }
  ],

  "rights_holders": [
    {
      "entity_name": "Patel, Anjali",
      "entity_type": "individual",
      "entity_role": "creator",
      "rights_type": "copyright",
      "rights_percentage": "100"
    }
  ],

  "licenses": [
    {
      "license": "CC BY-NC-ND 4.0",
      "license_uri": "https://creativecommons.org/licenses/by-nc-nd/4.0/",
      "license_scope": "Documentation only; physical works not for reproduction"
    }
  ],

  "funding": [
    {
      "funder_name": "Arts and Humanities Research Council",
      "funder_ror": "https://ror.org/0505m1554",
      "award_number": "AH/V012345/1",
      "award_title": "Material Memory in Contemporary Sculpture"
    }
  ],

  "research_methodology": "Practice-led methodology combining archival research, material experimentation, and iterative prototyping. Research insights emerged through engagement with found objects and traditional materials.",

  "keywords": ["sculpture", "installation", "memory", "migration", "material culture", "practice-led research"],

  "fair_care_assessment": {
    "fair_score": 88,
    "care_score": 70,
    "assessment_date": "2023-08-20"
  }
}
```

---

## Resources and Further Reading

### Standards and Ontologies

- **PROV-O**: W3C Provenance Ontology - https://www.w3.org/TR/prov-o/
- **DataCite Schema 4.4**: https://schema.datacite.org/
- **Dublin Core**: https://www.dublincore.org/specifications/dublin-core/dcmi-terms/
- **Schema.org**: https://schema.org/
- **FOAF (Friend of a Friend)**: http://xmlns.com/foaf/spec/
- **CRediT (Contributor Roles Taxonomy)**: https://credit.niso.org/

### FAIR and CARE Principles

- **FAIR Principles**: https://www.go-fair.org/fair-principles/
- **CARE Principles for Indigenous Data Governance**: https://www.gida-global.org/care

### Traditional Knowledge and Cultural Protocols

- **Local Contexts**: https://localcontexts.org/
- **TK Labels**: https://localcontexts.org/labels/traditional-knowledge-labels/
- **BC Labels**: https://localcontexts.org/labels/biocultural-labels/

### Persistent Identifiers

- **ORCID**: https://orcid.org/
- **ROR (Research Organization Registry)**: https://ror.org/
- **RAiD (Research Activity Identifier)**: https://www.raid.org/
- **DOI**: https://www.doi.org/

### Repository Platforms

- **DSpace**: https://dspace.lyrasis.org/
- **EPrints**: https://www.eprints.org/
- **Fedora**: https://fedorarepository.org/
- **Samvera/Hyrax**: https://samvera.org/
- **Islandora**: https://islandora.ca/

### Practice Research Resources

- **PRVoices Schema**: https://github.com/research-technologies/prvoices_schema
- **NTRO (Non-Traditional Research Outputs)**: Australian Research Council guidance

---

## Summary

Effective provenance implementation for practice research requires:

1. **Start simple**: Use existing Dublin Core and DataCite fields
2. **Adopt standards**: ORCID, ROR, controlled vocabularies
3. **Respect culture**: Apply TK labels, document community consultation
4. **Track process**: Document creation stages and transformations
5. **Manage rights**: Record complex, shared, and community-based ownership
6. **Enable discovery**: Use persistent identifiers and rich metadata
7. **Assess quality**: Apply FAIR and CARE principles
8. **Automate where possible**: Validation, enrichment, assessment

**The goal is not perfection, but continuous improvement in documenting the full story of practice research outputs.**

---

*This guide is maintained as part of the Enact Hyku project. For questions or contributions, see the [GitHub repository](https://github.com/adammoore/enact-hyku).*
