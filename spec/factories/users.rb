FactoryBot.define do
  factory :user do
    first_name { 'Harry' }
    last_name  { 'Potter' }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'quidditch' }
    admin { false }
    dark_mode { false }
  end
end
