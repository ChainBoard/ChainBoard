# frozen_string_literal: true

class Comment < ApplicationRecord
  include IdentityCache

  before_create :crypt_user_name
  before_create :set_default_user_display_name

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
                       salt = user_name.split('').select {|c| /[A-Za-z0-9.\/]/ =~ c}.join('') + 'salt'
                       user_name.crypt(salt).slice(2, 10)
                     else
                       'Anonymous'
                     end
  end

  def set_default_user_display_name
    self.user_display_name = 'Anonymous' if user_display_name.blank?
  end
end
