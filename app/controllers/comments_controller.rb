class CommentsController < ApplicationController
  def index
    @comments = Comment.last(20)
  end

  def show
    @comment = Comment.includes(:comment).find_by(id: params[:id])
    @child_comments = Comment.where(comment: @comment)

    @new_comment = Comment.new(comment: @comment)
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to @comment
    else
      redirect_to root_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body,
                                    :comment_id,
                                    :user_display_name,
                                    :user_name)
  end
end
