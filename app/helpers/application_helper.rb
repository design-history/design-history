module ApplicationHelper
  def h1(text = nil, **options, &block)
    title_text = options[:page_title] || text
    options.delete(:page_title)

    content_for(:page_title, title_text) unless content_for?(:page_title)

    if block_given?
      if title_text.blank?
        raise ArgumentError, "Must provide title option when using block"
      end
      content_tag(:h1, options, &block)
    else
      content_tag(:h1, text, **options)
    end
  end

  def page_title(service_name)
    title = content_for(:page_title)

    if title.blank?
      raise "No page title set. Either use the <%= h1 %> helper in your page, \
or set it with content_for(:page_title)."
    end

    title = "Error: #{title}" if response.status == 422

    [title, service_name].join(" - ")
  end

  def govuk_row(&block)
    tag.div(class: "govuk-grid-row", &block)
  end

  def govuk_one_third(&block)
    tag.div(class: "govuk-grid-column-one-third-from-desktop", &block)
  end

  def govuk_two_thirds(&block)
    tag.div(class: "govuk-grid-column-two-thirds-from-desktop", &block)
  end

  def govuk_one_half(&block)
    tag.div(class: "govuk-grid-column-one-half-from-desktop", &block)
  end

  def is_admin?
    request.domain == Rails.application.config.admin_domain
  end

  def design_history_link(project)
    protocol = Rails.env.production? ? "https" : "http"
    link = humanize_design_history_link(project)
    port = Rails.env.production? ? "" : ":#{request.port}"
    "#{protocol}://#{link}#{port}"
  end

  def humanize_design_history_link(project)
    subdomain = project.subdomain
    domain = Rails.application.config.app_domain
    "#{subdomain}.#{domain}"
  end

  def image_title(image)
    image.custom_metadata["title"] || humanize_image_title(image)
  end

  def image_alt_text(image)
    image.custom_metadata["alt_text"] || ""
  end

  def image_alt_text_fallback(image)
    image.custom_metadata["alt_text"].presence || image_title(image)
  end

  def image_caption(image)
    image.custom_metadata["caption"]
  end

  def image_show_at_bottom(image)
    image.custom_metadata["show_at_bottom"]
  end

  def humanize_image_title(image)
    extension = File.extname(image.filename.to_s)
    filename = image.filename.to_s.chomp extension
    filename = filename.sub(/\A\d{2}-/, "").gsub("-", "_")
    filename.humanize
  end

  def humanize_theme(theme)
    { "dh" => "Default", "nhs" => "UK Healthcare", "gov" => "UK Government" }[
      theme
    ]
  end
end
