require "rails_helper"

RSpec.describe "Teams" do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user:, subdomain: "this") }

  it "can manage access to projects" do
    given_i_am_signed_in
    when_i_visit_my_project_page
    then_i_see_the_project_page

    when_i_click_on_manage_access
    then_i_see_the_manage_access_page

    when_i_click_on_create_a_team
    then_i_see_the_team_creation_page

    when_i_submit_a_name
    then_i_see_the_team_show_page
  end

  private

  def given_i_am_signed_in
    sign_in user
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

  def when_i_click_on_create_a_team
    click_link "Create a team"
  end

  def then_i_see_the_team_creation_page
    expect(page).to have_content "New team"
  end

  def when_i_submit_a_name
    fill_in "team[name]", with: Faker::Company.bs.capitalize
    click_button "Create team"
  end

  def then_i_see_the_team_show_page
    expect(page).to have_content "settings"
  end
end
