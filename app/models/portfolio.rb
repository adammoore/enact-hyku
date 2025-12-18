# frozen_string_literal: true

##
# Portfolio - Practice Research portfolio containing artefacts, events, and other research outputs
# Based on the PRVoices schema + NTRO Provenance Framework
#
# @see https://github.com/research-technologies/prvoices_schema
class Portfolio < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include IiifPrint.model_configuration(
    pdf_split_child_model: GenericWork,
    pdf_splitter_service: IiifPrint::TenantConfig::PdfSplitter
  )
  include PdfBehavior
  include VideoEmbedBehavior

  self.indexer = PortfolioIndexer

  validates :title, presence: { message: 'Your portfolio must have a title.' }

  # === PRVOICES SCHEMA METADATA ===

  # Portfolio identifier (e.g., RAiD)
  property :portfolio_identifier, predicate: ::RDF::URI('https://hykucommons.org/terms/portfolio_identifier'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :portfolio_identifier_type, predicate: ::RDF::URI('https://hykucommons.org/terms/portfolio_identifier_type'), multiple: false do |index|
    index.as :stored_searchable
  end

  # Context statement (rich text field for research narrative)
  property :context_statement, predicate: ::RDF::URI('https://hykucommons.org/terms/context_statement'), multiple: false do |index|
    index.as :stored_searchable
  end

  # Project link/identifier
  property :project, predicate: ::RDF::URI('https://hykucommons.org/terms/project') do |index|
    index.as :stored_searchable
  end

  # Alternate identifiers (DOI, URL, etc.)
  property :alternate_identifier, predicate: ::RDF::Vocab::DC.identifier do |index|
    index.as :stored_searchable
  end

  property :alternate_identifier_type, predicate: ::RDF::URI('https://hykucommons.org/terms/alternate_identifier_type') do |index|
    index.as :stored_searchable
  end

  # Funding references
  property :funder_name, predicate: ::RDF::Vocab::SCHEMA.funder do |index|
    index.as :stored_searchable, :facetable
  end

  property :funder_identifier, predicate: ::RDF::URI('https://hykucommons.org/terms/funder_identifier') do |index|
    index.as :stored_searchable
  end

  property :award_number, predicate: ::RDF::URI('https://hykucommons.org/terms/award_number') do |index|
    index.as :stored_searchable
  end

  property :award_title, predicate: ::RDF::URI('https://hykucommons.org/terms/award_title') do |index|
    index.as :stored_searchable
  end

  # Contributors with roles (extends basic creator/contributor)
  property :contributor_role, predicate: ::RDF::URI('https://hykucommons.org/terms/contributor_role') do |index|
    index.as :stored_searchable, :facetable
  end

  property :contributor_orcid, predicate: ::RDF::URI('https://hykucommons.org/terms/contributor_orcid') do |index|
    index.as :stored_searchable
  end

  property :contributor_affiliation, predicate: ::RDF::URI('https://hykucommons.org/terms/contributor_affiliation') do |index|
    index.as :stored_searchable
  end

  # Date types (Issued, Conceptualized, etc.)
  property :date_type, predicate: ::RDF::URI('https://hykucommons.org/terms/date_type') do |index|
    index.as :stored_searchable, :facetable
  end

  # Additional Dublin Core and Schema.org fields
  property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation do |index|
    index.as :stored_searchable
  end

  # Bulkrax identifier for imports
  property :bulkrax_identifier, predicate: ::RDF::URI("https://hykucommons.org/terms/bulkrax_identifier"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # === NTRO PROVENANCE METADATA ===

  # Cultural Context
  property :cultural_origin, predicate: ::RDF::URI('http://ntro.example.org/terms/culturalOrigin') do |index|
    index.as :stored_searchable, :facetable
  end

  property :cultural_community, predicate: ::RDF::URI('http://ntro.example.org/terms/culturalCommunity') do |index|
    index.as :stored_searchable, :facetable
  end

  property :indigenous_affiliation, predicate: ::RDF::URI('http://ntro.example.org/terms/indigenousAffiliation') do |index|
    index.as :stored_searchable, :facetable
  end

  property :cultural_sensitivity_level, predicate: ::RDF::URI('http://ntro.example.org/terms/culturalSensitivityLevel') do |index|
    index.as :stored_searchable, :facetable
  end

  # Traditional Knowledge Labels
  property :tk_labels, predicate: ::RDF::URI('http://localcontexts.org/tk/label') do |index|
    index.as :stored_searchable, :facetable
  end

  property :tk_label_text, predicate: ::RDF::URI('http://localcontexts.org/tk/labelText') do |index|
    index.as :stored_searchable
  end

  property :tk_attribution_requirement, predicate: ::RDF::URI('http://localcontexts.org/tk/attributionRequirement') do |index|
    index.as :stored_searchable
  end

  # Rights & Ownership
  property :rights_holder_names, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
    index.as :stored_searchable, :facetable
  end

  property :rights_type, predicate: ::RDF::URI('http://ntro.example.org/terms/rightsType') do |index|
    index.as :stored_searchable, :facetable
  end

  property :cultural_authority, predicate: ::RDF::URI('http://ntro.example.org/terms/culturalAuthority') do |index|
    index.as :stored_searchable
  end

  property :ownership_percentage, predicate: ::RDF::URI('http://ntro.example.org/terms/ownershipPercentage') do |index|
    index.as :stored_searchable
  end

  # Ethical & Process Documentation
  property :ethical_clearance, predicate: ::RDF::URI('http://ntro.example.org/terms/ethicalClearance'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :community_consultation_status, predicate: ::RDF::URI('http://ntro.example.org/terms/communityConsultation'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :research_methodology, predicate: ::RDF::URI('http://ntro.example.org/terms/researchMethodology') do |index|
    index.as :stored_searchable
  end

  property :ethical_considerations, predicate: ::RDF::URI('http://ntro.example.org/terms/ethicalConsiderations') do |index|
    index.as :stored_searchable
  end

  property :process_narrative, predicate: ::RDF::Vocab::DC.description do |index|
    index.as :stored_searchable
  end

  # Extended Contributors (CRediT taxonomy extensions)
  property :contributor_role_extended, predicate: ::RDF::URI('http://ntro.example.org/terms/contributorRoleExtended') do |index|
    index.as :stored_searchable, :facetable
  end

  # Version & Transformation Tracking
  property :version_type, predicate: ::RDF::URI('http://ntro.example.org/terms/versionType') do |index|
    index.as :stored_searchable, :facetable
  end

  property :version_number, predicate: ::RDF::URI('http://ntro.example.org/terms/versionNumber'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :transformation_type, predicate: ::RDF::URI('http://ntro.example.org/terms/transformationType') do |index|
    index.as :stored_searchable, :facetable
  end

  property :instantiation_type, predicate: ::RDF::URI('http://ntro.example.org/terms/instantiationType') do |index|
    index.as :stored_searchable, :facetable
  end

  # Temporal Documentation
  property :creation_date_start, predicate: ::RDF::URI('http://ntro.example.org/terms/creationDateStart'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :creation_date_end, predicate: ::RDF::URI('http://ntro.example.org/terms/creationDateEnd'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :performance_date, predicate: ::RDF::URI('http://ntro.example.org/terms/performanceDate') do |index|
    index.as :stored_searchable
  end

  property :exhibition_date, predicate: ::RDF::URI('http://ntro.example.org/terms/exhibitionDate') do |index|
    index.as :stored_searchable
  end

  # JSON Fields for Complex Nested Structures
  property :creation_stages_json, predicate: ::RDF::URI('http://ntro.example.org/terms/creationStages'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :rights_holders_json, predicate: ::RDF::URI('http://ntro.example.org/terms/rightsHolders'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :licenses_extended_json, predicate: ::RDF::URI('http://ntro.example.org/terms/licensesExtended'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :cultural_protocols_json, predicate: ::RDF::URI('http://ntro.example.org/terms/culturalProtocols'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :process_documentation_json, predicate: ::RDF::URI('http://ntro.example.org/terms/processDocumentation'), multiple: false do |index|
    index.as :stored_searchable
  end

  # Relationship IDs (OER pattern for version tracking)
  property :previous_version_id, predicate: ::RDF::Vocab::DC.replaces do |index|
    index.as :stored_searchable
  end

  property :newer_version_id, predicate: ::RDF::Vocab::DC.isReplacedBy do |index|
    index.as :stored_searchable
  end

  property :alternate_version_id, predicate: ::RDF::Vocab::DC.hasVersion do |index|
    index.as :stored_searchable
  end

  property :derivative_work_id, predicate: ::RDF::Vocab::DC.relation do |index|
    index.as :stored_searchable
  end

  property :performance_id, predicate: ::RDF::URI('http://ntro.example.org/terms/performanceOf') do |index|
    index.as :stored_searchable
  end

  property :exhibition_id, predicate: ::RDF::URI('http://ntro.example.org/terms/exhibitionOf') do |index|
    index.as :stored_searchable
  end

  # This must be included at the end
  include ::Hyrax::BasicMetadata
  include OrderMetadataValues

  # Enable nested attributes for controlled vocabularies
  id_blank = proc { |attributes| attributes[:id].blank? }
  class_attribute :controlled_properties
  self.controlled_properties = [:based_near]
  accepts_nested_attributes_for :based_near, reject_if: id_blank, allow_destroy: true

  # === JSON ACCESSOR METHODS ===

  def creation_stages
    JSON.parse(creation_stages_json || '[]')
  rescue JSON::ParserError
    []
  end

  def creation_stages=(stages)
    self.creation_stages_json = stages.to_json if stages
  end

  def rights_holders
    JSON.parse(rights_holders_json || '[]')
  rescue JSON::ParserError
    []
  end

  def rights_holders=(holders)
    self.rights_holders_json = holders.to_json if holders
  end

  def licenses_extended
    JSON.parse(licenses_extended_json || '[]')
  rescue JSON::ParserError
    []
  end

  def licenses_extended=(licenses)
    self.licenses_extended_json = licenses.to_json if licenses
  end

  def cultural_protocols
    JSON.parse(cultural_protocols_json || '[]')
  rescue JSON::ParserError
    []
  end

  def cultural_protocols=(protocols)
    self.cultural_protocols_json = protocols.to_json if protocols
  end

  def process_documentation
    JSON.parse(process_documentation_json || '[]')
  rescue JSON::ParserError
    []
  end

  def process_documentation=(docs)
    self.process_documentation_json = docs.to_json if docs
  end

  # === RELATIONSHIP HELPER METHODS (OER pattern) ===

  def previous_version
    @previous_version ||= Portfolio.where(id: previous_version_id) if previous_version_id.present?
  end

  def newer_version
    @newer_version ||= Portfolio.where(id: newer_version_id) if newer_version_id.present?
  end

  def alternate_version
    @alternate_version ||= Portfolio.where(id: alternate_version_id) if alternate_version_id.present?
  end

  def derivative_works
    @derivative_works ||= Portfolio.where(id: derivative_work_id) if derivative_work_id.present?
  end

  def performances
    @performances ||= Portfolio.where(id: performance_id) if performance_id.present?
  end

  def exhibitions
    @exhibitions ||= Portfolio.where(id: exhibition_id) if exhibition_id.present?
  end
end
