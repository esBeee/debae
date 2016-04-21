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
      redirect_to @statement
    else
      render :new
    end
  end


  private

  def statement_params
    params.require(:statement).permit(:body)
  end
end
