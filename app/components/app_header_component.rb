class AppHeaderComponent < GovukComponent::HeaderComponent
  class NavigationItem < GovukComponent::HeaderComponent::NavigationItem
    attr_reader :destroy

    def initialize(
      text:,
      href: nil,
      options: {},
      active: nil,
      destroy: nil,
      classes: [],
      html_attributes: {}
    )
      super(text:, href:, options:, active:, classes:, html_attributes:)

      @destroy = destroy
    end

    private

    def destroy?
      destroy.present? # rubocop:disable Rails/SaveBang
    end

    def call
      tag.li(**html_attributes) do
        if link?
          link_to(text, href, class: "govuk-header__link", **options)
        elsif destroy?
          button_to(
            text,
            destroy,
            **options,
            method: :delete,
            class: "app-button-link"
          )
        else
          text
        end
      end
    end
  end
end
