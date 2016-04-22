class VotesController < ApplicationController
  before_action :authenticate_user!

  # POST /statements/:statement_id/vote
  def create
    # Get the statement from the DB. Throw 404 if it doesn't exist.
    statement = Statement.find_by(id: params[:statement_id]) || not_found

    # The user, whose existence is verified at this point by a before_action,
    # might already have voted for this statement. Looking that up.
    new_vote = current_user.votes.find_by(statement: statement)

    # Build a new vote for the current user if none exists yet.
    new_vote = current_user.votes.build(statement: statement) unless new_vote

    # Currently, a vote can only be invalid for internal reasons.
    unless new_vote.update(vote_params)
      # TODO: proper debugging
    end

    redirect_to statement
  end


  private

  def vote_params
    params.require(:vote).permit(:is_pro_vote)
  end
end
