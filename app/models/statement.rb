# The Statement class describes a statement that is being discuessed, like
# "What politician X has done was wrong!". Now other users are able to add pro and contra
# arguments. The clou: those arguments are an instance of class Statement themselves, so also those
# arguments can be subject of a debate.
# Also users are able to up- or downvote this statement. Which is to say a user
# agrees or disagrees with the statement.
class Statement < ApplicationRecord
  belongs_to :user
  # Has many links to arguments (which are also objects of type Statement).
  # Is only used inside this class to help define has_many :arguments.
  has_many :links_to_arguments, class_name: "StatementArgumentLink"
  # Has many links to statements.
  # Is only used inside this class to help define the scope :top_level, and the has_many
  # relation :statements.
  has_many :links_to_statements, class_name: "StatementArgumentLink", foreign_key: "argument_id"
  # Has many links to PRO arguments.
  # Is only used inside this class to help define has_many :pro_arguments.
  has_many :links_to_pro_arguments, -> { where(is_pro_argument: true) }, class_name: "StatementArgumentLink"
  # Has many links to CONTRA arguments.
  # Is only used inside this class to help define has_many :contra_arguments.
  has_many :links_to_contra_arguments, -> { where(is_pro_argument: false) }, class_name: "StatementArgumentLink"
  # Has many arguments (also objects of type Statement).
  has_many :arguments, through: :links_to_arguments
  # Has many pro arguments.
  has_many :pro_arguments, through: :links_to_pro_arguments, source: :argument
  # Has many contra arguments.
  has_many :contra_arguments, through: :links_to_contra_arguments, source: :argument
  # Has many pro votes.
  has_many :pro_votes, -> { where(is_pro_vote: true) }, class_name: "Vote"
  # Has many contra votes.
  has_many :contra_votes, -> { where(is_pro_vote: false) }, class_name: "Vote"
  # Has many statements. In this context, statements are all statements this statement is an argument for.
  has_many :statements, through: :links_to_statements

  # The method/scope #top_level should return a collection of statements ordered by
  # importance, which is currently only determined by the creation date - the
  # newer the more important a statement is.
  # This method should change its behaviour as soon as the user is allowed to create new
  # statements while initialize them with already existing statements. Until then
  # it grants a better overview to just display statements that aren't argument for another statement.
  #
  # In the future, a 'popularity score' value should be determined using creation date AND
  # total number of votes. Then simply order descending by this score.
  scope :top_level, -> {
    includes(:links_to_statements).where(statement_argument_links: {argument_id: nil}).order(created_at: :desc)
  }

  # Returns all statements that have no arguments.
  scope :ground_level, -> {
    includes(:links_to_arguments).where(statement_argument_links: {statement_id: nil})
  }

  validates :body, presence: true, length: { in: 2..260 }
  # Validate score the be within [0..1]. Also allow nil to indicate insufficient information.
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
end
