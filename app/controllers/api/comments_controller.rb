# frozen_string_literal: true

class Api::CommentsController < ApplicationController
  def index
    @search_params = index_params
    @comments = Comment.fetch_multi(search_comment_hit_ids(@search_params), includes: %i[comment comments])
  end

  def create
    @comment = Comment.new(create_params)
    render status: 400 unless @comment.save
  end

  private

  def index_params
    params.permit(:body,
                  :id,
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
      with(:id, query[:id]) if query[:id].present?
      fulltext query[:body] if query[:body].present?
      with(:user_display_name, query[:user_display_name]) if query[:user_display_name].present?
      with(:user_name, query[:user_name]) if query[:user_name].present?
      order_by(:id, :desc)
    end.hits.map(&:primary_key)
  end
end
