# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string
#  subdomain  :string
#  theme      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_subdomain  (subdomain) UNIQUE
#
class Team < ApplicationRecord
  has_many :users
  has_many :projects, as: :owner

  validates :name, presence: true, length: { maximum: 50 }

  with_options on: :update do
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
    validates :theme, inclusion: { in: %w[dh gov nhs] }
  end
  before_validation :strip_domain_and_protocol_from_subdomain,
                    on: %i[update]

  private

  def strip_domain_and_protocol_from_subdomain
    self.subdomain = subdomain.gsub(%r{\Ahttps?://}, "").gsub(/\..*\z/, "")
  end
end
