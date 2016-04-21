class StatementsController < ApplicationController
  def index
    @statements = Statement.top_level.page(params[:page])
  end

  def show
  end
end
