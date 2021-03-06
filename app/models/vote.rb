# The Vote class describes a vote pro or contra a statement by a user.
# The attribute :is_pro_vote holds a boolean that is 'true', if the user
# agrees with the statement and 'false', if he doesn't.
class Vote < ApplicationRecord
  belongs_to :user
  # Currently voteables are statements and statement-argument-links.
  belongs_to :voteable, polymorphic: true

  validates_uniqueness_of :user, scope: [:voteable_id, :voteable_type] # Make sure a voteable-user-pair is unique
  validates :is_pro_vote, inclusion: { in: [true, false] } # Make sure it's a boolean
end
