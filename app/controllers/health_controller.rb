# frozen_string_literal: true

# Simple health check controller for load balancers and monitoring
class HealthController < ActionController::Base
  def show
    render plain: 'OK', status: :ok
  end
end
