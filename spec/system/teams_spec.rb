require "rails_helper"

RSpec.describe "Teams" do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:project) { create(:project, user:, subdomain: "this") }

  it "can manage access to projects" do
    given_i_am_signed_in
    when_i_visit_my_project_page
    then_i_see_the_project_page

    when_i_click_on_manage_access
    then_i_see_the_manage_access_page

    when_i_click_on_create_a_team
    then_i_see_the_team_create_page

    when_i_submit_a_name
    then_i_see_the_team_show_page

    when_i_submit_an_invalid_email
    then_i_see_an_error

    when_i_submit_a_valid_email_from_a_user_with_a_team
    then_i_see_an_error

    when_i_submit_a_valid_email
    then_i_see_a_success_message

    when_i_sign_in_as_another_user
    and_i_visit_my_project_page
    then_i_see_the_project_page
  end

  private

  def given_i_am_signed_in
    sign_in user
  end

  def when_i_visit_my_project_page
    visit project_path(project)
  end
  alias_method :and_i_visit_my_project_page, :when_i_visit_my_project_page

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

  def when_i_click_on_create_a_team
    click_link "Create a team"
  end

  def then_i_see_the_team_create_page
    expect(page).to have_content "New team"
  end

  def when_i_submit_a_name
    fill_in "team[name]", with: Faker::Company.bs.capitalize
    click_button "Create team"
  end

  def then_i_see_the_team_show_page
    expect(page).to have_content user.email
  end

  def when_i_submit_an_invalid_email
    fill_in "add_user[email]", with: Faker::Internet.email
    click_button "Add user"
  end

  def then_i_see_an_error
    expect(page).to have_content "problem"
  end

  def when_i_submit_a_valid_email_from_a_user_with_a_team
    fill_in "add_user[email]", with: user.email
    click_button "Add user"
  end

  def when_i_submit_a_valid_email
    fill_in "add_user[email]", with: another_user.email
    click_button "Add user"
  end

  def then_i_see_a_success_message
    expect(page).to have_content "Success"
  end

  def when_i_sign_in_as_another_user
    sign_in another_user
  end
end
