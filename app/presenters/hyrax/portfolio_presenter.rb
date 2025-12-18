# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Portfolio`
# Extended with NTRO Provenance Framework presentation methods
module Hyrax
  class PortfolioPresenter < Hyrax::WorkShowPresenter
    # PRVoices Schema field delegations
    delegate :portfolio_identifier, :portfolio_identifier_type, :context_statement,
             :project, :alternate_identifier, :alternate_identifier_type,
             :funder_name, :funder_identifier, :award_number, :award_title,
             :contributor_role, :contributor_orcid, :contributor_affiliation,
             :date_type, :bibliographic_citation, to: :solr_document

    # NTRO Provenance field delegations
    delegate :cultural_origin, :cultural_community, :indigenous_affiliation,
             :cultural_sensitivity_level, :tk_labels, :tk_label_text,
             :tk_attribution_requirement, :rights_holder_names, :rights_type,
             :cultural_authority, :ownership_percentage, :ethical_clearance,
             :community_consultation_status, :research_methodology,
             :ethical_considerations, :process_narrative,
             :contributor_role_extended, :version_type, :version_number,
             :transformation_type, :instantiation_type,
             :creation_date_start, :creation_date_end,
             :performance_date, :exhibition_date, to: :solr_document

    # JSON field accessors for display
    def creation_stages_for_display
      JSON.parse(solr_document['creation_stages_json_tesim']&.first || '[]')
        .sort_by { |s| s['date'] || '' }
    rescue JSON::ParserError
      []
    end

    def rights_holders_for_display
      JSON.parse(solr_document['rights_holders_json_tesim']&.first || '[]')
    rescue JSON::ParserError
      []
    end

    def licenses_extended_for_display
      JSON.parse(solr_document['licenses_extended_json_tesim']&.first || '[]')
    rescue JSON::ParserError
      []
    end

    def cultural_protocols_for_display
      JSON.parse(solr_document['cultural_protocols_json_tesim']&.first || '[]')
    rescue JSON::ParserError
      []
    end

    def process_documentation_for_display
      JSON.parse(solr_document['process_documentation_json_tesim']&.first || '[]')
    rescue JSON::ParserError
      []
    end

    # Version relationships (OER pattern)
    def previous_versions
      return [] unless solr_document['previous_version_id_tesim']
      ids = solr_document['previous_version_id_tesim']
      paginated_item_list(page_array: authorized_items_by_ids(ids))
    end

    def newer_versions
      return [] unless solr_document['newer_version_id_tesim']
      ids = solr_document['newer_version_id_tesim']
      paginated_item_list(page_array: authorized_items_by_ids(ids))
    end

    def alternate_versions
      return [] unless solr_document['alternate_version_id_tesim']
      ids = solr_document['alternate_version_id_tesim']
      authorized_items_by_ids(ids)
    end

    def derivative_works
      return [] unless solr_document['derivative_work_id_tesim']
      ids = solr_document['derivative_work_id_tesim']
      authorized_items_by_ids(ids)
    end

    def performances
      return [] unless solr_document['performance_id_tesim']
      ids = solr_document['performance_id_tesim']
      authorized_items_by_ids(ids)
    end

    def exhibitions
      return [] unless solr_document['exhibition_id_tesim']
      ids = solr_document['exhibition_id_tesim']
      authorized_items_by_ids(ids)
    end

    private

    def authorized_items_by_ids(ids)
      return [] if ids.blank?
      
      items = Portfolio.where(id: ids)
      items = items.to_a if items.respond_to?(:to_a)
      
      # Filter by authorization if feature flag is enabled
      if Flipflop.hide_private_items?
        items.delete_if { |m| !current_ability.can?(:read, m) }
      end
      
      items
    rescue => e
      Rails.logger.error "Error fetching related items: #{e.message}"
      []
    end
  end
end
