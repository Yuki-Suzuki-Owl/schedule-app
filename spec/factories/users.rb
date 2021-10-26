FactoryBot.define do
  factory :user do
    name { "foobar" }
    email { "foobar@email.com" }
    password { "password" }
    ziel {}
    memo {}
    admin { false }
  end
end
