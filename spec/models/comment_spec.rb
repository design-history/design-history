require "rails_helper"

RSpec.describe Comment, type: :model do
  it "queues a job to check for spam after creation" do
    owner = create(:user)
    project = create(:project, owner:)
    post = create(:post, project:)

    expect { create(:comment, commentable: post) }.to have_enqueued_job(
      CheckSpamJob
    )
  end
end
