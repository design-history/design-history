require "rails_helper"

RSpec.describe "Groups" do
  it "can be created, edited, and visited" do
    given_i_am_signed_in
    when_i_am_on_the_projects_page
    then_i_see_a_new_group_button

    when_i_click_the_new_group_button
    then_i_see_the_new_group_form
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
end
