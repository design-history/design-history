class AppController < ApplicationController
  before_action :set_project

  def index
    @posts = @project.posts.where(published: true).order(published_at: :desc)
  end

  def show
    @post = @project.posts.find(params[:post_id])
  end

  private

  def set_project
    @project = Project.find_by!(subdomain: request.subdomain)
  end
end
