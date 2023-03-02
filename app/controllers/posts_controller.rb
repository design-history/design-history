class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_post, only: %i[edit update destroy]

  # GET /posts
  def index
    @posts = @project.posts.order(published_at: :desc)
  end

  # GET /posts/new
  def new
    @post = @project.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = @project.posts.new(post_params)

    if @post.save
      redirect_to edit_project_post_path(@project, @post),
                  notice: "Post created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      if @post.published?
        body =
          helpers.govuk_link_to "View post",
                                app_post_url(
                                  @post.to_param,
                                  host: Rails.application.config.app_domain,
                                  subdomain: @project.subdomain
                                )
        notice = { title: "Changes saved", body: }
      else
        notice = "Changes saved"
      end

      redirect_to edit_project_post_path(@project, @post), notice:
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
    redirect_to posts_url, notice: "Post deleted"
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_post
    @post = @project.posts.friendly.with_attached_images.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :title,
      :slug,
      :body,
      :related_links,
      :published,
      :published_at
    )
  end
end
