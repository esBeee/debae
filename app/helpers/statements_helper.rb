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
  def score decimal
    return t("statements.score.not_available", default: "N/A") if decimal.nil?

    rounded = (decimal * 100).round
    return "#{rounded} " + t("statements.score.unit", default: "%")
  end

  # Decides how big a headline will be depending on the length
  # of the given string. Returns the <hi>-tag as symbol (e.g. :h1)
  def headline_tag string
    str_length = string.length

    if str_length < 40
      :h1
    else
      :h2
    end 
  end
end
