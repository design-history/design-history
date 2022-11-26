# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  password    :string
#  subdomain   :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_projects_on_subdomain  (subdomain) UNIQUE
#  index_projects_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Project < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :subdomain,
            presence: true,
            length: {
              maximum: 50
            },
            exclusion: {
              in: %w[www the our]
            },
            format: {
              with: /\A[a-z0-9-]+\z/
            },
            uniqueness: true
  validates :description, presence: true, length: { maximum: 255 }
end
