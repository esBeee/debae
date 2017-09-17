class VoteStats
  attr_reader :amount_of_pro_votes, :total_amount_of_votes

  def initialize data
    @amount_of_pro_votes = data['amount_of_pro_votes']
    @total_amount_of_votes = data['total_amount_of_votes']
  end
end
