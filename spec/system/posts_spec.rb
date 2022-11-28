require "rails_helper"

RSpec.describe "Posts" do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user:, owner: user) }

  it "can be created" do
    given_i_am_signed_in
    when_i_visit_my_project
    then_i_see_the_new_post_button

    when_i_click_on_new_post
    then_i_see_the_new_post_page

    when_i_submit_my_post_details
    then_i_see_the_edit_post_page
  end

  private

  def given_i_am_signed_in
    sign_in user
  end

  def when_i_visit_my_project
    visit project_path(project)
  end

  def then_i_see_the_new_post_button
    expect(page).to have_link "New post"
  end

  def when_i_click_on_new_post
    click_link "New post"
  end

  def then_i_see_the_new_post_page
    expect(page).to have_content "New post"
  end

  def when_i_submit_my_post_details
    fill_in "post[title]", with: Faker::Company.bs.capitalize
    fill_in "post[slug]", with: Faker::Internet.slug.gsub("_", "-")
    fill_in "post[body]", with: Faker::Markdown.sandwich
    click_button "Save"
  end

  def then_i_see_the_edit_post_page
    expect(page).to have_content "Editing post"
  end
end
