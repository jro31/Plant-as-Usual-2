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
    authentication_token { Faker::Internet.password(min_length: 15, max_length: 30, mix_case: true, special_characters: true) }
  end
end
