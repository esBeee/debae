# The Questioning class describes an interrogation someone is interested in, like
# "What politician X has done was correct!". Now other users are able to add pro and contra
# arguments. The clou: those arguments are an instance of class Questioning themselves. So also those
# arguments can be argued about.
class Questioning < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { in: 2..260 }
end
