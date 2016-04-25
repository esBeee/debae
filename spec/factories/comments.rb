FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :statement
    user
    body
  end
end
