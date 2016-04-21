FactoryGirl.define do
  factory :argumental_questioning_link do
    questioning
    association :argument, factory: :questioning, strategy: :build
    is_pro_argument false
  end
end
