class StatementStatsLoader
  def initialize statement_id
    @statement_id = statement_id
  end

  private

  attr_reader :statement_id

  def execute sql
    ActiveRecord::Base.connection.execute(sql)
  end
end
