class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_post, only: %i[edit update destroy]

  # GET /posts
  def index
    @drafts = @project.posts.where(published: false).order(updated_at: :desc)
    @posts = @project.posts.where(published: true).order(published_at: :desc)
  end

  # GET /posts/1
  def show
    @post = @project.posts.with_attached_images.find(params[:id])
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
      redirect_to [@project, @post], notice: "Post was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if destroy_attachment_params
      @post.images.find(destroy_attachment_params).purge
    end

    if @post.update(post_params)
      redirect_to edit_project_post_path(@project, @post),
                  notice: "Post was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
    redirect_to posts_url, notice: "Post was successfully destroyed"
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_post
    @post = @project.posts.with_attached_images.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :title,
      :slug,
      :body,
      :published,
      :published_at,
      images: []
    )
  end

  def destroy_attachment_params
    return false if params[:destroy_attachment].blank?

    params.require(:destroy_attachment)
  end
end
