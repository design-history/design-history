class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_projects, only: %i[new create]
  before_action :set_project, only: %i[edit update destroy]

  layout "two_thirds", only: %i[index new edit create update]

  # GET /projects
  def index
    @projects = current_user.projects.where(type: nil).order(:title)
    @groups = current_user.groups.all.order(:title)
  end

  # GET /projects/1
  def show
    redirect_to project_posts_path(project_id: params[:id])
  end

  # GET /projects/new
  def new
    @project = @projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = @projects.new(project_params)
    if @project.save
      redirect_to project_path(@project),
        notice: "Your #{@project.label} has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to project_path(@project),
        notice: "Your changes have been saved"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to projects_url, notice: "Your #{@project.label} has been deleted"
  end

  private

  def set_projects
    @projects = if params[:type] == "group"
      current_user.own_groups
    else
      current_user.own_projects
    end
  end

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.fetch(:project, params.require(:group)).permit(
      :title,
      :subdomain,
      :description,
      :theme,
      :related_links,
      :comments_enabled
    )
  end
end
