module ApplicationHelper
  def govuk_row(&block)
    tag.div(class: "govuk-grid-row", &block)
  end

  def govuk_one_third(&block)
    tag.div(class: "govuk-grid-column-one-third-from-desktop", &block)
  end

  def govuk_two_thirds(&block)
    tag.div(class: "govuk-grid-column-two-thirds-from-desktop", &block)
  end
end
