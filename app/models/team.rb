# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Team < ApplicationRecord
  has_many :users
  has_many :projects, as: :owner

  validates :name, presence: true, length: { maximum: 50 }
end
