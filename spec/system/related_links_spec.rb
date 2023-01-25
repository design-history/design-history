require "rails_helper"

RSpec.describe "Related links" do
  it "can be edited" do
    given_i_am_signed_in
    when_i_visit_my_project
    then_i_see_the_edit_post_link

    when_i_click_on_the_edit_post_link
    and_edit_the_related_links_section
    then_the_post_is_updated

    when_i_visit_my_post
    then_i_see_my_related_links
  end

  private

  def given_i_am_signed_in
    @owner = create(:user)
    @project = create(:project, owner: @owner, subdomain: "this")
    @first_post = create(:post, project: @project, related_links: "")
    sign_in @owner
  end

  def when_i_visit_my_project
    visit project_path(@project)
  end

  def then_i_see_the_edit_post_link
    expect(page).to have_link(@first_post.title)
  end

  def when_i_click_on_the_edit_post_link
    click_link @first_post.title
  end

  def and_edit_the_related_links_section
    @content = "[Related markdown link](https://gov.uk)"
    fill_in "post[related_links]", with: @content
    click_button "Save"
  end

  def then_the_post_is_updated
    expect(page).to have_content("Success")
  end

  def when_i_visit_my_post
    click_link @project.title
    click_link "View published post"
  end

  def then_i_see_my_related_links
    expect(page).to have_link "Related markdown link"
  end
end
