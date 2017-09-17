require_dependency 'statement_stats_loader/vote'

class StatementScoreUpdater
  def initialize statement_id
    @statement_id = statement_id
  end

  def update
    update_scores_of_arguments

    Statement.update(
      statement_id,
      score: statement_scoring.score,
      argument_score: statement_scoring.argument_score,
      vote_score: statement_scoring.vote_score,
      amount_of_votes: vote_stats.total_amount_of_votes
    )
  end

  def update_scores_of_arguments
    argument_stats_collection.each do |argument_stats|
      score = statement_scoring.score_for_argument(argument_stats)

      StatementArgumentLink.update(
        argument_stats.id,
        score: score
      )
    end
  end

  private

  attr_reader :statement_id

  def statement_scoring
    @statement_scoring ||= begin
      StatementScoring.new(
        vote_stats: vote_stats,
        argument_stats_collection: argument_stats_collection
      )
    end
  end

  def vote_stats
    @vote_stats ||= StatementStatsLoader::Vote.new(statement_id).stats
  end

  def argument_stats_collection
    @argument_stats_collection ||= StatementStatsLoader::Arguments.new(statement_id).stats
  end
end
