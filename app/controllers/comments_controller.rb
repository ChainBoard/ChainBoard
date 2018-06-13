# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @comments = Comment.search(include: :comment) do
      fulltext params[:body] if params[:body].present?
      with(:user_display_name, params[:user_display_name]) if params[:user_display_name].present?
      with(:user_name, params[:user_name]) if params[:user_name].present?
      order_by(:id, :desc)
    end.results
  end

  def show
    @comment = Comment.includes(:comment).find_by(id: params[:id])

    if @comment
      @child_comments = Comment.where(comment: @comment)
      @new_comment = Comment.new(comment: @comment)
    else
      redirect_to root_path, alert: 'Comment not found.'
    end
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
