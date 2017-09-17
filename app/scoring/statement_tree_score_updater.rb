# This class is responsible for calculating and updating the score of statements.
class StatementTreeScoreUpdater
  def self.update_all
    # Take start time to measure the duration
    strt = Time.now

    # Start with updating all statements that have no arguments.
    statements = Statement.ground_level

    # The history will collect the arrays of IDs of the statements
    # that get updated each round. Gets handed to the any_loops?
    # function to make sure we're not caught in an infinite loop.
    history = []

    # Count statements just to hand it to any_loops?
    total_amount_of_statements = Statement.all.size

    while statements.any?
      # Include an array of the IDs of all statements to be updated
      # this round.
      history << statements.pluck(:id)

      # Check for loops to prevent superfluous calculations.
      break if any_loops?(total_amount_of_statements, history)

      # #update_score_for_set returns all parents of the updated statements.
      statements = update_score_for_set(statements)
    end

    # Log the duration
    duration = Time.now - strt # in seconds
    log_level = duration > 0.5 ? :warn : :info

    # 540 seconds are 9 minutes. Currently, I plan on running this function every
    # 10 minutes in the background. So...
    log_level = :fatal if duration > 540

    Kazus.log(log_level, "Updated all scores in #{duration} seconds.")

    true
  end

  private

  # Updates score for each in the given set of statements
  # and returns an array of those statements parent statements.
  def self.update_score_for_set statements
    parent_statements = []

    statements.each do |statement|
      StatementScoreUpdater.new(statement.id).update
      parent_statements += statement.statements
    end

    parent_statements
  end

  # Searches a history matrix for loops.
  def self.any_loops? total_amount_of_statements, history
    # As another security layer preventing from being caught in an infinite loop, we
    # will escape if we did more rounds than statements exist.
    rounds = history.length
    if rounds > total_amount_of_statements
      Kazus.log(:error, "While updating score, we did more rounds than statements exist. Does an infinite loop exist?", total_amount_of_statements, history)
      return true
    end

    return false if rounds < 2

    # If the last entry exists twice in the history, assume
    # that there's a loop.
    #
    # TODO:
    # Proof that an infinite loop exists <=> the last entry exists twice in history
    last_entry = history.last

    # Count all occurences of the last entry.
    occurences = 0
    history.each do |entry|
      if entry.eql?(last_entry)
        occurences += 1
      end
    end

    # If there's more than one occurence, assume there's a loop.
    if occurences > 1
      Kazus.log(:warn, "A loop was detected in the statement tree.", last_entry, occurences, history)
      return true
    end

    false
  end
end
