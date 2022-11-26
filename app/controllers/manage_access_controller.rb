class ManageAccessController < ApplicationController
  before_action :set_project

  def edit
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
