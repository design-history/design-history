class ManageAccessController < ApplicationController
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
    params.require(:project).permit(:private, :password)
  end
end
