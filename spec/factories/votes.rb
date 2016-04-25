FactoryGirl.define do
  factory :vote do
    user
    association :voteable, factory: :statement
    is_pro_vote true

    trait :up do
      is_pro_vote true
    end

    trait :down do
      is_pro_vote false
    end

    trait :statement do
      association :voteable, factory: :statement
    end

    trait :link do
      association :voteable, factory: :statement_argument_link
    end
  end
end
