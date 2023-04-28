# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  commentable_type :string           not null
#  email            :string           not null
#  name             :string           not null
#  spam             :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
