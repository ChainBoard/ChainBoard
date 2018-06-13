# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @search_params = search_params
    @comments = search_comment(@search_params).results
    flash.now[:alert] = 'Comment not found.' if @comments.empty?
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

  def search_comment(query)
    Comment.search(include: :comment) do
      fulltext query[:body] if query[:body].present?
      with(:user_display_name, query[:user_display_name]) if query[:user_display_name].present?
      with(:user_name, query[:user_name]) if query[:user_name].present?
      order_by(:id, :desc)
    end
  end

  def search_params
    params.permit(:body,
                  :user_display_name,
                  :user_name)
  end
end
