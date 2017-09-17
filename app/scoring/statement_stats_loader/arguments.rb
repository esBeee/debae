class StatementStatsLoader::Arguments < StatementStatsLoader
  def stats
    records_array = execute(arguments_sql)

    argument_stats = records_array.map do |tuple|
      tuple['score'] = tuple['score'].to_f unless tuple['score'].nil?

      ArgumentStats.new(tuple)
    end

    ArgumentStatsCollection.new(argument_stats)
  end

  private

  def arguments_sql
    <<-SQL.squish
      SELECT
        statement_argument_links.id id,
        is_pro_argument,
        statements.score,
        SUM(
          CASE
          WHEN votes.is_pro_vote=TRUE THEN 1
          WHEN votes.is_pro_vote=FALSE THEN -1
          ELSE 0
          END
        ) vote_sum
      FROM statement_argument_links
      LEFT OUTER JOIN votes ON
        votes.voteable_type='StatementArgumentLink' AND
        votes.voteable_id=statement_argument_links.id
      LEFT OUTER JOIN statements ON
        statements.id=statement_argument_links.argument_id
      WHERE statement_argument_links.statement_id=#{statement_id}
      GROUP BY
        statement_argument_links.id,
        statements.id
    SQL
  end
end
