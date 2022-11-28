# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  owner_type  :string
#  password    :string
#  subdomain   :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_projects_on_owner      (owner_type,owner_id)
#  index_projects_on_subdomain  (subdomain) UNIQUE
#  index_projects_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    subdomain { Faker::Internet.slug.gsub("_", "-") }
    description { Faker::Company.bs.capitalize }
  end
end
