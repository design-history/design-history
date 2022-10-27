class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_project, only: %i[edit update destroy]

  # GET /projects
  def index
    @projects = Project.all.order(:title)
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

    if @project.save
      redirect_to @project, notice: "Project was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to projects_url, notice: "Project was successfully destroyed"
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :subdomain, :description)
  end
end
