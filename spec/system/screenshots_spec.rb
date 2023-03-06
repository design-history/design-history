require "rails_helper"

RSpec.describe "Screenshots" do
  it "can have titles and can be attached, deleted, reordered" do
    given_i_am_signed_in
    when_i_visit_my_post
    then_i_see_the_screenshots_link

    when_i_click_the_screenshots_link
    then_i_see_the_screenshots_section

    when_i_upload_an_image
    then_i_see_the_image

    when_i_upload_another_image
    then_i_see_both_images

    when_i_edit_the_first_image_title
    then_the_title_is_updated

    when_i_move_the_first_image_down
    and_i_delete_the_second_image
    then_i_see_the_first_image
  end

  private

  def given_i_am_signed_in
    @owner = create(:user)
    sign_in @owner
  end

  def when_i_visit_my_post
    @project = create(:project, owner: @owner)
    @post = create(:post, project: @project)
    visit edit_project_post_path(@project, @post)
  end

  def then_i_see_the_screenshots_link
    expect(page).to have_link "Screenshots"
  end

  def when_i_click_the_screenshots_link
    click_link "Screenshots"
  end

  def then_i_see_the_screenshots_section
    expect(page).to have_css "h2", text: "Screenshots"
  end

  def when_i_upload_an_image
    attach_file "post[images][]",
                Rails.root.join("spec/fixtures/files/screenshot.png")
    click_button "Save images"
  end

  def then_i_see_the_image
    expect(page).to have_css "img[src*='screenshot.png']"
  end

  def when_i_upload_another_image
    attach_file "post[images][]",
                Rails.root.join("spec/fixtures/files/screenshot2.png")
    click_button "Save images"
  end

  def then_i_see_both_images
    expect(page).to have_css "img[src*='screenshot.png']"
    expect(page).to have_css "img[src*='screenshot2.png']"
  end

  def when_i_move_the_first_image_down
    first("button", text: "Move down image").click
  end

  def and_i_delete_the_second_image
    first("button", text: "Delete image").click
  end

  def then_i_see_the_first_image
    expect(page).to have_css "img[src*='screenshot.png']"
    expect(page).to have_no_css "img[src*='screenshot2.png']"
  end

  def when_i_edit_the_first_image_title
    first("input[name*='title']").set "New title"
    first("button", text: "Save").click
  end

  def then_the_title_is_updated
    expect(@post.images.first.custom_metadata).to eq "title" => "New title"
  end
end
