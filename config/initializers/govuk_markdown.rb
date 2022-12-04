GovukMarkdown::Renderer.include Redcarpet::Render::SmartyPants

class MarkdownTemplate
  def self.call(template, source)
    erb_handler = ActionView::Template.registered_template_handler(:erb)
    compiled_source = erb_handler.call(template, source)
    "GovukMarkdown.render(begin;#{compiled_source};end).html_safe"
  end
end

ActionView::Template.register_template_handler :md, MarkdownTemplate
