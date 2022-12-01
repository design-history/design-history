require "rails_helper"

RSpec.describe "Design histories" do
  it "display posts" do
    when_i_visit_my_design_history
    then_i_see_the_published_posts

    when_i_click_on_the_first_post
    then_i_see_the_post_content
  end

  private

  def when_i_visit_my_design_history
    @owner = create(:user)
    @project = create(:project, owner: @owner, subdomain: "this")
    @post_body = "It's working"
    @first_post = create(:post, project: @project, body: @post_body)
    @second_post = create(:post, project: @project, published: false)
    port = page.driver.browser.options.port
    visit "http://this.app.local:#{port}"
  end

  def then_i_see_the_published_posts
    expect(page).to have_link @first_post.title
    expect(page).not_to have_link @second_post.title
  end

  def when_i_click_on_the_first_post
    click_link @first_post.title
  end

  def then_i_see_the_post_content
    expect(page).to have_content @post_body
  end
end
