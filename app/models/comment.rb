# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :comment, optional: true

  validates :body, length: { maximum: 280 }, presence: true
  validates :user_display_name, length: { maximum: 50 }
  validates :user_name, length: { maximum: 16 }

  searchable do
    integer :id
    text :body
    string :user_display_name
    string :user_name
  end
end
