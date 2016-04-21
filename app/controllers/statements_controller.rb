class StatementsController < ApplicationController
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
end
