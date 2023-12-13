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
FactoryBot.define do
  factory :team do
    name { Faker::Company.bs.capitalize }
  end
end
