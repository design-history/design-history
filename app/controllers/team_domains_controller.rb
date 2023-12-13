class TeamDomainsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team

  layout "two_thirds"

  def start
  end

  def new
    if @team.projects.map(&:theme).uniq.count == 1
      @team.theme = @team.projects.first.theme
      @theme_is_preselected = true
    end
  end

  def edit
  end

  def update
    if @team.update(team_domain_params)
      redirect_to @team, notice: "Your team subdomain has been set up"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = current_user.team
  end

  def team_domain_params
    params.require(:team).permit(:subdomain, :theme)
  end
end
