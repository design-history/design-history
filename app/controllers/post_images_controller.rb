class PostImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_post
  before_action :set_image, except: %i[index create]

  def index
    @images = @post.images
  end

  def up
    @post.ordered_image_move_up!(@image)
    redirect_to project_post_images_path, notice: "Image moved"
  end

  def down
    @post.ordered_image_move_down!(@image)
    redirect_to project_post_images_path, notice: "Image moved"
  end

  def create
    if @post.update(create_params)
      redirect_to project_post_images_path, notice: "Images uploaded"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @image.purge
    redirect_to project_post_images_path,
                notice: "Image was successfully deleted"
  end

  private

  def create_params
    params.require(:post).permit(images: [])
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_post
    @post = @project.posts.friendly.with_attached_images.find(params[:post_id])
  end

  def set_image
    @image = @post.images.find(params[:id])
  end
end
