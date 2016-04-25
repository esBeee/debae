module VotesHelper
  # This function determines if a user has voted for a voteable and returns nil
  # if he hasn't or the vote if he has. Parameters:
  #
  # has_pro_voted <=> Boolean meaning "has voted voteable up?" if true and "has voted voteable down" otherwise
  # user <=> The user in question
  # voteable <=> The voteable in question
  #
  # For example to find out if a user has voted a voteable down:
  #
  # has_voted?(false, user, voteable)
  #
  # Returns the vote, if one exists, nil else.
  def has_voted? has_pro_voted, user, voteable
    unless user && voteable
      Kazus.log :fatal, "[2kml4btj2] Unexpected condition.", has_pro_voted, user, voteable
      return
    end
    
    user.votes.find_by(is_pro_vote: has_pro_voted, voteable: voteable)
  end
end
