# This class is responsible for calculating and updating the score of statements.
class Statement::Scoring
  class << self
    # Updates the score of all existing statements.
    def update_scores
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

        # Check for loops to prevent superflous calculations.
        break if any_loops?(total_amount_of_statements, history)

        # #update_score_for_set returns all parents of the updated statements.
        statements = update_score_for_set(statements)
      end

      # Log the duration
      duration = Time.now - strt # in seconds
      log_level = duration > 1 ? :warn : :info

      # 540 seconds are 9 minutes. Currently, I plan on running this function every 
      # 10 minutes in the background. So...
      log_level = :fatal if duration > 540

      Kazus.log(log_level, "Updated all scores in #{duration} seconds.")

      true
    end

    # Freshly calculates the current score of a statement.
    # Returns either a decimal number in the closed interval [0, 1]
    # or nil, if not enough information is available.
    def calculate_score statement
      # The score consists of the score from the votes of a statement
      # and the score from its arguments.
      vote_score = vote_score(statement)
      argument_score = argument_score(statement)

      # If both the vote score and the argument score could be
      # calcualted, returns a distribution of the two values.
      # Otherwise it returns the only given value or nil,
      # if both values are nil.
      unless vote_score.nil? || argument_score.nil?
        score = (vote_score + argument_score) / 2.0
      else
        score = vote_score.nil? ? argument_score : vote_score
      end

      # Just in case, make sure the calculated score is within [0, 1]
      if score && score < 0
        Kazus.log(:fatal, "The calculation of the score of a statement just returned a negative number!", statement, score)
        return 0
      elsif score && score > 1
        Kazus.log(:fatal, "The calculation of the score of a statement just returned a number greater than 1!", statement, score)
        return 1
      end

      score
    end


    private

    # Function that calculates the score the statement receives from its
    # voting quota.
    # Returns a real number within [0, 1] or nil, if not enough information
    # is available.
    def vote_score statement
      amount_of_pro_votes = statement.pro_votes.count
      amount_of_contra_votes = statement.contra_votes.count
      total_amount_of_votes = amount_of_pro_votes + amount_of_contra_votes

      # If no it has not been voted yet, return nil.
      return nil if total_amount_of_votes == 0

      amount_of_pro_votes / total_amount_of_votes.to_f
    end

    # Calculates the score a statement receives from its arguments.
    # Returns a real number in the closed interval [0, 1] or nil,
    # if not enough information is available.
    def argument_score statement
      # Return nil if no arguments exist.
      return nil if statement.arguments.size == 0

      # The formula to weight the scores of the arguments written in SQL.
      # Low scored arguments, like arguments with a score between 0 up to 0.5
      # only have a tiny little effect on the total argument-score by design.
      #
      # The formula in a more readable way
      # h(x) := 1/4 * (0.6x)^4 * sqrt(x)
      # g(x) := 1 / h(1)
      # f(x) := h(x) * g(x)
      score_weight_formula = "POWER(score * 0.6, 4) * POWER(score, 0.5) * 7.716049382716049375"
      pro_argument_score = statement.pro_arguments.sum(score_weight_formula)
      contra_argument_score = statement.contra_arguments.sum(score_weight_formula)

      # Calculate the difference
      difference = pro_argument_score - contra_argument_score

      0.5 + to_o_5(difference)
    end

    # Takes a no matter how big number and maps it to the interval
    # ]-0.5, 0.5[.
    def to_o_5 decimal
      positive = true

      if decimal < 0
        positive = false
        decimal *= -1
      end

      result = (1 - Math.exp(-1 * decimal / 0.9)) * 0.5

      result *= -1 unless positive

      result
    end

    # Updates score for each in the given set of statements
    # and returns an array of those statements parent statements.
    def update_score_for_set statements
      parent_statements = []

      statements.each do |statement|
        update_score(statement)
        parent_statements += statement.statements
      end

      parent_statements
    end

    # Recalculates and updates the score of the given statement
    def update_score statement
      new_score = calculate_score(statement)

      unless statement.update(score: new_score)
        Kazus.log(:fatal, "Updating score failed unexpectedly", statement: statement, score: new_score)
      end
    end

    # Searches a history matrix for loops.
    def any_loops? total_amount_of_statements, history
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
end
