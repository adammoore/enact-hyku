# frozen_string_literal: true

# TK Permission Service
# Checks user permissions against Traditional Knowledge labels
# Enforces community-based, gender-based, and initiation-based access restrictions
#
# Usage:
#   service = TkPermissionService.new(current_user, portfolio)
#   service.can_view? # => true/false
#   service.access_denial_reason # => "This material is restricted..."
class TkPermissionService
  attr_reader :user, :work

  # Initialize the permission service
  # @param user [User, nil] Current user (nil for anonymous users)
  # @param work [Portfolio] The portfolio work to check permissions for
  def initialize(user, work)
    @user = user
    @work = work
  end

  # Check if user can view the work's metadata and files
  # @return [Boolean]
  def can_view?
    # No TK labels = no restrictions
    return true if work.tk_labels.blank?

    # Admins and cultural authorities can always view
    return true if admin_or_cultural_authority?

    # Check various restriction types
    return false if community_restricted? && !community_member?
    return false if gender_restricted? && !gender_matches?
    return false if initiated_restricted? && !initiated_member?

    # All checks passed
    true
  end

  # Check if user can download files
  # @return [Boolean]
  def can_download?
    # TK_CO (Community Use Only) blocks downloads
    return false if TkLabelService.blocks_downloads?(work.tk_labels)

    # Otherwise, same rules as viewing
    can_view?
  end

  # Get human-readable reason for access denial
  # @return [String, nil] Denial reason or nil if access is granted
  def access_denial_reason
    return nil if can_view?

    if community_restricted? && !community_member?
      communities = work.cultural_community.presence || work.indigenous_affiliation.presence || ['the community']
      "This material is restricted to community members only (#{communities.join(', ')})."
    elsif gender_restricted? && !gender_matches?
      allowed = TkLabelService.allowed_genders(work.tk_labels).join('/')
      "This material has gender-based restrictions (#{allowed} only)."
    elsif initiated_restricted? && !initiated_member?
      "This material is restricted to initiated community members only."
    else
      "This material has access restrictions based on Traditional Knowledge labels."
    end
  end

  # Get download denial reason
  # @return [String, nil] Denial reason or nil if download is allowed
  def download_denial_reason
    return nil if can_download?

    if TkLabelService.blocks_downloads?(work.tk_labels)
      "This material cannot be downloaded due to community use restrictions (TK Community Use Only label)."
    else
      access_denial_reason
    end
  end

  private

  # Check if user is admin or cultural authority for this work
  # @return [Boolean]
  def admin_or_cultural_authority?
    return false unless user

    # Check if user has admin role
    return true if user.respond_to?(:has_role?) && user.has_role?(:admin)

    # Check if user is listed as cultural authority
    return true if work.cultural_authority.present? && user.email.in?(work.cultural_authority)

    false
  end

  # Check if user is a member of the cultural community
  # @return [Boolean]
  def community_member?
    return false unless user
    return false unless user.respond_to?(:cultural_affiliations)

    user_affiliations = user.cultural_affiliations || []
    work_communities = (work.cultural_community || []) + (work.indigenous_affiliation || [])

    # Check for any overlap between user affiliations and work communities
    (user_affiliations & work_communities).any?
  end

  # Check if user's gender matches allowed genders
  # @return [Boolean]
  def gender_matches?
    return true unless user
    return true unless user.respond_to?(:gender)

    allowed = TkLabelService.allowed_genders(work.tk_labels)
    return true if allowed.empty?

    user.gender.present? && allowed.include?(user.gender)
  end

  # Check if work has community-based restrictions
  # @return [Boolean]
  def community_restricted?
    TkLabelService.requires_community_membership?(work.tk_labels)
  end

  # Check if work has gender-based restrictions
  # @return [Boolean]
  def gender_restricted?
    TkLabelService.is_gender_restricted?(work.tk_labels)
  end

  # Check if work requires initiated status
  # @return [Boolean]
  def initiated_restricted?
    TkLabelService.requires_initiation?(work.tk_labels)
  end

  # Check if user has initiated status
  # @return [Boolean]
  def initiated_member?
    return false unless user
    return false unless user.respond_to?(:initiated_member?)

    user.initiated_member?
  rescue NoMethodError
    false
  end
end
