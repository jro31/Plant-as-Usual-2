FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    username { Faker::Internet.username(specifier: 5..15) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    admin { false }
    dark_mode { Faker::Boolean.boolean }
  end
end
