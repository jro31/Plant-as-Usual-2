FactoryBot.define do
  factory :user do
    first_name { 'Harry' }
    last_name  { 'Potter' }
    username { 'harry_potter' }
    email { 'hpotter@hogwarts.com' }
    password { 'quidditch' }
    admin { false }
    dark_mode { false }
  end
end
