class ApplicationController < ActionController::Base
  before_action :set_active_storage_url_options

  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  def after_sign_in_path_for(_)
    projects_path
  end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end
end
