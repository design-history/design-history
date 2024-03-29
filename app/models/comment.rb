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
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  scope :ham, -> { where(spam: false) }

  validates :body, presence: true, length: { maximum: 1000 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            length: {
              maximum: 255
            }

  after_create :check_for_spam

  private

  def check_for_spam
    CheckSpamJob.perform_later(self)
  end
end
