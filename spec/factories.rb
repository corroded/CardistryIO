FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "bob-#{n}@example.com" }
    password "secret"
  end

  factory :move do
    name "Sybil"
    user
  end

  factory :video do
    sequence(:name) { |n| "Classic #{n}" }
    description "A video I made"
    url "https://www.youtube.com/watch?v=W799NKLEz8s"
    user
    approved true
  end

  factory :appearance do
    video
    move
    minutes 1
    seconds 2
  end
end
