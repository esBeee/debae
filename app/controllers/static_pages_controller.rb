class StaticPagesController < ApplicationController
  # GET /
  def onboarding
    @statements = Statement
      .where(top_level: true)
      .select("statements.*, COUNT(statement_argument_links.id) statement_argument_links_count")
      .joins("LEFT OUTER JOIN statement_argument_links ON statement_argument_links.statement_id = statements.id")
      .group("statements.id")
      .order("statement_argument_links_count DESC")
      .limit(9)
  end
end
