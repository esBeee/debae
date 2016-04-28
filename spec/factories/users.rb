FactoryGirl.define do
  factory :user do
    email
    password "foobar12"
    confirmed_at Time.now # Setting the confirmed_at to a time means the user is confirmed
    name "Maxima Monk"
    avatar_url nil

    # Can be called like FactoryGirl.create(:user, :unconfirmed, password: "foo")
    trait :unconfirmed do
      confirmed_at nil # If the confirmed_at is nil, it means the user is unconfirmed
    end
  end
end
