FactoryBot.define do
  factory :user do
    name { "TestUser" }
    email { "testuser@email.com" }
    password_digest { "password" }
    admin { false }
  end
end
