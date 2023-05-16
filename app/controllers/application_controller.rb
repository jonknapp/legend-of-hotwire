class ApplicationController < ActionController::Base
  before_action :add_turbo_variant

  private

  def add_turbo_variant
    return if request.variant.any?

    logger.info "Turbo-Frame: #{request.headers['Turbo-Frame']}"

    request.variant = request.headers['Turbo-Frame'].to_sym if request.headers['Turbo-Frame'].present?
  end
end
