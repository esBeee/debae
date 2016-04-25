class Comment < ApplicationRecord
  # Currently statements and comments are commentable.
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { in: 1..9999 }
end
