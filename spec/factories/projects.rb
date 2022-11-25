FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    subdomain { Faker::Internet.slug.gsub("_", "-") }
    description { Faker::Company.bs.capitalize }
  end
end
