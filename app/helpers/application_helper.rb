module ApplicationHelper
  # Returns a formatted page title containing the given page description
  # or a general description, if none is given.
  def page_title description
    base_title = "debae"
    description = t("layouts.title") if description.blank?
    "#{description} | #{base_title}"
  end

  # Returns the given description or the default description, if
  # the given description is blank.
  def page_description description
    return t("layouts.description") if description.blank?
    description
  end
end
