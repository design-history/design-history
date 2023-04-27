class AppController < ApplicationController
  before_action :set_project
  before_action :check_password, except: %i[confirm_password]

  layout "app"

  def index
    @posts = @project.posts.where(published: true).order(published_at: :desc)
  end

  def show
    @post =
      @project.posts.friendly.where(published: true).find(params[:post_id])
    @comment = Comment.new
  end

  def confirm_password
    if @project.update(confirm_password_params)
      session[:password] = @project.password
      redirect_to session.delete(:previous_url)
    else
      render :password, status: :forbidden
    end
  end

  private

  def set_project
    @project = Project.find_by!(subdomain: request.subdomain)
  end

  def check_password
    return unless @project.private?
    return if session[:password] == @project.password

    session[:previous_url] = request.path

    render :password, status: :forbidden
  end

  def confirm_password_params
    params.require(:project).permit(:password_confirmation)
  end
end
