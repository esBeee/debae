class VotesController < ApplicationController
  before_action :authenticate_user!
  after_action :demand_statements_score_update, only: [:create, :destroy]

  # POST /statements/:statement_id/vote
  def create
    # Get the statement from the DB.
    statement = Statement.find_by(id: params[:statement_id])

    # Return here if the statement could not be found.
    return not_found unless statement

    # The user, whose existence is verified at this point by a before_action,
    # might already have voted for this statement. Looking that up.
    new_vote = current_user.votes.find_by(statement: statement)

    # Build a new vote for the current user if none exists yet.
    new_vote = current_user.votes.build(statement: statement) unless new_vote

    # Currently, a vote can only be invalid for internal reasons.
    unless new_vote.update(vote_params)
      Kazus.log :fatal, "A Vote that is supposed to be created couldn't be saved.", new_vote, vote_params
    end

    redirect_to statement
  end

  # DELETE /votes/:id
  def destroy
    # Get the vote from the DB.
    vote = Vote.find_by(id: params[:id])

    # Return here if the vote could not be found.
    return not_found unless vote

    # Make sure the current user is owner of the vote.
    return unless authenticate_owner!(vote)

    # Destroy the vote.
    vote.destroy

    redirect_to vote.statement
  end


  private

  def vote_params
    params.require(:vote).permit(:is_pro_vote)
  end
end
