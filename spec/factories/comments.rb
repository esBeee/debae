FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :statement
    user
    body
    related_comment nil
  end
end
