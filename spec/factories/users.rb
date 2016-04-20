FactoryGirl.define do
  sequence :email do |n|
    "debae_user_#{n}@aol.com"
  end

  factory :user do
    email
    password "foobar12"
    confirmed_at Time.now # Setting the confirmed_at to a time means the user is confirmed

    factory :unconfirmed_user do
      confirmed_at nil # If the confirmed_at is nil, it means the user is unconfirmed
    end
  end
end
