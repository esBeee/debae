class ArgumentStats
  attr_reader :id, :is_pro_argument, :score, :vote_sum

  def initialize data
    @id = data['id']
    @is_pro_argument = data['is_pro_argument']
    @score = data['score']
    @vote_sum = data['vote_sum']
  end
end
