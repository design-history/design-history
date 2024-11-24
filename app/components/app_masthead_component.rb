class AppMastheadComponent < ViewComponent::Base
  def initialize(
    breadcrumbs: nil,
    classes: nil,
    description: nil,
    image: nil,
    phase_banner: nil,
    start_button: nil,
    title: nil
  )
    super
    option = Struct.new(:html, :text, :classes, keyword_init: true)

    @breadcrumbs = breadcrumbs # TODO
    @classes = classes
    @description = description.nil? ? nil : option.new(description)
    @image = image # TODO
    @phase_banner = phase_banner # TODO
    @start_button = start_button # TODO
    @title = title.nil? ? nil : option.new(title)
  end
end
