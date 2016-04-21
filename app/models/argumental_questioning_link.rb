# This class is a linking table that links an interrogation (which
# is an instance of the class Questioning) with arguments for that 
# interrogation (which are also instances of the class Questioning).
#
# Additionally it contains the information whether the agrument is
# a pro argument for that interrogation or a contra argument. (The
# attribute of type boolean, that holds that information, is :is_pro_argument)
class ArgumentalQuestioningLink < ApplicationRecord
  belongs_to :questioning
  belongs_to :argument, class_name: "Questioning" # In this app, arguments are questionings themselves

  validates :is_pro_argument, inclusion: { in: [true, false] } # Make sure it's a boolean
end
