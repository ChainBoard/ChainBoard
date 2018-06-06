class CommentsController < ApplicationController
  def index
    @comments = Comment.search do
      fulltext params[:body] if params[:body].present?
      with(:user_display_name, params[:user_display_name]) if params[:user_display_name].present?
      with(:user_name, params[:user_name]) if params[:user_name].present?
      order_by(:id, :desc)
    end.results
  end

  def show
    @comment = Comment.includes(:comment).find_by(id: params[:id])
    @child_comments = Comment.where(comment: @comment)
  end

  def create
  end
end
