require "rails_helper"

RSpec.describe "Related links" do
  it "can be edited" do
    given_i_am_signed_in
    when_i_visit_my_project
    then_i_see_the_change_details_link

    when_i_click_on_change_details
    and_edit_the_project_related_links
    then_the_project_is_updated

    when_i_click_on_the_edit_post_link
    and_edit_the_post_related_links
    then_the_post_is_updated

    when_i_visit_my_post
    then_i_see_my_related_links

    when_i_visit_my_design_history
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

  def then_i_see_the_change_details_link
    expect(page).to have_link("Change details")
  end

  def when_i_click_on_change_details
    click_link "Change details"
  end

  def and_edit_the_project_related_links
    fill_in "project[related_links]",
            with: "[Related markdown link](https://gov.uk)"
    click_button "Save"
  end

  def when_i_click_on_the_edit_post_link
    click_link @first_post.title
  end

  def and_edit_the_post_related_links
    fill_in "post[related_links]",
            with: "[Related markdown link](https://gov.uk)"
    click_button "Save"
  end

  def then_the_project_is_updated
    expect(page).to have_content("Success")
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

  def when_i_visit_my_design_history
    click_link @project.title, match: :first
  end
end
