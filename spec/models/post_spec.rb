# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  body              :text
#  ordered_image_ids :json
#  published         :boolean
#  published_at      :date
#  related_links     :text             default("")
#  slug              :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_project_id           (project_id)
#  index_posts_on_project_id_and_slug  (project_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require "rails_helper"

RSpec.describe Post, type: :model do
  it "sanitizes body and related content" do
    owner = create(:user)
    project = create(:project, owner:)
    post = create(:post, project:)

    post.update! body: "
      # Header should be a header

      Paragraph should be a paragraph

      > Blockquote should be a blockquote

      <script>alert('Evil script should be stripped')</script>

      ```
      <script>alert('Safe script should stay')</script>
      ```

<details>
  <summary>User-provided html should be stripped</summary>
  <p>But safe tags<br />should stay</p>
</details>
    "
    expect(post.body).to eq "
      # Header should be a header

      Paragraph should be a paragraph

      > Blockquote should be a blockquote

      alert('Evil script should be stripped')

      ```
      <script>alert('Safe script should stay')</script>
      ```


  User-provided html should be stripped
  <p>But safe tags<br>should stay</p>

    "
  end
end
