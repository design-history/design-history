# == Schema Information
#
# Table name: projects
#
#  id               :bigint           not null, primary key
#  comments_enabled :boolean          default(FALSE)
#  description      :string
#  owner_type       :string           not null
#  password         :string
#  related_links    :text             default("")
#  subdomain        :string
#  theme            :string           default("dh"), not null
#  title            :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :bigint           not null
#  project_id       :bigint
#
# Indexes
#
#  index_projects_on_owner       (owner_type,owner_id)
#  index_projects_on_project_id  (project_id)
#  index_projects_on_subdomain   (subdomain) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Project < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :posts, dependent: :destroy

  attr_accessor :visibility

  scope :ungrouped, -> { where(project_id: nil, type: nil) }

  belongs_to :group, foreign_key: :project_id, optional: true

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
  validates :password, length: { maximum: 50 }, confirmation: true
  validates :password, presence: true, if: -> { visibility == "private" }
  validates :theme, inclusion: { in: %w[dh gov nhs] }
  before_validation :strip_domain_and_protocol_from_subdomain,
                    on: %i[create update],
                    if: -> { subdomain.present? }

  def private?
    password.present?
  end

  private

  def strip_domain_and_protocol_from_subdomain
    self.subdomain = subdomain.gsub(%r{\Ahttps?://}, "").gsub(/\..*\z/, "")
  end
end
