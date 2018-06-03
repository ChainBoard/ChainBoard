class Comment < ApplicationRecord
  belongs_to :comment, optional: true

  validates :body, length: { maximum: 280 }, presence: true
  validates :user_display_name, length: { maximum: 50 }, presence: true
  validates :user_name, length: { maximum: 16 }, presence: true
end
