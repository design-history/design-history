require "rails_helper"

RSpec.describe "Password protection" do
  let(:owner) { create(:user) }
  let!(:project) { create(:project, owner:, subdomain: "this") }

  it "allows users to create private design histories" do
    given_i_am_signed_in
    when_i_visit_my_project_page
    then_i_see_the_project_page

    when_i_click_on_manage_access
    then_i_see_the_manage_access_page

    when_i_set_the_project_as_private
    then_i_see_an_error

    when_i_set_the_project_as_private_with_a_password
    then_i_see_the_project_page

    when_i_visit_my_design_history
    then_i_am_asked_for_the_password

    when_i_submit_an_invalid_password
    then_i_see_an_error

    when_i_submit_the_right_password
    then_i_see_my_design_history

    when_i_visit_my_project_page
    and_i_click_on_manage_access
    then_i_see_the_manage_access_page

    when_i_change_the_password
    then_i_see_the_project_page

    when_i_visit_my_design_history
    then_i_am_asked_for_the_password
  end

  private

  def given_i_am_signed_in
    sign_in owner
  end

  def when_i_visit_my_project_page
    visit project_path(project)
  end

  def then_i_see_the_project_page
    expect(page).to have_content project.title
  end

  def when_i_click_on_manage_access
    click_link "Manage access"
  end
  alias_method :and_i_click_on_manage_access, :when_i_click_on_manage_access

  def then_i_see_the_manage_access_page
    expect(page).to have_content "Manage access"
  end

  def when_i_set_the_project_as_private
    choose "private", visible: false
    click_button "Update visibility"
  end

  def then_i_see_an_error
    expect(page).to have_content "problem"
  end

  def when_i_set_the_project_as_private_with_a_password
    choose "private", visible: false
    fill_in "project[password]", with: "rosebud"
    click_button "Update visibility"
  end

  def when_i_visit_my_design_history
    port = page.driver.browser.options.port
    visit "http://this.app.local:#{port}"
  end

  def then_i_am_asked_for_the_password
    expect(page).to have_content "This design history is private"
  end

  def when_i_submit_an_invalid_password
    fill_in "project[password_confirmation]", with: "motherlode"
    click_button "Continue"
  end

  def when_i_submit_the_right_password
    fill_in "project[password_confirmation]", with: "rosebud"
    click_button "Continue"
  end

  def then_i_see_my_design_history
    expect(page).to have_content "#{project.title} design history"
  end

  def when_i_change_the_password
    fill_in "project[password]", with: "motherlode"
    click_button "Update visibility"
  end
end
