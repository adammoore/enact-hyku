# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Portfolio`
# Extended with NTRO Provenance Framework fields
module Hyrax
  # Generated form for Portfolio
  class PortfolioForm < Hyrax::Forms::WorkForm
    self.model_class = ::Portfolio
    self.terms += [
      # PRVoices Schema fields
      :portfolio_identifier,
      :portfolio_identifier_type,
      :context_statement,
      :project,
      :alternate_identifier,
      :alternate_identifier_type,
      :funder_name,
      :funder_identifier,
      :award_number,
      :award_title,
      :contributor_role,
      :contributor_orcid,
      :contributor_affiliation,
      :date_type,
      :bibliographic_citation,

      # NTRO Cultural Context
      :cultural_origin,
      :cultural_community,
      :indigenous_affiliation,
      :cultural_sensitivity_level,

      # TK Labels
      :tk_labels,
      :tk_label_text,
      :tk_attribution_requirement,

      # Rights
      :rights_holder_names,
      :rights_type,
      :cultural_authority,
      :ownership_percentage,

      # Ethical
      :ethical_clearance,
      :community_consultation_status,
      :research_methodology,
      :ethical_considerations,
      :process_narrative,

      # Contributors Extended
      :contributor_role_extended,

      # Versions
      :version_type,
      :version_number,
      :transformation_type,
      :instantiation_type,

      # Temporal
      :creation_date_start,
      :creation_date_end,
      :performance_date,
      :exhibition_date,

      # JSON fields
      :creation_stages_json,
      :rights_holders_json,
      :licenses_extended_json,
      :cultural_protocols_json,
      :process_documentation_json,

      # Relationships
      :previous_version_id,
      :newer_version_id,
      :alternate_version_id,
      :derivative_work_id,
      :performance_id,
      :exhibition_id
    ]

    # Delegate JSON accessors
    delegate :creation_stages, :creation_stages=,
             :rights_holders, :rights_holders=,
             :licenses_extended, :licenses_extended=,
             :cultural_protocols, :cultural_protocols=,
             :process_documentation, :process_documentation=,
             :previous_version, :newer_version, :alternate_version,
             :derivative_works, :performances, :exhibitions,
             to: :model

    # Build permitted params for nested attributes
    def self.build_permitted_params
      super + [
        { related_members_attributes: %i[id _destroy relationship] },
        { creation_stages: [:stage_type, :date, :location, :description, :contributors, :_destroy] },
        { rights_holders: [:entity_name, :entity_type, :entity_role, :rights_percentage, :cultural_context, :_destroy] },
        { licenses_extended: [:license_type, :license_identifier, :license_text, :license_scope, :_destroy] },
        { cultural_protocols: [:protocol_type, :protocol_description, :_destroy] }
      ]
    end

    # JSON serialization for UI
    def previous_version_json
      return [] if previous_version.blank?
      previous_version.map do |work|
        {
          id: work.id.to_s,
          label: work.title.join(' | '),
          path: Rails.application.routes.url_helpers.url_for(work),
          relationship: "previous-version"
        }
      end.to_json
    end

    def newer_version_json
      return [] if newer_version.blank?
      newer_version.map do |work|
        {
          id: work.id.to_s,
          label: work.title.join(' | '),
          path: Rails.application.routes.url_helpers.url_for(work),
          relationship: "newer-version"
        }
      end.to_json
    end
  end
end
