# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  body              :text
#  ordered_image_ids :json
#  published         :boolean
#  published_at      :date
#  slug              :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Post < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, length: { maximum: 50 }
  validates :body, presence: true
  validates :published_at, presence: true, if: -> { published == true }
end
