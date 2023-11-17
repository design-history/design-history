class PagesController < ApplicationController
  layout "two_thirds", only: %i[start privacy_notice]

  def landing
    render layout: "landing"
  end

  def robots
    project = Project.find_by(subdomain: request.subdomain)
    @block_crawlers = !Rails.env.production? || project&.private?

    respond_to :text
    expires_in 6.hours, public: true
  end
end
