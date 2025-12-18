# frozen_string_literal: true

# TK Label Service
# Defines Traditional Knowledge (TK) Labels from Local Contexts
# and provides methods for checking restriction levels and access requirements
#
# @see https://localcontexts.org/labels/traditional-knowledge-labels/
class TkLabelService
  TK_LABELS = {
    'TK_A' => {
      name: 'Attribution',
      description: 'This Label is being used to correct historical mistakes or exclusions.',
      restriction_level: 'low',
      url: 'https://localcontexts.org/label/tk-attribution/'
    },
    'TK_F' => {
      name: 'Family',
      description: 'This Label is being used to indicate that this material is culturally sensitive.',
      restriction_level: 'high',
      family_only: true,
      url: 'https://localcontexts.org/label/tk-family/'
    },
    'TK_MC' => {
      name: 'Multiple Communities',
      description: 'This Label is being used to indicate that this material has community-approved restrictions.',
      restriction_level: 'high',
      url: 'https://localcontexts.org/label/tk-multiple-communities/'
    },
    'TK_MG' => {
      name: "Men's General",
      description: "This Label is being used to indicate that this material is specifically designed for men's access.",
      restriction_level: 'high',
      gender_restricted: true,
      allowed_genders: ['male'],
      url: 'https://localcontexts.org/label/tk-men-general/'
    },
    'TK_WG' => {
      name: "Women's General",
      description: "This Label is being used to indicate that this material is specifically designed for women's access.",
      restriction_level: 'high',
      gender_restricted: true,
      allowed_genders: ['female'],
      url: 'https://localcontexts.org/label/tk-women-general/'
    },
    'TK_MR' => {
      name: "Men's Restricted",
      description: 'This Label is being used to indicate that this material is specifically designed for initiated men.',
      restriction_level: 'critical',
      gender_restricted: true,
      allowed_genders: ['male'],
      initiated_only: true,
      url: 'https://localcontexts.org/label/tk-men-restricted/'
    },
    'TK_WR' => {
      name: "Women's Restricted",
      description: 'This Label is being used to indicate that this material is specifically designed for initiated women.',
      restriction_level: 'critical',
      gender_restricted: true,
      allowed_genders: ['female'],
      initiated_only: true,
      url: 'https://localcontexts.org/label/tk-women-restricted/'
    },
    'TK_CO' => {
      name: 'Community Use Only',
      description: 'This Label is being used to indicate that this material is only for use within the community.',
      restriction_level: 'critical',
      community_only: true,
      url: 'https://localcontexts.org/label/tk-community-use-only/'
    },
    'TK_S' => {
      name: 'Seasonal',
      description: 'This Label is being used to indicate that this material has seasonal or temporal restrictions.',
      restriction_level: 'medium',
      seasonal: true,
      url: 'https://localcontexts.org/label/tk-seasonal/'
    },
    'TK_NC' => {
      name: 'Non-Commercial',
      description: 'This Label is being used to indicate that this material is available for non-commercial use only.',
      restriction_level: 'medium',
      url: 'https://localcontexts.org/label/tk-non-commercial/'
    },
    'TK_CB' => {
      name: 'Open to Collaboration',
      description: 'This Label is being used to indicate that this material is available for collaborative work.',
      restriction_level: 'low',
      url: 'https://localcontexts.org/label/tk-open-to-collaboration/'
    },
    'TK_O' => {
      name: 'Outreach',
      description: 'This Label is being used to support engagement with external users.',
      restriction_level: 'low',
      url: 'https://localcontexts.org/label/tk-outreach/'
    },
    'TK_V' => {
      name: 'Verified',
      description: 'This Label is being used to indicate that this material has been verified by the community.',
      restriction_level: 'low',
      url: 'https://localcontexts.org/label/tk-verified/'
    },
    'TK_CR' => {
      name: 'Community Researchers',
      description: 'This Label is being used to indicate that community researchers were involved.',
      restriction_level: 'low',
      url: 'https://localcontexts.org/label/tk-community-researchers/'
    }
  }.freeze

  class << self
    # Get display information for a TK label
    # @param label_code [String] TK label code (e.g., 'TK_A', 'TK_CO')
    # @return [Hash] Label information
    def display_info(label_code)
      TK_LABELS[label_code] || { name: label_code, description: '', restriction_level: 'unknown' }
    end

    # Check if any labels require community membership
    # @param labels [Array<String>] Array of TK label codes
    # @return [Boolean]
    def requires_community_membership?(labels)
      return false if labels.blank?
      labels.any? { |l| TK_LABELS.dig(l, :community_only) || TK_LABELS.dig(l, :family_only) }
    end

    # Check if any labels have gender restrictions
    # @param labels [Array<String>] Array of TK label codes
    # @return [Boolean]
    def is_gender_restricted?(labels)
      return false if labels.blank?
      labels.any? { |l| TK_LABELS.dig(l, :gender_restricted) }
    end

    # Get allowed genders for restricted labels
    # @param labels [Array<String>] Array of TK label codes
    # @return [Array<String>] Array of allowed genders
    def allowed_genders(labels)
      return [] if labels.blank?
      labels.flat_map { |l| TK_LABELS.dig(l, :allowed_genders) || [] }.uniq
    end

    # Get the highest restriction level from a set of labels
    # @param labels [Array<String>] Array of TK label codes
    # @return [String] Highest restriction level (critical, high, medium, low)
    def restriction_level(labels)
      return 'low' if labels.blank?

      levels = { 'critical' => 4, 'high' => 3, 'medium' => 2, 'low' => 1 }
      max_level = labels.map { |l| TK_LABELS.dig(l, :restriction_level) }
                        .compact
                        .max_by { |level| levels[level] || 0 }
      max_level || 'low'
    end

    # Check if any labels require initiated status
    # @param labels [Array<String>] Array of TK label codes
    # @return [Boolean]
    def requires_initiation?(labels)
      return false if labels.blank?
      labels.any? { |l| TK_LABELS.dig(l, :initiated_only) }
    end

    # Check if downloads are blocked by any labels
    # @param labels [Array<String>] Array of TK label codes
    # @return [Boolean]
    def blocks_downloads?(labels)
      return false if labels.blank?
      # TK_CO (Community Use Only) blocks downloads
      labels.include?('TK_CO')
    end

    # Get all label codes
    # @return [Array<String>] Array of all TK label codes
    def all_label_codes
      TK_LABELS.keys
    end

    # Get labels grouped by restriction level
    # @return [Hash] Labels grouped by restriction level
    def labels_by_restriction_level
      {
        critical: TK_LABELS.select { |_, v| v[:restriction_level] == 'critical' }.keys,
        high: TK_LABELS.select { |_, v| v[:restriction_level] == 'high' }.keys,
        medium: TK_LABELS.select { |_, v| v[:restriction_level] == 'medium' }.keys,
        low: TK_LABELS.select { |_, v| v[:restriction_level] == 'low' }.keys
      }
    end
  end
end
