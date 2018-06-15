# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @search_params = index_params
    @comments = Comment.fetch_multi(search_comment_hit_ids(@search_params), includes: [:comment, :comments])
    flash.now[:alert] = 'Comment not found.' if @comments.empty?
  end

  def show
    @comment = Comment.fetch_by_id(params[:id], includes: [:comment, :comments])
    @new_comment = Comment.new(comment: @comment)

    unless @comment
      redirect_to root_path, alert: 'Comment not found.'
    end
  end

  def create
    @comment = Comment.new(create_params)

    if @comment.save
      redirect_to @comment
    else
      redirect_to root_path
    end
  end

  private

  def index_params
    params.permit(:body,
                  :user_display_name,
                  :user_name)
  end

  def create_params
    params.require(:comment).permit(:body,
                                    :comment_id,
                                    :user_display_name,
                                    :user_name)
  end

  def search_comment_hit_ids(query)
    Comment.search do
      fulltext query[:body] if query[:body].present?
      with(:user_display_name, query[:user_display_name]) if query[:user_display_name].present?
      with(:user_name, query[:user_name]) if query[:user_name].present?
      order_by(:id, :desc)
    end.hits.map(&:primary_key)
  end
end
