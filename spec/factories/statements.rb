FactoryGirl.define do
  factory :statement do
    user
    body
    score nil

    trait :top_level do
      top_level true
    end
  end
end
