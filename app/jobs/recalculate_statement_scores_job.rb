class RecalculateStatementScoresJob < ApplicationJob
  queue_as :default

  # Updates the score of all statements.
  def perform
    Kazus.log :info, "RecalculateStatementScoresJob performs now!"

    # Updates all statements scores.
    Statement::Scoring.update_scores

    Kazus.log :info, "RecalculateStatementScoresJob performed!"
  end
end
