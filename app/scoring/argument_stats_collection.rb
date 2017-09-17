class ArgumentStatsCollection
  def initialize arguments_stats
    @arguments_stats = arguments_stats
  end

  def max_vote_sum
    max_sum = nil

    arguments_stats.each do |argument_stats|
      sum = argument_stats.vote_sum

      next if sum.nil?

      if max_sum.nil? || sum > max_sum
        max_sum = sum
      end
    end

    max_sum
  end

  def pro_arguments
    self.class.new(
      arguments_stats.select { |argument| argument.is_pro_argument }
    )
  end

  def contra_arguments
    self.class.new(
      arguments_stats.select { |argument| !argument.is_pro_argument }
    )
  end

  def each
    arguments_stats.each { |argument_stats| yield(argument_stats) }
  end

  def sum
    arguments_stats.sum { |argument_stats| yield(argument_stats) }
  end

  def empty?
    arguments_stats.empty?
  end

  private

  attr_reader :arguments_stats
end
