class PostImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_post
  before_action :set_image, except: [:create]

  def up
    @post.ordered_image_move_up!(@image)
    redirect_to edit_project_post_path(@project, @post), notice: "Image moved"
  end

  def down
    @post.ordered_image_move_down!(@image)
    redirect_to edit_project_post_path(@project, @post), notice: "Image moved"
  end

  def create
    if @post.update(create_params)
      redirect_to edit_project_post_path(@project, @post),
                  notice: "Images uploaded"
    else
      render "post/edit", status: :unprocessable_entity
    end
  end

  def destroy
    @image.purge
    redirect_to edit_project_post_path(@project, @post),
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
