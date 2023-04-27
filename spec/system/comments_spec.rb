require "rails_helper"

RSpec.describe "Comments" do
  it "can be be submitted on public posts" do
    when_i_visit_my_design_history_post
    then_i_dont_see_the_comments_section

    when_i_sign_in
    and_i_go_to_my_project_settings
    then_i_see_the_comments_setting

    when_i_enable_comments
    and_i_visit_my_design_history_post
    then_i_see_the_comments_section

    when_i_post_an_invalid_comment
    then_i_see_an_error_message

    when_i_post_a_comment
    then_i_see_my_comment
  end

  private

  def when_i_visit_my_design_history_post
    @owner = create(:user)
    @project = create(:project, owner: @owner, subdomain: "this")
    @first_post = create(:post, project: @project, body: "It's working")
    port = page.driver.browser.options.port
    visit "http://this.app.local:#{port}"
    click_link @first_post.title
  end

  def and_i_visit_my_design_history_post
    port = page.driver.browser.options.port
    visit "http://this.app.local:#{port}"
    click_link @first_post.title
  end

  def when_i_sign_in
    sign_in @owner
    visit project_path(@project)
  end

  def when_i_enable_comments
    check "Enable comments", allow_label_click: true
    click_button "Save changes"
  end

  def and_i_go_to_my_project_settings
    click_link "Change details"
  end

  def then_i_see_the_comments_setting
    expect(page).to have_content "Enable comments"
  end

  def then_i_see_the_comments_section
    expect(page).to have_content "Leave a comment"
  end

  def then_i_dont_see_the_comments_section
    expect(page).not_to have_content "Leave a comment"
  end

  def when_i_post_a_comment
    fill_in "Name", with: "John Doe"
    fill_in "Email", with: "john.doe@example.com"
    fill_in "Enter your comment", with: "This is a comment"
    click_button "Submit comment"
  end

  def then_i_see_my_comment
    expect(page).to have_content "1 comment"
    expect(page).to have_content "This is a comment"
  end

  def when_i_post_an_invalid_comment
    click_button "Submit comment"
  end

  def then_i_see_an_error_message
    expect(page).to have_content "Enter an email"
  end
end
