FactoryBot.define do
  factory :user do
    name { "TestUser" }
    email { "testuser@email.com" }
    password { "password" }
    admin { false }
  end
end
