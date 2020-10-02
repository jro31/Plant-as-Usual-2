FactoryBot.define do
  factory :user do
    username { (0...36).map{ |i| i.to_s 36 }.sample(rand(3..16)).join() }
    email { Faker::Internet.email }
    password { 'quidditch' }
    admin { false }
    dark_mode { false }
    twitter_handle { 'boy_who_lived' }
    instagram_handle { 'potter_pix' }
    website_url { 'www.dumbledoresarmy.org' }
  end
end
