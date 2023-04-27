class CommentsController < ApplicationController
  before_action :set_post

  def new
    @comment = Comment.new
  end

  def create
    @comment = @post.comments.new comment_params

    if @comment.save
      redirect_to app_post_path(@post),
                  notice: "Your comment was successfully posted"
    else
      @post.reload # Clear out the comment we just added
      render template: "app/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :name, :email)
  end

  def set_post
    @project = Project.find_by!(subdomain: request.subdomain)
    @post =
      @project.posts.friendly.where(published: true).find(params[:post_id])
  end
end
