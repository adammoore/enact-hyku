# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Portfolio`
# Extended with NTRO Provenance Framework indexing
class PortfolioIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Custom indexing for Portfolio and NTRO metadata
  def generate_solr_document
    super.tap do |solr_doc|
      # === PRVOICES SCHEMA FIELDS ===
      solr_doc['portfolio_identifier_tesim'] = object.portfolio_identifier
      solr_doc['portfolio_identifier_type_tesim'] = object.portfolio_identifier_type
      solr_doc['context_statement_tesim'] = object.context_statement
      solr_doc['project_tesim'] = object.project
      solr_doc['funder_name_tesim'] = object.funder_name
      solr_doc['award_number_tesim'] = object.award_number
      solr_doc['award_title_tesim'] = object.award_title
      solr_doc['contributor_role_tesim'] = object.contributor_role
      solr_doc['date_type_tesim'] = object.date_type

      # === NTRO PROVENANCE FIELDS ===

      # Cultural facets
      solr_doc['cultural_origin_sim'] = object.cultural_origin
      solr_doc['cultural_origin_tesim'] = object.cultural_origin
      solr_doc['cultural_community_sim'] = object.cultural_community
      solr_doc['cultural_community_tesim'] = object.cultural_community
      solr_doc['indigenous_affiliation_sim'] = object.indigenous_affiliation
      solr_doc['indigenous_affiliation_tesim'] = object.indigenous_affiliation
      solr_doc['cultural_sensitivity_level_sim'] = object.cultural_sensitivity_level

      # TK labels (facetable and searchable)
      solr_doc['tk_labels_sim'] = object.tk_labels
      solr_doc['tk_labels_tesim'] = object.tk_labels
      solr_doc['tk_label_text_tesim'] = object.tk_label_text
      solr_doc['tk_attribution_requirement_tesim'] = object.tk_attribution_requirement

      # Rights facets
      solr_doc['rights_holder_names_sim'] = object.rights_holder_names
      solr_doc['rights_holder_names_tesim'] = object.rights_holder_names
      solr_doc['rights_type_sim'] = object.rights_type
      solr_doc['rights_type_tesim'] = object.rights_type
      solr_doc['cultural_authority_tesim'] = object.cultural_authority

      # Version facets
      solr_doc['version_type_sim'] = object.version_type
      solr_doc['version_type_tesim'] = object.version_type
      solr_doc['transformation_type_sim'] = object.transformation_type
      solr_doc['transformation_type_tesim'] = object.transformation_type
      solr_doc['instantiation_type_sim'] = object.instantiation_type
      solr_doc['instantiation_type_tesim'] = object.instantiation_type

      # Contributor roles (extended)
      solr_doc['contributor_role_extended_sim'] = object.contributor_role_extended
      solr_doc['contributor_role_extended_tesim'] = object.contributor_role_extended

      # Searchable text fields
      solr_doc['research_methodology_tesim'] = object.research_methodology
      solr_doc['ethical_considerations_tesim'] = object.ethical_considerations
      solr_doc['process_narrative_tesim'] = object.process_narrative
      solr_doc['ethical_clearance_tesim'] = object.ethical_clearance
      solr_doc['community_consultation_status_tesim'] = object.community_consultation_status

      # Temporal fields
      solr_doc['creation_date_start_tesim'] = object.creation_date_start
      solr_doc['creation_date_end_tesim'] = object.creation_date_end
      solr_doc['performance_date_tesim'] = object.performance_date
      solr_doc['exhibition_date_tesim'] = object.exhibition_date

      # JSON fields - store for retrieval
      solr_doc['creation_stages_json_tesim'] = object.creation_stages_json
      solr_doc['rights_holders_json_tesim'] = object.rights_holders_json
      solr_doc['licenses_extended_json_tesim'] = object.licenses_extended_json
      solr_doc['cultural_protocols_json_tesim'] = object.cultural_protocols_json
      solr_doc['process_documentation_json_tesim'] = object.process_documentation_json

      # Extract from JSON for faceting
      index_creation_stages(solr_doc)
      index_rights_holders(solr_doc)

      # Relationship IDs
      solr_doc['previous_version_id_tesim'] = object.previous_version_id
      solr_doc['newer_version_id_tesim'] = object.newer_version_id
      solr_doc['alternate_version_id_tesim'] = object.alternate_version_id
      solr_doc['derivative_work_id_tesim'] = object.derivative_work_id
      solr_doc['performance_id_tesim'] = object.performance_id
      solr_doc['exhibition_id_tesim'] = object.exhibition_id
    end
  end

  private

  def index_creation_stages(solr_doc)
    return if object.creation_stages_json.blank?

    stages = JSON.parse(object.creation_stages_json)
    solr_doc['creation_stage_types_sim'] = stages.map { |s| s['stage_type'] }.compact
    solr_doc['creation_stage_types_tesim'] = stages.map { |s| s['stage_type'] }.compact
    solr_doc['creation_stage_locations_tesim'] = stages.map { |s| s['location'] }.compact
    solr_doc['creation_stage_dates_tesim'] = stages.map { |s| s['date'] }.compact
  rescue JSON::ParserError
    # Skip indexing if invalid JSON
  end

  def index_rights_holders(solr_doc)
    return if object.rights_holders_json.blank?

    holders = JSON.parse(object.rights_holders_json)
    solr_doc['rights_holder_entities_tesim'] = holders.map { |h| h['entity_name'] }.compact
    solr_doc['rights_holder_roles_sim'] = holders.map { |h| h['entity_role'] }.compact
    solr_doc['rights_holder_roles_tesim'] = holders.map { |h| h['entity_role'] }.compact
    solr_doc['rights_holder_types_sim'] = holders.map { |h| h['entity_type'] }.compact
  rescue JSON::ParserError
    # Skip indexing if invalid JSON
  end
end
