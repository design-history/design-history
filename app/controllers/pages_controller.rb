class PagesController < ApplicationController
  def start
  end

  def working
    @subdomain = request.subdomain
  end
end
