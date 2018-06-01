class Comment < ApplicationRecord
  belongs_to :comment, optional: true
end
