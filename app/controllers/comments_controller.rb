class CommentsController < ApplicationController
  def index
    @comments = Comment.last(20)
  end

  def show
    @comment = Comment.includes(:comment).find_by(id: params[:id])
    @child_comments = Comment.where(comment: @comment)
  end

  def create
  end
end
