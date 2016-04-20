require 'rails_helper'

RSpec.describe User, type: :model do
  
  # Using factory girl to build a user. That way it is ensured,
  # that factory girl returns a valid user object.
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  # Test that the user is valid.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    context "when password is too short (7 characters)" do
      before { @user.password = "1234567" }
      it { should_not be_valid }
    end

    context "when password has min length (8 characters)" do
      before { @user.password = "12345678" }
      it { should be_valid }
    end

    # Create a couple of tests with invalid email addresses.
    %w(a@b @b.de a@.de ab.de a a@b. a.b.c).each do |invalid_email|
      context "when email is #{invalid_email} (invalid)" do
        before { @user.email = invalid_email }
        it { should_not be_valid }
      end
    end

    # Create a couple of tests with valid email addresses.
    %w(a@b.de aaaaa@bbbbbb.des a@b.d a@b.accountant).each do |valid_email|
      context "when email is #{valid_email} (valid)" do
        before { @user.email = valid_email }
        it { should be_valid }
      end
    end
  end
end
