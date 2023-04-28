require "rails_helper"

RSpec.describe CheckSpamJob, type: :job do
  let(:comment) do
    owner = create(:user)
    project = create(:project, owner:)
    post = create(:post, project:)

    create(:comment, commentable: post)
  end

  it "doesn't set spam on an innocent comment" do
    allow_any_instance_of(SpamChecker).to receive(:spam?).and_return(false)

    expect { CheckSpamJob.perform_now(comment) }.not_to change(
      comment,
      :spam
    ).from(false)
  end

  it "sets spam to true on a spam comment" do
    allow_any_instance_of(SpamChecker).to receive(:spam?).and_return(true)

    expect { CheckSpamJob.perform_now(comment) }.to change(comment, :spam).to(
      true
    )
  end
end
