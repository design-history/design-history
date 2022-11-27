class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show]

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    if @team.save
      current_user.update!(team: @team)
      redirect_to @team, notice: "Your team has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = current_user.team
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
