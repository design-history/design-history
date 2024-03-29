require "rails_helper"

RSpec.describe "Images" do
  it "can have titles and alt_text and can be attached, deleted, reordered" do
    given_i_am_signed_in
    when_i_visit_my_post
    then_i_see_the_images_link

    when_i_click_the_images_link
    then_i_see_the_images_section

    when_i_upload_an_image
    then_i_see_the_image

    when_i_upload_another_image
    then_i_see_both_images

    when_i_edit_the_first_image_title
    then_the_title_is_updated

    when_i_move_the_first_image_down
    and_i_delete_the_second_image
    then_i_see_the_first_image

    when_i_edit_the_first_image_alt_text
    then_the_alt_text_is_updated

    when_i_edit_the_first_image_caption
    then_the_caption_is_updated

    when_i_remove_the_first_image_from_the_list_at_the_end_of_the_post
    then_the_image_metadata_is_updated
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

  def then_i_see_the_images_link
    expect(page).to have_link "Images"
  end

  def when_i_click_the_images_link
    click_link "Images"
  end

  def then_i_see_the_images_section
    expect(page).to have_content "Add images"
  end

  def when_i_upload_an_image
    attach_file "post[append_images][]",
                Rails.root.join("spec/fixtures/files/screenshot.png")
    click_button "Add images"
  end

  def then_i_see_the_image
    expect(page).to have_css "img[src*='screenshot.png']"
  end

  def when_i_upload_another_image
    attach_file "post[append_images][]",
                Rails.root.join("spec/fixtures/files/screenshot2.png")
    click_button "Add images"
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
    expect(@post.images.first.custom_metadata["title"]).to eq "New title"
  end

  def when_i_edit_the_first_image_alt_text
    first("input[name*='alt_text']").set "New alt text"
    first("button", text: "Save").click
  end

  def then_the_alt_text_is_updated
    expect(@post.images.first.custom_metadata["alt_text"]).to eq "New alt text"
  end

  def when_i_edit_the_first_image_caption
    first("textarea[name*='caption']").set "New **caption**"
    first("button", text: "Save").click
  end

  def then_the_caption_is_updated
    expect(
      @post.images.first.custom_metadata["caption"]
    ).to eq "New **caption**"
  end

  def when_i_remove_the_first_image_from_the_list_at_the_end_of_the_post
    check "attachment[show_at_bottom]", allow_label_click: true
    first("button", text: "Save").click
  end

  def then_the_image_metadata_is_updated
    expect(@post.images.first.custom_metadata["show_at_bottom"]).to eq "1"
  end
end
