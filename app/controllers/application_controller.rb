class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  def after_sign_in_path_for(_)
    projects_path
  end
end
