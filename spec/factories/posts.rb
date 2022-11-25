FactoryBot.define do
  factory :post do
    title { Faker::Company.bs.capitalize }
    slug { Faker::Internet.slug.gsub("_", "-") }
    body { Faker::Markdown.sandwich }
    published { true }
    published_at { Time.zone.today }
  end
end
