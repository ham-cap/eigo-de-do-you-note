require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can\'t be blank")
  end

  it "is invalid without a provider" do
    user = FactoryBot.build(:user, provider: nil)
    user.valid?
    expect(user.errors[:provider]).to include("can\'t be blank")
  end

  it "is invalid without a uid" do
    user = FactoryBot.build(:user, uid: nil)
    user.valid?
    expect(user.errors[:uid]).to include("can\'t be blank")
  end
end
