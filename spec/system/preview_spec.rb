require "rails_helper"

RSpec.describe "Preview" do
  it "lets users preview draft posts" do
    given_i_am_signed_in
    when_i_visit_my_post
    then_i_see_the_preview_button

    when_i_edit_the_post
    and_i_click_the_preview_button
    then_i_see_the_preview_with_the_edit
  end

  private

  def given_i_am_signed_in
    @owner = create(:user)
    sign_in @owner
  end

  def when_i_visit_my_post
    @project = create(:project, owner: @owner)
    @post = create(:post, :draft, project: @project)
    visit edit_project_post_path(@project, @post)
  end

  def then_i_see_the_preview_button
    expect(page).to have_button "Save and preview"
  end

  def when_i_edit_the_post
    fill_in "Post", with: "New content"
  end

  def and_i_click_the_preview_button
    click_button "Save and preview"
  end

  def then_i_see_the_preview_with_the_edit
    expect(page).to have_content "New content"
  end
end
