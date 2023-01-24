class ManageAccessController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Your changes have been saved"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def project_params
    p = params.require(:project).permit(:visibility, :password)
    p[:password] = "" if p[:visibility] == "public"
    p
  end
end
