# Recalculates the scores of ALL exisiting statements.
class RecalculateStatementScoresJob < ApplicationJob
  queue_as :default

  # Updates the score of all statements.
  def perform
    Kazus.log :info, "RecalculateStatementScoresJob performs now!"

    # Updates all statements scores.
    StatementTreeScoreUpdater.update_all

    Kazus.log :info, "RecalculateStatementScoresJob performed!"
  end
end
