class VotesController < ApplicationController
  before_action :authenticate_user!
  after_action :demand_statements_score_update, only: [:create, :destroy]

  # POST /statements/:statement_id/vote
  def create
    vote = current_user.votes.build(vote_params)

    # The user, whose existence is verified at this point by a before_action,
    # might already have voted for this statement. Looking that up.
    existing_vote = current_user.votes.find_by(voteable: vote.voteable)

    # If already a vote for this user-voteable-pair exists,
    # update that instead of (trying) creating a new one.
    vote = existing_vote || vote

    vote.assign_attributes(vote_params)

    # Currently, a vote can only be invalid for internal reasons.
    unless vote.save
      Kazus.log :fatal, "A Vote that is supposed to be created couldn't be saved.", vote, vote_params
    end

    redirect_to statement_from(vote.voteable)
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

    redirect_to statement_from(vote.voteable)
  end


  private

  def vote_params
    params.require(:vote).permit(:voteable_id, :voteable_type, :is_pro_vote)
  end

  # Returns voteable if voteable is a Statement or the to the 
  # argument associated statement.
  def statement_from voteable
    voteable.class == Statement ? voteable : voteable.statement
  end
end
