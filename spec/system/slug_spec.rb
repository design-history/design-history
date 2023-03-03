require "rails_helper"

RSpec.describe "Slugs" do
  it "get generated and work" do
    given_i_am_signed_in
    when_i_visit_my_project
    when_i_click_on_new_post
    when_i_submit_a_title_without_a_slug
    then_the_slug_has_been_generated
    and_the_url_contains_the_slug
  end

  private

  def given_i_am_signed_in
    @owner = create(:user)
    sign_in @owner
  end

  def when_i_visit_my_project
    @project = create(:project, owner: @owner)
    visit project_path(@project)
  end

  def when_i_click_on_new_post
    click_link "New post"
  end

  def then_i_see_the_new_post_page
    expect(page).to have_content "New post"
  end

  def when_i_submit_a_title_without_a_slug
    fill_in "post[title]", with: Faker::Company.bs.capitalize
    click_button "Save"
  end

  def then_the_slug_has_been_generated
    expect(page).to have_field "post[slug]", with: Post.last.title.parameterize
  end

  def and_the_url_contains_the_slug
    expect(page.current_path).to include @project.posts.last.slug
  end
end
