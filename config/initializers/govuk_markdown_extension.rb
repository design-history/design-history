module GovukMarkdownExtension
  def render(markdown, govuk_options = {})
    renderer = GovukMarkdown::Renderer.new(govuk_options, {
      with_toc_data: true,
      link_attributes: { class: "govuk-link" }
    })

    Redcarpet::Markdown
      .new(renderer, {
        tables: true,
        highlight: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true
      })
        .render(markdown.to_s).strip
  end
end

module PreprocessorExtension
  def inject_email
    sections = @output.split("```")
    sections.each_with_index do |section, index|
      next if index.odd?

      section.gsub!(build_regexp("email")) do
        content = Regexp.last_match(1)
        headers, body = construct_email_from(content)
        <<~HTML
          <div class="app-email">
            <dl class="app-email-headers">
              #{headers.map { |k, v| email_header_row(k, v) }.join("")}
            </dl>
            #{nested_markdown(body)}
          </div>
        HTML
      end
    end

    @output = sections.join("```")
    self
  end

  private

  def construct_email_from(match_string)
    headers = {}

    header, body = match_string.split(/^-{3,}\n?/, 2)

    header_regex = /^(.*?):\s*(.*?)\s*$/
    header.each_line do |line|
      matches = header_regex.match(line)
      headers[matches[1]] = matches[2] if matches
    end

    body.gsub!(/(\(\()(.*?)(\)\))/, '\1==\2==\3')

    [headers, body]
  end

  def email_header_row(key, value)
    <<~HTML
      <div class="app-email-headers__row">
        <dt class="app-email-headers__key">#{key}</dt>
        <dd class="app-email-headers__value">#{value}</dd>
      </div>
    HTML
  end
end

module RendererExtension
  def preprocess(document)
    GovukMarkdown::Preprocessor
      .new(document)
      .inject_email
      .output
  end
end

GovukMarkdown.singleton_class.prepend(GovukMarkdownExtension)
GovukMarkdown::Preprocessor.prepend(PreprocessorExtension)
GovukMarkdown::Renderer.prepend(RendererExtension)
