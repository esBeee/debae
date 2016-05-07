module ApplicationHelper
  # Returns a formatted page title containing the given page description
  # or a general description, if none is given.
  def page_title description
    description = t("layouts.title") if description.blank?
    "#{description} | debae"
  end
end
