class TeamsController < ApplicationController
  before_action :authenticate_user!

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    # @project = current_user.projects.new(project_params)
    # if @project.save
    #   redirect_to @project, notice: "Your design history has been created"
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end
end
