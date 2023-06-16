FactoryBot.define do
  factory :comment do
    name { Faker::Lorem.sentence }
    comment { Faker::Lorem.paragraph }
    post
  end
end
