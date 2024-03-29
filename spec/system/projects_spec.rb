require "rails_helper"

RSpec.describe "Projects" do
  it "can be created, edited, and visited" do
    given_i_am_signed_in
    when_i_am_on_the_projects_page
    then_i_see_a_new_project_button

    when_i_click_the_new_project_button
    then_i_see_the_new_project_form

    when_i_submit_my_project_details
    then_i_see_my_new_project

    when_i_click_on_change_details
    then_i_see_the_change_details_page

    when_i_change_the_subdomain
    then_i_see_my_updated_subdomain

    when_i_click_on_the_project_link
    then_i_see_the_project_index

    when_i_visit_the_edit_page_for_my_project
    and_i_change_the_subdomain_to_a_full_domain
    then_i_see_my_updated_subdomain_with_just_the_subdomain
  end

  private

  def given_i_am_signed_in
    sign_in create(:user)
  end

  def when_i_am_on_the_projects_page
    visit projects_path
  end

  def then_i_see_a_new_project_button
    expect(page).to have_link "Create your first design history"
  end

  def when_i_click_the_new_project_button
    click_link "Create your first design history"
  end

  def then_i_see_the_new_project_form
    expect(page).to have_content "New design history"
  end

  def when_i_submit_my_project_details
    @project_title = Faker::Company.name
    fill_in "project[title]", with: @project_title
    fill_in "project[subdomain]", with: Faker::Internet.slug.gsub("_", "-")
    fill_in "project[description]", with: Faker::Company.bs.capitalize
    click_button "Create design history"
  end

  def then_i_see_my_new_project
    expect(page).to have_content @project_title
  end

  def when_i_click_on_change_details
    click_link "Change details"
  end

  def then_i_see_the_change_details_page
    expect(page).to have_content "Change details"
  end

  def when_i_change_the_subdomain
    fill_in "project[subdomain]", with: "this"
    click_button "Save changes"
  end

  def then_i_see_my_updated_subdomain
    expect(page).to have_link "this.app.local"
  end

  def when_i_click_on_the_project_link
    click_link "this.app.local"
  end

  def then_i_see_the_project_index
    expect(page).to have_content "#{@project_title} design history"
  end

  def when_i_visit_the_edit_page_for_my_project
    visit edit_project_path(Project.last.id)
  end

  def and_i_change_the_subdomain_to_a_full_domain
    fill_in "project[subdomain]",
            with: "https://blueberry-horse.designhistory.app"
    click_button "Save changes"
  end

  def then_i_see_my_updated_subdomain_with_just_the_subdomain
    expect(page).to have_link "blueberry-horse.app.local"
  end
end
