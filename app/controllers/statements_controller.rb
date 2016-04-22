class StatementsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  # GET /statements or GET /
  def index
    @statements = Statement.top_level.page(params[:page])
  end

  # GET /statements/:id
  def show
    # Query the requested statement and provide it in the view
    # or render 404 if not found.
    @statement = Statement.find_by(id: params[:id]) || not_found
  end

  # GET /statements/new
  def new
    @statement = Statement.new
  end

  # POST /statements
  def create
    # Build a new statement for the current user.
    # The before action #authenticate_user! ensures its existence.
    @statement = current_user.statements.build(statement_params)

    if @statement.save
      # Create a LinkToArgument if params hold the respective
      # information.
      backed_statement_id = create_link_to_argument(@statement.id)

      if backed_statement_id
        redirect_to statement_path(backed_statement_id)
      else
        redirect_to @statement
      end
    else
      render :new
    end
  end


  private

  def statement_params
    params.require(:statement).permit(:body)
  end

  # If the argument parameter is present and holds the information that
  # this statement is supposed to be interpreted as a pro- or contra-argument
  # for antoher statement, this method creates the respective LinkToArgument
  # object. It is assumed to be called after the statement was saved successfully.
  # Returns the id found in argument_for on success, it can be redirected to this
  # statement.
  #
  # An example for the expected params for this to succeed:
  #
  # {
  #   argument: {
  #     argument_for: "532",               # the ID of the statement to be backed
  #     is_pro_argument: "true"   # A boolean that states whether this is a pro or a contra argument.
  #   }
  # }
  def create_link_to_argument statement_id
    argument_params = params[:argument]

    # Return if argument parameter is not present.
    return nil unless params[:argument] && params[:argument].class == ActionController::Parameters

    # These parameters can potentially contain unsafe strings and are handed to the db, so let's
    # make sure they are nothing more than integers or booleans, respectively.
    argument_for = argument_params[:argument_for].to_i
    is_pro_argument = ["true", :true].include?(argument_params[:is_pro_argument])

    # Validate information, do nothing if invalid.
    if Statement.find_by(id: argument_for) && !statement_id.nil?
      unless LinkToArgument.create(statement_id: argument_for, argument_id: statement_id, is_pro_argument: is_pro_argument)
        # TODO error handling
      end
      argument_for
    else
      nil
    end
  end
end
