FactoryGirl.define do
  factory :link_to_argument do
    statement
    association :argument, factory: :statement
    is_pro_argument false
  end
end
