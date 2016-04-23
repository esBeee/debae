module VotesHelper
  # This function determines if a user has voted for a statement and returns nil
  # if he hasn't or the vote if he has. Parameters:
  #
  # has_pro_voted <=> Boolean meaning "has voted statement up?" if true and "has voted statement down" otherwise
  # user <=> The user in question
  # statement <=> The statement in question
  #
  # For example to find out if a user has voted a statement down:
  #
  # has_voted?(false, user, statement)
  #
  # Returns the vote, if one exists, nil else.
  def has_voted? has_pro_voted, user, statement
    unless user && statement
      Kazus.log :fatal, "[2kml4btj2] Unexpected condition.", has_pro_voted, user, statement
      return
    end
    
    user.votes.find_by(is_pro_vote: has_pro_voted, statement: statement)
  end
end
