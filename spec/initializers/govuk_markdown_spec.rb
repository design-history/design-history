require 'rails_helper'

describe 'GovukMarkdownExtension' do
  it 'renders smart quotes' do
    markdown = "I'm a smart quote"
    rendered_text = GovukMarkdown.render(markdown)
    expect(rendered_text).to include('&rsquo;')
  end

  it 'renders fenced code blocks' do
    markdown = "```\ncode block\n```"
    rendered_text = GovukMarkdown.render(markdown)
    expect(rendered_text).to include('<pre>')
  end

  it 'renders highlights' do
    markdown = "This is ==highlighted=="
    rendered_text = GovukMarkdown.render(markdown)
    expect(rendered_text).to include('<mark>')
  end

  describe 'emails' do
    it 'render correctly' do
      markdown = <<~MD
        {email}
        Subject: This is a subject
        To: foo@example.com
        ---
        # This is the body

        With some markdown, and a ((placeholder))
        {/email}
      MD
      rendered_text = GovukMarkdown.render(markdown)
      expect(rendered_text).to include('<div class="app-email">')
      expect(rendered_text).to include('<dl class="app-email-headers">')
      expect(rendered_text).to include('<h1')
      expect(rendered_text).to include('<mark>placeholder</mark>')
    end

    it 'render correctly when header is missing' do
      markdown = <<~MD
        {email}
        # This is the body

        With some markdown, and a ((placeholder))
        {/email}
      MD
      rendered_text = GovukMarkdown.render(markdown)
      expect(rendered_text).to include('<div class="app-email">')
      expect(rendered_text).not_to include('<dl class="app-email-headers">')
      expect(rendered_text).to include('<h1')
      expect(rendered_text).to include('<mark>placeholder</mark>')
    end
  end

  it "doesn't render emails when they're in a code block" do
    markdown = <<~MD
      ```
      {email}
      Subject: This is a subject
      ---
      # This is the body
      {/email}
      ```
    MD
    rendered_text = GovukMarkdown.render(markdown)
    expect(rendered_text).to include('<pre>')
    expect(rendered_text).not_to include('<div class="app-email">')
  end
end
