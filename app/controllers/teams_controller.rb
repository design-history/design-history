class TeamsController < ApplicationController
  before_action :authenticate_user!

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to @team, notice: "Your team has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
