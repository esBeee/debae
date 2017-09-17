class Formulary
  # Let s_max the maximum of all vote sums of a statement's arguments, and s the
  # vote sum of a single argument of that statement. Then the importance of that
  # argument is defined as
  #
  #                    | if s <= -1: 0
  #   ip(s_max, s) := <
  #                    | else:       (s + 1) / (s_max + 1)
  def self.argument_importance s_max, s
    return 0 if s <= -1
    (s + 1) / (s_max + 1).to_f
  end

  # Let s the score of an argument's underlying statement. The integrity if the
  # argument is then defined as
  #
  #   ig(s) := s
  #
  # Proposal: a function that doesn't care too much about differences around 0.5
  # and amplifies scores greater than 0.7.
  def self.argument_integrity s
    s
  end

  # Let ip the importance and ig the integrity of an argument. The score of the
  # argument is then defined as
  #
  #   s_a(ip, ig) := ip * ig
  def self.argument_score ip, ig
    return nil if ig.nil?
    ip * ig
  end

  # Let p the sum of the scores of all pro-arguments and c the sum of the scores
  # of all contra-arguments. The argument score s_sa of a statement is then
  # defined as
  #
  #   s_sa(p, c) := 0.5 (1 + (p - c) / max { p + c, 1 })
  def self.statement_argument_score p, c
    0.5 * (1 + (p - c)/[p + c, 1].max.to_f)
  end

  # Let v € N^+ the amount of votes a statement received, and p the amount of
  # up-votes. The vote score s_sv of a statement is then defined as
  #
  #   s_sv(v, p) := p / v
  def self.statement_vote_score v, p
    return nil if v == 0
    p / v.to_f
  end

  # Let v_s the vote score and a_s the argument score of a statement. Then the
  # score s of that statement is defined as
  #
  #   s(v_s, a_s) := (v_s + a_s) / 2
  def self.statement_score v_s, a_s
    return nil if v_s.nil? && a_s.nil?
    return v_s if v_s && a_s.nil?
    return a_s if a_s && v_s.nil?

    (v_s + a_s) / 2.0
  end
end
