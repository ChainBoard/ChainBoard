# frozen_string_literal: true

class Comment < ApplicationRecord
  include IdentityCache

  before_create :crypt_user_name

  belongs_to :comment, optional: true
  cache_belongs_to :comment

  has_many :comments
  cache_has_many :comments

  validates :body, length: { maximum: 280 }, presence: true
  validates :user_display_name, length: { maximum: 50 }
  validates :user_name, length: { maximum: 16 }

  searchable do
    integer :id
    text :body
    string :user_display_name
    string :user_name
  end

  private

  def crypt_user_name
    self.user_name = if user_name.present?
                       user_name.crypt(user_name + 'salt').slice(2, 10)
                     else
                       'Anonymous'
                     end
  end
end
