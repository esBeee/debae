module StatementsHelper
  # This function returns an array to be passed to the create-statement-action
  # via hidden input fields, to inform the action that this statement is to
  # be interpreted as a pro or contra argument for another statement.
  # How to use:
  #
  # If only pro is set, it is assumed that pro holds the ID of the
  # statement to be supported as a pro argument.
  #
  # If only contra is set, it is assumed that contra holds the ID of the
  # statement to be supported as a contra argument.
  #
  # If neither pro nor contra was set, it is assumed that this is not
  # an argument for another statement. The function returns nil then.
  def argument_hash pro, contra
    # If this method is called after the creation previously failed,
    # the requested format is already in the params as "argument".
    # Return this if this is the case.
    return [params[:argument][:argument_for], params[:argument][:is_pro_argument]] if params[:argument]

    # Do nothing if neither pro nor contra is set. We can assume that the
    # statement is a top-level-statement in this case.
    return nil unless pro || contra

    # Do nothing if both params are set (can't be a pro and a contra
    # argument).
    return nil if pro && contra

    # At this point, we know that exactly one param is set.
    is_pro_argument = pro ? true : false

    # It is assumed, that the not-nil-parameter holds the id of
    # the statement to be supported.
    statement_to_be_supported = pro || contra

    return [statement_to_be_supported, is_pro_argument]
  end

  # Returns a rounded decimal in a formatted percent string
  def percent decimal
    return t("statements.score.not_available", default: "N/A") if decimal.nil?

    rounded = (decimal * 100).round
    return "#{rounded} " + t("statements.score.unit", default: "%")
  end

  def score decimal
    return t("statements.score.not_available", default: "N/A") if decimal.nil?

    rounded = (decimal * 10).round(1)
    return rounded.to_s
  end

  def argument_score decimal
    return t("statements.score.not_available", default: "N/A") if decimal.nil?

    rounded = (decimal * 20 - 10).round(1)
    return rounded.to_s
  end

  # Decides how big a headline will be depending on the length
  # of the given string. Returns the <hi>-tag as symbol (e.g. :h1)
  def headline_tag string
    str_length = string.length

    if str_length < 50
      :h1
    else
      :h2
    end
  end

  # Returns a string representing whether the creator of the given statement
  # agrees, disagrees or hasn't decided yet.
  def creator_attitude statement
    if statement.nil?
      Kazus.log :error, "#creator_attitude called without statement"
      return ""
    end

    creator = statement.user
    return "creator_destroyed" if creator.nil?

    if (vote=statement.votes.find_by(user: creator))
      vote.is_pro_vote ? "agreeing" : "disagreeing"
    else
      "undecided"
    end
  end

  def creator_attitude_icon statement
    creator = statement.user
    return "" if creator.nil?

    if (vote=statement.votes.find_by(user: creator))
      vote.is_pro_vote ? fa_icon("check-circle", class: "agree") : fa_icon("times-circle", class: "disagree")
    else
      fa_icon("minus-circle", class: "neutral")
    end
  end

  # Returns the thesis of a statement or the counter-thesis, if second
  # argument is true, in the current locale.
  def body statement, counter_thesis = false
    th = counter_thesis ? "counter_thesis" : "thesis"

    # This should never happen. Inform if it does anyway.
    if statement.nil? || (bodies=statement.body[th]).nil?
      Kazus.log :fatal, "Something went horribly wrong in #body", statement, I18n.locale, th
      return "N/A"
    end

    # Try to get the body in the current locale.
    bod = bodies[I18n.locale.to_s]

    # If it doesn't exist in the current locale, take the original locale.
    if bod.blank?
      bod = bodies[statement.body["original_locale"]]
    end

    # Warn if body is still blank because that should never happen.
    if bod.blank?
      Kazus.log :error, "Only a blank string could be found for the statement's body", statement, I18n.locale, th
      return bodies.values[0] || "N/A"
    end

    bod
  end
end
