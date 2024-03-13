require "rails_helper"

RSpec.describe "Groups" do
  it "can be created, edited, and visited" do
    given_i_am_signed_in
    when_i_am_on_the_projects_page
    then_i_see_a_new_group_button

    when_i_click_the_new_group_button
    then_i_see_the_new_group_form

    when_i_fill_in_and_submit_the_form
    then_i_see_the_group_page

    when_i_edit_the_group
    then_i_see_the_edit_group_form

    when_i_change_the_title_and_submit_the_form
    then_i_see_the_updated_group_page

    when_i_click_the_add_project_link
    then_i_see_the_add_project_form

    when_i_choose_a_project_and_submit_the_form
    then_i_see_the_project_on_the_group_page
  end

  private

  before do
    @user = create(:user)
    @project1 = create(:project, owner: @user, subdomain: "foo")
    @project2 = create(:project, owner: @user, subdomain: "bar")
  end

  def given_i_am_signed_in
    sign_in @user
  end

  def when_i_am_on_the_projects_page
    visit projects_path
  end

  def then_i_see_a_new_group_button
    expect(page).to have_link "New group"
  end

  def when_i_click_the_new_group_button
    click_link "New group"
  end

  def then_i_see_the_new_group_form
    expect(page).to have_content "New group"
  end

  def when_i_fill_in_and_submit_the_form
    fill_in "Title", with: "Becoming a juggler desing (typo) history"
    fill_in "Group subdomain", with: "this"
    fill_in "Description",
      with: "A history of the designs for the Becoming a juggler team"
    click_button "Create group"
  end

  def then_i_see_the_group_page
    expect(page).to have_content "Becoming a juggler desing (typo) history"
  end

  def when_i_edit_the_group
    click_link "Change details"
  end

  def then_i_see_the_edit_group_form
    expect(page).to have_content "Change details"
  end

  def when_i_change_the_title_and_submit_the_form
    fill_in "Title", with: "Becoming a juggler design history"
    click_button "Save changes"
  end

  def then_i_see_the_updated_group_page
    expect(page).to have_content "Becoming a juggler design history"
  end

  def when_i_click_the_add_project_link
    click_link "Add design history"
  end

  def then_i_see_the_add_project_form
    expect(page).to have_content "Add design history"
  end

  def when_i_choose_a_project_and_submit_the_form
    choose @project1.title, visible: false
    click_button "Save changes"
  end

  def then_i_see_the_project_on_the_group_page
    expect(page).to have_content @project1.title
  end
end
