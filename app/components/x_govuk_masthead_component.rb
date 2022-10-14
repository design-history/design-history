class XGovukMastheadComponent < ViewComponent::Base
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
    @breadcrumbs = breadcrumbs # TODO
    @classes = classes
    @description = OpenStruct.new(description)
    @image = image # TODO
    @phase_banner = phase_banner # TODO
    @start_button = start_button # TODO
    @title = OpenStruct.new(title)
  end
end
