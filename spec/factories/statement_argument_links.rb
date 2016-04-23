FactoryGirl.define do
  factory :statement_argument_link do
    statement
    association :argument, factory: :statement
    is_pro_argument false

    trait :pro do
      is_pro_argument true
    end

    trait :contra do
      is_pro_argument false
    end
  end
end
