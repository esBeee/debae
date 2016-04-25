require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  before { @comment = FactoryGirl.build(:comment) }

  subject { @comment }

  it { should be_valid }
end
