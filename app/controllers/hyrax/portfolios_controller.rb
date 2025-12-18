# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Portfolio`
module Hyrax
  # Generated controller for Portfolio
  class PortfoliosController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Portfolio

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PortfolioPresenter
  end
end
