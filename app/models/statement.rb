# The Statement class describes an interrogation someone is interested in, like
# "What politician X has done was wrong!". Now other users are able to add pro and contra
# arguments. The clou: those arguments are an instance of class Statement themselves. So also those
# arguments can be subject of a debate.
class Statement < ApplicationRecord
  belongs_to :user

  # Has many links to arguments (which are also objects of type Statement).
  # Is only used inside this class to help define has_many :arguments.
  has_many :links_to_arguments, class_name: "LinkToArgument"
  # Has many links to PRO arguments.
  # Is only used inside this class to help define has_many :pro_arguments.
  has_many :links_to_pro_arguments, -> { where(is_pro_argument: true) }, class_name: "LinkToArgument"
  # Has many links to CONTRA arguments.
  # Is only used inside this class to help define has_many :contra_arguments.
  has_many :links_to_contra_arguments, -> { where(is_pro_argument: false) }, class_name: "LinkToArgument"
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

  # Validations
  validates :body, presence: true, length: { in: 2..260 }
end
