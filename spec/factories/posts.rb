# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  body              :text
#  ordered_image_ids :json
#  preview_token     :string
#  published         :boolean
#  published_at      :date
#  related_links     :text             default("")
#  slug              :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_project_id           (project_id)
#  index_posts_on_project_id_and_slug  (project_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
FactoryBot.define do
  factory :post do
    title { Faker::Company.bs.capitalize }
    slug { Faker::Internet.slug.gsub("_", "-") }
    body { Faker::Markdown.sandwich }
    related_links { Faker::Markdown.sandwich }
    published { true }
    published_at { Time.zone.today }

    trait :draft do
      published { false }
      published_at { nil }
    end
  end
end
