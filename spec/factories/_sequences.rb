FactoryGirl.define do
  sequence :email do |n|
    "debae_user_#{n}@aol.com"
  end

  sequence :body do |n|
    "For the #{n}th time - she did the right thing!"
  end
end
