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

  def is_admin?
    request.domain == Rails.application.config.admin_domain
  end

  def design_history_link(project)
    protocol = Rails.env.production? ? "https" : "http"
    subdomain = project.subdomain
    domain = Rails.application.config.app_domain
    port = Rails.env.production? ? "" : ":#{request.port}"

    "#{protocol}://#{subdomain}.#{domain}#{port}"
  end

  def humanize_image_title(image)
    extension = File.extname(image.filename.to_s)
    filename = image.filename.to_s.chomp extension
    filename.humanize
  end

  def humanize_theme(theme)
    { "dh" => "Default", "nhs" => "UK Healthcare", "gov" => "UK Government" }[
      theme
    ]
  end
end
