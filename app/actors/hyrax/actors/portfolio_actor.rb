# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Portfolio`
# Extended with NTRO Phase 2: Nested data processing
module Hyrax
  module Actors
    class PortfolioActor < Hyrax::Actors::BaseActor
      def create(env)
        process_ntro_metadata(env)
        super
      end

      def update(env)
        process_ntro_metadata(env)
        super
      end

      private

      def process_ntro_metadata(env)
        # Process version relationships (OER pattern)
        attributes_collection = env.attributes.delete(:related_members_attributes)
        add_relationships(env, attributes_collection) if attributes_collection

        # Process JSON nested structures
        process_creation_stages(env)
        process_rights_holders(env)
        process_licenses(env)
        process_cultural_protocols(env)
        process_process_documentation(env)

        env
      end

      def add_relationships(env, attributes_collection)
        return unless attributes_collection

        attributes_collection.each do |_, attributes|
          next if attributes[:_destroy] == '1' || attributes[:_destroy] == true

          relationship = attributes[:relationship]
          work_id = attributes[:id]

          next unless work_id.present? && relationship.present?

          case relationship
          when 'previous-version'
            add_to_relationship(env.curation_concern, :previous_version_id, work_id)
          when 'newer-version'
            add_to_relationship(env.curation_concern, :newer_version_id, work_id)
          when 'alternate-version'
            add_to_relationship(env.curation_concern, :alternate_version_id, work_id)
          when 'performance'
            add_to_relationship(env.curation_concern, :performance_id, work_id)
          when 'exhibition'
            add_to_relationship(env.curation_concern, :exhibition_id, work_id)
          when 'derivative'
            add_to_relationship(env.curation_concern, :derivative_work_id, work_id)
          end
        end
      end

      def add_to_relationship(work, relationship_field, work_id)
        current_ids = work.send(relationship_field) || []
        work.send("#{relationship_field}=", current_ids + [work_id]) unless current_ids.include?(work_id)
      end

      def process_creation_stages(env)
        stages = env.attributes.delete(:creation_stages)
        return unless stages

        # Convert array of hashes to JSON
        valid_stages = stages.select { |s| s.is_a?(Hash) && s[:stage_type].present? }
        env.curation_concern.creation_stages = valid_stages unless valid_stages.empty?
      end

      def process_rights_holders(env)
        holders = env.attributes.delete(:rights_holders)
        return unless holders

        # Convert array of hashes to JSON
        valid_holders = holders.select { |h| h.is_a?(Hash) && h[:entity_name].present? }
        env.curation_concern.rights_holders = valid_holders unless valid_holders.empty?
      end

      def process_licenses(env)
        licenses = env.attributes.delete(:licenses_extended)
        return unless licenses

        # Convert array of hashes to JSON
        valid_licenses = licenses.select { |l| l.is_a?(Hash) && l[:license_type].present? }
        env.curation_concern.licenses_extended = valid_licenses unless valid_licenses.empty?
      end

      def process_cultural_protocols(env)
        protocols = env.attributes.delete(:cultural_protocols)
        return unless protocols

        # Convert array of hashes to JSON
        valid_protocols = protocols.select { |p| p.is_a?(Hash) && p[:protocol_type].present? }
        env.curation_concern.cultural_protocols = valid_protocols unless valid_protocols.empty?
      end

      def process_process_documentation(env)
        docs = env.attributes.delete(:process_documentation)
        return unless docs

        # Convert array of hashes to JSON
        valid_docs = docs.select { |d| d.is_a?(Hash) }
        env.curation_concern.process_documentation = valid_docs unless valid_docs.empty?
      end
    end
  end
end
