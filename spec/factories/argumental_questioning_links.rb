FactoryGirl.define do
  factory :argumental_questioning_link do
    statement
    association :argument, factory: :statement, strategy: :build
    is_pro_argument false
  end
end
