require "rails_helper"

RSpec.describe "Team domain" do
  it "can be set up and managed access to multiple projects" do
    given_i_am_signed_in
    when_i_visit_my_team_page
    then_i_see_the_set_up_domain_link

    when_i_click_on_set_up_domain
    then_i_see_the_set_up_domain_start_page

    when_i_click_continue
    then_i_see_the_choose_domain_page
    and_the_theme_is_preselected

    when_i_fill_in_a_domain
    and_i_click_submit
    then_i_see_the_team_page

    when_i_click_edit_domain
    then_i_see_the_choose_domain_page

    when_i_click_back
    then_i_see_the_team_page
  end

  private

  def given_i_am_signed_in
    @team = create(:team)
    @owner = create(:user, team: @team)
    @dh1 = create(:project, owner: @team, subdomain: "first", theme: "nhs")
    @dh2 = create(:project, owner: @team, subdomain: "second", theme: "nhs")
    sign_in @owner
  end

  def when_i_visit_my_team_page
    visit team_path(@team)
  end

  def then_i_see_the_set_up_domain_link
    expect(page).to have_link "Setup"
  end

  def when_i_click_on_set_up_domain
    click_link "Setup"
  end

  def then_i_see_the_set_up_domain_start_page
    expect(page).to have_content "Setup a team domain"
  end

  def when_i_click_continue
    click_link "Continue"
  end

  def then_i_see_the_choose_domain_page
    expect(page).to have_content "Choose a subdomain and style"
  end

  def and_the_theme_is_preselected
    expect(page).to have_content "We’ve pre-selected"
  end

  def when_i_fill_in_a_domain
    fill_in "Team subdomain", with: "this"
  end

  def and_i_click_submit
    click_button "Submit"
  end

  def then_i_see_the_team_page
    expect(page).to have_content "this.app.local"
  end

  def when_i_click_edit_domain
    click_link "Edit the team domain"
  end

  def when_i_click_back
    click_link "Back"
  end
end
