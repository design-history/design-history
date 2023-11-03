# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  commentable_type :string           not null
#  email            :string           not null
#  name             :string           not null
#  spam             :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
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
