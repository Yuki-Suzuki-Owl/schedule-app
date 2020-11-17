FactoryBot.define do
  factory :user do
    name { "TestUser" }
    email { "testuser@email.com" }
    password { "password" }
    ziel {}
    memo {}
    admin { false }
  end
end
