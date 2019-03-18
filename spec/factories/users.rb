FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email){|n| "test#{n}@example.com" }
    password { "password" }
  end

  factory :user_2, class: User do
    name { "テストユーザー" }
    email { "test2@example.com" }
    password { "password" }
  end

  factory :user_3, class: User do
    name { "テストユーザー" }
    email { "test3@example.com" }
    password { "password" }
  end
end
