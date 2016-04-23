# This class is a linking table that links a statement (which
# is an instance of the class Statement) with arguments for that 
# statement (which are also instances of the class Statement).
#
# Additionally it contains the information whether the argument is
# a pro argument for that statement or a contra argument. (The
# attribute of type boolean, that holds that information, is :is_pro_argument)
class StatementArgumentLink < ApplicationRecord
  belongs_to :statement
  belongs_to :argument, class_name: "Statement" # In this app, arguments are statements themselves

  validates_uniqueness_of :statement, scope: :argument # Make sure a statement-argument-pair is unique
  validates :is_pro_argument, inclusion: { in: [true, false] } # Make sure it's a boolean
  validate :statement_differs_from_argument # Ensure the statement doesn't equal the argument


  private

  # Adds an error if the statement equals the argument.
  def statement_differs_from_argument
    # If statement is not nil and equals the argument, add an error.
    if statement && statement == argument
      errors.add(:statement, I18n.t("activerecord.errors.messages.statement_eq_argument", default: "can't be its own argument"))
    end
  end
end
