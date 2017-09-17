class StatementStatsLoader::Vote < StatementStatsLoader
  def stats
    records_array = execute(votes_sql)

    records_array.each do |tuple|
      tuple['amount_of_pro_votes'] ||= 0
      tuple['total_amount_of_votes'] ||= 0

      return VoteStats.new(tuple)
    end
  end

  private

  def votes_sql
    <<-SQL.squish
      SELECT
        SUM(
          CASE
          WHEN votes.is_pro_vote=TRUE THEN 1
          ELSE 0
          END
        ) amount_of_pro_votes,
        SUM(
          CASE
          WHEN votes.is_pro_vote=TRUE THEN 1
          WHEN votes.is_pro_vote=FALSE THEN 1
          ELSE 0
          END
        ) total_amount_of_votes
      FROM votes
      WHERE
        votes.voteable_type='Statement' AND
        votes.voteable_id=#{statement_id}
    SQL
  end
end
