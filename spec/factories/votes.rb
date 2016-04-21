FactoryGirl.define do
  factory :vote do
    user
    statement
    is_pro_vote true
  end
end
