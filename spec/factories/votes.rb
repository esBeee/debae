FactoryGirl.define do
  factory :vote do
    user
    statement
    is_pro_vote true

    trait :up do
      is_pro_vote true
    end

    trait :down do
      is_pro_vote false
    end
  end
end
