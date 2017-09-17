class StatementScoring
  def initialize vote_stats:, argument_stats_collection:
    @vote_stats = vote_stats
    @argument_stats_collection = argument_stats_collection
    @max_vote_sum = argument_stats_collection.max_vote_sum

    @score_for_argument = {}
    @statement_argument_score_calculated = {}
  end

  def score
    return @score if @score_calculated
    @score_calculated = true

    @score = Formulary.statement_score(vote_score, argument_score)
  end

  def vote_score
    return @vote_score if @vote_score_calculated
    @vote_score_calculated = true

    @vote_score = Formulary.statement_vote_score(
      vote_stats.total_amount_of_votes,
      vote_stats.amount_of_pro_votes
    )
  end

  def argument_score
    return @argument_score if @argument_score_calculated
    @argument_score_calculated = true

    return @argument_score = nil if argument_stats_collection.empty?

    @argument_score = Formulary.statement_argument_score(
      argument_score_sum(argument_stats_collection.pro_arguments),
      argument_score_sum(argument_stats_collection.contra_arguments)
    )
  end

  def score_for_argument argument_stats
    if @statement_argument_score_calculated[argument_stats.id]
      return @score_for_argument[argument_stats.id]
    else
      @statement_argument_score_calculated[argument_stats.id] = true
    end

    importance = Formulary.argument_importance(max_vote_sum, argument_stats.vote_sum)
    integrity = Formulary.argument_integrity(argument_stats.score)
    score = Formulary.argument_score(importance, integrity)

    @score_for_argument[argument_stats.id] = score
  end

  private

  attr_reader :vote_stats, :argument_stats_collection, :max_vote_sum

  def argument_score_sum argument_stats_collection
    argument_stats_collection.sum do |argument_stats|
      score_for_argument(argument_stats) || 0
    end
  end
end
