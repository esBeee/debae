FactoryGirl.define do
  sequence :body do |n|
    "For the #{n}th time - she did the right thing!"
  end

  factory :statement do
    user
    body
    score nil
  end
end
