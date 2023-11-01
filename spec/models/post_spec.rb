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
