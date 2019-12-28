FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email { "dog@cat.mouse" }
    password { "bleepbleep" }
  end
end
