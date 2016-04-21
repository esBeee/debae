FactoryGirl.define do
  factory :link_to_argument do
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
