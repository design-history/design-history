class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy]

  layout "two_thirds", only: %i[index new edit]

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
    @project = if params[:type] == "group"
      current_user.own_groups.new
    else
      current_user.own_projects.new
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = current_user.own_projects.new(project_params)
    if @project.save
      redirect_to @project, notice: "Your #{@project.label} has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Your changes have been saved"
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

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :title,
      :subdomain,
      :description,
      :theme,
      :related_links,
      :comments_enabled
    )
  end
end
