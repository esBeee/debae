FactoryGirl.define do
  factory :comment do
    sequence(:body, 1000) { |n| "For the #{n}th time - she did the right thing!" }

    association :commentable, factory: :statement
    user
  end
end
