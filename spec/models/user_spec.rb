require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe "association" do
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_many(:plans).dependent(:destroy) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(15) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to allow_value("toyokappa").for(:name) }
    it { is_expected.not_to allow_value("toyo.kappa").for(:name)}
  end
end
