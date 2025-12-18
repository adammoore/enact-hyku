# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Portfolio`
class PortfolioResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::ArResource
  include Hyrax::NestedWorks
end
