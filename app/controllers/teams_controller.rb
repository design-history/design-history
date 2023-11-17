class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, except: %i[new create]

  layout "two_thirds", only: %i[new add_user]

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

  # GET /teams/1/add-user
  def add_user
    @add_user_form = AddUserForm.new
  end

  # POST /teams/1/add-user
  def add_user_create
    @add_user_form = AddUserForm.new(add_user_params)
    @add_user_form.team = @team
    if @add_user_form.save
      redirect_to @team, notice: "User added"
    else
      render :add_user, status: :unprocessable_entity
    end
  end

  # POST /teams/1/add-project/1
  def add_project
    project = Project.find(add_project_params)
    project.update!(owner: @team)
    redirect_to project_manage_access_path(project),
                notice: "Design history was added to your team"
  end

  private

  def set_team
    @team = current_user.team
  end

  def team_params
    params.require(:team).permit(:name)
  end

  def add_user_params
    params.require(:add_user_form).permit(:email)
  end

  def add_project_params
    params.require(:project_id)
  end
end
