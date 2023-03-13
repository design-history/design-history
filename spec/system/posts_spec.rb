require "rails_helper"

RSpec.describe "Posts" do
  it "can be created" do
    given_i_am_signed_in
    when_i_visit_my_project
    then_i_see_the_new_post_button

    when_i_click_on_new_post
    then_i_see_the_new_post_page

    when_i_submit_my_post_details
    then_i_see_the_edit_post_page

    when_i_publish_my_post
    then_i_see_the_edit_post_page
    and_i_see_a_publish_date_that_is_today
    and_i_see_a_view_post_link
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
    @slug = Faker::Internet.slug.gsub("_", "-")
    fill_in "post[title]", with: Faker::Company.bs.capitalize
    fill_in "post[slug]", with: @slug
    fill_in "post[body]", with: Faker::Markdown.sandwich
    click_button "Save"
  end

  def when_i_publish_my_post
    find('label[for*="post-published"]').click
    click_button "Save"
  end

  def then_i_see_the_edit_post_page
    expect(page).to have_title "Edit post"
  end

  def and_i_see_a_publish_date_that_is_today
    expect(page).to have_field(
      "post[published_at(1i)]",
      with: Time.zone.today.year
    )

    expect(page).to have_field(
      "post[published_at(2i)]",
      with: Time.zone.today.month
    )

    expect(page).to have_field(
      "post[published_at(3i)]",
      with: Time.zone.today.day
    )
  end

  def and_i_see_a_view_post_link
    expect(page).to have_selector(
      "a[href*='#{@project.subdomain}'][href*='#{@slug}']",
      text: "View post"
    )
  end
end
