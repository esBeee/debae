class Comment < ApplicationRecord
  # Currently statements and comments are commentable.
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { in: 1..9999 }

  # Simply orders the collection by newest first.
  scope :newest, -> { order(created_at: :desc) }


  # Returns this statement's user or a mock, if
  # the user doesn't exist anymore.
  def user_or_mock
    self.user || User.new(name: "Deleted user")
  end
end
