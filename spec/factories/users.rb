FactoryBot.define do
  factory :user do
    first_name { 'Harry' }
    last_name  { 'Potter' }
    username { (0...36).map{ |i| i.to_s 36 }.sample(rand(3..16)).join() }
    email { Faker::Internet.email }
    password { 'quidditch' }
    admin { false }
    dark_mode { false }
  end
end
