FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyText" }
    password_digest { "MyString" }
  end
end
