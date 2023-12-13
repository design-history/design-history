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
end
