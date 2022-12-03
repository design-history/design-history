# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  owner_type  :string           not null
#  password    :string
#  subdomain   :string
#  theme       :string           default("dh"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_owner      (owner_type,owner_id)
#  index_projects_on_subdomain  (subdomain) UNIQUE
#
FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    subdomain { Faker::Internet.slug.gsub("_", "-") }
    description { Faker::Company.bs.capitalize }
  end
end
