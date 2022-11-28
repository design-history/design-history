class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy]

  # GET /projects
  def index
    @projects = current_user.projects.all.order(:title)
  end

  # GET /projects/1
  def show
    redirect_to project_posts_path(project_id: params[:id])
  end

  # GET /projects/new
  def new
    @project = current_user.projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = current_user.projects.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to @project, notice: "Your design history has been created"
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
    redirect_to projects_url, notice: "Your design history has been deleted"
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :subdomain, :description)
  end
end
