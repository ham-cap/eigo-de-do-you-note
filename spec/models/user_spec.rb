require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("Nameを入力してください。")
  end

  it "is invalid without a provider" do
    user = FactoryBot.build(:user, provider: nil)
    user.valid?
    expect(user.errors[:provider]).to include("Providerを入力してください。")
  end

  it "is invalid without a uid" do
    user = FactoryBot.build(:user, uid: nil)
    user.valid?
    expect(user.errors[:uid]).to include("Uidを入力してください。")
  end
end
